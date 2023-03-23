# Listado filtrado - Spring Boot

Al igual que en el caso anterior vamos a crear un nuevo proyecto que contendrá un nuevo micro servicio.

Para la creación de proyecto nos remitimos a la guía de instalación donde se detalla el proceso de creación de nuevo proyecto [Entorno de desarrollo](../../install/springboot.md)

Todos los pasos son exactamente iguales, lo único que va a variar, es el nombre de nuestro proyecto, que en este caso se va a llamar `tutorial-game`. El campo que debemos modificar es `artifact` en Spring Initilizr, el resto de campos se cambiaran automáticamente.


## Código

Dado de vamos a implementar el micro servicio Spring Boot de `Juegos`, vamos a respetar la misma estructura del [Listado filtrado](../../develop/filtered/springboot.md) de la version monolítica.

En primer lugar, vamos a añadir la clase que necesitamos para realizar el filtrado y vimos en la version monolítica del tutorial en el package `com.ccsw.tutorialgame.common.criteria`.

=== "SearchCriteria.java"
    ``` Java
    package com.ccsw.tutorialgame.common.criteria;
    
    public class SearchCriteria {
    
        private String key;
        private String operation;
        private Object value;
    
        public SearchCriteria(String key, String operation, Object value) {
    
            this.key = key;
            this.operation = operation;
            this.value = value;
        }
    
        public String getKey() {
            return key;
        }
    
        public void setKey(String key) {
            this.key = key;
        }
    
        public String getOperation() {
            return operation;
        }
    
        public void setOperation(String operation) {
            this.operation = operation;
        }
    
        public Object getValue() {
            return value;
        }
    
        public void setValue(Object value) {
            this.value = value;
        }
    
    }
    ```

Ahora vamos a crear los DTOs de las entidades relacionadas que usaremos más adelante dentro de los packages:

* `com.ccsw.tutorialgame.category.model`
* `com.ccsw.tutorialgame.author.model`

=== "CategoryDto.java"
    ``` Java
    package com.ccsw.tutorialgame.category.model;

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
=== "AuthorDto.java"
    ``` Java
    package com.ccsw.tutorialgame.author.model;

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

Seguimos con la entidad y el DTO dentro del package `com.ccsw.tutorialgame.game.model`.

=== "Game.java"
    ``` Java
    package com.ccsw.tutorialgame.game.model;
    
    import jakarta.persistence.*;
    
    
    /**
     * @author ccsw
     *
     */
    @Entity
    @Table(name = "game")
    public class Game {
    
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id", nullable = false)
        private Long id;
    
        @Column(name = "title", nullable = false)
        private String title;
    
        @Column(name = "age", nullable = false)
        private String age;
    
        @Column(name = "category_id", nullable = false)
        private Long idCategory;
    
        @Column(name = "author_id", nullable = false)
        private Long idAuthor;
    
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
         * @return title
         */
        public String getTitle() {
    
            return this.title;
        }
    
        /**
         * @param title new value of {@link #getTitle}.
         */
        public void setTitle(String title) {
    
            this.title = title;
        }
    
        /**
         * @return age
         */
        public String getAge() {
    
            return this.age;
        }
    
        /**
         * @param age new value of {@link #getAge}.
         */
        public void setAge(String age) {
    
            this.age = age;
        }
    
        /**
         * @return idCategory
         */
        public Long getIdCategory() {
    
            return this.idCategory;
        }
    
        /**
         * @param idCategory new value of {@link #getIdCategory}.
         */
        public void setIdCategory(Long idCategory) {
    
            this.idCategory = idCategory;
        }
    
        /**
         * @return idAuthor
         */
        public Long getIdAuthor() {
    
            return this.idAuthor;
        }
    
        /**
         * @param idAuthor new value of {@link #getIdAuthor}.
         */
        public void setIdAuthor(Long idAuthor) {
    
            this.idAuthor = idAuthor;
        }
    
    }
    ```
