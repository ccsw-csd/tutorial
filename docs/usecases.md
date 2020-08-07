# Contexto de la aplicación

Nuestro amigo *Ernesto Esvida* es muy aficionado a los juegos de mesa y desde muy pequeño ha ido coleccionando muchos juegos. Hasta tal punto que ha decidido regentar una Ludoteca.

Como la colección de juegos era suya personal, toda la información del catálogo de juegos la tenía perfectamente clasificado en fichas de cartón. Pero ahora que va abrir su propio negocio, necesita digitalizar esa información y hacerla más accesible.

Como es un buen amigo de la infancia, hemos decidido ayudar a Ernesto y colaborar haciendo una pequeña aplicación web que le sirva de catálogo de juegos. Es más o menos el mismo sistema que estaba utilizando, pero esta vez en digital.

Por cierto, la Ludoteca al final se va a llamar *Ludoteca Tán*.

## ** Diseño de BD **

Para el proyecto que vamos a crear vamos a modelizar y gestionar 3 entidades: `GAME`, `CATEGORY` y `AUTHOR`.

Para la entidad `GAME`, Ernesto nos ha comentado que la información que está guardando en sus fichas es la siguiente:

*  id (este dato no estaba originalmente en las fichas pero nos será muy util para indexar y realizar búsquedas)
*  title
*  age
*  category
*  author

La entidad `CATEGORY` estará compuesta por los siguientes campos:

*  id (lo mismo que en `GAME`)
*  name

La entidad `AUTHOR` estará compuesta por los siguientes campos:

*  id (lo mismo que en `GAME`)
*  name
*  nationality


Comenzaremos con un caso básico que cumpla las siguientes premisas: un juego pertenece a una categoría y ha sido creado por un único autor. 

Modelando este contexto quedaría algo similar a esto:

![diagrama-bd](./assets/images/diagrama-bd.png)


## ** Diseño de pantallas **

Deberíamos construir tres pantallas de mantenimiento CRUD (Create, Read, Update, Delete) y una pantalla de Login general para activar las acciones de administrador. Más o menos las pantallas deberían quedar así:

### Listado de juegos
![listado-juegos](./assets/images/listado-juegos.png)

### Edición de juego
![edicion-juego](./assets/images/edicion-juego.png)

### Listado de categorías
![listado-categorias](./assets/images/listado-categorias.png)

### Edición de categoría
![edicion-categoria](./assets/images/edicion-categoria.png)

### Listado de autores
![listado-autores](./assets/images/listado-autores.png)

### Edición de autor
![edicion-autor](./assets/images/edicion-autor.png)

### Pantalla de Login
![login](./assets/images/login.png)


## ** Diseño funcional **

Por último vamos a definir un poco la funcionalidad básica que Ernesto necesita para iniciar su negocio.

### Aspectos generales

* El sistema tan solo tendrá dos roles:
  ** `usuario básico` es el usuario anónimo que accede a la web sin registrar. Solo tiene permisos para mostrar listados
  ** `usuario administrador` es el usuario que se registra en la aplicación. Puede realizar las operaciones de alta, edición y borrado

Por defecto cuando entras en la aplicación tendrás los privilegios de un `usuario básico` hasta que el usuario haga un login correcto con el usuario / password `admin` / `admin`. En ese momento pasara a ser un `usuario administrador` y podrá realizar operaciones de alta, baja y modificación.

La estructura general de la aplicación será:

* Una cabecerá superior que contendrá:
  * el logo y el nombre de la tienda
  * un enlace a cada uno de los CRUD del sistema
  * un botón de `Sign in`
* Zona de trabajo, donde cargaremos las pantallas que el usuario vaya abriendo

Al pulsar sobre la funcionalidad de `Sign in` aparecerá una ventana modal que preguntará usuario y password. Esto realizará una llamada al backend, donde se validará si el usuario es correcto. 

* En caso de ser correcto, devolverá un token jwt de acceso, que el cliente web deberá guardar en `sessionStorage` para futuras peticiones
* En caso de no ser correcto, devolverá un error de *Usuario y/o password incorrectos*

Todas las operaciones del backend que permitan crear, modificar o borrar datos, deberán estar securizadas para que no puedan ser accedidas sin haberse autenticado previamente.


### CRUD de Juegos

Al acceder a esta pantalla se mostrará un listado de los juegos disponibles en el catálogo de la BD.
Esta tabla debe contener filtros en la parte superior, pero no debe estar paginada.

Se debe poder filtrar por:

* nombre del juego. Donde el usuario podrá poner cualquier texto y el filtrado será todos aquellos juegos que `contengan` el texto buscado
* categoría del juego. Donde aparecerá un desplegable que el usuario seleccionar de entre todas las categorías de juego que existan en la BD.

Dos botones permitirán realizar el filtrado de juegos (lanzando una nueva consulta a BD) o limpiar los filtros seleccionados (lanzando una consulta con los filtros vacíos).

En la tabla debe aparecer a modo de fichas. No hace falta que sea exactamente igual a la maqueta, no es un requisito determinar un ancho general de ficha por lo que pueden caber 2,3 o x fichas en una misma fila, dependerá del programador. Pero todas las fichas deben tener el mismo ancho:

