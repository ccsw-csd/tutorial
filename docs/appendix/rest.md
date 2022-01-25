# Breve detalle sobre REST

Antes de empezar vamos a hablar de operaciones REST. Estas operaciones son el punto de entrada a nuestra aplicación y se pueden diferenciar dos claros elementos:

* Ruta hacia el recurso, lo que viene siendo la URL.
* Acción a realizar sobre el recurso, lo que viene siendo la operación HTTP o el verbo.


## Ruta del recurso

La ruta del recurso nos indica entre otras cosas, el endpoint y su posible jerarquía sobre la que se va a realizar la operación. Debe tener una raíz de recurso y si se requiere navegar por el recursos, la jerarquía irá separada por barras. La URL nunca debería tener verbos o acciones solamente recursos, identificadores o atributos. 
Por ejemplo en nuestro caso de `Categorías`, serían correctas las siguientes rutas:

* :heavy_check_mark: /category
* :heavy_check_mark: /category/3
* :heavy_check_mark: /category/?name=Dados

Sin embargo, no serían del todo correctas las rutas:

* :x: /getCategory
* :x: /findCategories
* :x: /saveCategory
* :x: /category/save

A menudo, se integran datos identificadores o atributos de búsqueda dentro de la propia ruta. Podríamos definir la operación `category/3` para referirse a la Categoría con ID = 3, o `category/?name=Dados` para referirse a las categorías con nombre = Dados. A veces, estos datos también pueden ir como atributos en la URL o en el cuerpo de la petición, aunque se recomienda que siempre que sean identificadores vayan determinados en la propia URL.

Si el dominio categoría tuviera hijos o relaciones con algún otro dominio se podría añadir esas jerarquía a la URL. Por ejemplo podríamos tener `category/3/child/2` para referirnos al hijo de ID = 2 que tiene la Categoría de ID = 3, y así sucesivamente.


## Acción sobre el recurso

La acción sobre el recurso se determina mediante la operación o verbo HTTP que se utiliza en el endpoint. Los verbos más usados serían:

- **GET**. Cuando se quiere recuperar un recursos.
- **POST**. Cuando se quiere crear un recurso. Aunque a menudo se utiliza para realizar otras acciones de búsqueda o validación.
- **PUT**. Cuando se quiere actualizar o modificar un recurso. Aunque a menudo se utiliza una sola operación para crear o actualizar. En ese caso se utilizaría solamente `POST`.
- **DELETE**. Cuando se quiere eliminar un recurso.

De esta forma tendríamos:

* `GET /category/3`. Realizaría un acceso para recuperar la categoría 3.
* `POST o PUT /category/3`. Realizaría un acceso para crear o modificar la categoría 3. Los datos a modificar deberían ir en el body.
* `DELETE /category/3`. Realizaría un acceso para borrar la categoría 3.
* `GET /category/?name=Dados`. Realizaría un acceso para recuperar las categorías que tengan nombre = Dados.


!!! tip "Excepciones a la regla"
    A veces hay que ejecutar una operación que no es 'estandar' en cuanto a verbos HTTP. Para ese caso, deberemos clarificar en la URL la acción que se debe realizar y si vamos a enviar datos debería ser de tipo `POST` mientras que si simplemente se requiere una contestación sin enviar datos será de tipo `GET`. Por ejemplo `POST /category/3/validate` realizaría un acceso para ejecutar una validación sobre los datos enviados en el body de la categoría 3.

