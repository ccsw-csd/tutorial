# Funcionamiento JPA

Este anexo no pretende explicar el funcionamiento interno de JPA, simplemente conocer un poco como utilizarlo y algunos pequeños tips que pueden ser interesantes.


## Functionamiento básico

Lo primero que deberías tener claro, es que hagas lo que hagas, al final todo termina lanzando una query nativa sobre la BBDD. Da igual que uses cualquier tipo de *acelerador* (luego veremos alguno), ya que al final Spring JPA termina convirtiendo lo que hayas programado en una query nativa.

Cuanta más información le proporciones a JPA, tendrás más control sobre la query final, pero más dificil será de mantener. Lo mejor es utilizar, siempre que se pueda, todos los automatismos y automagias posibles y dejar que Spring haga su faena. Habrá ocasiones en que esto no nos sirva, en ese momento tendremos que decidir si queremos bajar el nivel de implementación o queremos utilizar otra alternativa como procesos por streams.


## Derived Query Methods

Para la realización de consultas a la base de datos, JPA nos ofrece un sencillo mecanismo el cual consiste en crear definiciones de métodos con una sintaxis especifica los cuales se traducen a consultas nativas por parte de JPA.

Esto es muy útil ya nos convertimos en agnósticos de la tecnología de BBDD utilizada y podemos migrar con facilidad entre las muchas soluciones disponibles en el mercado, delegando esta tarea en Spring.

Esta opción es la mas indicada en la mayoría de los casos, como parte negativa, en algunos casos en consultas más complejas la definición de los métodos puede extenderse demasiado dificultado la lectura del código.

Como ejemplo, si tenemos la entidad libro que tiene un atributo nombre (name), la consulta de libros por nombre quedaría en:

List < Book > findByName(String name)


[Link a Doc](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods.query-creation)

[Link a Baeldung](https://www.baeldung.com/spring-data-derived-queries)



## Anotación @Query

También se dispone de la anotación @Query la cual nos ofrece la posibilidad de realizar consultas de forma más cercana a los lenguajes SQL.

En primer lugar, las consultas JPQL, estas consultas guardan un parecido con el lenguaje SQL pero al igual que en el caso las “Drived Query Methos” son traducidas por JPA a la consulta final nativa. Su uso no es muy recomendado ya que al subir la complejidad de las consultas se vuelven difíciles de mantener.

Por otra parte, es posible inyectad consultas nativas directamente dentro de esta anotación interactuando de forma directa con la base de datos. Esta práctica es altamente desaconsejable ya que crea acoplamientos con la tecnología de la BBDD utilizada y es una fuente de errores.

[Link a Baeldung](https://www.baeldung.com/spring-data-jpa-query)


## Acelerando las consultas

En muchas ocasiones necesitamos obtener información que no está en una única tabla por motivos de diseño de la base de datos. Debemos plasmar esta casuística con cuidado a nuestro modelo relacional para obtener resultados óptimos en cuanto al rendimiento.

Para ilustrar el caso vamos a tomar el ejemplo de un listado de libros que tienen asociados categorías y autores, los cuales a su vez tienen asociada una nacionalidad.

Así tendríamos la entidad Book que tendría un join con la entidad Category y Author la que tendría su correspondiente join con la entidad Nationality.

Si utilizamos el método findAll, heredado del repository de la entidad Book, el resultado seria 1 consulta a la base de datos para obtener todos los libros de la tabla correspondiente, además realizaría una consulta por cada categoría y autor diferente presente en la tabla y además una consulta por cada nacionalidad diferente de cada autor.

En total se realizarían, en el peor de los casos, 1 + n (categoría) +  n (autor) + n * n (nacionalidad) consultas, esto seria muy costoso y nuestra consulta seria muy lenta dado el volumen de transacciones necesarias con la base de datos.

Para evitar esta circunstancia, disponemos de la anotación denominada EnitityGraph la cual proporciona directrices a JPA de la forma en la que deseamos realizar la consulta para que agrupe todas las consultas en una única, aun siendo mas compleja, en muchos casos el rendimiento es mucho mejor que realizar múltiples interacciones con la BBDD.


Ejemplo de anotación en el método findAll: 

@EntityGraph(attributePaths = { "category", "author", "author.nationality" })

[Link a Baeldung](https://www.baeldung.com/jpa-entity-graph)


## Alternativa de Streams

Desde Java 8 disponemos de los Java Streams. Se trata de una herramienta que nos permite multitud de opciones relativas tratamiento y trasformación de los datos manejados.

En este apartado únicamente se menciona debido a que en muchas ocasiones cuando nos enfrentamos a consultas complejas, puede ser beneficioso evitar ofuscar las consultas y realizar las trasformaciones necesarias mediante los Streams.

Un ejemplo de uso practico podría ser, evitar usar la cláusula “IN” en una determinada consulta la cual penaliza notablemente el rendimiento de las consultas. En vez de esos se podría utilizar el método “filter” sobre el conjunto de elementos para obtener el mismo resultado.

[Link a Baeldung](https://www.baeldung.com/java-8-streams)


## Repository Custom

Explicar como hacer una Impl de la interface y cosas de Criteria y Predicates, etc.


