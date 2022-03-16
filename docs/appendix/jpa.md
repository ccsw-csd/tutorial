# Funcionamiento JPA

Este anexo no pretende explicar el funcionamiento interno de JPA, simplemente conocer un poco como utilizarlo y algunos pequeños tips que pueden ser interesantes.


## Functionamiento básico

Lo primero que deberías tener claro, es que hagas lo que hagas, al final todo termina lanzando una query nativa sobre la BBDD. Da igual que uses cualquier tipo de *acelerador* (luego veremos alguno), ya que al final Spring JPA termina convirtiendo lo que hayas programado en una query nativa.

Cuanta más información le proporciones a JPA, tendrás más control sobre la query final, pero más dificil será de mantener. Lo mejor es utilizar, siempre que se pueda, todos los automatismos y automagias posibles y dejar que Spring haga su faena. Habrá ocasiones en que esto no nos sirva, en ese momento tendremos que decidir si queremos bajar el nivel de implementación o queremos utilizar otra alternativa como procesos por streams.


## Derived Query Methods

Explicar como usarlos

[Link a Baeldung](https://www.baeldung.com/spring-data-derived-queries)



## Anotación @Query

Una alternativa serían las query, no usar salvo casos concretos y NUNCA natives (no se podría migrar a otra BBDD)

[Link a Baeldung](https://www.baeldung.com/spring-data-jpa-query)


## Acelerando las consultas

[Link a Baeldung](https://www.baeldung.com/jpa-entity-graph)

Explicar un poco la anotación y los beneficios

@EntityGraph(attributePaths = { "category", "author", "author.nationality" })


## Alternativa de Streams

Explicar cuando usarla y como usarla



## Repository Custom

Explicar como hacer una Impl de la interface y cosas de Criteria y Predicates, etc.


