# Despligue en la nube
Para desplegar la aplicacion haremos uso de los servicios de AWS Elastic Cluster Registry (AWS ECR) y Elastic Cluster Service (AWS ECS).

## Que es Elastic Cluster Registry
Amazon Elastic Container Registry (Amazon ECR) es un registro de contenedores completamente administrado que ofrece alojamiento de alto rendimiento, lo que permite utilizar imágenes de aplicaciones y artefactos de forma confiable en cualquier lugar.

ECR nos permite tanto hacer repositorios privados como publicos para poder almacenar las imagenes, en este caso haremos uso de los repositorios privados para almacenar las imagenes de nuestros micro servicios

## Que es Elastic Cluster Service
Amazon ECS es un servicio de orquestación de contenedores completamente administrado que ayuda a implementar, administrar y escalar fácilmente las aplicaciones en contenedores. Se integra profundamente al resto de la plataforma de AWS para proporcionar una solución segura y fácil de utilizar que ejecuta cargas de trabajo con contenedores en la nube.

## Pre-requisitos
En este tutorial, partiremos de la aplicacion con [micro servicios](../springcloud/intro.md), [dockerizada](../docker/installdocker.md) y de [AWS CLI](./cli.md)

## Crear repositorios ECR
Para poder desplegar la aplicacion, primero necesitaremos crear los repositorios en AWS.

El primer paso de todos es autenticar nuestro docker para que pueda acceder a los repositorios para ello ejecutaremos el siguiente comando
```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```

Ahora, para cada microservicio que queramos almacenar en ECR ejecutaremos los siguientes comandos.
1. Crear la imagen de docker.
```bash
sudo docker build -t image:tag .
``` 

2. Etiquetar la imagen para poder enviarla al repositorio
```bash
sudo docker tag image:tag <aws_account_id>.dkr.ecr.<region>.amazonaws.com/remote-repository:tag
``` 

3. Enviar la imagen al repositorio de AWS.
```bash
sudo docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/remote-repository:tag
```

## Despligue de la aplicacion

TODO