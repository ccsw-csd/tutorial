# MÓDULO 1: INSTALACIÓN DOCKER EN WINDOWS

Para instalar la versión gratuita y open source de Docker Community Edition (CE) siga estos pasos:  

1. Instalar Ubuntu 24.04.1 LTS desde Microsoft Store:  
Como no está el WSL, al ejecutar, no funcionará y saldrá un error, pero se solucionará en los pasos siguientes.  

2. Instalar PowerShell desde Microsoft Store.  

3. Instalar el Subsistema de Linux para Windows:  
· Ejecuta el comando `wsl --install`  
· Manda una petición para que te lo instalen. Cuando sea aprobada, debería dejarte continuar.  

![elevar-req.png](images/elevar-req.png)  
Ejemplo de lo que os sale, se elige la primera opción  

· Después  
![run-wsl.png](images/run-wsl.png)  

4.	Verificar la instalación:  
• Para ver si está instalado, ejecuta `wsl –version`  
![wsl-version.png](images/wsl-version.png)  

• Prueba `wsl --status`. Aquí debería indicar que "Windows subsystem for Linux has no installed distributions".  
• Cuando abras Ubuntu, seguramente no funcione. De manera que tienes que reiniciar el PC y comprobar que ahora Ubuntu sí funciona.  

5.	Introducir los siguientes comandos en Ubuntu.  
Si pide un usuario y contraseña, poner la que sea.  

• Más adelante damos unas capturas  
• `sudo apt-get update`  
• `sudo apt-get install apt-transport-https ca-certificates curl software-properties-common`  
• `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add –`  
• `sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable”`  
• `sudo apt-get install docker-ce`  
• `sudo gpasswd -a $USER docker`  

En este o en el siguiente paso, te dará error por falta de permisos, no hay problema:  
• Abrir Ubuntu y darle a ejecutar como administrador.  
• Después, tendréis que pedir una solicitud para los permisos.  
• `sudo service docker start`  
• `docker run hello-world`  
![docker-run-hello.png](images/docker-run-hello.png)  
![docker-run-hello-2.png](images/docker-run-hello-2.png)  
![docker-run-hello-3.png](images/docker-run-hello-3.png)  

6.	Entrar en Ubuntu como administrador:  
• Vuelve a ejecutar en Ubuntu `sudo service docker start`  
• Ejecuta `docker run hello-world`  
![docker-run-hello-4.png](images/docker-run-hello-4.png)  

7.	Verificar Docker:  
• Cuando ejecutes el comando anterior, debería funcionar.  
• Prueba `docker ps -a` para ver un listado de contenedores.  