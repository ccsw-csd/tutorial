# Listado filtrado - Springboot

En este punto ya tenemos dos listados, uno básico y otro paginado. Ahora vamos a implementar un listado un poco diferente, este listado va a tener filtros de búsqueda.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

## Modelos

Lo primero que vamos a hacer es crear los modelos para trabajar con BBDD y con peticiones hacia el front. Además, también tenemos que añadir datos al script de inicialización de BBDD.

=== "schema.sql"
    ``` SQL hl_lines="18 20-26 28 29"
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


    DROP TABLE IF EXISTS GAME;

    CREATE TABLE GAME (
        id BIGINT IDENTITY NOT NULL PRIMARY KEY,
        title VARCHAR(250) NOT NULL,
        age VARCHAR(3) NOT NULL,
        category_id BIGINT DEFAULT NULL,
        author_id BIGINT DEFAULT NULL
    );

    ALTER TABLE GAME ADD FOREIGN KEY (category_id) REFERENCES CATEGORY(id);
    ALTER TABLE GAME ADD FOREIGN KEY (author_id) REFERENCES AUTHOR(id);
    ```
=== "data.sql"
    ``` SQL hl_lines="12 13 14 15 16 17 18"
    INSERT INTO CATEGORY(id, name) VALUES (1, 'Eurogames');
    INSERT INTO CATEGORY(id, name) VALUES (2, 'Ameritrash');
    INSERT INTO CATEGORY(id, name) VALUES (3, 'Familiar');

    INSERT INTO AUTHOR(id, name, nationality) VALUES (1, 'Alan R. Moon', 'US');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (2, 'Vital Lacerda', 'PT');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (3, 'Simone Luciani', 'IT');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (4, 'Perepau Llistosella', 'ES');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (5, 'Michael Kiesling', 'DE');
    INSERT INTO AUTHOR(id, name, nationality) VALUES (6, 'Phil Walker-Harding', 'US');

    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (1, 'On Mars', '14', 1, 2);
    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (2, 'Aventureros al tren', '8', 3, 1);
    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (3, '1920: Wall Street', '12', 1, 4);
    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (4, 'Barrage', '14', 1, 3);
    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (5, 'Los viajes de Marco Polo', '12', 1, 3);
    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (6, 'Azul', '8', 3, 5);
    ```
=== "Game.java"
    ``` Java
    package com.ccsw.tutorial.game.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.ManyToOne;
    import javax.persistence.Table;

    import com.ccsw.tutorial.author.model.Author;
    import com.ccsw.tutorial.category.model.Category;

    /**
    * @author ccsw
    */
    @Entity
    @Table(name = "Game")
    public class Game {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id", nullable = false)
        private Long id;

        @Column(name = "title", nullable = false)
        private String title;

        @Column(name = "age", nullable = false)
        private String age;

        @ManyToOne
        @JoinColumn(name = "category_id", nullable = false)
        private Category category;

        @ManyToOne
        @JoinColumn(name = "author_id", nullable = false)
        private Author author;

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
        public Category getCategory() {

            return this.category;
        }

        /**
        * @param category new value of {@link #getCategory}.
        */
        public void setCategory(Category category) {

            this.category = category;
        }

        /**
        * @return author
        */
        public Author getAuthor() {

            return this.author;
        }

        /**
        * @param author new value of {@link #getAuthor}.
        */
        public void setAuthor(Author author) {

            this.author = author;
        }

    }
    ```
