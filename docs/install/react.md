# Entorno de desarrollo - React

## Instalación de herramientas
Las herramientas básicas que vamos a utilizar para esta tecnología son:

* [Visual Studio Code](https://code.visualstudio.com/)
* [Nodejs](https://nodejs.org/es/)


### Visual Studio Code

Lo primero de todo es instalar el IDE para el desarrollo front.

Te recomiendo utilizar [Visual Studio Code](https://code.visualstudio.com/), en un IDE que a nosotros nos gusta mucho y tiene muchos plugins configurables. Puedes entrar en su página y descargarte la versión estable.


### Nodejs

El siguiente paso será instalar el motor de [Nodejs](https://nodejs.org/es/). Entrando en la página de descargas e instalando la última versión estable. Con esta herramienta podremos compilar y ejecutar aplicaciones basadas en Javascript y Typescript, e instalar y gestionar las dependencias de las aplicaciones.


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
