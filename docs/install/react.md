# Entorno de desarrollo - React

## Instalación de herramientas
Las herramientas básicas que vamos a utilizar para esta tecnología son:

* [Visual Studio Code](https://code.visualstudio.com/)
* [Scoop.sh](https://scoop.sh/)
* Nodejs


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


## Creación de proyecto

Hasta ahora para la generación de un proyecto React se ha utilizado la herramienta “create-react-app” pero últimamente se usa más vite debido a su velocidad para desarrollar y su optimización en tiempos de construcción. En realidad, para realizar nuestro proyecto da igual una herramienta u otra más allá de un poco de configuración, pero para este proyecto elegiremos vite por su velocidad.

Para generar nuestro proyecto react con Vite abrimos una consola de Windows y escribimos lo siguiente en la carpeta donde queramos localizar nuestro proyecto: 

``` Typescript
npm create vite@latest
```

Con esto se nos lanzara un wizard para la creación de nuestro proyecto donde elegiremos el nombre del proyecto (en mi caso ludoteca-react), el framework (react evidentemente) y en la variante elegiremos typescript.
Tras estos pasos instalaremos las dependencias base de nuestro proyecto. Primero accedemos a la raíz y después ejecutaremos el comando install de npm. 

``` Typescript
cd ludoteca-react
```

``` Typescript
npm install
```

ó 

``` Typescript
npm i
```

## Arrancar el proyecto

Para arrancar el proyecto, tan solo necesitamos ejecutar en consola el siguiente comando siempre dentro del directorio creado por Vite:

    npm run dev

Vite compilará el código fuente, levantará un servidor local al que podremos acceder por defecto mediante la URL: [http://localhost:5173/](http://localhost:5173/)

Y ya podemos empezar a trabajar en nuestro proyecto React.

!!! info "Info"
    Cuando se trata de un proyecto nuevo recien descargado de un repositorio, recuerda que será necesario resolver las dependencias antes de arrancar el servidor. Esto se puede realizar mediante el gestor de dependencias de Nodejs, directamente en consola ejecuta el comando `npm update` y descargará e instalará las nuevas dependencias.
