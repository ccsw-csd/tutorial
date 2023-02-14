# Listado paginado - Springboot

Ahora vamos a implementar las operaciones necesarias para ayudar al front a cubrir la funcionalidad del CRUD paginado en servidor. 
Recuerda que para que un listado paginado en servidor funcione, el cliente debe enviar en cada petición que página está solicitando y cual es el tamaño de la página, para que el servidor devuelva solamente un subconjunto de datos, en lugar de devolver el listado completo.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.


## Crear modelos

Lo primero que vamos a hacer es crear los modelos para trabajar con BBDD y con peticiones hacia el front. Además, también tenemos que añadir datos al script de inicialización de BBDD.

=== "schema.sql"
    ``` SQL hl_lines="9-15"
    DROP TABLE IF EXISTS CATEGORY;

    CREATE TABLE CATEGORY (
        id BIGINT IDENTITY NOT NULL PRIMARY KEY,
        name VARCHAR(250) NOT NULL
    );


    DROP TABLE IF EXISTS AUTHOR;

    CREATE TABLE AUTHOR (
        id BIGINT IDENTITY NOT NULL PRIMARY KEY,
        name VARCHAR(400) NOT NULL,
        nationality VARCHAR(250) NOT NULL
    );
    ```
=== "data.sql"
    ``` SQL hl_lines="5 6 7 8 9 10"
    INSERT INTO CATEGORY(id, name) VALUES (1, 'Eurogames');
    INSERT INTO CATEGORY(id, name) VALUES (2, 'Ameritrash');
    INSERT INTO CATEGORY(id, name) VALUES (3, 'Familiar');

    INSERT INTO AUTHOR(id, name, nationality) VALUES (1, 'Alan R. Moon', 'US');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (2, 'Vital Lacerda', 'PT');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (3, 'Simone Luciani', 'IT');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (4, 'Perepau Llistosella', 'ES');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (5, 'Michael Kiesling', 'DE');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (6, 'Phil Walker-Harding', 'US');
    ```
=== "Author.java"
    ``` Java
    package com.ccsw.tutorial.author.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Table;

    /**
    * @author ccsw
    */
    @Entity
    @Table(name = "Author")
    public class Author {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id", nullable = false)
        private Long id;

        @Column(name = "name", nullable = false)
        private String name;

        @Column(name = "nationality")
        private String nationality;

        /**
        * @return id
        */
        public Long getId() {

            return this.id;
        }

        /**
        * @param id new value of {@link #getid}.
        */
        public void setId(Long id) {

            this.id = id;
        }

        /**
        * @return name
        */
        public String getName() {

            return this.name;
        }

        /**
        * @param name new value of {@link #getname}.
        */
        public void setName(String name) {

            this.name = name;
        }

        /**
        * @return nationality
        */
        public String getNationality() {

            return this.nationality;
        }

        /**
        * @param nationality new value of {@link #getnationality}.
        */
        public void setNationality(String nationality) {

            this.nationality = nationality;
        }

    }
    ```
=== "AuthorDto.java"
    ``` Java
    package com.ccsw.tutorial.author.model;

    /**
    * @author ccsw
    */
    public class AuthorDto {

        private Long id;

        private String name;

        private String nationality;

        /**
        * @return id
        */
        public Long getId() {

            return this.id;
        }

        /**
        * @param id new value of {@link #getid}.
        */
        public void setId(Long id) {

            this.id = id;
        }

        /**
        * @return name
        */
        public String getName() {

            return this.name;
        }

        /**
        * @param name new value of {@link #getname}.
        */
        public void setName(String name) {

            this.name = name;
        }

        /**
        * @return nationality
        */
        public String getNationality() {

            return this.nationality;
        }

        /**
        * @param nationality new value of {@link #getnationality}.
        */
        public void setNationality(String nationality) {

            this.nationality = nationality;
        }

    }
    ```

## Implementar TDD - Pruebas

Para desarrollar todas las operaciones, empezaremos primero diseñando las pruebas y luego implementando el código necesario que haga funcionar correctamente esas pruebas. Para ir más rápido vamos a poner todas las pruebas de golpe, pero realmente se deberían crear una a una e ir implementando el código necesario para esa prueba. Para evitar tantas iteraciones en el tutorial las haremos todas de golpe.

Vamos a pararnos a pensar un poco que necesitamos en la pantalla. Ahora mismo nos sirve con:

