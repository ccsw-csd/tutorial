# Listado paginado - Spring Boot

Al igual que en el caso anterior vamos a crear un nuevo proyecto que contendrá un nuevo micro servicio.

Para la creación de proyecto nos remitimos a la guía de instalación donde se detalla el proceso de creación de nuevo proyecto [Entorno de desarrollo](../../install/springboot.md)

Todos los pasos son exactamente iguales, lo único que va a variar, es el nombre de nuestro proyecto, que en este caso se va a llamar `tutorial-author`. El campo que debemos modificar es `artifact` en Spring Initilizr, el resto de campos se cambiaran automáticamente.


## Código

Dado de vamos a implementar el micro servicio Spring Boot de `Autores`, vamos a respetar la misma estructura del [Listado paginado](../../develop/paginated/springboot.md) de la version monolítica.

### Paginación

En primer lugar, vamos a añadir la clase que necesitamos para realizar la paginación y vimos en la version monolítica del tutorial en el package `com.ccsw.tutorialauthor.common.pagination`. Ojo al package que lo hemos renombrado con respecto al listado monolítico.

=== "PageableRequest.java"
    ``` Java
    package com.ccsw.tutorialauthor.common.pagination;

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

### Entity y Dto

Seguimos con la entidad y los DTOs dentro del package `com.ccsw.tutorialauthor.author.model`.

=== "Author.java"
    ``` Java
    package com.ccsw.tutorialauthor.author.model;
    
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
    package com.ccsw.tutorialauthor.author.model;

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
=== "AuthorSearchDto.java"
    ``` Java
    package com.ccsw.tutorialauthor.author.model;
    
    import com.ccsw.tutorialauthor.common.pagination.PageableRequest;
    
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

### Repository, Service y Controller

Posteriormente, emplazamos el resto de clases dentro del package `com.ccsw.tutorialauthor.author`.

=== "AuthorRepository.java"
    ``` Java
    package com.ccsw.tutorialauthor.author;

    import com.ccsw.tutorialauthor.author.model.Author;
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
=== "AuthorService.java"
    ``` Java
    package com.ccsw.tutorialauthor.author;
    
    import com.ccsw.tutorialauthor.author.model.Author;
    import com.ccsw.tutorialauthor.author.model.AuthorDto;
    import com.ccsw.tutorialauthor.author.model.AuthorSearchDto;
    import org.springframework.data.domain.Page;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
     */
    public interface AuthorService {
    
        /**
         * Recupera un {@link Author} a través de su ID
         *
         * @param id PK de la entidad
         * @return {@link Author}
         */
        Author get(Long id);
    
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
    
        /**
         * Recupera un listado de autores {@link Author}
         *
         * @return {@link List} de {@link Author}
         */
        List<Author> findAll();
    
    }
    ```
=== "AuthorServiceImpl.java"
    ``` Java
    package com.ccsw.tutorialauthor.author;
    
    import com.ccsw.tutorialauthor.author.model.Author;
    import com.ccsw.tutorialauthor.author.model.AuthorDto;
    import com.ccsw.tutorialauthor.author.model.AuthorSearchDto;
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
         * @return
         */
        @Override
        public Author get(Long id) {
    
            return this.authorRepository.findById(id).orElse(null);
        }
    
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
                author = this.get(id);
            }
    
            BeanUtils.copyProperties(data, author, "id");
    
            this.authorRepository.save(author);
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public void delete(Long id) throws Exception {
    
            if(this.get(id) == null){
                throw new Exception("Not exists");
            }
    
            this.authorRepository.deleteById(id);
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public List<Author> findAll() {
    
            return (List<Author>) this.authorRepository.findAll();
        }
    
    }
    ```
=== "AuthorController.java"
    ``` Java
    package com.ccsw.tutorialauthor.author;
    
    import com.ccsw.tutorialauthor.author.model.Author;
    import com.ccsw.tutorialauthor.author.model.AuthorDto;
    import com.ccsw.tutorialauthor.author.model.AuthorSearchDto;
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
    
        /**
         * Recupera un listado de autores {@link Author}
         *
         * @return {@link List} de {@link AuthorDto}
         */
        @Operation(summary = "Find", description = "Method that return a list of Authors")
        @RequestMapping(path = "", method = RequestMethod.GET)
        public List<AuthorDto> findAll() {
    
            List<Author> authors = this.authorService.findAll();
    
            return authors.stream().map(e -> mapper.map(e, AuthorDto.class)).collect(Collectors.toList());
        }
    
    }
    ```

### SQL y Configuración    

Finalmente, debemos crear el script de inicialización de base de datos con solo los datos de author y modificar ligeramente la configuración inicial para añadir un puerto manualmente para poder tener multiples micro servicios funcionando simultáneamente.

=== "data.sql"
    ``` SQL
    INSERT INTO author(name, nationality) VALUES ('Alan R. Moon', 'US');
    INSERT INTO author(name, nationality) VALUES ('Vital Lacerda', 'PT');
    INSERT INTO author(name, nationality) VALUES ('Simone Luciani', 'IT');
    INSERT INTO author(name, nationality) VALUES ('Perepau Llistosella', 'ES');
    INSERT INTO author(name, nationality) VALUES ('Michael Kiesling', 'DE');
    INSERT INTO author(name, nationality) VALUES ('Phil Walker-Harding', 'US');
    ```
=== "application.properties"
    ``` properties hl_lines="1"
    server.port=8092

    #Database
    spring.datasource.url=jdbc:h2:mem:testdb
    spring.datasource.username=sa
    spring.datasource.password=sa
    spring.datasource.driver-class-name=org.h2.Driver
    
    spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
    spring.jpa.defer-datasource-initialization=true
    spring.jpa.show-sql=true
    
    spring.h2.console.enabled=true
    ```

### Pruebas

Ahora si arrancamos la aplicación server y abrimos el [Postman](https://www.postman.com/) podemos realizar las mismas pruebas del apartado de [Listado paginado](../../develop/paginated/springboot.md) pero esta vez apuntado al puerto `8092`.


## Siguientes pasos

En este punto ya tenemos un micro servicio de categorías en el puerto `8091` y un micro servicio de autores en el puerto `8092`. Al igual que antes, con estos datos ya podríamos conectar el frontend a estos servicios, pero vamos a esperar un poquito más a tener toda la infraestructura, para que sea más sencillo.

Vamos a convertir en micro servicio el último listado.