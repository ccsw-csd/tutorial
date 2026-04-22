# Instalación del entorno

!!! warning Atención
    Esta sección se encuentra en desarrollo 🚧.  
    **NO se recomienda realizarla** a menos que te lo hayan indicado expresamente.

En esta sección se asume que ya se ha completado el tutorial base y que el **Entorno de desarrollo** para Angular y Spring Boot está correctamente configurado.

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






Los proyectos base se deben descargar de aquí --> https://github.com/ccsw-csd/tutorial-proyectos


para el ejemplo vamos a usar angular y springboot 


Luego contar que hay modelos de pago y modelos gratuitos y por tanto deben elegir una de las opciones. Contar beneficios de uno y de otro


- 🆓 Gestión de clientes: specs/customers_free.md
- 🆓 Gestión de préstamos: specs/loans_free.md

- 💰 Gestión de clientes: specs/customers_paid.md
- 💰 Gestión de préstamos: specs/loans_paid.md