* Una consulta paginada, que reciba datos de la página a consultar y devuelva los datos paginados
* Una operación de guardado y modificación
* Una operación de borrado

Para la primera prueba necesitaremos que hemos descrito (consulta paginada) se necesita un objeto que contenga los datos de la página a consultar. Así que crearemos una clase `AuthorSearchDto` para utilizarlo como 'paginador'. 

!!! tip "Paginación en Springframework"
    Cuando utilicemos paginación en Springframework, debemos recordar que ya vienen implementados algunos objetos que podemos utilizar y que nos facilitan la vida. Es el caso de `Pageable` y `Page`.

    * El objeto `Pageable` no es más que una interface que le permite a Spring JPA saber que página se quiere buscar, cual es el tamaño de página y cuales son las propiedades de ordenación que se debe lanzar en la consulta.
    * El objeto `PageRequest` es una utilidad que permite crear objetos de tipo `Pageable` de forma sencilla. Se utiliza mucho para codificación de test.
    * El objeto `Page` no es más que un contenedor que engloba la información básica de la página que se está consultando (número de página, tamaño de página, número total de resultados) y el conjunto de datos de la BBDD que contiene esa página una vez han sido buscados y ordenados.


También crearemos una clase `AuthorController` dentro del package de `com.ccsw.tutorial.author` con la implementación de los métodos vacíos, para que no falle la compilación.

¡Vamos a implementar test!


=== "AuthorSearchDto.java"
    ``` Java
    package com.ccsw.tutorial.author.model;

    import org.springframework.data.domain.Pageable;

    /**
    * @author ccsw
    */
    public class AuthorSearchDto {

        private Pageable pageable;

        /**
        * @return pageable
        */
        public Pageable getPageable() {

            return this.pageable;
        }

        /**
        * @param pageable new value of {@link #getPageable}.
        */
        public void setPageable(Pageable pageable) {

            this.pageable = pageable;
        }

    }
    ```
=== "AuthorController.java"
    ``` Java
    package com.ccsw.tutorial.author;

    import org.springframework.data.domain.Page;
    
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;

    /**
    * @author ccsw
    */
    public class AuthorController {

        /**
        * Método para recuperar un listado paginado de {@link com.ccsw.tutorial.author.model.Author}
        * @param dto
        * @return
        */
        public Page<AuthorDto> findPage(AuthorSearchDto dto) {

            return null;

        }

        /**
        * Método para crear o actualizar un {@link com.ccsw.tutorial.author.model.Author}
        * @param id
        * @param data datos de la entidad 
        */
        public void save(Long id, AuthorDto data) {

        }

        /**
        * Método para crear o actualizar un {@link com.ccsw.tutorial.author.model.Author}
        * @param id PK de la entidad
        */
        public void delete(Long id) {

        }
    }
    ```
