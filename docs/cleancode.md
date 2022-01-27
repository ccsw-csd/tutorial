# Estructura de proyecto y Clean Code

## Angular

!!! info "Nota"
    Antes de empezar y para puntualizar, Angular se considera un framework SPA Single-page application.

En esta parte vamos a explicar los fundamentos de un proyecto en Angular y las recomendaciones existentes.

### Estructura y funcionamiento

#### Ciclo de vida de Angular

El comportamiento de ciclo de vida de un componente Angular pasa por diferentes etapas que podemos ver en el esquema que mostramos a continuación:

![angular-lifecycle](./assets/images/angular-lifecycle.png)

Es importante tenerlo claro para saber que métodos podemos utilizar para realizar operaciones con el componente.


#### Carpetas creadas por Angular

Al crear una aplicación Angular, tendremos los siguientes directorios:

- node_modules: *Todos los módulos de librarías usado por el proyecto.*
-	\src\app: *Contiene todo el código asociado al proyecto.*
    -	\src\assets: *Normalmente la carpeta usada para los recursos.*
	-	\src\environments: *Aquí irán los ficheros relacionados con los entornos de desarrollos.*

**Otros ficheros importantes de un proyecto de Angular**

Otros archivos que debemos tener en cuenta dentro del proyecto son:

- angular.json: Configuración del propio CLI. La madre de todos los configuradores
- package.json: Dependencias de librerías y scripts


#### Estructura de módulos
Existe múltiples consensos al respecto de como estructurar un proyecto en Angular, pero al final, depende de los requisitos del proyecto.
Una sugerencia de como hacerlo es la siguiente:

```
- src\app
	- core            	/* Componentes y utilidades comunes */ 
		- header	  	/* Estructura del header */ 
		- footer	  	/* Estructura del footer */ 
  - domain1       /* Módulo con los componentes del dominio1 */
	  - services       	/* Servicios con operaciones del dominio1 */ 
	  - models        	/* Modelos de datos del dominio1 */ 
	  - component1     	/* Componente1 del dominio1 */ 
	  - componentX     	/* ComponenteX del dominio1 */ 
  - domainX       /* Así para el resto de dominios de la aplicación */
```

Recordar, que esto es una sugerencia para una estructura de carpetas y componentes. No existe un estandar.

!!! tip "ATENCIÓN: Componentes genéricos"
    Debemos tener en cuenta que a la hora de programar un componente `core`, lo ideal es pensar que sea un componente plug & play, es decir que si lo copias y lo llevas a otro proyecto funcione sin la necesidad de adaptarlo.

### Buenas prácticas y Clean Code

A continuación veremos un listado de buenas prácticas de Angular y de código limpio que deberíamos intentar seguir en nuestro desarrollo.

#### Estructura de archivos
Antes de empezar con un proyecto lo ideal, es pararse y pensar en los requerimientos de una buena estructura, en un futuro lo agradecerás.

#### Nombres claros
Utilizar la S de los principios S.O.L.I.D para los nombres de variables, métodos y demás código.

El efecto que produce este principio son clases con nombres muy descriptivos y por tanto largos.

También se recomienta utilizar `kebab-case` para los nombres de ficheros. *Ej. hero-button.component.ts*

#### Organiza tu código

Intenta organizar tu código fuente:

-   Lo más importante debe ir arriba.
-   Primero propiedades, después métodos.
-   **Un Item para un archivo**: cada archivo debería contener solamente un componente, al igual que los servicios.
-   **Solo una responsabilidad**: Cada clase o modulo debería tener solamente una responsabilidad.
-   **El nombre correcto**: las propiedades y métodos deberían usar el sistema de camel case *(ej: getUserByName)*, al contrario, las clases (componentes, servicios, etc) deben usar upper camel case *(ej: UserComponent)*.
-   Los componentes y servicios deben tener su respectivo sufijo: UserComponent, UserService.
-   **Imports**: los archivos externos van primero.


#### Usar linters Prettier & ESLint
Un linter es una herramienta que nos ayuda a seguir las buenas prácticas o guías de estilo de nuestro código fuente. En este caso, para JavaScript, proveeremos de unos muy famosos.
Una de las más famosas es la combinación de  **Angular app to ESLint with Prettier, AirBnB Styleguide**
Recordar que añadir este tipo de configuración es opcional, pero necesaria para tener un buen código de calidad.

#### Git Hooks
Los Git Hooks son scripts de shell que se ejecutan automáticamente antes o después de que Git ejecute un comando importante como Commit o Push.
Para hacer uso de el es tan sencillo como:

npm install husky --save-dev

Y añadir en el fichero lo siguiente:

```js
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm test",
      "pre-push": "npm test",
      "...": "..."
    }
  }
}
```

!!! tip "Usar husky para el preformateo de código antes de subirlo"
    Es una buena práctica que todo el equipo use el mismo estándar de formateo de codigo, con husky se puede solucionar.

