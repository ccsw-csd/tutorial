# Listado simple - Spring Boot

A diferencia del tutorial básico de Spring Boot, donde construíamos una aplicación monolítica, ahora vamos a construir multiples servicios por lo que necesitamos crear proyectos separados.

Para la creación de proyecto nos remitimos a la guía de instalación donde se detalla el proceso de creación de nuevo proyecto [Entorno de desarrollo](../../install/springboot.md)

Todos los pasos son exactamente iguales, lo único que va a variar es el nombre de nuestro proyecto, que en este caso se va a llamar `tutorial-category`. El campo que debemos modificar es `artifact` en Spring Initilizr, el resto de campos se cambiaran automáticamente.


## Estructurar el código y buenas prácticas

Esta parte de tutorial es una ampliación de la parte de backend con Spring Boot, por tanto, no se ve a enfocar en las partes básicas aprendidas previamente, sino que se va a explicar el funcionamiento de los micro servicios aplicados al mismo caso de uso. 

Para cualquier duda sobre la estructura del código y buenas prácticas, consultar el apartado de [Estructura y buenas prácticas](../../cleancode/springboot.md), ya que aplican a este caso en el mismo modo.


## Código

Dado de vamos a implementar el micro servicio Spring Boot de `Categorías`, vamos a respetar la misma estructura del [Listado simple](../../develop/basic/springboot.md) de la version monolítica.

### Entity y Dto

En primer lugar, vamos a crear la entidad y el DTO dentro del package `com.ccsw.tutorialcategory.category.model`. Ojo al package que lo hemos renombrado con respecto al listado monolítico.

=== "Category.java"
    ``` Java
    package com.ccsw.tutorialcategory.category.model;
    
    import jakarta.persistence.*;
    
    /**
     * @author ccsw
     *
     */
    @Entity
    @Table(name = "category")
    public class Category {
    
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id", nullable = false)
        private Long id;
    
        @Column(name = "name", nullable = false)
        private String name;
    
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
    
    }
    ```
=== "CategoryDto.java"
    ``` Java
    package com.ccsw.tutorialcategory.category.model;
    
    /**
     * @author ccsw
     *
     */
    public class CategoryDto {
    
        private Long id;
    
        private String name;
    
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
    
    }
    ```

### Repository, Service y Controller

Posteriormente, emplazamos el resto de clases dentro del package `com.ccsw.tutorialcategory.category`.

=== "CategoryRepository.java"
    ``` Java
    package com.ccsw.tutorialcategory.category;
    
    import com.ccsw.tutorialcategory.category.model.Category;
    import org.springframework.data.repository.CrudRepository;
    
    /**
     * @author ccsw
     *
     */
    public interface CategoryRepository extends CrudRepository<Category, Long> {
    
    }
    ```
=== "CategoryService.java"
    ``` Java
    package com.ccsw.tutorialcategory.category;
    
    
    import com.ccsw.tutorialcategory.category.model.Category;
    import com.ccsw.tutorialcategory.category.model.CategoryDto;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
     */
    public interface CategoryService {
    
        /**
         * Recupera una {@link Category} a partir de su ID
         *
         * @param id PK de la entidad
         * @return {@link Category}
         */
        Category get(Long id);
    
        /**
         * Método para recuperar todas las {@link Category}
         *
         * @return {@link List} de {@link Category}
         */
        List<Category> findAll();
    
        /**
         * Método para crear o actualizar una {@link Category}
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        void save(Long id, CategoryDto dto);
    
        /**
         * Método para borrar una {@link Category}
         *
         * @param id PK de la entidad
         */
        void delete(Long id) throws Exception;
    
    }
    ```