=== "AuthorIT.java"
    ``` Java
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.boot.test.web.client.TestRestTemplate;
    import org.springframework.boot.web.server.LocalServerPort;
    import org.springframework.core.ParameterizedTypeReference;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.PageRequest;
    import org.springframework.http.HttpEntity;
    import org.springframework.http.HttpMethod;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.test.annotation.DirtiesContext;
    
    import static org.junit.jupiter.api.Assertions.*;
    
    @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
    @DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
    public class AuthorIT {
    
        public static final String LOCALHOST = "http://localhost:";
        public static final String SERVICE_PATH = "/author/";
        
        public static final Long DELETE_AUTHOR_ID = 6L;
        public static final Long MODIFY_AUTHOR_ID = 3L;
        public static final String NEW_AUTHOR_NAME = "Nuevo Autor";
        public static final String NEW_NATIONALITY = "Nueva Nacionalidad";
        
        private static final int TOTAL_AUTHORS = 6;
        private static final int PAGE_SIZE = 5;
        
        @LocalServerPort
        private int port;
        
        @Autowired
        private TestRestTemplate restTemplate;
        
        ParameterizedTypeReference<Page<AuthorDto>> responseTypePage = new ParameterizedTypeReference<Page<AuthorDto>>(){};
        
        @Test
        public void findFirstPageWithFiveSizeShouldReturnFirstFiveResults() {
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(PageRequest.of(0, PAGE_SIZE));
        
              ResponseEntity<Page<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(TOTAL_AUTHORS, response.getBody().getTotalElements());
              assertEquals(PAGE_SIZE, response.getBody().getContent().size());
        }
        
        @Test
        public void findSecondPageWithFiveSizeShouldReturnLastResult() {
        
              int elementsCount = TOTAL_AUTHORS - PAGE_SIZE;
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(PageRequest.of(1, PAGE_SIZE));
        
              ResponseEntity<Page<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(TOTAL_AUTHORS, response.getBody().getTotalElements());
              assertEquals(elementsCount, response.getBody().getContent().size());
        }
        
        @Test
        public void saveWithoutIdShouldCreateNewAuthor() {
        
              long newAuthorId = TOTAL_AUTHORS + 1;
              long newAuthorSize = TOTAL_AUTHORS + 1;
        
              AuthorDto dto = new AuthorDto();
              dto.setName(NEW_AUTHOR_NAME);
              dto.setNationality(NEW_NATIONALITY);
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(PageRequest.of(0, (int) newAuthorSize));
        
              ResponseEntity<Page<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(newAuthorSize, response.getBody().getTotalElements());
        
              AuthorDto author = response.getBody().getContent().stream().filter(item -> item.getId().equals(newAuthorId)).findFirst().orElse(null);
              assertNotNull(author);
              assertEquals(NEW_AUTHOR_NAME, author.getName());
        
        }
        
        @Test
        public void modifyWithExistIdShouldModifyAuthor() {
        
              AuthorDto dto = new AuthorDto();
              dto.setName(NEW_AUTHOR_NAME);
              dto.setNationality(NEW_NATIONALITY);
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + MODIFY_AUTHOR_ID, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(PageRequest.of(0, PAGE_SIZE));
        
              ResponseEntity<Page<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(TOTAL_AUTHORS, response.getBody().getTotalElements());
        
              AuthorDto author = response.getBody().getContent().stream().filter(item -> item.getId().equals(MODIFY_AUTHOR_ID)).findFirst().orElse(null);
              assertNotNull(author);
              assertEquals(NEW_AUTHOR_NAME, author.getName());
              assertEquals(NEW_NATIONALITY, author.getNationality());
        
        }
        
        @Test
        public void modifyWithNotExistIdShouldThrowException() {
        
              long authorId = TOTAL_AUTHORS + 1;
        
              AuthorDto dto = new AuthorDto();
              dto.setName(NEW_AUTHOR_NAME);
        
              ResponseEntity<?> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + authorId, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        }
        
        @Test
        public void deleteWithExistsIdShouldDeleteCategory() {
        
              long newAuthorsSize = TOTAL_AUTHORS - 1;
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + DELETE_AUTHOR_ID, HttpMethod.DELETE, null, Void.class);
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(PageRequest.of(0, TOTAL_AUTHORS));
        
              ResponseEntity<Page<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(newAuthorsSize, response.getBody().getTotalElements());
        
        }
        
        @Test
        public void deleteWithNotExistsIdShouldThrowException() {
        
              long deleteAuthorId = TOTAL_AUTHORS + 1;
        
              ResponseEntity<?> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + deleteAuthorId, HttpMethod.DELETE, null, Void.class);
        
              assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        }
    }
    ```

!!! info "Cuidado con las clases de Test"
    Recuerda que el código de aplicación debe ir en `src/main/java`, mientras que las clases de test deben ir en `src/test/java` para que no se mezclen unas con otras y se empaquete todo en el artefacto final. En este caso `AuthorTest.java` va en el directorio de test `src/test/java`.


Si ejecutamos los test, el resultado será 7 maravillosos test que fallan su ejecución. Es normal, puesto que no hemos implementado nada de código de aplicación para corresponder esos test.


## Implementar Controller

Si recuerdas, esta capa de `Controller` es la que tiene los endpoints de entrada a la aplicación. Nosotros ya tenemos definidas 3 operaciones, que hemos diseñado directamente desde los tests. Ahora vamos a implementar esos métodos con el código necesario para que los test funcionen correctamente, y teniendo en mente que debemos apoyarnos en las capas inferiores `Service` y `Repository` para repartir lógica de negocio y acceso a datos.

