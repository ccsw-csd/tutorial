# Listado paginado - Spring Boot

Ahora vamos a implementar las operaciones necesarias para ayudar al front a cubrir la funcionalidad del CRUD paginado en servidor. 
Recuerda que para que un listado paginado en servidor funcione, el cliente debe enviar en cada petición que página está solicitando y cuál es el tamaño de la página, para que el servidor devuelva solamente un subconjunto de datos, en lugar de devolver el listado completo.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.


## Crear modelos

Lo primero que vamos a hacer es crear los modelos para trabajar con BBDD y con peticiones hacia el front. Además, también tenemos que añadir datos al script de inicialización de BBDD.

=== "data.sql"
    ``` SQL hl_lines="5 6 7 8 9 10"
    INSERT INTO category(name) VALUES ('Eurogames');
    INSERT INTO category(name) VALUES ('Ameritrash');
    INSERT INTO category(name) VALUES ('Familiar');

    INSERT INTO author(name, nationality) VALUES ('Alan R. Moon', 'US');
    INSERT INTO author(name, nationality) VALUES ('Vital Lacerda', 'PT');
    INSERT INTO author(name, nationality) VALUES ('Simone Luciani', 'IT');
    INSERT INTO author(name, nationality) VALUES ('Perepau Llistosella', 'ES');
    INSERT INTO author(name, nationality) VALUES ('Michael Kiesling', 'DE');
    INSERT INTO author(name, nationality) VALUES ('Phil Walker-Harding', 'US');
    ```
=== "Author.java"
    ``` Java
    package com.ccsw.tutorial.author.model;
    
    import jakarta.persistence.*;
    
    /**
     * @author ccsw
     *
     */
    @Entity
    @Table(name = "author")
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
         * @param id new value of {@link #getId}.
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
         * @param name new value of {@link #getName}.
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
         * @param nationality new value of {@link #getNationality}.
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
     *
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
         * @param id new value of {@link #getId}.
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
         * @param name new value of {@link #getName}.
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
         * @param nationality new value of {@link #getNationality}.
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

Para ello, en primer lugar, deberemos añadir una clase que vamos a utilizar como envoltorio para la paginación de Springframework. Hacemos esto para desacoplar la interface de spring de nuestro contrato de entrada. Crearemos esta clase en el paquete `com.ccsw.tutorial.common.pagination`.

=== "PageableRequest.java"
    ``` Java
    package com.ccsw.tutorial.common.pagination;
    
    import com.fasterxml.jackson.annotation.JsonIgnore;
    import org.springframework.data.domain.*;
    
    import java.io.Serializable;
    import java.util.ArrayList;
    import java.util.List;
    import java.util.stream.Collectors;
    
    public class PageableRequest implements Serializable {

        private static final long serialVersionUID = 1L;
    
        private int pageNumber;
    
        private int pageSize;
    
        private List<SortRequest> sort;
    
        public PageableRequest() {
    
            sort = new ArrayList<>();
        }
    
        public PageableRequest(int pageNumber, int pageSize) {
    
            this();
            this.pageNumber = pageNumber;
            this.pageSize = pageSize;
        }
    
        public PageableRequest(int pageNumber, int pageSize, List<SortRequest> sort) {
    
            this();
            this.pageNumber = pageNumber;
            this.pageSize = pageSize;
            this.sort = sort;
        }
    
        public int getPageNumber() {
            return pageNumber;
        }
    
        public void setPageNumber(int pageNumber) {
            this.pageNumber = pageNumber;
        }
    
        public int getPageSize() {
            return pageSize;
        }
    
        public void setPageSize(int pageSize) {
            this.pageSize = pageSize;
        }
    
        public List<SortRequest> getSort() {
            return sort;
        }
    
        public void setSort(List<SortRequest> sort) {
            this.sort = sort;
        }
    
        @JsonIgnore
        public Pageable getPageable() {
    
            return PageRequest.of(this.pageNumber, this.pageSize, Sort.by(sort.stream().map(e -> new Sort.Order(e.getDirection(), e.getProperty())).collect(Collectors.toList())));
        }
    
        public static class SortRequest implements Serializable {

            private static final long serialVersionUID = 1L;
    
            private String property;
    
            private Sort.Direction direction;
    
            protected String getProperty() {
                return property;
            }
    
            protected void setProperty(String property) {
                this.property = property;
            }
    
            protected Sort.Direction getDirection() {
                return direction;
            }
    
            protected void setDirection(Sort.Direction direction) {
                this.direction = direction;
            }
        }
    
    }
    ```

Adicionalmente necesitaremos una clase para deserializar las respuestas de Page recibidas en los test que vamos a implementar. Para ello creamos la clase necesaria dentro de la fuente de la carpeta de los `test` en el paquete `com.ccsw.tutorial.config`.

=== "PageableRequest.java"
    ``` Java
    package com.ccsw.tutorial.config;
    
    import com.fasterxml.jackson.annotation.JsonCreator;
    import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
    import com.fasterxml.jackson.annotation.JsonProperty;
    import com.fasterxml.jackson.databind.JsonNode;
    import org.springframework.data.domain.PageImpl;
    import org.springframework.data.domain.PageRequest;
    import org.springframework.data.domain.Pageable;
    
    import java.util.ArrayList;
    import java.util.List;
    
    @JsonIgnoreProperties(ignoreUnknown = true)
    public class ResponsePage<T> extends PageImpl<T> {

        private static final long serialVersionUID = 1L;
    
        @JsonCreator(mode = JsonCreator.Mode.PROPERTIES)
        public ResponsePage(@JsonProperty("content") List<T> content,
                            @JsonProperty("number") int number,
                            @JsonProperty("size") int size,
                            @JsonProperty("totalElements") Long totalElements,
                            @JsonProperty("pageable") JsonNode pageable,
                            @JsonProperty("last") boolean last,
                            @JsonProperty("totalPages") int totalPages,
                            @JsonProperty("sort") JsonNode sort,
                            @JsonProperty("first") boolean first,
                            @JsonProperty("numberOfElements") int numberOfElements) {
    
            super(content, PageRequest.of(number, size), totalElements);
        }
    
        public ResponsePage(List<T> content, Pageable pageable, long total) {
            super(content, pageable, total);
        }
    
        public ResponsePage(List<T> content) {
            super(content);
        }
    
        public ResponsePage() {
            super(new ArrayList<>());
        }
    
    }
    ```

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
    
    import com.ccsw.tutorial.common.pagination.PageableRequest;
    
    /**
     * @author ccsw
     *
     */
    public class AuthorSearchDto {
    
        private PageableRequest pageable;
    
        public PageableRequest getPageable() {
            return pageable;
        }
    
        public void setPageable(PageableRequest pageable) {
            this.pageable = pageable;
        }
    }
    ```
