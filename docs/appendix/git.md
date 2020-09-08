# Tutorial básico de Git

!!! warning "Atención"
	Esta sección está incompleta y todavía en desarrollo. Puedes leerla pero seguramente cambiará o ampliará su información.


Cada vez se tiende más a utilizar repositorios de código Git y, aunque no sea objeto de este tutorial Springboot-Angular, queremos hacer un resumen muy básico y sencillo de como utilizar Git.

En el mercado existen multitud de herramientas para gestionar repositorios Git, podemos utilizar cualquiera de ellas, aunque desde devonfw se recomienda utilizar [Git SCM](https://git-scm.com/download/win).
Además, existen también multitud de servidores de código que implementan repositorios Git, como podrían ser GitHub, GitLab, Bitbucket, etc. Todos ellos trabajan de la misma forma, así que este resumen servirá para todos ellos.

!!tip "Info"
    Este anexo muestra un resumen muy sencillo y básico de los comandos más comunes que se utilizan en Git. Para ver detalles más avanzados o un tutorial completo te recomiendo que leas la guia de [Atlassian](https://www.atlassian.com/es/git).

Ahora si, vamos al resumen básico de Git. 


## Estructuras y flujo de trabajo

Lo primero que debes conocer de Git es su funcionamiento básico de flujo de trabajo. Tu repositorio local está compuesto por tres "estructuras" que contienen los archivos y los cambios de los ficheros del repositorio. 

![apendix_git-workflow_1](../assets/images/apendix_git-workflow_1.png)

- **Working directory** - Contiene los archivos con los que estás trabajando localmente.
- **Staging Area** - Es un área intermedia donde vamos añadiendo ficheros para ir agrupando modificaciones.
- **Local Repository** - Es el repositorio local donde tendrémos el registro de todos los commits que hemos realizado. Por defecto apunta a HEAD que es el último commit registrado.

Existen operaciones que nos permiten añadir o borrar ficheros dentro de cada una de las estructuras desde otra estructura.

![apendix_git-workflow_2](../assets/images/apendix_git-workflow_2.png)

Así pues, los comandos básicos dentro de nuestro repositorio local son los siguientes.

### **add y commmit**

Puedes registrar los cambios realizados en tu `working directory` y añadirlos al `staging area` usando el comando

```
git add <filename>
```
    o si quieres añadir todos los ficheros modificados
```
git add .
```

Este es el primer paso en el flujo de trabajo básico. Una vez tenemos los cambios registrados en el `staging area` podemos hacer un commit y persistirlos dentro del `local repository` mediante el comando

```
git commit -m "<Commit message>"
```

A partir de ese momento, los ficheros modificados y añadidos al `local repository` se han persistido y se han añadido a tu `HEAD`, aunque todavía siguen estando el local, no lo has enviado a ningún repositorio remoto.


### **reset**

De la misma manera que se han añadido ficheros a `staging area` o a `local repository`, podemos retirarlos de estas estructuras y volver a recuperar los ficheros que teníamos anteriormente en el `working directory`. Por ejemplo, si nos hemos equivocado al incluir ficheros en un commit o simplemente queremos deshacer los cambios que hemos realizado bastaría con lanzar el comando

```
git reset --hard
```
    o si queremos volver a un commit concreto
```
git reset <COMMIT>
```


## Trabajo con ramas

Para complicarlo todo un poco más, el trabajo con git siempre se realiza mediante ramas. Estas ramas nos sirven para desarrollar funcionalidades aisladas unas de otras y poder hacer mezclas de código de unas ramas a otras. Las ramas más comunes dentro de git suelen ser:

- **master** Esta será la rama que contenga el código fuente que tenemos en **`producción`**.
- **release** Esta será la rama que contenga el código fuente de cada una de las entregas parciales, no tiene porqué coincidir con la rama `master`.
- **develop** Esta será la rama que contenga el código fuente estable que está actualmente en desarrollo.
- **feature/xxxx** Estas seránn la rama que contengan el código fuente de desarrollo de cada una de las funcionalidades. Generalmente estas ramas las crea cada desarrollador, las mantiene en local, hasta que las sube a remoto para realizar un `merge` a la rama `develop`.

Siempre que trabajes con ramas debes tener en cuenta que al empezar tu desarrollo debes partir de una versión actualizada de la rama `develop`, y al terminar tu desarrollo debes solicitar un `merge` contra `develop`, para que tu funcionalidad esté incorporada en la rama de desarrollo.

![apendix_git-workflow_3](../assets/images/apendix_git-workflow_3.png)


## Remote repository

### clone

### envío de cambios

### actualizar y fusionar

## Guía rápida

Los pasos básicos de utilización de git son sencillos.

- Primero nos bajamos el repositorio o lo creamos en local mediante los comandos
```
git clone
    o 
git init
```
- Una vez estamos trabajando con nuestro repositorio remoto, cada vez que vayamos a comenzar una funcionalidad nueva, debemos crear una rama nueva siempre partiendo desde `develop` mediante el comando 
```
git checkout -b <rama>
```
- Cuando tengamos implementados los cambios que queremos realizar, hay que subirlos al staging y luego persistirlos en nuestro repositorio local. Esto lo hacemos con el comando
```
git add .
git commit -m "<Commit message>"
```
- Siempre antes de subir los cambios al repositorio remoto, hay que comprobar que tenemos actualizada nuestra rama comparandola con la rama remota que queremos mergear, en nuestro ejemplo será `develop`. Por tanto tenemos que cambiar a la rama `develop`, descargarnos los cambios del repositorio remoto, volver a cambiar a nuestra rama y ejecutar un merge desde `develop` hacia nuestra rama, ejecutando estos comandos
```
git checkout develop
git pull
git checkout <rama>
git merge develop
```
- Ahora que ya tenemos actualizadas las ramas, tan solo nos basta subir nuestra rama a remoto, con el comando
```
git push --set-upstream origin <rama>
```
- Por último accedemos al cliente web del repositorio y solicitamos un `merge request` contra `develop`. Para que sea validado y aprobado por otro compañero del equipo.
- Si en algún momento necesitamos modificar nuestro código del `merge request` antes de que haya sido aprobado, nos basta con repetir los pasos anteriores
```
git add .
git commit -m "<Commit message>"
git push origin
```
- Una vez hayamos terminado el desarrollo y vayamos a empezar una nueva funcionalidad, volveremos al punto 2 de este listado y comenzaremos de nuevo los comando. Debemos recordad que tenemos que partir siempre de la rama `develop` y además debe estar actualizada `git pull`.

