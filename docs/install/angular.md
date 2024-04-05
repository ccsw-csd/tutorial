# Entorno de desarrollo - Angular

## Instalación de herramientas
Las herramientas básicas que vamos a utilizar para esta tecnología son:

* [Visual Studio Code](https://code.visualstudio.com/)
* [Scoop.sh](https://scoop.sh/)
* Nodejs
* Angular CLI


### Visual Studio Code

Lo primero de todo es instalar el IDE para el desarrollo front.

Te recomiendo utilizar [Visual Studio Code](https://code.visualstudio.com/), en un IDE que a nosotros nos gusta mucho y tiene muchos plugins configurables. Puedes entrar en su página y descargarte la versión estable.


### Scoop.sh

Muchas de las herramientas que necesitarás a lo largo de tu estancia en los proyectos, no podrás instalarlas por temas de permisos de seguridad en nuestros portátiles. Una forma de evitar estos permisos de seguridad y poder instalar herramientas (sobre todo a nivel de consola), es utilizando a [Scoop.sh](https://scoop.sh/).

Para instalar *scoop.sh* tan solo necesitas abrir un termina de PowerShell (**OJO que es PowerShell y no una consola de msdos**) y ejecutar los siguientes comandos:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

Esto nos instalará *scoop.sh* en nuestros portátiles. Además de la instalación, y debido a las restricciones de seguridad que tenemos, necesitaremos activar el *lessmsi* para que las aplicaciones que necesitemos instalar no intenten ejecutar los .exe de instalación, sino que descompriman el zip. Para ello deberemos ejecutar el comando:

```
scoop config use_lessmsi true
```

A partir de este punto, ya tenemos listo el portátil para instalar herramientas y aplicaciones.


### Nodejs

El siguiente paso será instalar el motor de Nodejs. Para esto vamos a usar *scoop.sh* ya que lo tenemos instalado, y vamos a pedirle que nos instalé el motor de Nodejs. Abriremos una consola de msdos y ejecutaremos el comando:

```
scoop install main/nodejs
```

Con esto, scoop ya nos instalará todo lo necesario.


### Angular CLI

El siguiente pasó será instalar una capa de gestión por encima de Nodejs que nos ayudará en concreto con la funcionalidad de Angular. En concreto instalaremos el CLI de Angular para la versión 16. Para poder instalarlo, tan solo hay que abrir una consola de msdos y ejecutar el comando y Nodejs ya hará el resto:

```
npm install -g @angular/cli@16
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

