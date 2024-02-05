# Entorno de desarrollo - Vue.js

## Instalación de herramientas
Las herramientas básicas que vamos a utilizar para esta tecnología son:

* [Visual Studio Code](https://code.visualstudio.com/)
* [Nodejs](https://nodejs.org/en)
* [Quasar CLI](https://quasar.dev/start/quick-start)


### Visual Studio Code

Lo primero de todo es instalar el IDE para el desarrollo front.

Te recomiendo utilizar [Visual Studio Code](https://code.visualstudio.com/), en un IDE que a nosotros nos gusta mucho y tiene muchos plugins configurables. Puedes entrar en su página y descargarte la versión estable.


### Nodejs

El siguiente paso será instalar el motor de [Nodejs](https://nodejs.org/es/). Entrando en la página de descargas e instalando la última versión estable. Con esta herramienta podremos compilar y ejecutar aplicaciones basadas en Javascript y Typescript, e instalar y gestionar las dependencias de las aplicaciones.


## Creación de proyecto

### Generar scaffolding

Lo primero que haremos será generar un proyecto mediante la librería "Quasar CLI" para ello ejecutamos en consola el siguiente comando:

```
npm init quasar
```

Este comando detectará si tienes el CLI de Quasar instalado y en caso contrario te preguntará si deseas instalarlo. Debes responder que sí, que lo instale. 

Una vez instalado, aparecerá un wizzard en el que se irán preguntando una serie de datos para crear la aplicación:

![install-vue1](../assets/images/install_vue1.png)

Y tendremos que elegir lo siguiente:

> What would you like to build?

> `App with Quasar CLI, let's go!`

> Project folder

> `tutorial-vue`

> Pick Quasar version

> `Quasar v2 (Vue 3 | latest and greatest)`

> Pick script type

> `Typescript`

> Pick Quasar App CLI variant

> `Quasar App CLI with Vite`

> Package name

> `tutorial-vue`

> Project product name

> `Ludoceta Tan`

> Project description

> `Proyecto tutorial Ludoteca Tan`

> Author

> `<por defecto el email>`

> Pick a Vue component style

> `Composition API`

> Pick your CSS preprocessor

> `Sass with SCSS syntax`

> Check the features needed for your project

> `ESLint`

> Pick an ESLint preset

> `Prettier`

> Install project dependencies?

> `Yes, use npm`


### Arrancar el proyecto

Cuando todo ha terminado el propio scaffolding te dice lo que tienes que hacer para poner el proyecto en marcha y ver lo que te ha generado, solo tienes que seguir esos pasos.


Accedes al directorio que acabas de crear y ejecutas

```
npx quasar dev
```

Esto arrancará el servidor y abrirá un navegador en el puerto 9000 donde se mostrará la template creada.

También podemos navegar nosotros mismos a la URL `http://localhost:9000/`.

!!! info "Info"
    Si durante el desarrollo del proyecto necesitas añadir nuevos módulos al proyecto Vue.js, será necesario resolver las dependencias antes de arrancar el servidor. Esto se puede realizar mediante el gestor de dependencias de Nodejs, directamente en consola ejecuta el comando npm install y descargará e instalará las nuevas dependencias..

!!! info "Proyecto descargado"
    Cuando se trata de un proyecto nuevo recien descargado de un repositorio, recuerda que será necesario resolver las dependencias antes de arrancar el servidor. Esto se puede realizar mediante el gestor de dependencias de Nodejs, directamente en consola ejecuta el comando npm install y descargará e instalará las nuevas dependencias. 
