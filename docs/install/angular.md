# Entorno de desarrollo - Angular

## Instalación de herramientas
Las herramientas básicas que vamos a utilizar para esta tecnología son:

* Visual Studio Code
* Node
* Angular CLI


### Visual Studio Code

Lo primero de todo es instalar el IDE para el desarrollo front.

Te recomiendo utilizar [Visual Studio Code](https://code.visualstudio.com/), en un IDE que a nosotros nos gusta mucho y tiene muchos plugins configurables. Puedes entrar en su página y descargarte la versión estable.


### Nodejs

El siguiente paso será instalar el motor de [Nodejs](https://nodejs.org/es/). Entrando en la página de descargas e instalando la última versión estable. Con esta herramienta podremos compilar y ejecutar aplicaciones basadas en Javascript y Typescript, e instalar y gestionar las dependencias de las aplicaciones.


### Angular CLI

Por último vamos a instalar una capa de gestión por encima de Nodejs que nos ayudará en concreto con la funcionalida de Angular. En concreto instalaremos el CLI de Angular. Para poder instalarlo, tan solo hay que abrir una consola de msdos y ejecutar el comando y Nodejs ya hará el resto:

```
npm install -g @angular/cli
```

Y con esto ya tendremos todo instalado, listo para empezar a crear los proyectos.


## Creación de proyecto

La mayoría de los proyectos con Angular en los que trabajamos normalmente, suelen ser proyectos web usando las librerías mas comunes de angular, como Angular Material.

Crear un proyecto de Angular es muy sencillo si tienes instalado el CLI de Angular. Lo primero abrir una consola de msdos y posicionarte en el directorio raiz donde quieres crear tu proyecto Angular, y ejecutamos lo siguiente:

```
ng new tutorial --strict=false
```

El propio CLI nos irá realizando una serie de preguntas.

> Would you like to add Angular routing? (y/N)

>  `Preferiblemente: y`

> Which stylesheet format would you like to use?

>  `Preferiblemente: SCSS`

En el caso del tutorial como vamos a tener dos proyectos para nuestra aplicación (front y back), para poder seguir correctamente las explicaciones, voy a renombrar la carpeta para poder diferenciarla del otro proyecto. A partir de ahora se llamará `client`.

!!! info "Info"
    Si durante el desarrollo del proyecto necesitas añadir nuevos módulos al proyecto Angular, será necesario resolver las dependencias antes de arrancar el servidor. Esto se puede realizar mediante el gestor de dependencias de Nodejs, directamente en consola ejecuta el comando `npm update` y descargará e instalará las nuevas dependencias.


## Arrancar el proyecto

Para arrancar el proyecto, tan solo necesitamos ejecutar en consola el siguiente comando siempre dentro del directorio creado por Angular CLI:

    ng serve

Angular compilará el código fuente, levantará un servidor local al que podremos acceder por defecto mediante la URL: [http://localhost:4200/](http://localhost:4200/)

Y ya podemos empezar a trabajar con Angular.

!!! info "Info"
    Cuando se trata de un proyecto nuevo recien descargado de un repositorio, recuerda que será necesario resolver las dependencias antes de arrancar el servidor. Esto se puede realizar mediante el gestor de dependencias de Nodejs, directamente en consola ejecuta el comando `npm update` y descargará e instalará las nuevas dependencias.

!!! tip "Comandos de Angular CLI"
    Si necesitas más información sobre los comandos que ofrece Angular CLI para poder crear aplicaciones, componentes, servicios, etc. los tienes disponibles en:
    [https://angular.io/cli#command-overview](https://angular.io/cli#command-overview)