=== "CategoryServiceImpl.java"
    ``` Java
    package com.ccsw.tutorialcategory.category;
    
    import com.ccsw.tutorialcategory.category.model.Category;
    import com.ccsw.tutorialcategory.category.model.CategoryDto;
    import jakarta.transaction.Transactional;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
     */
    @Service
    @Transactional
    public class CategoryServiceImpl implements CategoryService {
    
        @Autowired
        CategoryRepository categoryRepository;
    
        /**
         * {@inheritDoc}
         */
        @Override
        public Category get(Long id) {
    
            return this.categoryRepository.findById(id).orElse(null);
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public List<Category> findAll() {
    
            return (List<Category>) this.categoryRepository.findAll();
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public void save(Long id, CategoryDto dto) {
    
            Category category;
    
            if (id == null) {
                category = new Category();
            } else {
                category = this.get(id);
            }
    
            category.setName(dto.getName());
    
            this.categoryRepository.save(category);
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public void delete(Long id) throws Exception {
    
            if(this.get(id) == null){
                throw new Exception("Not exists");
            }
    
            this.categoryRepository.deleteById(id);
        }
    
    }
    ```
=== "CategoryController.java"
    ``` Java
    package com.ccsw.tutorialcategory.category;
    
    import com.ccsw.tutorialcategory.category.model.Category;
    import com.ccsw.tutorialcategory.category.model.CategoryDto;
    import io.swagger.v3.oas.annotations.Operation;
    import io.swagger.v3.oas.annotations.tags.Tag;
    import org.modelmapper.ModelMapper;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.*;
    
    import java.util.List;
    import java.util.stream.Collectors;
    
    /**
     * @author ccsw
     *
     */
    @Tag(name = "Category", description = "API of Category")
    @RequestMapping(value = "/category")
    @RestController
    @CrossOrigin(origins = "*")
    public class CategoryController {
    
        @Autowired
        CategoryService categoryService;
    
        @Autowired
        ModelMapper mapper;
    
        /**
         * Método para recuperar todas las {@link Category}
         *
         * @return {@link List} de {@link CategoryDto}
         */
        @Operation(summary = "Find", description = "Method that return a list of Categories"
        )
        @RequestMapping(path = "", method = RequestMethod.GET)
        public List<CategoryDto> findAll() {
    
            List<Category> categories = this.categoryService.findAll();
    
            return categories.stream().map(e -> mapper.map(e, CategoryDto.class)).collect(Collectors.toList());
        }
    
        /**
         * Método para crear o actualizar una {@link Category}
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        @Operation(summary = "Save or Update", description = "Method that saves or updates a Category"
        )
        @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
        public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody CategoryDto dto) {
    
            this.categoryService.save(id, dto);
        }
    
        /**
         * Método para borrar una {@link Category}
         *
         * @param id PK de la entidad
         */
        @Operation(summary = "Delete", description = "Method that deletes a Category")
        @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
        public void delete(@PathVariable("id") Long id) throws Exception {
    
            this.categoryService.delete(id);
        }
    
    }
    ```

### SQL y Configuración

Finalmente, debemos crear el mismo fichero de inicialización de base de datos con solo los datos de categorías y modificar ligeramente la configuración inicial para añadir un puerto manualmente. Esto es necesario ya que vamos a levantar varios servicios simultáneamente y necesitaremos levantarlos en puertos diferentes para que no colisionen entre ellos.

=== "data.sql"
    ``` SQL
    INSERT INTO category(name) VALUES ('Eurogames');
    INSERT INTO category(name) VALUES ('Ameritrash');
    INSERT INTO category(name) VALUES ('Familiar');
    ```
=== "application.properties"
    ``` properties hl_lines="1"
    server.port=8091
    
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

Ahora si arrancamos la aplicación server y abrimos el [Postman](https://www.postman.com/) podemos realizar las mismas pruebas del apartado de [Listado simple](../../develop/basic/springboot.md) pero esta vez apuntado al puerto `8091`.


## Siguientes pasos

Con esto ya tendríamos nuestro primer servicio separado. Podríamos conectar el frontend a este servicio, pero a medida que nuestra aplicación creciera en número de servicios sería un poco engorroso todo, así que todavía no lo vamos a conectar hasta que no tengamos toda la infraestructura.

Vamos a convertir en micro servicio el siguiente listado.