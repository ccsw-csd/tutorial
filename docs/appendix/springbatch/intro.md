# Introducción Batch - Spring Batch

## Que son los procesos batch?

El proceso batch o procesamiento por lotes es un proceso por el cual un sistema realiza procesos, muchas veces de forma simultánea, de forma continuada y secuencial. 

Normalmente, este tipo de procesos se dividen en pequeñas partes que se realizan de forma contínua consiguiendo un mejor rendimiento.


## Spring Batch

Existente multiples soluciones para implementar procesos batch, en nuestro caso vamos a utilizar la solución que nos ofrece Spring Framework y que está incluido dentro del módulo [Spring Batch](https://spring.io/projects/spring-batch/). 

Spring Batch es framework de procesos batch ligero y completo diseñado para permitir el desarrollo de aplicaciones por lotes robustas, vitales para las operaciones diarias de los sistemas empresariales.

Proporciona funciones reutilizables que son esenciales en el procesamiento de grandes volúmenes de registros, incluyendo trazabilidad, gestión de transacciones, estadísticas de procesamiento de trabajos, reinicio de trabajos, omisión y gestión de recursos. También proporciona servicios y funcionalidades más avanzadas que permitirán realizar procesos batch de gran volumen y alto rendimiento mediante técnicas de optimización y partición.


### Estructura

![Spring Batch](../../assets/images/spring-batch-reference-model.png)

* **JobLauncher**: Esta pieza es la encargada de la gestión de ejecuciones de los distintos Jobs que componen nuestro sistema. En nuestro ejemplo no vamos a utilizarla, ya que lanzaremos los procesos manualmente para simplificar el código, pero podéis consultar el detalle en la [documentación](https://docs.spring.io/spring-batch/reference/job/configuring-launcher.html).
* **JobRepository**: Se trata del repositorio que almacena información sobre cada Job y los datos de su ejecución necesario para mantener la trazabilidad del sistema. Para más información consultar la [documentación](https://docs.spring.io/spring-batch/reference/job/configuring-repository.html).
* **Job**: Se trata de la entidad principal de un proceso batch y es un bloque que contiene uno o varios steps que conforman el proceso a ejecutar.
* **Step**: Un `Step`, como su nombre indica, es un paso en la ejecución de un `Job` el cual contiene la lógica de negocio de un determinado caso de uso. Un `Step` habitualmente está formado por un `ItemReader`, `ItemProcessor` y `ItemWriter` o por un `Tasklet`. La primera opción es relativa a la ejecución normal de un batch donde asociamos el tamaño del lote y el procesado es en función de esta configuración. Esta es la opción que deberíamos usar en la mayoría de los casos, mientras que la opción de `Tasklet` esta reservada para cuando necesitamos realizar operaciones de forma atómica. 
* **ItemReader**: Se trata de la ingesta de datos para un determinado `Step`. Se puede realizar de forma manual o con los [Readers](https://docs.spring.io/spring-batch/reference/readers-and-writers/item-reader-writer-implementations.html) que proporciona `Spring Batch`.
* **ItemProcessor**: En esta pieza se realizan todas las trasformaciones de datos que contenga nuestra lógica de negocio.
* **ItemWriter**: Es la producción de datos por determinado `Step`. Se puede realizar de forma manual o con los [Writers](https://docs.spring.io/spring-batch/reference/readers-and-writers/item-reader-writer-implementations.html) que proporciona `Spring Batch`.
* **Tasklet**: En los casos que no deseemos realizar ingestas, trasformación y producción de datos para realizar funcionalidades de forma atómica tenemos disponibles los `Tasklet`.


### Contexto de la aplicación

Llegados a este punto, ¿qué es lo que vamos a hacer en los siguientes pasos?.
Basándonos en el ejemplo del tutorial y en el [Contexto de la aplicación](../../usecases.md) vamos a reinventar nuestros requisitos para poder resolver las problemáticas con procesos batch.

Ya deberíamos tener claros los conceptos y los actores que compondrán nuestro sistema, así que, allá vamos!!!