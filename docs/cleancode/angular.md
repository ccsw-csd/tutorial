# Estructura y Buenas prácticas - Angular

!!! info "Nota"
    Antes de empezar y para puntualizar, Angular se considera un framework SPA Single-page application.

En esta parte vamos a explicar los fundamentos de un proyecto en Angular y las recomendaciones existentes.

## Estructura y funcionamiento

### Ciclo de vida de Angular

El comportamiento de ciclo de vida de un componente Angular pasa por diferentes etapas que podemos ver en el esquema que mostramos a continuación:

![angular-lifecycle](../assets/images/angular-lifecycle.png)

Es importante tenerlo claro para saber que métodos podemos utilizar para realizar operaciones con el componente.


### Carpetas creadas por Angular

Al crear una aplicación Angular, tendremos los siguientes directorios:

- node_modules: *Todos los módulos de librerías usadas por el proyecto.*
-	\src\app: *Contiene todo el código asociado al proyecto.*
    -	\src\assets: *Normalmente la carpeta usada para los recursos.*
	-	\src\environments: *Aquí irán los ficheros relacionados con los entornos de desarrollos.*

**Otros ficheros importantes de un proyecto de Angular**

Otros archivos que debemos tener en cuenta dentro del proyecto son:

- angular.json: Configuración del propio CLI. La madre de todos los configuradores
- package.json: Dependencias de librerías y scripts


### Estructura de módulos
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

## Buenas prácticas

A continuación veremos un listado de buenas prácticas de Angular y de código limpio que deberíamos intentar seguir en nuestro desarrollo.

### Estructura de archivos
Antes de empezar con un proyecto lo ideal, es pararse y pensar en los requerimientos de una buena estructura, en un futuro lo agradecerás.

### Nombres claros
Utilizar la S de los principios S.O.L.I.D para los nombres de variables, métodos y demás código.

El efecto que produce este principio son clases con nombres muy descriptivos y por tanto largos.

También se recomienta utilizar `kebab-case` para los nombres de ficheros. *Ej. hero-button.component.ts*

### Organiza tu código

Intenta organizar tu código fuente:

-   Lo más importante debe ir arriba.
-   Primero propiedades, después métodos.
-   **Un Item para un archivo**: cada archivo debería contener solamente un componente, al igual que los servicios.
-   **Solo una responsabilidad**: Cada clase o modulo debería tener solamente una responsabilidad.
-   **El nombre correcto**: las propiedades y métodos deberían usar el sistema de camel case *(ej: getUserByName)*, al contrario, las clases (componentes, servicios, etc) deben usar upper camel case *(ej: UserComponent)*.
-   Los componentes y servicios deben tener su respectivo sufijo: UserComponent, UserService.
-   **Imports**: los archivos externos van primero.


### Usar linters Prettier & ESLint
Un linter es una herramienta que nos ayuda a seguir las buenas prácticas o guías de estilo de nuestro código fuente. En este caso, para JavaScript, proveeremos de unos muy famosos.
Una de las más famosas es la combinación de  **Angular app to ESLint with Prettier, AirBnB Styleguide**
Recordar que añadir este tipo de configuración es opcional, pero necesaria para tener un buen código de calidad.

### Git Hooks
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

### Utilizar Banana in the Box
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

### Correcto uso de los servicios
Una buena practica es aconsejable no declarar los servicios en el provides, sino usar un decorador que forma parte de las ultimas versiones de Angular

```js
@Injectable({
  providedIn: 'root',
})
export class HeroService {
  constructor() { }
}
```
### Lazy Load
Lazy Load es un patrón de diseño que consiste en retrasar la carga o inicialización

desde el **app-routing.module.ts** o desde **app.routes.ts** si estamos en Angular 17+

Añadiremos un codigo parecido a este
```js
  // Para cargar modulos
  {
    path: 'customers',
    loadChildren: () => import('./customers/customers.module').then(m => m.CustomersModule)
  },

  // Para cargar standalone components
  {
    path: 'customers',
    loadComponent: () => import('./customers/customers.component').then(m => m.CustomersComponent)
  },
```

Con esto veremos que el módulo o componente se cargará según se necesite.