# Preparación del entorno

!!! warning Atención
    Esta sección se encuentra en desarrollo 🚧.  
    **NO se recomienda realizarla** a menos que te lo hayan indicado expresamente.

En esta sección se asume que ya se ha completado el tutorial base y que el **Entorno de desarrollo** para Angular y Spring Boot está correctamente configurado.

Además, sería de mucha ayuda si además has realizado el ejercicio **`Ahora hazlo tu!`** ya que así tendrás el conocimiento de lo que estamos intentando construir en este punto.

Por tanto, partimos de un entorno en el que ya están instaladas las herramientas básicas necesarias para trabajar en el proyecto. 

Daremos por hecho que ya dispones de:

- **Visual Studio Code**
- **Node.js**
- **Angular CLI**
- **Java (17 o superior)**

Estas herramientas se consideran **prerrequisitos** y no se describirá de nuevo su instalación detallada en este apartado.

!!! info "Info"
    Si alguna de estas herramientas no está instalada o necesitas revisar el proceso completo de configuración, puedes consultar los siguientes apartados del tutorial:

    - Entorno de desarrollo – Angular
    - Entorno de desarrollo – Spring Boot

---

## Instalación de herramientas

En este apartado se describen las herramientas necesarias y la preparación del entorno para poder trabajar con **Spec-Driven Development** utilizando **OpenSpec**.

Durante todo el proceso se trabajará desde **Visual Studio Code**, utilizando un único workspace que contendrá el frontend, el backend y las especificaciones.

---

### Verificación de Node.js

OpenSpec se distribuye como una herramienta basada en Node.js, por lo que es necesario tener instalado **Node.js 20.19.0 o superior**.

Para comprobar la versión instalada, ejecuta en una terminal:

```
node --version
```

Si no tienes Node.js instalado o tu versión es inferior, puedes descargarlo desde su [web oficial](https://nodejs.org/).

Se recomienda instalar la versión LTS más reciente.

Si tienes restricciones de permisos en el portátil, también es posible instalar Node.js a través del Portal de Empresa, siguiendo el mismo procedimiento utilizado durante la configuración del Entorno de desarrollo para el tutorial:

1. Accede al Portal de Empresa
2. Entra en el catálogo de aplicaciones pre‑aprobadas
3. Busca Node.js
4. Instálalo desde ahí

Una vez finalizada la instalación, vuelve a ejecutar el comando `node --version` para verificar que Node.js está correctamente instalado.

--- 

### Instalación de OpenSpec


OpenSpec se puede instalar de forma global utilizando cualquiera de los gestores de paquetes soportados por Node.js.  

Si utilizas **npm**, ejecuta el siguiente comando:

```
npm install -g @fission-ai/openspec@latest
```

!!! info "Info"
    OpenSpec también es compatible con otros gestores de paquetes como pnpm, yarn o bun.

    En esta guía se utilizará npm por simplicidad y porque es el más común.

Una vez finalizada la instalación, verifica que OpenSpec está correctamente instalado ejecutando:
```
openspec --version
```

Si el comando responde correctamente mostrando la versión instalada, el entorno ya está preparado para trabajar con Spec‑Driven Development utilizando OpenSpec.



## Preparación de entorno

### Github Copilot 

Llegados a este punto, y para poder seguir, necesitas una cuenta de GitHub con GitHub Copilot, da igual que sea con licencia premium o con versión gratuita. Además de tener cuenta, deberás acceder desde ``Visual Studio Code`` a esta cuenta para poder activar las características del chat.


### Estructura inicial del proyecto

A partir de aquí, necesitas los proyectos base (*sin el ejercicio hecho*) para poder seguir con los siguientes puntos de la guía.
Si no los tienes, los puedes descargar de aquí [https://github.com/ccsw-csd/tutorial-proyectos](https://github.com/ccsw-csd/tutorial-proyectos).


En nuestro ejemplo vamos a utilizar los proyectos de ``server-springboot`` y ``client-angular17``. Los dos proyectos deberían estar en un mismo directorio raiz. Para simplificar los siguientes puntos, durante todo el documento, los llamaremos:

- **``backend``**
- **``frontend``**

La estructura debería ser similar a esta:

![workspace](../assets/images/specs-install_1.png)


### ¿Y ahora qué?

Pues a partir de ahora debemos elegir que camino tomar... si tenemos GitHub Copilot premium con licencia, podemos hacer el tutorial versión 💰💰 que tendrá más contexto y será mucho más rápido y concreto.

Si por el contrario tenemos la licencia gratuita de GitHub Copilot, podremos hacer la versión del tutorial 🆓🆓, pero será bastante más lento y deberemos abordarlo de otra forma. Además de armarnos de mucha paciencia.

La versión gratuita tiene muchas limitaciones, de contexto, de peticiones por hora y por día que es posible que superes y tengas que esperar al día siguiente para continuar con el tutorial.

Tu decides:

- [🆓 Gestión de clientes](./customers_free.md)
- [🆓 Gestión de préstamos](./loans_free.md)
- [💰 Gestión de clientes](./customers_paid.md)
- [💰 Gestión de préstamos](./loans_paid.md)
