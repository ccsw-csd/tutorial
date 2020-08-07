# Entorno de desarrollo

## Herramientas que utilizaremos
Las herramientas básicas que vamos a utilizar para el desarrollo del tutorial son:

* Para el desarrollo Back
    * Eclipse
    * Java 8+
    * Maven
* Para el desarrollo Front
    * Visual Studio Code
    * Node
    * Yarn
    * Angular CLI

Puedes instalarte estas herramientas por tu cuenta y configurarlas una a una, o puedes instalarte el entorno de desarrollo de devonfw con todo configurado y listo para usarse.


## Instalación del entorno devonfw

A continuación se explican los pasos a seguir para la instalación de Devon en nuestro equipo.

*  Nos aseguramos que tenemos en nuestro equipo el siguiente software instalado:
      *  [7-Zip](https://www.7-zip.org/)
      *  [Git y curl](https://git-scm.com/download/win). Ojo, es muy importante que tengamos seteada la variable GIT_HOME, de lo contrario fallará la instalación de devonfw.
*  Descargamos la última versión de los scripts de instalación de Devon desde [aquí.](https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.devonfw.tools.ide&a=devonfw-ide-scripts&v=LATEST&p=tar.gz)

*  Una vez descargado, tendremos un fichero con extensión *.tar.gz. Descomprimimos con 7-Zip y  obtendremos un fichero con extensión *.tar. Por último, volveremos a descomprimir el fichero *.tar y ya tendremos una carpeta con los scripts.

*  Renombramos dicha carpeta (por ejemplo: devon) y la copiamos en C:\, quedándonos una ruta del estilo C:\devon.

*  Accedemos a la carpeta recién creada y ejecutamos el fichero *setup.bat*.
!!! attention "Atención"
    Si no tenemos definida la variable de entorno GIT_HOME, el proceso fallará y nos dará un error que no ecuentra "bin/bash.exe". Aseguraos de que la variable exista.

*  Aparecerá un mensaje para introducir la URL para descargar los settings, como el siguiente:
![Devon-setup](./assets/images/devon-setup.png)
Simplemente pulsado la tecla Enter y el proceso continuará.

*  A continuación, el instalador se va a descargar todo el software necesario para tener todo el paquete de herramientas listo. Se trata de una descarga de software larga y posiblemente lenta, por lo que deberemos armarnos de paciencia.

*  Una vez haya terminado el proceso, nos dirigimos a nuestra carpeta de instalación y ya podremos arrancar nuestro entorno de desarrollo Eclipse. Para ello ejecutaremos el fichero *eclipse-main.bat*. Una vez comprobemos que arranca, ya lo podemos cerrar.