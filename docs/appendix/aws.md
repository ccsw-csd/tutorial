# AWS CLI

AWS CLI (Command Line Interface) es una herramienta oficial proporcionada por Amazon Web Services que permite gestionar y automatizar servicios en la nube directamente desde la terminal, sin necesidad de acceder a la consola web. Con AWS CLI, los desarrolladores, administradores de sistemas y arquitectos pueden ejecutar comandos para crear, configurar y controlar recursos como instancias EC2, buckets S3, funciones Lambda, entre otros. Su uso es esencial en entornos donde se requiere eficiencia, repetibilidad y automatización, como en scripts de despliegue, tareas programadas o integraciones CI/CD. Además, facilita el trabajo remoto y la administración de múltiples cuentas o regiones de AWS de forma centralizada y segura.


## Pre-requisitos

Vamos a instalar AWS CLI desde un sistema Linux, así que lo primero que deberás tener instalado en tu máquina es un Linux o un WSL. Si no lo tienes, puedes revisar el tutorial de [Subsistema de Linux para Windows](./docker/installdocker.md).


## Instalación de AWS CLI

Una vez tenemos Linux, si entramos en su consola de comandos, para instalar AWS CLI tan solo es necesario lanzar estos comandos:


1. Update your Ubuntu packages
``` 
sudo apt update
sudo apt upgrade -y
``` 

2. Install unzip if you don't have it already
``` 
sudo apt install -y unzip curl
``` 

3. Download the AWS CLI v2 installation package
``` 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
``` 

4. Unzip the installer
``` 
unzip awscliv2.zip
``` 

5. Run the install program
``` 
sudo ./aws/install
``` 

6. Verify the installation
``` 
aws --version
``` 

Y eso es todo, ya tienes AWS CLI instalado.