=== "AuthorController.java"
    ``` Java hl_lines="24 25"
    package com.ccsw.tutorial.author;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.web.bind.annotation.CrossOrigin;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;

    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import com.ccsw.tutorial.config.mapper.BeanMapper;

    /**
    * @author ccsw
    */
    @RequestMapping(value = "/author")
    @RestController
    @CrossOrigin(origins = "*")
    public class AuthorController {

        @Autowired
        AuthorService authorService;

        @Autowired
        BeanMapper beanMapper;

        /**
        * Método para recuperar un listado paginado de {@link com.ccsw.tutorial.author.model.Author}
        * @param dto
        * @return
        */
        @RequestMapping(path = "", method = RequestMethod.POST)
        public Page<AuthorDto> findPage(@RequestBody AuthorSearchDto dto) {

            return this.beanMapper.mapPage(this.authorService.findPage(dto), AuthorDto.class);
        }

        /**
        * Método para crear o actualizar un {@link com.ccsw.tutorial.author.model.Author}
        * @param id
        * @param data datos de la entidad 
        */
        @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
        public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody AuthorDto data) {

            this.authorService.save(id, data);
        }

        /**
        * Método para crear o actualizar un {@link com.ccsw.tutorial.author.model.Author}
        * @param id PK de la entidad
        */
        @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
        public void delete(@PathVariable("id") Long id) {

            this.authorService.delete(id);
        }
    }
    ```
=== "AuthorService.java"
    ``` Java
    package com.ccsw.tutorial.author;

    import org.springframework.data.domain.Page;

    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;

    /**
    * @author ccsw
    */
    public interface AuthorService {

        /**
        * Método para recuperar un listado paginado de {@link com.ccsw.tutorial.author.model.Author}
        * @param dto
        * @return
        */
        Page<Author> findPage(AuthorSearchDto dto);

        /**
        * Método para crear o actualizar un {@link com.ccsw.tutorial.author.model.Author}
        * @param id
        * @param data
        */
        void save(Long id, AuthorDto data);

        /**
        * Método para crear o actualizar un {@link com.ccsw.tutorial.author.model.Author}
        * @param id
        */
        void delete(Long id);

    }
    ```

Si te fijas, hemos trasladado toda la lógica a llamadas al `AuthorService` que hemos inyectado, y para que no falle la compilación hemos creado una interface con los métodos necesarios.


En la clase `AuthorController` es donde se hacen las conversiones de cara al cliente, pasaremos de un `Page<Author>` (modelo entidad) a un `Page<AuthorDto>` (modelo DTO) con la ayuda del beanMapper. Recuerda que al cliente no le deben llegar modelos entidades sino DTOs.

Además, el método de carga `findPage` ya no es un método de tipo `GET`, ahora es de tipo `POST` porque le tenemos que enviar los datos de la paginación para que Spring JPA pueda hacer su magia.


Ahora debemos implementar la siguiente capa.


## Implementar Service

La siguiente capa que vamos a implementar es justamente la capa que contiene toda la lógica de negocio, hace uso del `Repository` para acceder a los datos, y recibe llamadas generalmente de los `Controller`.

=== "AuthorServiceImpl.java"
    ``` Java hl_lines="21 22 45"
    package com.ccsw.tutorial.author;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.stereotype.Service;

    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;

    /**
    * @author ccsw
    */
    @Service
    @Transactional
    public class AuthorServiceImpl implements AuthorService {

        @Autowired
        AuthorRepository authorRepository;

        /**
        * {@inheritDoc}
        */
        @Override
        public Page<Author> findPage(AuthorSearchDto dto) {

            return this.authorRepository.findAll(dto.getPageable());
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public void save(Long id, AuthorDto data) {

            Author author = null;
            if (id != null)
                author = this.authorRepository.findById(id).orElse(null);
            else
                author = new Author();

            BeanUtils.copyProperties(data, author, "id");

            this.authorRepository.save(author);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public void delete(Long id) {

            this.authorRepository.deleteById(id);

        }

    }
    ```
=== "AuthorRepository.java"
    ``` Java hl_lines="12"
    package com.ccsw.tutorial.author;

    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;
    import org.springframework.data.repository.CrudRepository;

    import com.ccsw.tutorial.author.model.Author;

    /**
    * @author ccsw
    */
    public interface AuthorRepository extends CrudRepository<Author, Long> {

        /**
        * Método para recuperar un listado paginado de {@link com.ccsw.tutorial.author.model.Author}
        * @param page
        * @return
        */
        Page<Author> findAll(Pageable pageable);

    }
    ```
    
