# Ahora hazlo tú!

Ahora vamos a ver si has comprendido bien el tutorial. ¡Vamos alla!

## Exportación de juegos a fichero

### Requisitos

En este ejercicio vamos a simular la exportación de datos desde una tabla de base de datos a fichero. 

El objetivo es que en función del número de stock de un determinado juego, generemos un fichero con su nombre y si el juego está disponible.

Par ello debemos tener una tabla de juegos con los siguientes atributos:

- Identificador
- Título
- Edad recomendada
- Stock

El proceso batch debe consultar los registros y convertirlos a la siguiente estructura:

- Título: Título del juego (el mismo que en la tabla de BBDD).
- Disponibilidad: Si el stock es mayor que cero estará disponible y si es cero debera aparecer que no está disponible.

Una vez realizada la conversion, se debe escribir dicha información a fichero y guardarlo en el `target` del proyecto.

### Consejos

Para empezar te daré unos consejos:

- Recuerda crear la tabla de la BBDD y sus datos.
- Intenta re-aprovechar lo que hemos aprendido en los ejemplos.
- Consulta la documentación para utilizar un `Reader` apropiado para la lectura desde BBDD.
- Date cuenta de que el `Processor` que necesitas es algo más complejo esta vez y necesitaras más de un modelo diferente.


## ¿Ya has terminado?

Si has llegado a este punto es porque ya tienes terminado el tutorial. Por favor no te olvides de subir los proyectos a algún repositorio Github propio (puedes revisar el anexo [Tutorial básico de Git](../../appendix/git.md)) y avísarnos para que podamos echarle un ojo y darte sugerencias y feedback :relaxed:.

_Si es una formación ligada a proyecto, que tu responsable nos contacte para que podamos darle prioridad al feedback_