=== "GameDto.java"
    ``` Java
    package com.ccsw.tutorial.game.model;

    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
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

!!! note "Relaciones anidadas"
    Fíjate que tanto la `Entity` como el `Dto` tienen relaciones con `Author` y `Category`. Gracias a Spring JPA se pueden resolver de esta forma y tener toda la información de las relaciones hijas dentro del objeto padre. Muy importante recordar que *en el mundo entity* las relaciones serán con objetos `Entity` mientras que *en el mundo dto* las relaciones deben ser siempre con objetos `Dto`. La utilidad beanMapper ya hará las conversiones necesarias, siempre que tengan el mismo nombre de propiedades.



## TDD - Pruebas

Para desarrollar todas las operaciones, empezaremos primero diseñando las pruebas y luego implementando el código necesario que haga funcionar correctamente esas pruebas. Para ir más rápido vamos a poner todas las pruebas de golpe, pero realmente se deberían crear una a una e ir implementando el código necesario para esa prueba. Para evitar tantas iteraciones en el tutorial las haremos todas de golpe.

Vamos a pararnos a pensar un poco que necesitamos en la pantalla. En este caso solo tenemos dos operaciones:

* Una consulta filtrada, que reciba datos de filtro opcionales (título e idCategoría) y devuelva los datos ya filtrados
* Una operación de guardado y modificación

De nuevo tendremos que desglosar esto en varios casos de prueba:

* Buscar un juego sin filtros
* Buscar un título que exista
* Buscar una categoría que exista
* Buscar un título y una categoría que existan
* Buscar un título que no exista
* Buscar una categoría que no exista
* Buscar un título y una categoría que no existan
* Crear un juego nuevo (en realidad deberíamos probar diferentes combinaciones y errores)
* Modificar un juego que exista
* Modificar un juego que no exista


También crearemos una clase `GameController` dentro del package de `com.ccsw.tutorial.game` con la implementación de los métodos vacíos, para que no falle la compilación.

¡Vamos a implementar test!


=== "GameController.java"
    ``` Java
    package com.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.web.bind.annotation.RestController;

    import com.ccsw.tutorial.game.model.GameDto;

    @RestController
    public class GameController {

        public List<GameDto> find(String title, Long idCategory) {
            return null;
        }

        public void save(Long id, GameDto dto) {

        }

    }
    ```
=== "GameIT.java"
    ``` Java
    package com.ccsw.tutorial.game;
    
    import com.ccsw.tutorial.author.model.AuthorDto;
    import com.ccsw.tutorial.category.model.CategoryDto;
    import com.ccsw.tutorial.game.model.GameDto;
    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.boot.test.web.client.TestRestTemplate;
    import org.springframework.boot.web.server.LocalServerPort;
    import org.springframework.core.ParameterizedTypeReference;
    import org.springframework.http.HttpEntity;
    import org.springframework.http.HttpMethod;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.test.annotation.DirtiesContext;
    import org.springframework.web.util.UriComponentsBuilder;
    
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;
    
    import static org.junit.jupiter.api.Assertions.*;
    
    @SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
    @DirtiesContext(classMode = DirtiesContext.ClassMode.BEFORE_EACH_TEST_METHOD)
    public class GameIT {
    
        public static final String LOCALHOST = "http://localhost:";
        public static final String SERVICE_PATH = "/game/";
        
        public static final Long EXISTS_GAME_ID = 1L;
        public static final Long NOT_EXISTS_GAME_ID = 0L;
        private static final String NOT_EXISTS_TITLE = "NotExists";
        private static final String EXISTS_TITLE = "Aventureros";
        private static final String NEW_TITLE = "Nuevo juego";
        private static final Long NOT_EXISTS_CATEGORY = 0L;
        private static final Long EXISTS_CATEGORY = 3L;
        
        private static final String TITLE_PARAM = "title";
        private static final String CATEGORY_ID_PARAM = "idCategory";
        
        @LocalServerPort
        private int port;
        
        @Autowired
        private TestRestTemplate restTemplate;
        
        ParameterizedTypeReference<List<GameDto>> responseType = new ParameterizedTypeReference<List<GameDto>>(){};
        
        private String getUrlWithParams(){
            return UriComponentsBuilder.fromHttpUrl(LOCALHOST + port + SERVICE_PATH)
            .queryParam(TITLE_PARAM, "{" + TITLE_PARAM +"}")
            .queryParam(CATEGORY_ID_PARAM, "{" + CATEGORY_ID_PARAM +"}")
            .encode()
            .toUriString();
        }
        
        @Test
        public void findWithoutFiltersShouldReturnAllGamesInDB() {
        
              int GAMES_WITH_FILTER = 6;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, null);
              params.put(CATEGORY_ID_PARAM, null);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void findExistsTitleShouldReturnGames() {
        
              int GAMES_WITH_FILTER = 1;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, EXISTS_TITLE);
              params.put(CATEGORY_ID_PARAM, null);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void findExistsCategoryShouldReturnGames() {
        
              int GAMES_WITH_FILTER = 2;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, null);
              params.put(CATEGORY_ID_PARAM, EXISTS_CATEGORY);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void findExistsTitleAndCategoryShouldReturnGames() {
        
              int GAMES_WITH_FILTER = 1;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, EXISTS_TITLE);
              params.put(CATEGORY_ID_PARAM, EXISTS_CATEGORY);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void findNotExistsTitleShouldReturnEmpty() {
        
              int GAMES_WITH_FILTER = 0;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, NOT_EXISTS_TITLE);
              params.put(CATEGORY_ID_PARAM, null);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void findNotExistsCategoryShouldReturnEmpty() {
        
              int GAMES_WITH_FILTER = 0;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, null);
              params.put(CATEGORY_ID_PARAM, NOT_EXISTS_CATEGORY);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void findNotExistsTitleOrCategoryShouldReturnEmpty() {
        
              int GAMES_WITH_FILTER = 0;
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, NOT_EXISTS_TITLE);
              params.put(CATEGORY_ID_PARAM, NOT_EXISTS_CATEGORY);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        
              params.put(TITLE_PARAM, NOT_EXISTS_TITLE);
              params.put(CATEGORY_ID_PARAM, EXISTS_CATEGORY);
        
              response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        
              params.put(TITLE_PARAM, EXISTS_TITLE);
              params.put(CATEGORY_ID_PARAM, NOT_EXISTS_CATEGORY);
        
              response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
              assertNotNull(response);
              assertEquals(GAMES_WITH_FILTER, response.getBody().size());
        }
        
        @Test
        public void saveWithoutIdShouldCreateNewGame() {
        
              GameDto dto = new GameDto();
              AuthorDto authorDto = new AuthorDto();
              authorDto.setId(1L);
        
              CategoryDto categoryDto = new CategoryDto();
              categoryDto.setId(1L);
        
              dto.setTitle(NEW_TITLE);
              dto.setAge("18");
              dto.setAuthor(authorDto);
              dto.setCategory(categoryDto);
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, NEW_TITLE);
              params.put(CATEGORY_ID_PARAM, null);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(0, response.getBody().size());
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(1, response.getBody().size());
        }
        
        @Test
        public void modifyWithExistIdShouldModifyGame() {
        
              GameDto dto = new GameDto();
              AuthorDto authorDto = new AuthorDto();
              authorDto.setId(1L);
        
              CategoryDto categoryDto = new CategoryDto();
              categoryDto.setId(1L);
        
              dto.setTitle(NEW_TITLE);
              dto.setAge("18");
              dto.setAuthor(authorDto);
              dto.setCategory(categoryDto);
        
              Map<String, Object> params = new HashMap<>();
              params.put(TITLE_PARAM, NEW_TITLE);
              params.put(CATEGORY_ID_PARAM, null);
        
              ResponseEntity<List<GameDto>> response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(0, response.getBody().size());
        
              restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + EXISTS_GAME_ID, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              response = restTemplate.exchange(getUrlWithParams(), HttpMethod.GET, null, responseType, params);
        
              assertNotNull(response);
              assertEquals(1, response.getBody().size());
              assertEquals(EXISTS_GAME_ID, response.getBody().get(0).getId());
        }
        
        @Test
        public void modifyWithNotExistIdShouldThrowException() {
        
              GameDto dto = new GameDto();
              dto.setTitle(NEW_TITLE);
        
              ResponseEntity<?> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH + NOT_EXISTS_GAME_ID, HttpMethod.PUT, new HttpEntity<>(dto), Void.class);
        
              assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        }
    
    }
    ```

!!! tip "Búsquedas en BBDD"
    Siempre deberíamos buscar a los hijos por primary keys, nunca hay que hacerlo por una descripción libre ya que el usuario podría teclear el mismo nombre de diferentes formas y no habría manera de buscar correctamente el resultado. Así que siempre que haya un dropdown, se debe filtrar por su ID.


Si ahora ejecutas los jUnits, verás que en este caso hemos construido 10 pruebas, para cubrir los casos básicos del `Controller`, y todas ellas fallan la ejecución. Vamos a seguir implementando el resto de capas para hacer que los test funcionen.

## Controller

De nuevo para poder compilar esta capa, nos hace falta delegar sus operaciones de lógica de negocio en un `Service` así que lo crearemos al mismo tiempo que lo vamos necesitando.

=== "GameService.java"
    ``` Java
    package com.ccsw.tutorial.game;

    import java.util.List;

    import com.ccsw.tutorial.game.model.Game;
    import com.ccsw.tutorial.game.model.GameDto;

    /**
    * @author ccsw
    */
    public interface GameService {

        /**
        * Recupera los juegos filtrando opcionalmente por título y/o categoría
        * @param title
        * @param idCategory
        * @return
        */
        List<Game> find(String title, Long idCategory);

        /**
        * Guarda o modifica un juego, dependiendo de si el id está o no informado
        * @param id
        * @param dto
        */
        void save(Long id, GameDto dto);

    }
    ```
=== "GameController.java"
    ``` Java hl_lines="21-23 26-27 29-30 32-39 41-45"
    package com.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.CrossOrigin;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RequestParam;
    import org.springframework.web.bind.annotation.RestController;

    import com.ccsw.tutorial.game.model.Game;
    import com.ccsw.tutorial.game.model.GameDto;
    import com.devonfw.module.beanmapping.common.api.BeanMapper;

    /**
    * @author ccsw
    */
    @RequestMapping(value = "/game")
    @RestController
    @CrossOrigin(origins = "*")
    public class GameController {

        @Autowired
        GameService gameService;

        @Autowired
        BeanMapper beanMapper;

        @RequestMapping(path = "", method = RequestMethod.GET)
        public List<GameDto> find(@RequestParam(value = "title", required = false) String title,
                @RequestParam(value = "idCategory", required = false) Long idCategory) {

            List<Game> games = gameService.find(title, idCategory);

            return beanMapper.mapList(games, GameDto.class);
        }

        @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
        public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody GameDto dto) {

            gameService.save(id, dto);
        }

    }
    ```

En esta ocasión, para el método de búsqueda hemos decidido utilizar parámetros en la URL de tal forma que nos quedará algo así `http://localhost:8080/game/?title=xxx&idCategoria=yyy`. Queremos recuperar el recurso `Game` que es el raiz de la ruta, pero filtrado por cero o varios parámetros.