De nuevo pasa lo mismo que con la capa anterior, aquí delegamos muchas operaciones de consulta y guardado de datos en `AuthorRepository`. Hemos tenido que crearlo como interface para que no falle la compilación. Recuerda que cuando creamos un `Repository` es de gran ayuda hacerlo extender de `CrudRepository<T, ID>` ya que tiene muchos métodos implementados de base que nos pueden servir, como el `delete` o el `save`.

Fíjate también que cuando queremos copiar más de un dato de una clase a otra, tenemos una utilidad llamada `BeanUtils` que nos permite realizar esa copia (siempre que las propiedades de ambas clases se llamen igual). Además, en nuestro ejemplo hemos ignorado el 'id' para que no nos copie un null a la clase destino.

## Implementar Repository

Y llegamos a la última capa, la que está más cerca de los datos finales. Tenemos la siguiente interface:

=== "AuthorRepository.java"
    ``` Java
    package com.ccsw.tutorial.author;

    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;
    import org.springframework.data.repository.CrudRepository;

    import com.ccsw.tutorial.author.model.Author;

    /**
    * @author ccsw
    */
    public interface AuthorRepository extends CrudRepository<Author, Long> {

        /**
        * Método para recuperar un listado paginado de {@link com.ccsw.tutorial.author.model.Author}
        * @param page
        * @return
        */
        Page<Author> findAll(Pageable pageable);

    }
    ```

    
Si te fijas, este `Repository` ya no está vacío como el anterior, no nos sirve con las operaciones básicas del `CrudRepository` en este caso hemos tenido que añadir un método nuevo al que pasandole un objeto de tipo `Pageable` nos devuelva una `Page`.

Pues bien, resulta que la mágina de Spring JPA en este caso hará su trabajo y nosotros no necesitamos implementar ninguna query, Spring ya entiende que un `findAll` significa que debe recuperar todos los datos de la tabla `Author` (que es la tabla que tiene como `generico` en `CrudRepository`) y además deben estar paginados ya que el método devuelve un objeto tipo `Page`. Nos ahorra tener que generar una sql para buscar una página concreta de datos y hacer un `count` de la tabla para obtener el total de resultados. Para ver otros ejemplos y más información, visita la página de [QueryMethods](https://www.baeldung.com/spring-data-derived-queries). Realmente se puede hacer muchísimas cosas con solo escribir el nombre del método, sin tener que pensar ni teclear ninguna sql.

Con esto ya lo tendríamos todo. 


## Probar las operaciones

Si ahora ejecutamos los test jUnit, veremos que todos funcionan y están en verde. Hemos implementado todas nuestras pruebas y la aplicación es correcta.

![step4-java0](../../assets/images/step4-java0.png)

Aun así, debemos realizar pruebas con el postman para ver los resultados que nos ofrece el back. Para ello, tienes que levantar la aplición y ejecutar las siguientes operaciones:

** POST /author ** 
```
{
    "pageable": {
        "pageSize" : 4,
        "pageNumber" : 0,
        "sort" : [
            {
                "property": "name",
                "direction": "ASC"
            }
        ]
    }
}
```
Nos devuelve un listado paginado de `Autores`. Fíjate que los datos que se envían están en el body como formato JSON (parte izquierda de la imagen). Si no envías datos con formato `Pageable`, te dará un error. También fíjate que la respuesta es de tipo `Page`. Prueba a jugar con los datos de paginación e incluso de ordenación. No hemos programado ninguna SQL pero Spring hace su magia.


![step4-java1](../../assets/images/step4-java1.png)

** PUT /author ** 

** PUT /author/{id} ** 
```
{
    "name" : "Nuevo autor",
    "nationality" : "Nueva nacionalidad"
}
```
Nos sirve para insertar `Autores` nuevas (si no tienen el id informado) o para actualizar `Autores` (si tienen el id informado en la URL).  Fíjate que los datos que se envían están en el body como formato JSON (parte izquierda de la imagen). Si no te dará un error.

![step4-java2](../../assets/images/step4-java2.png)
![step4-java3](../../assets/images/step4-java3.png)

** DELETE /author/{id} **  nos sirve eliminar `Autores`. Fíjate que el dato del ID que se envía está en el path.

![step4-java4](../../assets/images/step4-java4.png)
