# Ahora hazlo tu!

Ahora vamos a ver si has comprendido bien el tutorial. Voy a poner dos ejercicios uno más sencillo que el otro para ver si eres capaz de llevarlos a cabo. ¡Vamos alla, mucha suerte!

Nuestro amigo *Ernesto Esvida* ya tiene disponible su web para gestionar su catálogo de juegos, autores y categorías, pero todavía le falta un poco más para poder hacer buen uso de su ludoteca. Así que nos ha pedido dos funcionalidades extra.

## Gestión de clientes

### Requisitos

Por un lado necesita poder tener una base de datos de sus clientes. Para ello nos ha pedido que si podemos crearle una pantalla de CRUD sencilla, al igual que hicimos con las categorías donde él pueda dar de alta a sus clientes.

Nos ha pasado un esquema muy sencillo de lo que quiere, tan solo quiere guardar un listado de los nombres de sus clientes para tenerlos *fichados*, y nos ha hecho un par de pantallas sencillas muy similares a **Categorías**.

![exercise_1](./assets/images/exercise_1.png)

![exercise_2](./assets/images/exercise_2.png)

Un listado sin filtros de ningún tipo ni paginación.

Un formulario de edición / alta, cuyo único dato editable sea el nombre. Además, la única restricción que nos ha pedido es que **NO** podamos dar de alta a un cliente con el mismo nombre que otro existente. Así que deberemos comprobar el nombre, antes de guardar el cliente.

### Consejos

Para empezar te daré unos consejos:

- Recuerda crear la tabla de la BBDD y sus datos
- Intenta primero hacer el listado completo, en el orden que más te guste: Angular o Springboot.
- Completa el listado conectando ambas capas.
- Termina el caso de uso haciendo las funcionalidades de edición, nuevo y borrado. Presta atención a la validación a la hora de guardar un cliente, **NO** se puede guardar si el nombre ya existe.


## Gestión de préstamos

### Requisitos

Por otro lado, quiere hacer uso de su catálogo de juegos y de sus clientes, y quiere saber que juegos ha prestado a cada cliente. Para ello nos ha pedido una página bastante compleja donde se podrá consultar diferente información y se permitirá realizar el préstamo de los juegos.

Nos ha pasado el siguiente boceto y requisitos:

![exercise_3](./assets/images/exercise_3.png)

La pantalla tendrá dos zonas:

- Una zona de filtrado donde se permitirá filtrar por:
	- Título del juego, que deberá ser un combo seleccionable con los juegos del catálogo de la Ludoteca.
	- Cliente, que deberá ser un combo seleccionable con los clientes dados de alta en la aplicación.
	- Fecha, que deberá ser de tipo Datepicker y que permitirá elegir una fecha de búsqueda. Al elegir un día nos deberá mostrar que juegos están prestados para dicho día. **OJO** que los préstamos son con fecha de inicio y de fin, si elijo un día intermedio debería aparecer el elemento en la tabla.
- Una zona de listado **paginado** que deberá mostrar
	- El identificador del préstamo
	- El nombre del juego prestado
	- El nombre del cliente que lo solicitó
	- La fecha de inicio del préstamo
	- La fecha de fin del préstamo
	- Un botón que permite eliminar el préstamo

![exercise_4](./assets/images/exercise_4.png)

Al pulsar el botón de `Nuevo préstamo` se abrirá una pantalla donde se podrá ingresar la siguiente información, toda ella obligatoria:

- Identificador, inicialmente vacío y en modo lectura
- Nombre del cliente, mediante un combo seleccionable
- Nombre del juego, mediante un combo seleccionable
- Fechas del préstamo, donde se podrá introducir dos fechas, de inicio y fin del préstamo.

Las validaciones son sencillas aunque laboriosas:

- La fecha de fin **NO** podrá ser anterior a la fecha de inicio
- El periodo de préstamo máximo solo podrá ser de 14 días. Si el usuario quiere un préstamo para más de 14 días la aplicación no debe permitirlo mostrando una alerta al intentar guardar.
- El mismo juego no puede estar prestado a dos clientes distintos en un mismo día. **OJO** que los préstamos tienen fecha de inicio y fecha fin, el juego no puede estar prestado a más de un cliente para ninguno de los días que contemplan las fechas actuales del rango.
- Un mismo cliente no puede tener prestados más de 2 juegos en un mismo día. **OJO** que los préstamos tienen fecha de inicio y fecha fin, el cliente no puede tener más de dos préstamos para ninguno de los días que contemplan las fechas actuales del rango.


### Consejos

Para empezar te daré unos consejos:

- Recuerda crear la tabla de la BBDD y sus datos
- Intenta primero hacer el listado paginado sin filtros, en el orden que más te guste: Angular o Springboot. Recuerda que se trata de un listado paginado, así que deberás utilizar el obtejo `Page`.
- Completa el listado conectando ambas capas.
- Ahora implementa los filtros, presta atención al filtro de fecha, es el más complejo.
- Para la paginación filtrada solo tienes que mezclar los conceptos que hemos visto en los puntos del tutorial anteriores y revisar [Baeldung](https://www.baeldung.com/spring-data-jpa-query) por si tienes dudas
- Implementa la pantalla de alta de préstamo, sin ninguna validación.
- Cuando ya te funcione, intenta ir añadiendo una a una las validaciones. Algunas de ellas pueden hacerse en frontend, mientras que otras deberán validarse en backend



## ¿Ya has terminado?

Si has llegado a este punto es porque ya tienes terminado el tutorial. Por favor no te olvides de subir los proyectos a algún repositorio Github propio (puedes revisar el anexo [Tutorial básico de Git](appendix/git.md)) y avísarnos para que podamos echarle un ojo y darte sugerencias y feedback :relaxed:.