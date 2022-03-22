# Funcionamiento Spring Data

Este anexo no pretende explicar el funcionamiento interno de Spring Data, simplemente conocer un poco como utilizarlo y algunos pequeños tips que pueden ser interesantes.


## Funcionamiento básico

Lo primero que deberías tener claro, es que hagas lo que hagas, al final todo termina lanzando una query nativa sobre la BBDD. Da igual que uses cualquier tipo de *acelerador* (luego veremos alguno), ya que al final Spring Data termina convirtiendo lo que hayas programado en una query nativa.

Cuanta más información le proporciones a Spring Data, tendrás más control sobre la query final, pero más dificil será de mantener. Lo mejor es utilizar, siempre que se pueda, todos los automatismos y automagias posibles y dejar que Spring haga su faena. Habrá ocasiones en que esto no nos sirva, en ese momento tendremos que decidir si queremos bajar el nivel de implementación o queremos utilizar otra alternativa como procesos por streams.


## Derived Query Methods

Para la realización de consultas a la base de datos, Spring Data nos ofrece un sencillo mecanismo que consiste en crear definiciones de métodos con una sintaxis especifica, para luego traducirlas automáticamente a consultas nativas, por parte de Spring Data.

Esto es muy útil, ya que convierte a la aplicación en agnósticos de la tecnología de BBDD utilizada y podemos migrar con facilidad entre las muchas soluciones disponibles en el mercado, delegando esta tarea en Spring.

Esta es la opción más indicada en la mayoría de los casos, siempre que puedas deberías utilizar esta forma de realizar las consultas. Como parte negativa, en algunos casos en consultas más complejas la definición de los métodos puede extenderse demasiado dificultando la lectura del código.