## Service

Siguiente paso, la capa de lógica de negocio, es decir el `Service`, que por tanto hará uso de un `Repository`.


=== "GameServiceImpl.java"
    ``` Java hl_lines="30 46"
    package com.ccsw.tutorial.game;

    import java.util.List;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.ccsw.tutorial.game.model.Game;
    import com.ccsw.tutorial.game.model.GameDto;

    /**
    * @author ccsw
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
        public List<Game> find(String title, Long category) {

            return this.gameRepository.find(title, category);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public void save(Long id, GameDto dto) {

            Game game = null;

            if (id == null)
                game = new Game();
            else
                game = this.gameRepository.findById(id).orElse(null);

            BeanUtils.copyProperties(dto, game, "id", "author", "category");

            this.gameRepository.save(game);
        }

    }
    ```
=== "GameRepository.java"
    ``` Java
    package com.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.data.repository.CrudRepository;

    import com.ccsw.tutorial.game.model.Game;

    public interface GameRepository extends CrudRepository<Game, Long> {

        List<Game> find(String title, Long category);

    }
    ```

Este servicio tiene dos peculiaridades, remarcadas en amarillo en la clase anterior. Por un lado tenemos la consulta, que no es un listado completo ni un listado paginado, sino que es un listado con filtros. Luego veremos como se hace eso, de momento lo dejaremos como un método que recibe los dos filtros.

