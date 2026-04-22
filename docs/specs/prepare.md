# Preparación del entorno

!!! warning Atención
    Esta sección se encuentra en desarrollo 🚧.  
    **NO se recomienda realizarla** a menos que te lo hayan indicado expresamente.

En esta sección asumimos que ya completaste el tutorial base y que el entorno de Angular y Spring Boot está configurado.

También es recomendable haber hecho el ejercicio **`Ahora hazlo tu!`** para que el contexto funcional te resulte familiar.

Partimos, por tanto, de un entorno con las herramientas básicas ya instaladas.

Daremos por hecho que ya dispones de:

- **Visual Studio Code**
- **Node.js**
- **Angular CLI**
- **Java (17 o superior)**

Estas herramientas son **prerrequisitos** y aquí no repetiremos su instalación en detalle.

!!! info "Info"
    Si alguna de estas herramientas no está instalada o necesitas revisar el proceso completo de configuración, puedes consultar los siguientes apartados del tutorial:

    - Entorno de desarrollo – Angular
    - Entorno de desarrollo – Spring Boot

---

## Prerrequisitos técnicos

Vamos a preparar el entorno para trabajar con **Spec-Driven Development** usando **OpenSpec** desde **Visual Studio Code**, en un único workspace con frontend, backend y especificaciones.

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

OpenSpec se puede instalar de forma global con cualquier gestor compatible con Node.js.

Si utilizas **npm**, ejecuta el siguiente comando:

```
npm install -g @fission-ai/openspec@latest
```

!!! info "Info"
    OpenSpec también es compatible con `pnpm`, `yarn` o `bun`. En esta guía usaremos `npm` por simplicidad.

Una vez finalizada la instalación, verifica que OpenSpec está correctamente instalado ejecutando:
```
openspec --version
```

Si el comando responde correctamente mostrando la versión instalada, el entorno ya está preparado para trabajar con Spec‑Driven Development utilizando OpenSpec.


## Convenciones de trabajo (aplican a todos los ejercicios)

### GitHub Copilot

Necesitas una cuenta de GitHub con Copilot (gratuita o premium) y haber iniciado sesión en `Visual Studio Code` para usar el chat.


### Estructura inicial del proyecto

A partir de aquí necesitas los proyectos base (*sin el ejercicio hecho*).
Si no los tienes, puedes descargarlos en [https://github.com/ccsw-csd/tutorial-proyectos](https://github.com/ccsw-csd/tutorial-proyectos).


En esta guía vamos a usar `server-springboot` y `client-angular17`. Ambos deben estar en el mismo directorio raíz. Para simplificar, durante todo el documento, los llamaremos:

- **`backend`**
- **`frontend`**

La estructura debería ser similar a esta:

![workspace](../assets/images/specs-install_1.png)


### Reglas generales y de ejecución

Durante todos los ejercicios:

- Empieza cada cambio relevante en un chat nuevo para no arrastrar contexto innecesario.
- Revisa siempre la propuesta antes de ejecutar la fase de `Apply`.
- Valida manualmente los resultados funcionales después de aplicar.

### ¿Y ahora qué?

A partir de aquí eliges ruta:

- Con licencia de pago 💰 tendrás más contexto y menos fragmentación.
- Con licencia gratuita 🆓 tendrás menos contexto y más iteraciones. Además es posible que superes las limitaciones diarias o de hora y tengas que esperar al día siguiente para continuar con el tutorial.

El flujo funcional es el mismo en ambos casos.

Elige tu camino:

- [🆓 Gestión de clientes](./customers_free.md)
- [🆓 Gestión de préstamos](./loans_free.md)
- [💰 Gestión de clientes](./customers_paid.md)
- [💰 Gestión de préstamos](./loans_paid.md)