=== "GameDto.java"
    ``` Java
    package com.ccsw.tutorialgame.game.model;
    
    
    import com.ccsw.tutorialgame.author.model.AuthorDto;
    import com.ccsw.tutorialgame.category.model.CategoryDto;
    
    /**
     * @author ccsw
     *
     */
    public class GameDto {
    
        private Long id;
    
        private String title;
    
        private String age;
    
        private CategoryDto category;
    
        private AuthorDto author;
    
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
         * @return title
         */
        public String getTitle() {
    
            return this.title;
        }
    
        /**
         * @param title new value of {@link #getTitle}.
         */
        public void setTitle(String title) {
    
            this.title = title;
        }
    
        /**
         * @return age
         */
        public String getAge() {
    
            return this.age;
        }
    
        /**
         * @param age new value of {@link #getAge}.
         */
        public void setAge(String age) {
    
            this.age = age;
        }
    
        /**
         * @return category
         */
        public CategoryDto getCategory() {
    
            return this.category;
        }
    
        /**
         * @param category new value of {@link #getCategory}.
         */
        public void setCategory(CategoryDto category) {
    
            this.category = category;
        }
    
        /**
         * @return author
         */
        public AuthorDto getAuthor() {
    
            return this.author;
        }
    
        /**
         * @param author new value of {@link #getAuthor}.
         */
        public void setAuthor(AuthorDto author) {
    
            this.author = author;
        }
    
    }
    ```

Posteriormente, emplazamos el resto de clases dentro del package `com.ccsw.tutorialgame.game`.

=== "GameRepository.java"
    ``` Java
    package com.ccsw.tutorialgame.game;
    
    import com.ccsw.tutorialgame.game.model.Game;
    import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
    import org.springframework.data.repository.CrudRepository;
    
    /**
     * @author ccsw
     *
     */
    public interface GameRepository extends CrudRepository<Game, Long>, JpaSpecificationExecutor<Game> {
    
    }
    ```
=== "GameService.java"
    ``` Java
    package com.ccsw.tutorialgame.game;
    
    import com.ccsw.tutorialgame.game.model.Game;
    import com.ccsw.tutorialgame.game.model.GameDto;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
     */
    public interface GameService {
    
        /**
         * Recupera los juegos filtrando opcionalmente por título y/o categoría
         *
         * @param title título del juego
         * @param idCategory PK de la categoría
         * @return {@link List} de {@link Game}
         */
        List<Game> find(String title, Long idCategory);
    
        /**
         * Guarda o modifica un juego, dependiendo de si el identificador está o no informado
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        void save(Long id, GameDto dto);
    
    }
    ```
=== "GameSpecification.java"
    ``` Java
    package com.ccsw.tutorialgame.game;
    
    import com.ccsw.tutorialgame.common.criteria.SearchCriteria;
    import com.ccsw.tutorialgame.game.model.Game;
    import jakarta.persistence.criteria.*;
    import org.springframework.data.jpa.domain.Specification;
    
    
    public class GameSpecification implements Specification<Game> {
    
        private static final long serialVersionUID = 1L;
    
        private final SearchCriteria criteria;
    
        public GameSpecification(SearchCriteria criteria) {
    
            this.criteria = criteria;
        }
    
        @Override
        public Predicate toPredicate(Root<Game> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
            if (criteria.getOperation().equalsIgnoreCase(":") && criteria.getValue() != null) {
                Path<String> path = getPath(root);
                if (path.getJavaType() == String.class) {
                    return builder.like(path, "%" + criteria.getValue() + "%");
                } else {
                    return builder.equal(path, criteria.getValue());
                }
            }
            return null;
        }
    
        private Path<String> getPath(Root<Game> root) {
            String key = criteria.getKey();
            String[] split = key.split("[.]", 0);
    
            Path<String> expression = root.get(split[0]);
            for (int i = 1; i < split.length; i++) {
                expression = expression.get(split[i]);
            }
    
            return expression;
        }
    
    }
    ```