- Un espacio destinado a una foto (de momento no pondremos nada en ese espacio)
- Una columna con la siguiente información:
    - Título del juego, resaltado de alguna forma
    - Edad recomendada
    - Categoría del juego, mostraremos su nombre
    - Autor del juego, mostraremos su nombre
    - Nacionalidad del juego, mostraremos la nacionalidad del autor del juego

Los juegos no se pueden eliminar, pero si se puede editar si el usuario pulsa en alguna de las fichas (solo en el caso de que el usuario tenga permisos).

Debajo de la tabla aparecerá un botón para crear nuevos juegos (solo en el caso de que el usuario tenga permisos).


**Crear**

Al pulsar el botón de crear se deberá abrir una ventana modal con cinco inputs:

* Identificador. Este input deberá ser de solo lectura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Identificador`
* Título. Este input es obligatorio, será de escritura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Título`
* Edad. Este input es obligatorio, es de tipo numérico de 0 a 99, será de escritura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Edad`
* Categoría. Este input es obligatorio, será un campo seleccionable donde aparecerán todas las categorías de la BD, aparecerá vacío por defecto. Con el placeholder de `Categoría`
* Autor. Este input es obligatorio, será un campo seleccionable donde aparecerán todos los autores de la BD, aparecerá vacío por defecto. Con el placeholder de `Autor`

Todos los datos obligatorios se deberán comprobar que son válidos antes de guardarlo en BD.
Dos botones en la parte inferior de la ventana permitirán al usuario cerrar la ventana o guardar los datos en la BD. 

**Editar**

Al pulsar en una de las fichas con un click simple, se deberá abrir una ventana modal utilizando el mismo componente que la ventana de `Crear` pero con los cinco campos rellenados con los datos de BD.


### CRUD de Categorías

Al acceder a esta pantalla se mostrará un listado de las categorías que tenemos en la BD.
La tabla no tiene filtros, puesto que tiene muy pocos registros. Tampoco estará paginada.

En la tabla debe aparecer:

* identificador de la categoría
* nombre de la categoría
* botón de editar (solo en el caso de que el usuario tenga permisos)
* botón de borrar (solo en el caso de que el usuario tenga permisos)

Debajo de la tabla aparecerá un botón para crear nuevas categorías (solo en el caso de que el usuario tenga permisos).

**Crear**

Al pulsar el botón de crear se deberá abrir una ventana modal con dos inputs:

* Identificador. Este input deberá ser de solo lectura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Identificador`
* Nombre. Este input es obligatorio, será de escritura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Nombre`

Todos los datos obligatorios se deberán comprobar que son válidos antes de guardarlo en BD.
Dos botones en la parte inferior de la ventana permitirán al usuario cerrar la ventana o guardar los datos en la BD.

**Editar**

Al pulsar el icono de editar se deberá abrir una ventana modal utilizando el mismo componente que la ventana de `Crear` pero con los dos campos rellenados con los datos de BD.

**Borrar**

Si el usuario pulsa el botón de borrar, se deberá comprobar si esa categoría tiene algún `Juego` asociado. En caso de tenerlo se le informará al usuario de que dicha categoría no se puede eliminar por tener asociado un juego.
En caso de no estar asociada, se le preguntará al usuario mediante un mensaje de confirmación si desea eliminar la categoría. Solo en caso de que la respuesta sea afirmativa, se lanzará el borrado físico de la categoría en BD.

### CRUD de Autores

Al acceder a esta pantalla se mostrará un listado de los autores que tenemos en la BD.
La tabla no tiene filtros pero deberá estar paginada en servidor.

En la tabla debe aparecer:

* identificador del autor
* nombre del autor
* nacionalidad del autor
* botón de editar (solo en el caso de que el usuario tenga permisos)
* botón de borrar (solo en el caso de que el usuario tenga permisos)

Debajo de la tabla aparecerá un botón para crear nuevos autores (solo en el caso de que el usuario tenga permisos).

**Crear**

Al pulsar el botón de crear se deberá abrir una ventana modal con tres inputs:

* Identificador. Este input deberá ser de solo lectura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Identificador`
* Nombre. Este input es obligatorio, será de escritura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Nombre`
* Nacionalidad. Este input es obligatorio, será de escritura y deberá aparecer vacío, sin ningún valor. Con el placeholder de `Nacionalidad`

Todos los datos obligatorios se deberán comprobar que son válidos antes de guardarlo en BD.
Dos botones en la parte inferior de la ventana permitirán al usuario cerrar la ventana o guardar los datos en la BD. 

**Editar**

Al pulsar el icono de editar se deberá abrir una ventana modal utilizando el mismo componente que la ventana de `Crear` pero con los tres campos rellenados con los datos de BD.

**Borrar**

Si el usuario pulsa el botón de borrar, se deberá comprobar si ese autor tiene algún `Juego` asociado. En caso de tenerlo se le informará al usuario de que dicho autor no se puede eliminar por tener asociado un juego.
En caso de no estar asociado, se le preguntará al usuario mediante un mensaje de confirmación si desea eliminar el autor. Solo en caso de que la respuesta sea afirmativa, se lanzará el borrado físico de la categoría en BD.
