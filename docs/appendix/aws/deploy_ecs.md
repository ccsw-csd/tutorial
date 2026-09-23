# Despliegue en la nube

## Resumen: qué vamos a hacer y para qué sirve cada pieza

Vamos a desplegar los seis servicios (los cinco microservicios de backend más el frontend) en **AWS ECS con Fargate**, sustituyendo lo que en local resolvían Eureka y el Gateway por servicios nativos de AWS:

1. Empaquetamos cada microservicio como imagen Docker y la subimos a **ECR**, el almacén de imágenes de AWS.
2. Creamos **Security Groups** (firewalls virtuales) para las tareas y para el balanceador, controlando qué tráfico puede entrar y salir de cada uno.
3. Creamos un único **ALB** (Application Load Balancer) público que hace de punto de entrada, tanto para el frontend como para las llamadas internas entre microservicios, enrutando por path (`/category`, `/author`...) a cada uno. Esto sustituye al Gateway: ya no hace falta desplegarlo como servicio aparte.
4. Como ya no tenemos Eureka, los microservicios que se llaman entre sí (vía Feign Client) también pasan por ese mismo ALB, en vez de resolverse por nombre lógico.
5. Desplegamos cada microservicio como una tarea de **ECS/Fargate** (sin servidores que gestionar), dentro de un **Cluster**, con un **Service** que mantiene las réplicas vivas y las registra automáticamente en el ALB.

**Piezas clave y para qué sirve cada una:**

| Pieza | Para qué sirve |
|---|---|
| **ECR** (Elastic Container Registry) | Almacena las imágenes Docker de cada microservicio, privadas por defecto. |
| **Security Group** | Firewall virtual: decide qué tráfico puede entrar (`ingress`) y salir (`egress`) de un recurso. |
| **ALB** (Application Load Balancer) | Punto de entrada estable (con DNS fijo) que reparte tráfico hacia las tareas, aunque su IP cambie al relanzarse. |
| **Target Group** | El "destino" de un ALB: un grupo de tareas verificadas por un health check, a las que se reenvía tráfico. |
| **Listener + Rule** | El puerto en el que escucha el ALB, y las reglas que deciden a qué target group reenviar según el path de la petición. |
| **Cluster** (ECS) | Agrupación lógica donde viven los servicios desplegados. |
| **Task Definition** | La plantilla de un contenedor: imagen, recursos, puertos, variables de entorno, logs, health check. |
| **Service** (ECS) | Mantiene vivo el número deseado de tareas de una Task Definition, y las registra/elimina del target group automáticamente. |

!!! note "Discovery Service"
    Al final de este documento se explica una alternativa a reutilizar el ALB para las llamadas internas: AWS Cloud Map como Discovery Service, y sus ventajas. No es el enfoque principal aquí porque esta cuenta no tiene concedidos los permisos de IAM necesarios (`servicediscovery:*`).

Todo lo que sigue se puede hacer igual desde la **consola web de AWS** que desde la **CLI**: aquí se documenta con comandos porque son fáciles de copiar y reproducir, pero si prefieres usar la interfaz gráfica, lo importante es entender qué es cada recurso, no memorizar el comando.

## Pre-requisitos
En este tutorial, partiremos de la aplicacion con [micro servicios](../springcloud/intro.md), [dockerizada](../docker/installdocker.md) y de [AWS CLI](./cli.md)

## Antes de construir las imágenes: actualizar la URL de los Feign Clients