=== "AuthorController.java"
    ``` Java
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import io.swagger.v3.oas.annotations.Operation;
    import io.swagger.v3.oas.annotations.tags.Tag;
    import org.springframework.data.domain.Page;
    import org.springframework.web.bind.annotation.*;
    
    /**
     * @author ccsw
     *
     */
    @Tag(name = "Author", description = "API of Author")
    @RequestMapping(value = "/author")
    @RestController
    @CrossOrigin(origins = "*")
    public class AuthorController {
    
        /**
         * Método para recuperar un listado paginado de {@link Author}
         *
         * @param dto dto de búsqueda
         * @return {@link Page} de {@link AuthorDto}
         */
        @Operation(summary = "Find Page", description = "Method that return a page of Authors")
        @RequestMapping(path = "", method = RequestMethod.POST)
        public Page<AuthorDto> findPage(@RequestBody AuthorSearchDto dto) {

            return null;
        }
    
        /**
         * Método para crear o actualizar un {@link Author}
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        @Operation(summary = "Save or Update", description = "Method that saves or updates a Author")
        @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
        public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody AuthorDto dto) {

        }
    
        /**
         * Método para crear o actualizar un {@link Author}
         *
         * @param id PK de la entidad
         */
        @Operation(summary = "Delete", description = "Method that deletes a Author")
        @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
        public void delete(@PathVariable("id") Long id) throws Exception {

        }
    
    }
    ```