De esto tenemos algún ejemplo por el tutorial, en el repositorio de [GameRepository](./step5/#repository).

Siguiendo el ejemplo del tutorial, si tuvieramos que recuperar los `Game` por el nombre del juego, se podría crear un método en el `GameRepository` de esta forma:

``` Java
List<Game> findByName(String name);
```

Spring Data entendería que quieres recuperar un listado de `Game` que están filtrados por su propiedad `Name` y generaría la consulta SQL de forma automática, sin tener que implementar nada.

Se pueden contruir muchos métodos diferentes, te recomiendo que leas un pequeño [tutorial de Baeldung](https://www.baeldung.com/spring-data-derived-queries) y profundices con la [documentación oficial](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods.query-creation) donde podrás ver todas las opciones.




## Anotación @Query

Otra forma de realizar consultas, esta vez menos automática y más cercana a SQL, es la anotación @Query.

Existen dos opciones a la hora de usar la anotación `@Query`. Esta anotación ya la hemos usado en el tutorial, dentro del [GameRepository](../../develop/step5/#repository).

En primer lugar tenemos las consultas JPQL. Estas guardan un parecido con el lenguaje SQL pero al igual que en el caso anterior, son traducidas por Spring Data a la consulta final nativa. Su uso no está recomendado ya que estamos añadiendo un nivel de concreción y por tanto estamos aumentando la complejidad del código. Aun así, es otra forma de generar consultas.

Por otra parte, también es posible generar consultas nativas directamente dentro de esta anotación interactuando de forma directa con la base de datos. Esta práctica es altamente desaconsejable ya que crea acoplamientos con la tecnología de la BBDD utilizada y es una fuente de errores.

Puedes ver más información de esta anotación desde este pequeño [tutorial de Baeldung](https://www.baeldung.com/spring-data-jpa-query).


## Acelerando las consultas

En muchas ocasiones necesitamos obtener información que no está en una única tabla por motivos de diseño de la base de datos. Debemos plasmar esta casuística con cuidado a nuestro modelo relacional para obtener resultados óptimos en cuanto al rendimiento.

Para ilustrar el caso vamos a recuperar los objetos utilizados en el tutorial `Author`, `Gategory` y `Game`.
Si recuerdas, tenemos que un `Game` tiene asociado un `Author` y tiene asociada una `Gategory`.

Cuando utilizamos el método de filtrado `find` que construimos en el `GameRepository`, vemos que Spring Data traduce la `@Query` que habíamos diseñado en una query SQL para recuperar los juegos.

``` Java
@Query("select g from Game g where (:title is null or g.title like '%'||:title||'%') and (:category is null or g.category.id = :category)")
List<Game> find(@Param("title") String title, @Param("category") Long category);
```

Esta `@Query` es la que utiliza Spring Data para traducir las propiedades a objetos de BBDD y mapear los resultados a objetos Java.
Si tenemos activada la property `spring.jpa.show-sql=true` podremos ver las queries que está generando Spring Data. El resultado es el siguiente.

``` SQL
Hibernate: select game0_.id as id1_2_, game0_.age as age2_2_, game0_.author_id as author_i4_2_, game0_.category_id as category5_2_, game0_.title as title3_2_ from game game0_ where (? is null or game0_.title like ('%'||?||'%')) and (? is null or game0_.category_id=?)
Hibernate: select author0_.id as id1_0_0_, author0_.name as name2_0_0_, author0_.nationality as national3_0_0_ from author author0_ where author0_.id=?
Hibernate: select category0_.id as id1_1_0_, category0_.name as name2_1_0_ from category category0_ where category0_.id=?
Hibernate: select author0_.id as id1_0_0_, author0_.name as name2_0_0_, author0_.nationality as national3_0_0_ from author author0_ where author0_.id=?
Hibernate: select category0_.id as id1_1_0_, category0_.name as name2_1_0_ from category category0_ where category0_.id=?
Hibernate: select author0_.id as id1_0_0_, author0_.name as name2_0_0_, author0_.nationality as national3_0_0_ from author author0_ where author0_.id=?
Hibernate: select author0_.id as id1_0_0_, author0_.name as name2_0_0_, author0_.nationality as national3_0_0_ from author author0_ where author0_.id=?
Hibernate: select author0_.id as id1_0_0_, author0_.name as name2_0_0_, author0_.nationality as national3_0_0_ from author author0_ where author0_.id=?
```

Si te fijas ha generado una query SQL para filtrar los `Game`, pero luego cuando ha intentado construir los objetos Java, ha tenido que lanzar una serie de queries para recuperar los diferentes `Author` y `Category` a través de sus `id`. Obviamente Spring Data es muy lista y cachea los resultados obtenidos para no tener que recuperarlos n veces, pero aun así, lanza unas cuantas consultas. Esto penaliza el rendimiento de nuestra operación, ya que tiene que lanzar n queries a BBDD que, aunque son muy óptimas, incrementan unos milisegundos el tiempo total.

Para evitar esta circunstancia, disponemos de la anotación denominada `@EnitityGraph` la cual proporciona directrices a Spring Data sobre la forma en la que deseamos realizar la consulta, permitiendo que realice agrupaciones y uniones de tablas en una única query que, aun siendo mas compleja, en muchos casos el rendimiento es mucho mejor que realizar múltiples interacciones con la BBDD.

Siguiendo el ejemplo anterior podríamos utilizar la anotación de esta forma:

``` Java hl_lines="2"
@Query("select g from Game g where (:title is null or g.title like '%'||:title||'%') and (:category is null or g.category.id = :category)")
@EntityGraph(attributePaths = {"category", "author"})
List<Game> find(@Param("title") String title, @Param("category") Long category);
```

Donde le estamos diciendo a Spring Data que cuando realice la query, haga el cruce con las propiedades `category` y `author`, que a su vez son entidades y por tanto mapean dos tablas de BBDD.
El resultado es el siguiente:


``` SQL
Hibernate: select game0_.id as id1_2_0_, category1_.id as id1_1_1_, author2_.id as id1_0_2_, game0_.age as age2_2_0_, game0_.author_id as author_i4_2_0_, game0_.category_id as category5_2_0_, game0_.title as title3_2_0_, category1_.name as name2_1_1_, author2_.name as name2_0_2_, author2_.nationality as national3_0_2_ from game game0_ left outer join category category1_ on game0_.category_id=category1_.id left outer join author author2_ on game0_.author_id=author2_.id where (? is null or game0_.title like ('%'||?||'%')) and (? is null or game0_.category_id=?)
```

Una única query, que es más compleja que la anterior, ya que hace dos cruces con tablas de BBDD, pero que nos evita tener que lanzar n queries diferentes para recuperar `Author` y `Category`.

Generalmente, el uso de `@EntityGraph` acelera mucho los resultados y es muy recomendable utilizarlo para realizar los cruces inline. Se puede utilizar tanto con `@Query` como con `Derived Query Methods`. Puedes leer más información en este pequeño [tutorial de Baeldung](https://www.baeldung.com/jpa-entity-graph).


## Alternativa de Streams

A partir de Java 8 disponemos de los Java Streams. Se trata de una herramienta que nos permite multitud de opciones relativas tratamiento y trasformación de los datos manejados.

En este apartado únicamente se menciona debido a que en muchas ocasiones cuando nos enfrentamos a consultas complejas, puede ser beneficioso evitar ofuscar las consultas y realizar las trasformaciones necesarias mediante los Streams.

Un ejemplo de uso práctico podría ser, evitar usar la cláusula `IN` de SQL en una determinada consulta que podría penalizar notablemente el rendimiento de las consultas. En vez de eso se podría utilizar el método de JAVA `filter` sobre el conjunto de elementos para obtener el mismo resultado.

Puedes leer más información en el [tutorial de Baeldung](https://www.baeldung.com/java-8-streams).


## Specifications

En algunos casos puede ocurrir que con las herramientas descritas anteriormente no tengamos suficiente alcance, bien porque las definiciones de los métodos se complican y alargan demasiado o debido a que la consulta es demasiado genérica como para realizarlo de este modo.

Para este caso se dispone de las Specifications que nos proveen de una forma de escribir consultas reutilizables mediante una API que ofrece una forma fluida de crear y combinar consultas complejas.

Un ejemplo de caso de uso podría ser un CRUD de una determinada entidad que debe poder filtrar por todos los atributos de esta, donde el tipo de filtrado viene especificado en la propia consulta y no siempre es requerido. En este caso no podríamos construir una consulta basada en definir un determinado método ya no conocemos de ante mano que filtros ni que atributos vamos a recibir y deberemos recurrir al uso de las Specifications.

Puedes leer más información en el [tutorial de Baeldung](https://www.baeldung.com/rest-api-search-language-spring-data-specifications).