La segunda peculiaridad es que de cliente nos está llegando un `GameDto`, que internamente tiene un `AuthorDto` y un `CategoryDto`, pero nosotros lo tenemos que traducir a entidades de BBDD. No sirve con copiar las propiedades tal cual, ya que entonces Spring lo que hará será crear un objeto nuevo y persistir ese objeto nuevo de `Author` y de `Category`. Además, de cliente generalmente tan solo nos llega el ID de esos objetos hijo, y no el resto de información de la entidad. Por esos motivos lo hemos *ignorado* del copyProperties.

Pero de alguna forma tendremos que setearle esos valores a la entidad `Game`. Si conocemos sus ID que es lo que generalmente llega, podemos recuperar esos objetos de BBDD y setearlos en el objeto `Game`. Si recuerdas las reglas básicas, un `Repository` debe pertenecer a un solo `Service`, por lo que en lugar de llamar a métodos de los `AuthorRepository` y `CategoryRepository` desde nuestro `GameServiceImpl`, debemos llamar a métodos expuestos en `AuthorService` y `CategoryService`, que son los que gestionan sus repositorios. Para ello necesitaremos crear esos métodos get en los otros `Services`. 

Y ya sabes, para implementar nuevos métodos, antes se deben hacer las pruebas jUnit, que en este caso, por variar, cubriremos con pruebas unitarias. Recuerda que los test van en `src/test/java`