=== "GameServiceImpl.java"
    ``` Java
    package com.ccsw.tutorialgame.game;
    
    import com.ccsw.tutorialgame.common.criteria.SearchCriteria;
    import com.ccsw.tutorialgame.game.model.Game;
    import com.ccsw.tutorialgame.game.model.GameDto;
    import jakarta.transaction.Transactional;
    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.jpa.domain.Specification;
    import org.springframework.stereotype.Service;
    
    import java.util.List;
    
    /**
     * @author ccsw
     *
     */
    @Service
    @Transactional
    public class GameServiceImpl implements GameService {
    
        @Autowired
        GameRepository gameRepository;
    
        /**
         * {@inheritDoc}
         */
        @Override
        public List<Game> find(String title, Long idCategory) {
    
            GameSpecification titleSpec = new GameSpecification(new SearchCriteria("title", ":", title));
            GameSpecification categorySpec = new GameSpecification(new SearchCriteria("idCategory", ":", idCategory));
    
            Specification<Game> spec = Specification.where(titleSpec).and(categorySpec);
    
            return this.gameRepository.findAll(spec);
        }
    
        /**
         * {@inheritDoc}
         */
        @Override
        public void save(Long id, GameDto dto) {
    
            Game game;
    
            if (id == null) {
                game = new Game();
            } else {
                game = this.gameRepository.findById(id).orElse(null);
            }
    
            BeanUtils.copyProperties(dto, game, "id");
    
            game.setIdAuthor(dto.getAuthor().getId());
            game.setIdCategory(dto.getCategory().getId());
    
            this.gameRepository.save(game);
        }
    
    }
    ```
=== "GameController.java"
    ``` Java
    package com.ccsw.tutorialgame.game;

    import com.ccsw.tutorialgame.game.model.Game;
    import com.ccsw.tutorialgame.game.model.GameDto;
    import io.swagger.v3.oas.annotations.Operation;
    import io.swagger.v3.oas.annotations.tags.Tag;
    import org.dozer.DozerBeanMapper;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.*;
    
    import java.util.List;
    import java.util.stream.Collectors;
    
    /**
     * @author ccsw
     *
     */
    @Tag(name = "Game", description = "API of Game")
    @RequestMapping(value = "/game")
    @RestController
    @CrossOrigin(origins = "*")
    public class GameController {
    
        @Autowired
        GameService gameService;
    
        @Autowired
        DozerBeanMapper mapper;
    
        /**
         * Método para recuperar una lista de {@link Game}
         *
         * @param title título del juego
         * @param idCategory PK de la categoría
         * @return {@link List} de {@link GameDto}
         */
        @Operation(summary = "Find", description = "Method that return a filtered list of Games")
        @RequestMapping(path = "", method = RequestMethod.GET)
        public List<GameDto> find(@RequestParam(value = "title", required = false) String title,
                                  @RequestParam(value = "idCategory", required = false) Long idCategory) {
    
            List<Game> game = this.gameService.find(title, idCategory);
    
            return game.stream().map(e -> mapper.map(e, GameDto.class)).collect(Collectors.toList());
        }
    
        /**
         * Método para crear o actualizar un {@link Game}
         *
         * @param id PK de la entidad
         * @param dto datos de la entidad
         */
        @Operation(summary = "Save or Update", description = "Method that saves or updates a Game")
        @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
        public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody GameDto dto) {
    
            gameService.save(id, dto);
        }
    
    }
    ```

Finalmente, debemos crear el script de inicialización de base de datos con solo los datos de autores y modificar ligeramente la configuración inicial para añadir un puerto manualmente para poder tener multiples micro servicios funcionando simultáneamente.

=== "data.sql"
    ``` SQL
    INSERT INTO game(title, age, category_id, author_id) VALUES ('On Mars', '14', 1, 2);
    INSERT INTO game(title, age, category_id, author_id) VALUES ('Aventureros al tren', '8', 3, 1);
    INSERT INTO game(title, age, category_id, author_id) VALUES ('1920: Wall Street', '12', 1, 4);
    INSERT INTO game(title, age, category_id, author_id) VALUES ('Barrage', '14', 1, 3);
    INSERT INTO game(title, age, category_id, author_id) VALUES ('Los viajes de Marco Polo', '12', 1, 3);
    INSERT INTO game(title, age, category_id, author_id) VALUES ('Azul', '8', 3, 5);
    ```
=== "application.properties"
    ``` properties hl_lines="1"
    server.port=8093

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

Ahora si arrancamos la aplicación server y abrimos el [Postman](https://www.postman.com/) podemos realizar las mismas pruebas del apartado de [Listado filtrado](../../develop/filtered/springboot.md) pero esta vez apuntado al puerto `8093`.

Cuando realicemos las pruebas veremos que tanto la categoría como autor llegaran nulos, esto es debido a que aún no hemos implementado la comunicación entre los diferentes micro servicios que haremos en el paso siguiente.