=== "AuthorIT.java"
    ``` Java
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import com.ccsw.tutorial.common.pagination.PageableRequest;
    import com.ccsw.tutorial.config.ResponsePage;
    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.boot.test.web.client.TestRestTemplate;
    import org.springframework.boot.test.web.server.LocalServerPort;
    import org.springframework.core.ParameterizedTypeReference;
    import org.springframework.http.*;
    import org.springframework.test.annotation.DirtiesContext;
    
    import java.util.List;
    
    import static org.junit.jupiter.api.Assertions.assertEquals;
    import static org.junit.jupiter.api.Assertions.assertNotNull;
    
    @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
    @DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
    public class AuthorIT {
    
        public static final String LOCALHOST = "http://localhost:";
        public static final String SERVICE_PATH = "/author";
        
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
        
        ParameterizedTypeReference<ResponsePage<AuthorDto>> responseTypePage = new ParameterizedTypeReference<ResponsePage<AuthorDto>>(){};
        
        @Test
        public void findFirstPageWithFiveSizeShouldReturnFirstFiveResults() {
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(new PageableRequest(0, PAGE_SIZE));
        
              ResponseEntity<ResponsePage<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(TOTAL_AUTHORS, response.getBody().getTotalElements());
              assertEquals(PAGE_SIZE, response.getBody().getContent().size());
        }
        
        @Test
        public void findSecondPageWithFiveSizeShouldReturnLastResult() {
        
              int elementsCount = TOTAL_AUTHORS - PAGE_SIZE;
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(new PageableRequest(1, PAGE_SIZE));
        
              ResponseEntity<ResponsePage<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
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
              searchDto.setPageable(new PageableRequest(0, (int) newAuthorSize));
        
              ResponseEntity<ResponsePage<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
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
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + "/" + MODIFY_AUTHOR_ID, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(new PageableRequest(0, PAGE_SIZE));
        
              ResponseEntity<ResponsePage<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
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
        
              ResponseEntity<?> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + "/" + authorId, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        }
        
        @Test
        public void deleteWithExistsIdShouldDeleteCategory() {
        
              long newAuthorsSize = TOTAL_AUTHORS - 1;
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + "/" + DELETE_AUTHOR_ID, HttpMethod.DELETE, null, Void.class);
        
              AuthorSearchDto searchDto = new AuthorSearchDto();
              searchDto.setPageable(new PageableRequest(0, TOTAL_AUTHORS));
        
              ResponseEntity<ResponsePage<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.POST, new HttpEntity<>(searchDto), responseTypePage);
        
              assertNotNull(response);
              assertEquals(newAuthorsSize, response.getBody().getTotalElements());
        }
        
        @Test
        public void deleteWithNotExistsIdShouldThrowException() {
        
              long deleteAuthorId = TOTAL_AUTHORS + 1;
        
              ResponseEntity<?> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + "/" + deleteAuthorId, HttpMethod.DELETE, null, Void.class);
        
              assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        }
    
    }
    ```

!!! info "Cuidado con las clases de Test"
    Recuerda que el código de aplicación debe ir en `src/main/java`, mientras que las clases de test deben ir en `src/test/java` para que no se mezclen unas con otras y se empaquete todo en el artefacto final. En este caso `AuthorIT.java` va en el directorio de test `src/test/java`.


Si ejecutamos los test, el resultado será 7 maravillosos test que fallan su ejecución. Es normal, puesto que no hemos implementado nada de código de aplicación para corresponder esos test.


## Implementar Controller

Si recuerdas, esta capa de `Controller` es la que tiene los endpoints de entrada a la aplicación. Nosotros ya tenemos definidas 3 operaciones, que hemos diseñado directamente desde los tests. Ahora vamos a implementar esos métodos con el código necesario para que los test funcionen correctamente, y teniendo en mente que debemos apoyarnos en las capas inferiores `Service` y `Repository` para repartir lógica de negocio y acceso a datos.

=== "AuthorController.java"
    ``` Java hl_lines="27 28"
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import io.swagger.v3.oas.annotations.Operation;
    import io.swagger.v3.oas.annotations.tags.Tag;
    import org.dozer.DozerBeanMapper;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.PageImpl;
    import org.springframework.web.bind.annotation.*;
    
    import java.util.List;
    import java.util.stream.Collectors;
    
    /**
     * @author ccsw
     *
     */
    @Tag(name = "Author", description = "API of Author")
    @RequestMapping(value = "/author")
    @RestController
    @CrossOrigin(origins = "*")
    public class AuthorController {
    
        @Autowired
        AuthorService authorService;
    
        @Autowired
        DozerBeanMapper mapper;
    
        /**
         * Método para recuperar un listado paginado de {@link Author}
         *
         * @param dto dto de búsqueda
         * @return {@link Page} de {@link AuthorDto}
         */
        @Operation(summary = "Find Page", description = "Method that return a page of Authors")
        @RequestMapping(path = "", method = RequestMethod.POST)
        public Page<AuthorDto> findPage(@RequestBody AuthorSearchDto dto) {
    
            Page<Author> page = this.authorService.findPage(dto);
    
            return new PageImpl<>(page.getContent().stream().map(e -> mapper.map(e, AuthorDto.class)).collect(Collectors.toList()), page.getPageable(), page.getTotalElements());
        }
    
        /**
         * Método para crear o actualizar un {@link Author}
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        @Operation(summary = "Save or Update", description = "Method that saves or updates a Author")
        @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
        public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody AuthorDto dto) {
    
            this.authorService.save(id, dto);
        }
    
        /**
         * Método para crear o actualizar un {@link Author}
         *
         * @param id PK de la entidad
         */
        @Operation(summary = "Delete", description = "Method that deletes a Author")
        @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
        public void delete(@PathVariable("id") Long id) throws Exception {
    
            this.authorService.delete(id);
        }
    
    }
    ```