=== "AuthorTest.java"
    ``` Java
    package com.ccsw.tutorial.author;

    import static org.junit.jupiter.api.Assertions.assertEquals;
    import static org.junit.jupiter.api.Assertions.assertNotNull;
    import static org.junit.jupiter.api.Assertions.assertNull;
    import static org.mockito.Mockito.mock;
    import static org.mockito.Mockito.when;
    
    import org.junit.jupiter.api.Test;
    import org.junit.jupiter.api.extension.ExtendWith;
    import org.mockito.InjectMocks;
    import org.mockito.Mock;
    import org.mockito.junit.jupiter.MockitoExtension;
    
    import com.ccsw.tutorial.author.model.Author;
    
    import java.util.Optional;
    
    @ExtendWith(MockitoExtension.class)
    public class AuthorTest {
    
       public static final Long EXISTS_AUTHOR_ID = 1L;
       public static final Long NOT_EXISTS_AUTHOR_ID = 0L;
    
       @Mock
       private AuthorRepository authorRepository;
    
       @InjectMocks
       private AuthorServiceImpl authorService;
    
       @Test
       public void getExistsAuthorIdShouldReturnAuthor() {
    
          Author author = mock(Author.class);
          when(author.getId()).thenReturn(EXISTS_AUTHOR_ID);
          when(authorRepository.findById(EXISTS_AUTHOR_ID)).thenReturn(Optional.of(author));
    
          Author authorResponse = authorService.get(EXISTS_AUTHOR_ID);
    
          assertNotNull(authorResponse);
    
          assertEquals(EXISTS_AUTHOR_ID, authorResponse.getId());
       }
    
       @Test
       public void getNotExistsAuthorIdShouldReturnNull() {
    
          when(authorRepository.findById(NOT_EXISTS_AUTHOR_ID)).thenReturn(Optional.empty());
    
          Author author = authorService.get(NOT_EXISTS_AUTHOR_ID);
    
          assertNull(author);
       }
    
    }
    ```
