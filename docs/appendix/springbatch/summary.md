# Resumen Batch - Spring Batch

## ¿Qué hemos hecho?

Llegados a este punto, ya has podido ver que los procesos batch tienen una filosofía muy diferente a una aplicación Spring Boot corriente, ya que el objetivo de los procesos está enfocado en procesado de datos y realización de tareas recurrentes.

En definitiva, lo que hemos implementado ha sido:

* **Lectura de fichero y persistencia en BBDD**: Este ha sido el primer ejemplo donde hemos visto la estructura básica de un batch y hemos hecho uso de las herramientas que nos proporciona para realizar tareas complejas de forma sencilla.

* **Lectura de fichero y persistencia en fichero**: Ejemplo similar al anterior para ilustrar la existencia de otro `Writer` y su utilización.

* **Limpieza**: Puesta en escena de la utilización de `Tasklet` que nos permite realizar operaciones atómicas que no requieran lectura, procesado y escritura para abarcar todo el espectro de posibles requisitos para implementar un proceso.


## Consideraciones

En estos ejemplos hemos realizado la implementación lo más sencilla posible de un proceso batch con `Spring Batch` y aunque no dista mucho de una implementación para un proyecto real, aquí un par de consideraciones a tener en cuenta:

* **Estructura**: A diferencia de Spring Boot no existe un convenio unificado de organización de clases y paquetes por lo que se puede ver de muchas formas diferentes. Aquí lo importante es que si se utiliza en un determinado proyecto, se debe respetar su estructura por homogeneidad y mantenibilidad del mismo.

* **Ejecución**: La ejecución de los procesos normalmente se delega en herramientas externas para su programación y ejecución. Esto varía mucho en función de la arquitectura que tenga implementada un determinado cliente.

Y como siempre, para tener la información más actualizada, acude a la documentación oficial de [Spring Batch](https://docs.spring.io/spring-batch/reference/index.html).


## Siguientes pasos

Ahora te propongo hacer un pequeño ejercicio para poner aprueba si los conceptos se han consolidado. Puedes realizarlo en el punto [Ahora hazlo tú!](exercise.md)