#### Utilizar Banana in the Box
Como el nombre sugiere **banana in the box** se debe a la forma que tiene lo siguiente: **[{}]**
Esto es una forma muy sencilla de trabajar los cambios en la forma de Two ways binding.
Es decir, el padre informa de un valor u objeto y el hijo lo manipula y actualiza el estado/valor al padre inmediatamente.
La forma de implementarlo es sencillo

**Padre:**
HTML:

`<my-input [(text)]="text"></my-input>`

**Hijo**

```js
@Input() value: string;
@Output() valueChange = new EventEmitter<string>();
updateValue(value){
	this.value = value;
	this.valueChange.emit(value);
}
```

!!! warning "Prefijo Change"
    Destacar que el prefijo **'Change'** es necesario incluirlo en el **Hijo** para que funcione

#### Correcto uso de los servicios
Una buena practica es aconsejable no declarar los servicios en el provides, sino usar un decorador que forma parte de las ultimas versiones de Angular

```js
@Injectable({
  providedIn: 'root',
})
export class HeroService {
  constructor() { }
}
```
#### Lazy Load
Lazy Load es un patrón de diseño que consiste en retrasar la carga o inicialización

desde el **app-routing.module.ts**

Añadiremos un codigo parecido a este
```js
  {
    path: 'customers',
    loadChildren: () => import('./customers/customers.module').then(m => m.CustomersModule)
  },
```

Con esto veremos que el módulo se cargará según se necesite.





## Springboot

### Estructura

Aquí tampoco existe nada estandarizado y oficial que hable sobre estructura de proyectos y nomenclatura de Springboot. Tan solo existen algunas sugerencias y buenas prácticas a la hora de desarrollar que te recomiendo que utilices en la medida de lo posible.

!!! tip Consejo
    Piensa que el código fuente que escribes hoy, es como un libro que se leerá durante años. Alguien tendrá que coger tu código y leerlo en unos meses o años para hacer alguna modificación y, como buenos desarrolladores que somos, tenemos la obligación de facilitarle en todo lo posible la comprensión de ese código fuente. Quizá esa persona futura podrías ser tu en unos meses y quedaría muy mal que no entendieras ni tu propio código :laughing:

#### Estructura en capas

Todos los proyectos web que construimos basados en Springboot se caracterizan por estar divididos en tres capas (a menos que utilicemos DDD para desarrollar que entonces existen infinitas capas :laughing:).

![Estructura-capas](./assets/images/estructura-capas.png)

* **Controlador**. Es la capa más alta, la que tiene acceso directo con el cliente. En esta capa es donde se exponen las operaciones que queremos publicar y que el cliente puede consumir. Para realizar sus operaciones lo más normal es que realice llamadas a las clases de la capa inmediatamente inferior.
* **Lógica**. También llamada capa de `Servicios`. Es la capa intermedia que da soporte a las operaciones que están expuestas y ejecutan toda la lógica de negocio de la aplicación. Para realizar sus operaciones puede realizar llamadas tanto a otras clases dentro de esta capa, como a clases de la capa inferior.
* **Acceso a Datos**. Como su nombre indica, es la capa que accede a datos. Típicamente es la capa que ejecuta las consultas contra BBDD, pero esto no tiene por qué ser obligadamente así. También entrarían en esa capa aquellas clases que consumen datos externos, por ejemplo de un servidor externo. Las clases de esta capa deben ser nodos `finales`, no pueden llamar a ninguna otra clase para ejecutar sus operaciones, ni siquiera de su misma capa.

#### Estructura de proyecto

En proyectos medianos o grandes, estructurar los directorios del proyecto en base a la estructura anteriormente descrita sería muy complejo, ya que en cada uno de los niveles tendríamos muchas clases.


#### Otras entidades


#### Consejos sobre la estructura

En base a esta división por capas que hemos comentado y el resto de entidades implicadas, hay una serie de reglas **importantísimas** que debes seguir muy de cerca:

* Un `Controlador`
    * NO debe contener lógica en su clase. Solo está permitido que ejecute lógica a través de un objeto de la capa `Lógica`.
    * NO puede ejecutar directamente operaciones de la capa `Aceso a Datos`, siempre debe pasar por la capa `Lógica`.
    * NO debe enviar ni recibir del cliente objetos de tipo `Entity`.
    * Es un buen lugar para realizar las conversiones de datos entre `Entity` y `Dto`.
    * En teoría cada operación debería tener su propio Dto, aunque los podemos reutilizar entre operaciones similares.
    * Debemos seguir una coherencia entre todas las URL de las operaciones. Por ejemplo si elegimos `save` para guardar, usemos esa palabra en todas las operaciones que sean de ese tipo. Evitad utilizar diferentes palabras `save`, `guardar`, `persistir`, `actualizar` para la misma acción.
* Un `Servicio`
    * NO puede llamar a objetos de la la capa `Controlador`.    