Los `Feign Client` de los micro servicios (ver [Feign Client](../springcloud/infra.md#feign-client)) llaman directamente al microservicio destino vía Eureka, sin `url` configurada (ej. `@FeignClient(value = "SPRING-CLOUD-EUREKA-CLIENT-XXX")`). Sin Eureka, cada `Feign Client` necesita una `url` explícita. Como en AWS todo va a pasar por el mismo ALB con routing por path (lo veremos más adelante), el valor será el mismo para todos los Feign Clients de cualquier microservicio: solo el host del ALB, sin puerto ni path (el path ya lo define el `@GetMapping` de cada método, tal como está hoy).

Este documento no modifica ese código, pero el cambio necesario sería externalizar esa URL, por ejemplo:

```properties
alb.url=${ALB_URL}
```

```java
@FeignClient(value = "SPRING-CLOUD-EUREKA-CLIENT-XXX", url = "${alb.url}")
```

Este cambio hay que aplicarlo y reconstruir la imagen **antes** de subirla a ECR, si no la imagen que despleguemos seguirá sin la `url`. El valor real de `ALB_URL` todavía no se conoce en este punto (el ALB se crea más adelante); no hace falta rellenarlo ahora, se define después como variable de entorno en la Task Definition de cada microservicio.

## Crear repositorios ECR
Para poder desplegar la aplicacion, primero necesitaremos crear los repositorios en AWS.

El primer paso de todos es autenticar nuestro docker para que pueda acceder a los repositorios para ello ejecutaremos el siguiente comando
```bash
aws ecr get-login-password --region <REGION> | sudo docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
```

Donde `<REGION>` es la region que tengamos configurada, y `<AWS_ACCOUNT_ID>` lo deberemos tener configurado de nuestros credenciales de AWS

Ahora, para cada microservicio que queramos almacenar en ECR ejecutaremos los siguientes comandos.

1. Crear el repositorio de ECR
```bash
aws ecr create-repository --repository-name <REPOSITORY_NAME> --region <REGION>
```

2. Crear la imagen de docker.
```bash
sudo docker build -t <IMAGE>:<TAG> .
``` 

3. Etiquetar la imagen para poder enviarla al repositorio
```bash
sudo docker tag <IMAGE>:<TAG> <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<REPOSITORY_NAME>:<TAG>
``` 

4. Enviar la imagen al repositorio de AWS.
```bash
sudo docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<REPOSITORY_NAME>:<TAG>
```

## Despliegue de la aplicacion

### Grupo de seguridad compartido

Vamos a crear un único SG compartido por todas las tareas ECS (microservicios + frontend).

1. Crear el grupo de seguridad, todavía sin ninguna regla:
```bash
aws ec2 create-security-group --group-name ecs-microservices-sg --description "Shared SG for ECS microservices communication" --vpc-id <VPC_ID> --region <REGION>
```
`<VPC_ID>` es el **Virtual Private Cloud**, vuestra red privada dentro de AWS con sus propias subredes y reglas de acceso: todo lo que creemos (ALB, tareas, security groups) vive dentro de una VPC concreta.

2. Permitir que las tareas se hablen entre sí, en cualquier puerto:
```bash
aws ec2 authorize-security-group-ingress --group-id <SG_SHARED> --protocol tcp --port 0-65535 --source-group <SG_SHARED> --region <REGION>
```
El parámetro `--source-group` (en vez de `--cidr`) es la clave aquí: en lugar de "desde esta IP o rango de IPs", dice "desde cualquier recurso que tenga este security group asignado". Como todas las tareas comparten este mismo SG, esto basta para que se comuniquen entre ellas sin importar qué IP le toque a cada una al arrancar (recordad que en Fargate la IP cambia cada vez que una tarea se relanza).

3. Exponer el frontend a internet: a diferencia de los microservicios, el frontend sí debe ser accesible desde cualquier navegador:
```bash
aws ec2 authorize-security-group-ingress --group-id <SG_SHARED> --protocol tcp --port 4200 --cidr 0.0.0.0/0 --region <REGION>
```

### Crear el ALB público

Como el frontend llama a los microservicios desde fuera de AWS, este ALB debe ser `internet-facing` (accesible desde internet). La alternativa sería `internal`, solo accesible desde dentro de la VPC.

1. Security group propio del ALB, separado del de las tareas: el ALB necesita estar expuesto a internet, las tareas no:
```bash
aws ec2 create-security-group --group-name alb-sg --description "ALB security group" --vpc-id <VPC_ID> --region <REGION>
```

2. Abrir el puerto 80 a todo internet. Al no haber Gateway, este es el único puerto del ALB que necesitamos: tanto el frontend como los propios microservicios (vía Feign Client) van a llegar a los demás a través de él:
```bash
aws ec2 authorize-security-group-ingress --group-id <SG_ALB> --protocol tcp --port 80 --cidr 0.0.0.0/0 --region <REGION>
```

3. Crear el propio load balancer, indicándole en qué subredes vive y qué security group usa:
```bash
aws elbv2 create-load-balancer --name public-alb --subnets <SUBNET_1> <SUBNET_2> <SUBNET_3> --security-groups <SG_ALB> --scheme internet-facing --type application --ip-address-type ipv4 --region <REGION>
```

4. Crear un target group por cada microservicio (Category, Author, Game, User, Rental): el "destino" al que el ALB reenvía tráfico, junto con la configuración del health check (cada cuánto comprueba, cuántos aciertos/fallos seguidos hacen falta para considerar una tarea sana o no). Se repite para cada `<SERVICE>` / `<SERVICE_PORT>`:
```bash
aws elbv2 create-target-group --name <SERVICE>-tg --protocol HTTP --port <SERVICE_PORT> --target-type ip --vpc-id <VPC_ID> --health-check-path /actuator/health --health-check-interval-seconds 30 
--health-check-timeout-seconds 5 --healthy-threshold-count 2 --unhealthy-threshold-count 3 --matcher HttpCode=200 --region <REGION>
```
`--target-type ip` es importante en Fargate: al no haber instancias EC2 fijas, el target group apunta directamente a la IP de cada tarea, y ECS se encarga de mantener esa lista actualizada según las tareas arrancan o mueren.

5. Crear el listener del puerto 80. Todo listener necesita una acción por defecto: aquí devolvemos un 404 simple para cuando ninguna regla de path coincida (por ejemplo, para el propio `/` del ALB):
```bash
aws elbv2 create-listener --load-balancer-arn <ALB_ARN> --protocol HTTP --port 80 --default-actions Type=fixed-response,FixedResponseConfig="{MessageBody=Not Found,StatusCode=404,ContentType=text/plain}" --region <REGION>
```

6. Crear una regla de enrutamiento por path para cada microservicio: esto reemplaza directamente lo que antes hacían los `predicates: Path=/category/**` del Gateway. Se repite para cada `<SERVICE>`, con una `--priority` distinta (las reglas se evalúan en orden, de menor a mayor):
```bash
aws elbv2 create-rule --listener-arn <LISTENER_ARN> --priority <N> --conditions Field=path-pattern,Values="/<SERVICE>*" --actions Type=forward,TargetGroupArn=<SERVICE_TG_ARN> --region <REGION>
```

!!! tip "El frontend deja de llamar al Gateway"
    El frontend, que antes apuntaba a la URL del Gateway, ahora debe apuntar directamente al DNS de este ALB: las rutas (`/category`, `/author`...) son las mismas, solo cambia el host. Este documento no modifica el código del frontend, pero es el cambio equivalente que habría que aplicar ahí.

!!! warning "El CORS centralizado del Gateway desaparece"
    El Gateway tenía configurado un `globalcors` que añadía las cabeceras CORS a todas las respuestas. El ALB no hace esto por sí solo, es cosa de la aplicación. Al quitar el Gateway, cada microservicio necesitaría gestionar su propio CORS (por ejemplo con `@CrossOrigin` en los controllers). Este documento no modifica ese código, queda documentado como pendiente.

### Nota: variable de entorno `ALB_URL` para los Feign Clients

Ya vimos, en la sección previa a construir las imágenes, que cada `Feign Client` necesita una `url` explícita (`${ALB_URL}`), y que su valor se rellenaría en este punto, ahora que el ALB ya existe.

Hay que añadir esa variable de entorno `ALB_URL` en la Task Definition de cualquier micro servicio que tenga un Feign Client, apuntando al DNS del `public-alb` (lo obtenemos con `aws elbv2 describe-load-balancers --names public-alb --region <REGION>`):

```json
{
  "name": "ALB_URL",
  "value": "http://<ALB_DNS>"
}
```

### Crear las tareas y los servicios

Con la red ya montada, toca desplegar el código en sí.

1. Crear el cluster que contendrá todos los servicios de ECS
```bash
aws ecs create-cluster --cluster-name docker-deploy --region <REGION>
```

2. Crear el rol de IAM que ejecutará los ECS
```bash
aws iam create-role --role-name ecs-service-role --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}'

```

3. Asignar el permiso
```bash
aws iam attach-role-policy --role-name ecs-service-role --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSServiceRolePolicy
```

Ahora, para cada microservicio (y el frontend), repetimos estos mismos pasos.

1. La Task Definition, en formato JSON. Los campos más relevantes:

    - `containerDefinitions.image`: la imagen que subimos antes a ECR.
    - `cpu` / `memory`: recursos reservados para la tarea.
    - `portMappings`: el puerto que expone el contenedor, debe coincidir con el puerto del target group correspondiente creado antes.
    - `environment`: variables de entorno: aquí es donde irían, por ejemplo, las URLs de los Feign Clients de la nota anterior.
    - `logConfiguration`: dónde van a parar los logs de la tarea. Con `awslogs-create-group: "true"` no hace falta crear antes el grupo de logs en CloudWatch, ECS lo crea automáticamente la primera vez que la tarea arranca.
    - `healthCheck`: cómo comprueba **ECS** (no el ALB) que el contenedor está vivo: es una verificación adicional e independiente del health check del target group.
    - `executionRoleArn`: el rol de IAM que permite a ECS tirar de la imagen de ECR y escribir logs, el que se creó en el paso anterior.

```json
{
  "family": "docker-deploy-<SERVICE>",
  "containerDefinitions": [
    {
      "name": "Main",
      "image": "<AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<REPOSITORY_NAME>:<TAG>",
      "cpu": 2048,
      "memory": 4096,
      "portMappings": [
        {
          "containerPort": "<SERVICE_PORT>",
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "environment": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/docker-deploy-<SERVICE>",
          "awslogs-region": "<REGION>",
          "awslogs-stream-prefix": "ecs",
          "awslogs-create-group": "true"
        }
      },
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "curl -f http://localhost:<SERVICE_PORT>/actuator/health || exit 1"
        ],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ],
  "requiresCompatibilities": [
    "FARGATE"
  ],
  "cpu": "2048",
  "memory": "4096",
  "networkMode": "awsvpc",
  "executionRoleArn": "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<EXECUTION_ROLE_NAME>",
  "runtimePlatform": {
    "cpuArchitecture": "X86_64",
    "operatingSystemFamily": "LINUX"
  }
}
```

2. Crear la tarea que ejecutará el servicio
```bash
aws ecs register-task-definition --cli-input-json file://task-ecs.json --region <REGION>
```

3. Crear el servicio: además de indicarle cuántas réplicas mantener (`--desired-count`) y en qué subredes/security group desplegarse, hay que decirle a qué target group registrarse: así el ALB sabe automáticamente cuándo una tarea nueva está lista para recibir tráfico.

    3.1 Comando base
    ```bash
    aws ecs create-service --cluster docker-deploy --service-name <SERVICE> --task-definition <TASK_NAME> --desired-count 1 --launch-type FARGATE 
    --network-configuration "awsvpcConfiguration={subnets=[<SUBNET_1>,<SUBNET_2>,<SUBNET_3>],securityGroups=[<SG_SHARED>],assignPublicIp=ENABLED}"
    --region <REGION>
    ```

    3.2 Cada microservicio de backend añade el flag `--load-balancers` apuntando a su propio target group creado antes (el frontend no, ya que no está detrás del ALB)
    ```bash
    --load-balancers "targetGroupArn=<SERVICE_TG_ARN>,containerName=Main,containerPort=<SERVICE_PORT>"
    ```

## Alternativa: Discovery Service con AWS Cloud Map

El enfoque anterior reutiliza el mismo ALB también para las llamadas internas entre microservicios. Existe una alternativa más cercana a cómo se hace en producción: usar [AWS Cloud Map](https://docs.aws.amazon.com/cloud-map/) como Discovery Service: un directorio de nombres que sustituye a Eureka por DNS privado dentro de la VPC, en vez de por el ALB.

**Nota:** esta cuenta de prácticas no tiene concedidos los permisos de IAM (`servicediscovery:*`) necesarios para este enfoque, por eso el despliegue principal usa el ALB. Se documenta aquí como referencia para cuando sí se disponga de esos permisos.

### Cómo funciona

Cloud Map se organiza en dos niveles:

- **Namespace**: una zona DNS privada, resoluble solo dentro de vuestra VPC (no es un dominio real de internet, no hay que "comprarlo"). Equivale a la Route 53 Private Hosted Zone que crea automáticamente por debajo.
- **Servicio (dentro del namespace)**: uno por cada microservicio. Cuando una tarea ECS arranca, se registra automáticamente en su servicio de Cloud Map con su IP actual; cuando muere, se elimina. El resto de microservicios lo encuentran resolviendo `<nombre-del-servicio>.<namespace>` por DNS, sin necesitar el ALB de por medio.

### Crear el namespace y registrar los microservicios

1. Crear el namespace DNS privado, asociado a la VPC donde corren las tareas:
```bash
aws servicediscovery create-private-dns-namespace --name local --vpc <VPC_ID> --region <REGION>
```

Esto devuelve un `OperationId`; consultamos el resultado para obtener el `NamespaceId` que necesitaremos en el siguiente paso
```bash
aws servicediscovery get-operation --operation-id <OPERATION_ID> --region <REGION>
```

2. Crear un servicio de Cloud Map por cada microservicio (se repite para cada `<SERVICE>`). `DnsRecords=[{Type=A,TTL=10}]` define que se publique un registro DNS tipo A (nombre → IP) con un TTL de 10 segundos: cuanto más bajo, antes se entera el resto de servicios si una tarea cambia de IP:
```bash
aws servicediscovery create-service --name <SERVICE> --namespace-id <NAMESPACE_ID> \
  --dns-config "NamespaceId=<NAMESPACE_ID>,DnsRecords=[{Type=A,TTL=10}]" \
  --health-check-custom-config FailureThreshold=1 --region <REGION>
```

Guardamos el `ServiceArn` que devuelve: se usaría como `<SD_SERVICE_ARN>` al crear el servicio ECS con el flag `--service-registries "registryArn=<SD_SERVICE_ARN>,containerName=Main,containerPort=<SERVICE_PORT>"` en lugar de `--load-balancers`. Es ECS quien, a partir de este flag, se encarga de registrar y eliminar automáticamente cada tarea en Cloud Map.

La `url` de cada Feign Client pasaría de apuntar al ALB (`http://<ALB_DNS>`) a apuntar directamente al nombre DNS de Cloud Map de su microservicio destino, por ejemplo `http://<SERVICE>.local:<SERVICE_PORT>` (a diferencia del ALB, aquí sí hace falta indicar el puerto, porque cada microservicio tiene su propio registro DNS en vez de compartir un único host con rutas por path).

### Ventajas frente a reutilizar el ALB

- **Menos saltos de red**: el tráfico interno (Game → Category, por ejemplo) va directo dentro de la VPC vía DNS, sin salir hacia el ALB y volver a entrar. Menor latencia.
- **Añadir un microservicio nuevo es más simple**: con el ALB hay que crear su target group y su regla de path; con Cloud Map basta con registrarlo en el namespace (lo hace ECS automáticamente vía `--service-registries` al crear el servicio), sin tocar nada del ALB.
- **El tráfico interno no depende del ALB para nada**: si el ALB tuviera algún problema o límite de capacidad, el tráfico servicio-a-servicio seguiría funcionando igual, porque no pasa por él.
- **Es el patrón recomendado por AWS** para comunicación servicio-a-servicio en arquitecturas de microservicios sobre ECS, frente a sobrecargar el ALB con tráfico que no es realmente externo.
- El coste adicional es mínimo (namespace + hosted zone privada, del orden de céntimos al mes a esta escala).