=== "AuthorService.java"
    ``` Java hl_lines="14-19"
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
        * Recupera un {@link com.ccsw.tutorial.author.model.Author} a través de su ID
        * @param id
        * @return
        */
        Author get(Long id);

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
=== "AuthorServiceImpl.java"
    ``` Java hl_lines="24-31 50"
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
        public Author get(Long id) {

            return this.authorRepository.findById(id).orElse(null);
        }

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
                author = this.get(id);
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

Y lo mismo para categorías.


=== "CategoryTest.java"
    ``` Java
    @Test
    public void getExistsCategoryIdShouldReturnCategory() {
    
          Category category = mock(Category.class);
          when(category.getId()).thenReturn(EXISTS_CATEGORY_ID);
          when(categoryRepository.findById(EXISTS_CATEGORY_ID)).thenReturn(Optional.of(category));
    
          Category categoryResponse = categoryService.get(EXISTS_CATEGORY_ID);
    
          assertNotNull(categoryResponse);
          assertEquals(EXISTS_CATEGORY_ID, category.getId());
    }
    
    @Test
    public void getNotExistsCategoryIdShouldReturnNull() {
    
          when(categoryRepository.findById(NOT_EXISTS_CATEGORY_ID)).thenReturn(Optional.empty());
    
          Category category = categoryService.get(NOT_EXISTS_CATEGORY_ID);
    
          assertNull(category);
    }
    ```
=== "CategoryService.java"
    ``` Java hl_lines="14-19"
    package com.ccsw.tutorial.category;

    import java.util.List;

    import com.ccsw.tutorial.category.model.Category;
    import com.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
    *
    */
    public interface CategoryService {

        /**
        * Recupera una {@link com.ccsw.tutorial.category.model.Category} a partir de su ID
        * @param id
        * @return
        */
        Category get(Long id);

        /**
        * Método para recuperar todas las {@link com.ccsw.tutorial.category.model.Category}
        * @return
        */
        List<Category> findAll();

        /**
        * Método para crear o actualizar una {@link com.ccsw.tutorial.category.model.Category}
        * @param dto
        * @return
        */
        void save(Long id, CategoryDto dto);

        /**
        * Método para borrar una {@link com.ccsw.tutorial.category.model.Category}
        * @param id
        */
        void delete(Long id);
    }
    ```
=== "CategoryServiceImpl.java"
    ``` Java hl_lines="21-28 50"
    package com.ccsw.tutorial.category;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.ccsw.tutorial.category.model.Category;
    import com.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
    *
    */
    @Service
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

            Category categoria = null;

            if (id == null)
                categoria = new Category();
            else
                categoria = this.get(id);

            categoria.setName(dto.getName());

            this.categoryRepository.save(categoria);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public void delete(Long id) {

            this.categoryRepository.deleteById(id);

        }
    }
    ```

!!! tip "Clean Code"
    A la hora de implementar métodos nuevos, ten siempre presente el `Clean Code`. ¡No dupliques código!, es muy importante de cara al futuro mantenimiento. Si en nuestro método `save` hacíamos uso de una operación `findById` y ahora hemos creado una nueva operación `get`, hagamos uso de esta nueva operación y no repitamos el código.


Y ahora que ya tenemos los métodos necesarios ya podemos implementar correctamente nuestro `GameServiceImpl`.


=== "GameServiceImpl.java"
    ``` Java hl_lines="26-27 29-30 56-57"
    package com.ccsw.tutorial.game;

    import java.util.List;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.ccsw.tutorial.author.AuthorService;
    import com.ccsw.tutorial.category.CategoryService;
    import com.ccsw.tutorial.game.model.Game;
    import com.ccsw.tutorial.game.model.GameDto;

    /**
    * @author ccsw
    */
    @Service
    @Transactional
    public class GameServiceImpl implements GameService {

        @Autowired
        GameRepository gameRepository;

        @Autowired
        AuthorService authorService;

        @Autowired
        CategoryService categoryService;

        /**
        * {@inheritDoc}
        */
        @Override
        public List<Game> find(String title, Long category) {

            return this.gameRepository.find(title, category);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public void save(Long id, GameDto dto) {

            Game game = null;

            if (id == null)
                game = new Game();
            else
                game = this.gameRepository.findById(id).orElse(null);

            BeanUtils.copyProperties(dto, game, "id", "author", "category");

            game.setAuthor(authorService.get(dto.getAuthor().getId()));
            game.setCategory(categoryService.get(dto.getCategory().getId()));

            this.gameRepository.save(game);
        }

    }
    ```