=== "AuthorService.java"
    ``` Java
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import org.springframework.data.domain.Page;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
     */
    public interface AuthorService {
    
        /**
         * Método para recuperar un listado paginado de {@link Author}
         *
         * @param dto dto de búsqueda
         * @return {@link Page} de {@link Author}
         */
        Page<Author> findPage(AuthorSearchDto dto);
    
        /**
         * Método para crear o actualizar un {@link Author}
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        void save(Long id, AuthorDto dto);
    
        /**
         * Método para crear o actualizar un {@link Author}
         *
         * @param id PK de la entidad
         */
        void delete(Long id) throws Exception;
    
    }
    ```

Si te fijas, hemos trasladado toda la lógica a llamadas al `AuthorService` que hemos inyectado, y para que no falle la compilación hemos creado una interface con los métodos necesarios.

En la clase `AuthorController` es donde se hacen las conversiones de cara al cliente, pasaremos de un `Page<Author>` (modelo entidad) a un `Page<AuthorDto>` (modelo DTO) con la ayuda del beanMapper. Recuerda que al cliente no le deben llegar modelos entidades sino DTOs.

Además, el método de carga `findPage` ya no es un método de tipo `GET`, ahora es de tipo `POST` porque le tenemos que enviar los datos de la paginación para que Spring JPA pueda hacer su magia.

Ahora debemos implementar la siguiente capa.


## Implementar Service

La siguiente capa que vamos a implementar es justamente la capa que contiene toda la lógica de negocio, hace uso del `Repository` para acceder a los datos, y recibe llamadas generalmente de los `Controller`.

=== "AuthorServiceImpl.java"
    ``` Java hl_lines="22 23 48"
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.author.model.AuthorSearchDto;
    import jakarta.transaction.Transactional;
    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.stereotype.Service;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
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
    
            return this.authorRepository.findAll(dto.getPageable().getPageable());
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public void save(Long id, AuthorDto data) {
    
            Author author;
    
            if (id == null) {
                author = new Author();
            } else {
                author = this.authorRepository.findById(id).orElse(null);
            }
    
            BeanUtils.copyProperties(data, author, "id");
    
            this.authorRepository.save(author);
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public void delete(Long id) throws Exception {
    
            if(this.authorRepository.findById(id).orElse(null) == null){
                throw new Exception("Not exists");
            }
    
            this.authorRepository.deleteById(id);
        }
    
    }
    ```
=== "AuthorRepository.java"
    ``` Java hl_lines="12"
    package com.ccsw.tutorial.author;
    
    import com.ccsw.tutorial.author.model.Author;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;
    import org.springframework.data.repository.CrudRepository;
    
    /**
     * @author ccsw
     *
     */
    public interface AuthorRepository extends CrudRepository<Author, Long> {
    
    }
    ```
    
De nuevo pasa lo mismo que con la capa anterior, aquí delegamos muchas operaciones de consulta y guardado de datos en `AuthorRepository`. Hemos tenido que crearlo como interface para que no falle la compilación. Recuerda que cuando creamos un `Repository` es de gran ayuda hacerlo extender de `CrudRepository<T, ID>` ya que tiene muchos métodos implementados de base que nos pueden servir, como el `delete` o el `save`.

Fíjate también que cuando queremos copiar más de un dato de una clase a otra, tenemos una utilidad llamada `BeanUtils` que nos permite realizar esa copia (siempre que las propiedades de ambas clases se llamen igual). Además, en nuestro ejemplo hemos ignorado el 'id' para que no nos copie un null a la clase destino.

## Implementar Repository

Y llegamos a la última capa, la que está más cerca de los datos finales. Tenemos la siguiente interface:

=== "AuthorRepository.java"
    ``` Java
    package com.ccsw.tutorial.author;

    import com.ccsw.tutorial.author.model.Author;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;
    import org.springframework.data.repository.CrudRepository;
    
    /**
     * @author ccsw
     *
     */
    public interface AuthorRepository extends CrudRepository<Author, Long> {
    
        /**
         * Método para recuperar un listado paginado de {@link Author}
         *
         * @param pageable pageable
         * @return {@link Page} de {@link Author}
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
