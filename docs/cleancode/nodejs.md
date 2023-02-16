# Estructura y Buenas prácticas - Nodejs

## Estructura y funcionamiento

En los proyectos Nodejs no existe nada estandarizado y oficial que hable sobre estructura de proyectos y nomenclatura de Nodejs. Tan solo existen algunas sugerencias y buenas prácticas a la hora de desarrollar que te recomiendo que utilices en la medida de lo posible.

!!! tip Consejo
    Piensa que el código fuente que escribes hoy, es como un libro que se leerá durante años. Alguien tendrá que coger tu código y leerlo en unos meses o años para hacer alguna modificación y, como buenos desarrolladores que somos, tenemos la obligación de facilitarle en todo lo posible la comprensión de ese código fuente. Quizá esa persona futura podrías ser tu en unos meses y quedaría muy mal que no entendieras ni tu propio código :laughing:

### Estructura en capas

Todos los proyectos para crear una Rest API con node y express están divididos en capas. Como mínimo estará la capa de rutas, controlador y modelo. En nuestro caso vamos a añadir una capa mas de servicios para quitarle trabajo al controlador y desacoplarlo de la capa de datos. Así si en el futuro queremos cambiar nuestra base de datos no romperemos tanto 😊

**Rutas**

En nuestro proyecto una ruta será una sección de código express que asociará un verbo http, una ruta o patrón de url y una función perteneciente al controlador para manejar esa petición.

**Controladores**

En nuestros controladores tendremos los métodos que obtendrán las solicitudes de las rutas, se comunicarán con la capa de servicio y convertirán estas solicitudes en respuestas http.

**Servicio**

Nuestra capa de servicio incluirá toda la lógica de negocio de nuestra aplicación. Para realizar sus operaciones puede realizar llamadas tanto a otras clases dentro de esta capa, como a clases de la capa inferior.

**Modelo**

Como su nombre indica esta capa representa los modelos de datos de nuestra aplicación. En nuestro caso, al usar un ODM, solo tendremos modelos de datos definidos según sus requisitos.



## Buenas prácticas

### Accesos entre capas

En base a la división por capas que hemos comentado arriba, y el resto de entidades implicadas, hay una serie de reglas importantísimas que debes seguir muy de cerca:

* Un `Controlador`
    * NO debe contener lógica en su clase. Solo está permitido que ejecute lógica a través de una llamada al objeto de la capa Lógica.
    * NO puede ejecutar directamente operaciones de la capa Acceso a Datos, siempre debe pasar por la capa de servicios.
    * Debemos seguir una coherencia entre todas las URL de las operaciones. Por ejemplo, si elegimos save para guardar, usemos esa palabra en todas las operaciones que sean de ese tipo. Evitad utilizar diferentes palabras save, guardar, persistir, actualizar para la misma acción.

* Un `Servicio`
    * NO puede llamar a objetos de la la capa Controlador.
    * NO debe llamar a Acceso a Datos que NO sean de su ámbito / competencia.
    * Si es necesario puede llamar a otros Servicios para recuperar cierta información que no sea de su ámbito / competencia.
    * Es un buen lugar para implementar la lógica de negocio.


### Usar linters Prettier & ESLint

Un linter es una herramienta que nos ayuda a seguir las buenas prácticas o guías de estilo de nuestro código fuente. En este caso, para JavaScript, proveeremos de unos muy famosos.
Una de las más famosas es la combinación de  **Angular app to ESLint with Prettier, AirBnB Styleguide**
Recordar que añadir este tipo de configuración es opcional, pero necesaria para tener un buen código de calidad.