Ahora si que tenemos la capa de lógica de negocio terminada, podemos pasar a la siguiente capa.


## Repository

Y llegamos a la última capa donde, si recordamos, teníamos un método `find` que recibe dos parámetros. Algo así:


=== "GameRepository.java"
    ``` Java
    package com.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.data.repository.CrudRepository;

    import com.ccsw.tutorial.game.model.Game;

    public interface GameRepository extends CrudRepository<Game, Long> {

        List<Game> find(String title, Long category);

    }
    ```


Para esta ocasión, vamos a necesitar un listado filtrado por título o por categoría, así que necesitaremos pasarle esos datos y filtrar la query. Para el título vamos a buscar por una cadena contenida, así que el parámetro será de tipo `String`, mientras que para la categoría vamos a buscar por su primary key, así que el parámetro será de tipo `Long`.

Existen varias estrategias para abordar esta implementación. Podríamos utilizar los [QueryMethods](https://www.baeldung.com/spring-data-derived-queries) para que Spring JPA haga su magia, pero en esta ocasión sería bastante complicado encontrar un predicado correcto.

También podríamos hacer una implementación de la interface y hacer la consulta directamente con Criteria. Pero en esta ocasión vamos a utilizar otra *magia* que nos ofrece Spring JPA y es utilizar la [anotación @Query](https://www.baeldung.com/spring-data-jpa-query).

Esta anotación nos permite definir una consulta en SQL nativo o en JPQL (Java Persistence Query Language) y Spring JPA se encargará de realizar todo el mapeo y conversión de los datos de entrada y salida. Veamos un ejemplo y luego lo explicamos en detalle:

=== "GameRepository.java"
    ``` Java hl_lines="11-12"
    package com.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.data.repository.CrudRepository;

    import com.ccsw.tutorial.game.model.Game;

    public interface GameRepository extends CrudRepository<Game, Long> {

        @Query("select g from Game g where (:title is null or g.title like '%'||:title||'%') and (:category is null or g.category.id = :category)")
        List<Game> find(@Param("title") String title, @Param("category") Long category);

    }
    ```

Si te fijas en las dos líneas que hemos modificado, por un lado hemos puesto nombre a los parámetros de entrada con la anotación @Param. Esto solo nos sirve para poder utilizar los parametros dentro de la query.

Por otro lado, hemos creado una query en un lenguaje similar a SQL, pero en lugar de hacer uso de tablas y columnas, hacemos uso de objetos entity y propiedades. Dentro del where hemos puesto las dos condiciones, o bien que el parámetro título sea nulo o bien si no es nulo, que la propiedad contenga el texto del parámetro título. Para categoría hemos hecho lo mismo. 
Con esta quuery, Spring JPA generará el SQL correcto y mapeará los resultados a un listado de `Game` que es lo que queremos obtener.

Es otra forma, bastante sencilla de implementar consultas a BBDD.


## Prueba de las operaciones


Si ahora ejecutamos de nuevo los jUnits, vemos que todos los que hemos desarrollado en `GameIT` ya funcionan correctamente, e incluso el resto de test de la aplicación también funcionan correctamente. 

!!! tip "Pruebas jUnit"
    Cada vez que desarrollemos un caso de uso nuevo, debemos relanzar todas las pruebas automáticas que tenga la aplicación. Es muy común que al implementar algún desarrollo nuevo, interfiramos de alguna forma en el funcionamiento de otra funcionalidad. Si lanzamos toda la batería de pruebas, nos daremos cuenta si algo ha dejado de funcionar y podremos solucionarlo antes de llevar ese error a Producción. Las pruebas jUnit son nuestra red de seguridad.


Además de las pruebas automáticas, podemos ver como se comporta la aplicación y que respuesta nos ofrece, lanzando peticiones Rest con Postman, como hemos hecho en los casos anteriores. Así que podemos levantar la aplicación y lanzar las operaciones:

** GET http://localhost:8080/game ** 

** GET http://localhost:8080/game?title=xxx **

** GET http://localhost:8080/game?idCategory=xxx **

Nos devuelve un listado filtrado de `Game`. Fíjate bien en la petición donde enviamos los filtros y la respuesta que tiene los objetos `Category` y `Author` incluídos.

![step5-java1](../../assets/images/step5-java1.png)

** PUT http://localhost:8080/game ** 
** PUT http://localhost:8080/game/{id} ** 

```
{
    "title": "Nuevo juego",
    "age": "18",
    "category": {
        "id": 3
    },
    "author": {
        "id": 1
    }
}
```

Nos sirve para insertar un `Game` nuevo (si no tienen el id informado) o para actualizar un `Game` (si tienen el id informado). Fíjate que para enlazar `Category` y `Author` tan solo hace falta el id de cada no de ellos, ya que en el método `save` se hace una consulta `get` para recuperarlos por su id. Además que no tendría sentido enviar toda la información de esas entidades ya que no estás dando de alta una `Category` ni un `Author`.

![step5-java2](../../assets/images/step5-java2.png)
![step5-java3](../../assets/images/step5-java3.png)


!!! tip "Rendimiento en las consultas JPA"
    En este punto te recomiendo que visites el [Anexo. Funcionamiento JPA](../../appendix/jpa.md) para conocer un poco más como funciona por dentro JPA y algún pequeño truco que puede mejorar el rendimiento.



## Implementar listado Autores

Antes de poder conectar front con back, si recuerdas, en la edición de un `Game`, nos hacía falta un listado de `Author` y un listado de `Category`. El segundo ya lo tenemos ya que lo reutilizaremos del listado de categorías que implementamos. Pero el primero no lo tenemos, porque en la pantalla que hicimos, se mostraban de forma paginada. 

Así que necesitamos implementar esa funcionalidad, y como siempre vamos de la capa de testing hacia las siguientes capas. Deberíamos añadir los siguientes métodos:


=== "AuthorIT.java"
    ``` Java
    ...

    ParameterizedTypeReference<List<AuthorDto>> responseTypeList = new ParameterizedTypeReference<List<AuthorDto>>(){};
    
    @Test
    public void findAllShouldReturnAllAuthor() {
    
          ResponseEntity<List<AuthorDto>> response = restTemplate.exchange(LOCALHOST + port + SERVICE_PATH, HttpMethod.GET, null, responseTypeList);
    
          assertNotNull(response);
          assertEquals(TOTAL_AUTHORS, response.getBody().size());
    }

    ...
    ```
=== "AuthorController.java"
    ``` Java
    ...

    /**
    * Recupera un listado de autores
    * @return
    */
    @RequestMapping(path = "", method = RequestMethod.GET)
    public List<AuthorDto> findAll() {

        List<Author> authors = this.authorService.findAll();

        return this.beanMapper.mapList(authors, AuthorDto.class);
    }

    ...
    ```
=== "AuthorService.java"
    ``` Java
    ...

    /**
    * Recupera un listado de autores
    * @return
    */
    List<Author> findAll();

    ...
    ```
=== "AuthorServiceImpl.java"
    ``` Java
    ...

    /**
    * {@inheritDoc}
    */
    @Override
    public List<Author> findAll() {

        return (List<Author>) this.authorRepository.findAll();
    }


    ...
    ```
