# Desarrollo con Springboot

Ahora que ya tenemos listo tanto el proyecto back de SpringBoot (en el puerto 8080) como el proyecto front de Angular (en el puerto 4200), ya podemos empezar a codificar la solución.

Durante todo el tutorial vamos a intentar separar completamente la implementación de front de la implementación de back, para que quede claro como se debe realizar en cada una de las tecnologías.

## Primeros pasos

!!! success "Antes de empezar"
    Quiero hacer hincapié en Springboot tiene una documentación muy extensa y completa, así que te recomiendo que hagas uso de ella cuando tengas cualquier duda. Tanto la propia web de [Spring](https://spring.io/projects/spring-boot) como en el portal de tutoriales de [Baeldung](https://www.baeldung.com/spring-tutorial) puedes buscar casi cualquier ejemplo que necesites.

Si has seguido el tutorial, en la creación del proyecto tenías la posibilidad de crear un proyecto Springboot simple o descargarte una plantilla ya creada. 

@TODO RELLENAR ESTO


## Estructurar el código

Vamos a hacer un breve refresco de la estructura del código que ya se ha visto en puntos anteriores.

Las clases deben estar agrupadas por ámbito funcional, en nuestro caso como vamos a hacer la funcionalidad de `Categorías` pues debería estar todo dentro de un package del tipo `com.capgemini.ccsw.tutorial.category`.

Además, deberíamos aplicar la separación por capas como ya se vió en el esquema:

![estructura-capas](../assets/images/estructura-capas.png)

La primera capa, la de `Controlador`, se encargará de procesar las peticiones y transformar datos. Esta capa llamará a la capa de `Lógica` de negocio que ejecutará las operaciones, ayudándose de otros objetos de esa misma capa de `Lógica` o bien de llamadas a datos a través de la capa de `Acceso a Datos`

Ahora sí, vamos a programar!.

## Capa de operaciones: Controller

En esta capa es donde se definen las operaciones que pueden ser consumidas por los clientes. Se caracterizan por estar anotadas con las anotaciones @Controller o @RestController y por las anotaciones @RequestMapping que nos permiten definir las rutas de acceso.

!!! tip "Recomendación: Breve detalle REST"
    Antes de continuar te recomiendo encarecidamente que leas el [Anexo: Detalle REST](../appendix/rest.md) donde se explica brevemente como estructurar los servicios REST que veremos a continuación.



### Controller de ejemplo

Vamos a crear una clase `CategoryController.java` dentro del package `com.capgemini.ccsw.tutorial.category` para definir las rutas de las operaciones.

=== "CategoryController.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;

    /**
    * @author ccsw
    */
    @RequestMapping(value = "/category")
    @RestController
    public class CategoryController {

      /**
      * Método para recuperar todas las Category
      * @return
      */
      @RequestMapping(path = "", method = RequestMethod.GET)
      public String prueba() {

        return "Probando el Controller";
      }

    }
    ```

Ahora si arrancamos la aplicación server, abrimos el [Postman](https://www.postman.com/) y creamos una petición GET a la url http://localhost:8080/category nos responderá con el mensaje que hemos programado.



### Implementar operaciones

Ahora que ya tenemos un controlador y una operacion de negocio ficticia, vamos a borrarla y añadir las operaciones reales que consumirá nuestra pantalla. Deberemos añadir una operación para listar, una para actualizar, una para guardar y una para borrar. Aunque para hacerlo más cómodo, utilizaremos la misma operación para guardar y para actualizar. Además, no vamos a trabajar directamente con datos simples, sino que usaremos objetos para recibir información y para enviar información.

Estos objetos típicamente se denominan DTO (Data Transfer Object) y nos sirven justamente para encapsular información que queremos transportar. En realidad no son más que clases *pojo* sencillas con propiedades, getters y setters. 

Para nuestro ejemplo crearemos una clase `CategoryDto` dentro del package `com.capgemini.ccsw.tutorial.category.model` con el siguiente contenido:

=== "CategoryDto.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category.model;

    /**
    * @author ccsw
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

A continuación utilizaremos esta clase en nuestro Controller para implementar las tres operaciones de negocio.

=== "CategoryController.java"
  ``` Java
  package com.capgemini.ccsw.tutorial.category;

  import java.util.ArrayList;
  import java.util.HashMap;
  import java.util.List;
  import java.util.Map;

  import org.springframework.web.bind.annotation.PathVariable;
  import org.springframework.web.bind.annotation.RequestBody;
  import org.springframework.web.bind.annotation.RequestMapping;
  import org.springframework.web.bind.annotation.RequestMethod;
  import org.springframework.web.bind.annotation.RestController;

  import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

  /**
  * @author ccsw
  */
  @RequestMapping(value = "/category")
  @RestController
  public class CategoryController {

    private long SEQUENCE = 1;
    private Map<Long, CategoryDto> categories = new HashMap<Long, CategoryDto>();

    /**
    * Método para recuperar todas las Category
    * @return
    */
    @RequestMapping(path = "", method = RequestMethod.GET)
    public List<CategoryDto> findAll() {

        return new ArrayList(this.categories.values());
    }

    /**
    * Método para crear o actualizar una Category
    * @param id
    * @param dto
    * @return
    */
    @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
    public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody CategoryDto dto) {

        CategoryDto category;

        if (id == null) {
          category = new CategoryDto();
          category.setId(this.SEQUENCE++);
          this.categories.put(category.getId(), category);
        } 
        else {
          category = this.categories.get(id);
        }

        category.setName(dto.getName());
    }

    /**
    * Método para borrar una Category
    * @param id
    */
    @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
    public void delete(@PathVariable("id") Long id) {

        this.categories.remove(id);
    }
  }
  ```

Como todavía no tenemos acceso a BD, hemos creado una variable tipo HashMap y una variable Long, que simularán una BD y una secuencia. También hemos implementado tres operaciones GET, PUT y DELETE que realizan las acciones necesarias por nuestra pantalla. Ahora podríamos probarlo desde el Postman con cuatro ejemplo sencillos.

Fíjate que el método `save` tiene dos rutas. La ruta normal `category/` y la ruta informada `category/3`. Esto es porque hemos juntado la acción create y update en un mismo método para facilitar el desarrollo. Es totalmente válido y funcional.


!!! tip "Atención"
    Los datos que se reciben pueden venir informados como un parámetro en la URL Get, como una variable en el propio path o dentro del body de la petición. Cada uno de ellos se recupera con una anotación especial: `@RequestParam`, `@PathVariable` y `@RequestBody` respectivamente.

**GET /category** nos devuelve un listado de `Categorías`

![step2-java1](../assets/images/step2-java1.png)

**PUT /category** nos sirve para insertar `Categorías` nuevas (si no tienen el id informado) o para actualizar `Categorías` (si tienen el id informado). Fíjate que los datos que se envían están en el body como formato JSON (parte izquierda de la imagen). Si no envías datos, te dará un error.

![step2-java2](../assets/images/step2-java2.png)
![step2-java3](../assets/images/step2-java3.png)

**DELETE /category** nos sirve eliminar `Categorías`. Fíjate que el dato del ID que se envía está en el path.

![step2-java4](../assets/images/step2-java4.png)


Prueba a jugar borrando categorías que no existen o modificando categorías que no existen. Tal y como está programado, el borrado no dará error, pero la modificación debería dar un NullPointerException al no existir el dato a modificar.


### Aspectos importantes

Los aspectos importantes de la capa `Controller` son:

* La clase debe estar anotada con `@Controller` o `@RestController`. Mejor usar la última anotación ya que estás diciendo que las operaciones son de tipo Rest y no hará falta configurar nada
* La ruta general al controlador se define con el `@RequestMapping` global de la clase, aunque también se puede obviar esta anotación y añadir a cada una de las operaciones la ruta raíz.
* Los métodos que queramos exponer como operaciones deben ir anotados también con `@RequestMapping` con la info:
    * `path` → Que nos permite definir un path para la operación, siempre sumándole el path de la clase (si es que tuviera)
    * `method` → Que nos permite definir el verbo de http que vamos a atender. Podemos tener el mismo path con diferente method, sin problema. Por lo general utilizaremos:
        * *GET* → Generalmente se usa para recuperar información
        * *POST* → Se utiliza para hacer update y filtrados complejos de información
        * *PUT* → Se utiliza para hacer save de información
        * *DELETE* → Se utiliza para hacer borrados de información

## Capa de Servicio: Service

Pero en realidad la cosa no funciona así. Hemos implementado parte de la lógica de negocio (las operaciones/acciones de guardado, borrado y listado) dentro de lo que sería la capa de operaciones o servicios al cliente. Esta capa no debe ejecutar lógica de negocio, tan solo debe hacer transformaciones de datos y enrutar peticiones, toda la lógica debería ir en la capa de servicio.

### Implementar servicios

Pues vamos a arreglarlo. Vamos a crear un servicio y vamos a mover la lógica de negocio al servicio.

=== "CategoryService.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
    *
    */
    public interface CategoryService {

      /**
      * Método para recuperar todas las Category
      * @return
      */
      List<CategoryDto> findAll();

      /**
      * Método para crear o actualizar una Category
      * @param dto
      * @return
      */
      void save(Long id, CategoryDto dto);

      /**
      * Método para borrar una Category
      * @param id
      */
      void delete(Long id);
    }
    ```
=== "CategoryServiceImpl.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import java.util.ArrayList;
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;

    import org.springframework.stereotype.Service;

    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
    *
    */
    @Service
    public class CategoryServiceImpl implements CategoryService {
      private long SEQUENCE = 1;

      private Map<Long, CategoryDto> categories = new HashMap<Long, CategoryDto>();

      /**
      * Método para recuperar todas las Category
      * @return
      */
      public List<CategoryDto> findAll() {

        return new ArrayList(this.categories.values());
      }

      /**
      * Método para crear o actualizar una Category
      * @param dto
      * @return
      */
      public void save(Long id, CategoryDto dto) {

        CategoryDto category;

        if (id == null) {
          category = new CategoryDto();
          category.setId(this.SEQUENCE++);
          this.categories.put(category.getId(), category);
        } else {
          category = this.categories.get(id);
        }

        category.setName(dto.getName());
      }

      /**
      * Método para borrar una Category
      * @param id
      */
      public void delete(Long id) {

        this.categories.remove(id);
      }
    }
    ```
=== "CategoryController.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;

    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
    */
    @RequestMapping(value = "/category")
    @RestController
    public class CategoryController {

      @Autowired
      private CategoryService categoryService;

      /**
      * Método para recuperar todas las Category
      * @return
      */
      @RequestMapping(path = "", method = RequestMethod.GET)
      public List<CategoryDto> findAll() {

        return this.categoryService.findAll();
      }

      /**
      * Método para crear o actualizar una Category
      * @param dto
      * @return
      */
      @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
      public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody CategoryDto dto) {

        this.categoryService.save(id, dto);
      }

      /**
      * Método para borrar una Category
      * @param id
      */
      @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
      public void delete(@PathVariable("id") Long id) {

        this.categoryService.delete(id);
      }
    }
    ```

Ahora ya tenemos bien estructurado nuestro proyecto. Ya tenemos las dos capas necesarias Controladores y Servicios y cada uno se encarga de llevar a cabo su cometido de forma correcta.


### Aspectos importantes

Los aspectos importantes de la capa `Service` son:

* Toda la lógica de negocio, operaciones y demás debe estar implementada en los servicios. Los controladores simplemente invocan servicios y transforman ciertos datos.
* Es buena práctica que la capa de servicios se implemente usando el patrón fachada, esto quiere decir que necesitamos tener una Interface y al menos una implementación de esa Interface. Y siempre siempre debemos interactuar con la Interface. Esto nos permitirá a futuro poder sustituir la implementación por otra diferente sin que el resto del código se vea afectado. Especialmente útil cuando queremos mockear comportamientos en tests.
* La capa de servicio puede invocar a otros servicios en sus operaciones, pero **nunca** debe invocar a un controlador.
* Para crear un servicio se debe anotar mediante `@Service` y además debe implementar la Interface del servicio. Un error muy común al arrancar un proyecto y ver que no funcionan las llamadas, es porqué no existe la anotación `@Service` o porqué no se ha implementado la Interface.
* La forma de `inyectar` y utilizar componentes manejados por Springboot es mediante la anotación `@Autowired`. **NO** intentes crear un objeto de CategoryServiceImpl, ni hacer un `new`, ya que no estará manejado por Springboot y dará fallos de NullPointer. Lo mejor es dejar que Springboot lo gestione y utilizar las inyecciones de dependencias.


## Capa de Datos: Repository

Pero no siempre vamos a acceder a los datos mediante un HasMap en memoria. En algunas ocasiones queremos que nuestro proyecto acceda a un servicio de datos como puede ser una BBDD, un servicio externo, un acceso a disco, etc.
Estos accesos se deben hacer desde la capa de acceso a datos, y en concreto para nuestro ejemplo, lo haremos a través de un Repository para que acceda a una BBDD.

### Creación de BBDD

Para el tutorial no necesitamos configurar una BBDD externa ni complicarnos demasiado. Vamos a utilizar una librería muy útil llamada `H2` que nos permite levantar una BBDD en memoria persistiendo los datos en memoria o en disco.

Para esto, si te acuerdas de cuando creamos la aplicación, existen unos ficheros que se encuentran dentro de la carpeta `src/main/resources/` y que nos permiten ir depositando scripts versionados para que se ejecuten en orden una vez se levante la aplicación. Vamos a crear los nuestros:

=== "schema.sql"
    ``` SQL
    DROP TABLE IF EXISTS CATEGORY;

    CREATE TABLE CATEGORY (
      id BIGINT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(250) NOT NULL
    );
    ```
=== "data.sql"
    ``` SQL
    INSERT INTO CATEGORY(id, name) VALUES (1, 'Eurogames');
    INSERT INTO CATEGORY(id, name) VALUES (2, 'Ameritrash');
    INSERT INTO CATEGORY(id, name) VALUES (3, 'Familiar');
    ```


### Implementar Entity

Una vez creada la BBDD el siguiente paso es crear la entidad con la que vamos a persistir y recuperar información. Las entidades igual que los DTOs deberían estar agrupados dentro del package `model` de cada funcionalidad, así que vamos a crear una nueva clase java.

=== "Category.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category.model;

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
    @Table(name = "Category")
    public class Category {

      @Id
      @GeneratedValue(strategy = GenerationType.AUTO)
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

Si te fijas, la Entity suele ser muy similar a un DTO, tiene unas propiedades y sus getters y setters. Pero a diferencia de los DTOs, esta clase tiene una serie de anotaciones que permiten a JPA hacer su magia y generar consultas SQL a la BBDD. En este ejemplo vemos 4 anotaciones importantes:

* `@Entity` → Le indica a Springboot que se trata de una clase que implementa una Entidad de BBDD. Sin esta anotación no es posible hacer queries.
* `@Table` → Le indica a JPA el nombre y el schema de la tabla que representa esta clase. Por claridad se debería poner siempre, aunque si el nombre de la tabla es igual al nombre de la clase no es necesaria la anotación.
* `@Id` y `@GeneratedValue` → Le indica a JPA que esta propiedad es la que mapea una Primary Key y además que esta PK se genera con la estrategia que se le indique en la anotación `@GeneratedValue`, que puede ser:
    * Generación de PK por `Secuence`, la que utiliza Oracle, en este caso habrá que indicarle un nombre de secuencia.
    * Generación de PK por `Indentity`, la que utiliza MySql o SQLServer, el auto-incremental. 
    * Generación de PK por `Table`, en algunas BBDD se permite tener una tabla donde se almacenan como registros todas las secuencias.
    * Generación de PK `Auto`, elige la mejor estrategia en función de la BBDD que hemos seleccionado.
* `@Column` → Le indica a JPA que esta propiedad mapea una columna de la tabla y le especifica el nombre de la columna. Al igual que la anotaciónd de `Table`, esta anotación no es necesaria aunque si es muy recomendable. Por claridad se debería poner siempre, aunque si el nombre de la columna es igual al nombre de la propiedad no es necesaria la anotación.

Hay muchas otras anotaciones, pero estas son las básicas, ya irás aprendiendo otras.

!!! tip "Consejo"
    Para definir las PK de las tablas, intenta evitar una PK compuesta de más de una columna. La programación se hace muy compleja y las magias que hace JPA en la oscuridad se complican mucho. Mi recomendación es que siempre utilices una PK númerica, en la medida de lo posible, y si es necesario, crees índices compuestos de búsqueda o checks compuestos para evitar duplicidades.

### Implementar Repository

Ahora que ya tenemos la entidad implementada, vamos a utilizarla para acceder a BBDD, y esto lo haremos con un `Repository`. Existen varias formas de utilizar los repositories, desde el todo automático y magia de JPA hasta el repositorio manual en el que hay que codificar todo. En el tutorial voy a explicar varias formas de implementarlo para este CRUD y los siguientes CRUDs.

Como ya se dijo en puntos anteriores, el acceso a datos se debe hacer siempre a través de un `Repository`, así que vamos a implementar uno. En esta capa, al igual que pasaba con los services, es recomendable utilizar el patrón fachada, para poder sustituir implementaciones sin afectar al código.

=== "CategoryRepository.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import org.springframework.data.repository.CrudRepository;

    import com.capgemini.ccsw.tutorial.category.model.Category;

    /**
    * @author ccsw
    */
    public interface CategoryRepository extends CrudRepository<Category, Long> {

    }
    ```

¿Que te parece?, sencillo, ¿no?. Spring ya tiene una implementación por defecto de un CrudRepository, tan solo tenemos que crear una interface que extienda de la interface `CrudRepository` pasandole como tipos la `Entity` y el tipo de la Primary Key. Con eso Spring construye el resto y nos provee de los métodos típicos y necesarios para un CRUD.

Ahora vamos a utilizarla en el `Service`, pero hay un problema. El `Repository` devuelve un objeto tipo `Category` y el `Service` y `Controller` devuelven un objeto tipo `CategoryDto`. Esto es porque en cada capa se debe con un ámbito de modelos diferente. Podríamos hacer que todo el back trabajara con `Category` que son entidades de persistencia, pero no es lo correcto y nos podría llevar a cometer errores, o modificar el objeto y que sin que nosotros lo ordenásemos se persistiera ese cambio en BBDD.

El ámbito de trabajo  de las capas con el que solemos trabajar y está más extendido es el siguiente:

![step2-java5](../assets/images/step2-java5.png)

* Los datos que vienen y van al cliente, deberían ser en la mayoría de los casos datos en formato json
* Al entrar en un `Controller` esos datos json se transforman en un DTO. Al salir del `Controller` hacia el cliente, esos DTOs se transforman en formato json. Estas conversiones son automáticas, las hace Springboot (en realidad las hace la librería de jackson codehaus).
* Cuando un `Controller` ejecuta una llamada a un `Service`, generalmente le pasa sus datos en DTO, y el `Service` se encarga de transformar esto a una `Entity`. A la inversa, cuando un `Service` responde a un `Controller`, él responde con una `Entity` y el `Controller` ya se encargará de transformarlo a DTO.
* Por último, para los `Repository`, siempre se trabaja de entrada y salida con objetos tipo `Entity`

Parece un lio, pero ya verás como es muy sencillo ahora que veremos el ejemplo. Una última cosa, para hacer esas transformaciones, las podemos hacer a mano usando getters y setters o bien utilizar el objeto `BeanMapper` que hemos configurado al principio como utilidad de Devonfw.

El código debería quedar así:

=== "CategoryServiceImpl.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.capgemini.ccsw.tutorial.category.model.Category;
    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

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
          categoria = this.categoryRepository.findById(id).orElse(null);

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
=== "CategoryService.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

    import com.capgemini.ccsw.tutorial.category.model.Category;
    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

    /**
    * @author ccsw
    *
    */
    public interface CategoryService {

      /**
      * Método para recuperar todas las {@link com.capgemini.ccsw.tutorial.category.model.Category}
      * @return
      */
      List<Category> findAll();

      /**
      * Método para crear o actualizar una {@link com.capgemini.ccsw.tutorial.category.model.Category}
      * @param dto
      * @return
      */
      void save(Long id, CategoryDto dto);

      /**
      * Método para borrar una {@link com.capgemini.ccsw.tutorial.category.model.Category}
      * @param id
      */
      void delete(Long id);
    }
    ```
=== "CategoryController.java"
    ``` Java hl_lines="26 35"
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;

    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;
    import com.devonfw.module.beanmapping.common.api.BeanMapper;

    /**
    * @author ccsw
    */
    @RequestMapping(value = "/category")
    @RestController
    public class CategoryController {

      @Autowired
      CategoryService categoryService;

      @Autowired
      BeanMapper beanMapper;

      /**
      * Método para recuperar todas las {@link com.capgemini.ccsw.tutorial.category.model.Category}
      * @return
      */
      @RequestMapping(path = "", method = RequestMethod.GET)
      public List<CategoryDto> findAll() {

        return this.beanMapper.mapList(this.categoryService.findAll(), CategoryDto.class);
      }

      /**
      * Método para crear o actualizar una {@link com.capgemini.ccsw.tutorial.category.model.Category}
      * @param dto
      * @return
      */
      @RequestMapping(path = { "", "/{id}" }, method = RequestMethod.PUT)
      public void save(@PathVariable(name = "id", required = false) Long id, @RequestBody CategoryDto dto) {

        this.categoryService.save(id, dto);
      }

      /**
      * Método para borrar una {@link com.capgemini.ccsw.tutorial.category.model.Category}
      * @param id
      */
      @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
      public void delete(@PathVariable("id") Long id) {

        this.categoryService.delete(id);

      }
    }
    ```

El `Service` no tiene nada raro, simplemente accede al `Repository` (siempre anotado como `@Autowired`) y recupera datos o los guarda. Fíjate en el caso especial del save que la única diferencia es que en un caso tendrá id != null y por tanto internamente hará un update, y en otro caso tendrá id == null y por tanto internamente hará un save.

En cuanto a la interface, lo único que cambiamos fue los objetos de respuesta, que ahora pasan a ser de tipo `Category`. Los de entrada se mantienen como `CategoryDto`.

Por último, en el `Controller` se puede ver como se utiliza el conversor de `BeanMapper` (siempre anotado como `@Autowired`), que permite traducir una lista a un tipo concreto, o un objeto único a un tipo concreto. La forma de hacer estas conversiones siempre es por nombre de propiedad. Las propiedades del objeto destino se deben llamar igual que las propiedades del objeto origen. En caso contrario se quedarán a null.

### Aspectos importantes

Los aspectos importantes de la capa `Repository` son:

* Al igual que los `Service`, se debe utilizar el patrón fachada, por lo que tendremos una Interface y posiblemente una implementación.
* A menudo la implementación la hace internamente Springboot, pero hay veces que podemos hacer una implementación manual. Lo veremos en siguientes puntos.
* Los `Repository` trabajan siempre con `Entity` que no son más que mapeos de una tabla o de una vista que existe en BBDD.
* Los `Repository` no contienen lógica de negocio, ni transformaciones, simplemente acceder a datos, persisten o devuelven información.
* Los `Repository` **JAMÁS** deben llamar a otros `Repository` ni `Service`.
* Intenta que tus clases `Entity` sean lo más sencillas posible, sobre todo en cuanto a Primary Keys, se simplificará mucho el desarrollo.

## Capa de Testing: TDD

Por último y aunque no es lo último que se desarrolla sino todo lo contrario, debería ser lo primero en desarrollar, tenemos la batería de pruebas.
Hemos hecho desarrollado este primer caso de uso con una ordenación peculiar con fines didácticos, pero en realidad deberíamos ir aplicando [TDD (Test Driven Development)](../appendix/tdd.md) para el desarrollo. Si quieres aprender las reglas básicas de como aplicar TDD al desarrollo diario, te recomiendo que leas el [Anexo. TDD](../appendix/tdd.md).

En este caso, y sin que sirva de precedente, ya tenemos implementados los métodos de la aplicación, y ahora vamos a testearlos. Existen muchas formas de testing en función del componente o la capa que yo quiera testear. En realidad, a medida que vayas programando irás aprendiendo todas ellas, de momento me sirve con que hagas un test simple que pruebe las casuísticas de los métodos.

Lo primero será conocer que queremos probar y para ello nos vamos a hacer una lista:

* Pruebas de listado, debe recuperar los elementos de la tabla `Categoría`
* Prueba de creación, debe crear una nueva `Categoría`
* Prueba de modificación correcta, debe modificar una `Categoría` existente
* Prueba de modificación incorrecta, debe dar error al modificar una `Categoría` que no existe
* Prueba de borrado correcta, debe borrar una `Categoría` existente
* Prueba de borrado incorrecta, debe dar error al borrar una `Categoría` que no existe

Se podrían hacer muchos más tests, pero creo que con esos son suficientes para que entiendas como se comporta esta capa. Si te fijas, hay que probar tanto los resultados correctos como los resultados incorrectos. El usuario no siempre se va a comportar como nosotros pensamos.

Pues vamos a ello.

### Pruebas de listado

Vamos a empezar haciendo una clase de test dentro de la carpeta `src/test/java`. No queremos que los test formen parte del código productivo de la aplicación, por eso utilizamos esa ruta que queda fuera del package general de la aplicación.

Crearemos la clase `com.capgemini.ccsw.tutorial.category.CategoryTest`.

=== "CategoryTest.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.transaction.annotation.Transactional;

    /**
    * @author ccsw
    */
    @SpringBootTest
    @Transactional
    public class CategoryTest {

    }
    ```

Esta clase es sencilla y tan solo tiene dos anotaciones de Springboot:

* `@SpringBootTest`. Esta anotación lo que hace es inicializar el contexto de Spring cada vez que se inician los test de jUnit. Aunque el contexto tarda unos segundos en arrancar, lo bueno que tiene es que solo se inicializa una vez y se lanzan todos los jUnits en batería con el mismo contexto.
* `@Transactional`. Esta anotación le indica a Spring que los test van a ser transaccionales, y por tanto cuando termine la ejecución de cada uno de los test, automáticamente por la anotación de arriba, Spring hará un rollback y dejará el estado de la BBDD como estaba inicialmente.

También nos faltará configurar la aplicación de test al igual que hicimos con la aplicación 'productiva'. Deberemos abrir el fichero `src/test/resources/application.properties` y añadir la configuración de la BBDD. Para este tutorial vamos a utilizar la misma BBDD que la aplicación productiva, pero de normal la aplicación se conectará a una BBDD, generalmente física, mientras que los test jUnit se conectarán a otra BBDD, generalmente en memoria.

=== "application.properties"
    ``` properties
    #Database
    spring.jpa.hibernate.ddl-auto=none
    spring.datasource.driver-class-name=org.h2.Driver
    spring.datasource.url=jdbc:h2:mem:test;mode=mysql
    spring.datasource.username=sa
    spring.datasource.password=sa
    spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
    ```

Con todo esto ya podemos crear nuestro primer test. Iremos a la clase `CategoryTest` y añadiremos un método público. Los test siempre tienen que ser métodos públicos que devuelvan el tipo `void`.


=== "CategoryTest.java"
    ``` Java hl_lines="3 4 6 8 9 13 19 20 22-34"
    package com.capgemini.ccsw.tutorial.category;

    import static org.junit.jupiter.api.Assertions.assertEquals;
    import static org.junit.jupiter.api.Assertions.assertNotNull;

    import java.util.List;

    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.transaction.annotation.Transactional;

    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

    @SpringBootTest
    @Transactional
    public class CategoryTest {

      @Autowired
      private CategoryController categoryController;

      @Test
      public void findAllShouldReturnAllCategoriesInDB() {

          assertNotNull(categoryController);

          long categoriesSize = 3;

          List<CategoryDto> categories = categoryController.findAll();

          assertNotNull(categories);
          assertEquals(categoriesSize, categories.size());

      }

    }
    ```

Es muy importante marcar cada método de prueba con la anotación `@Test`, en caso contrario no se ejecutará. Lo que se debe hacer en cada método que implementemos es probar **una y solo una** acción. En el ejemplo anterior, hemos probado que llamando al método findAll() comprobamos que realmente nos devuelve 3 resultados, que son los que hay en BBDD inicialmente.

!!! tip "Muy importante: Nomenclatura de los tests"
    La nomenclatura de los métodos de test debe sigue una estructura determinada. Hay muchas formas de nombrar a los métodos, pero nosotros solemos utilizar la estructura 'should', para indicar lo que va a hacer. En el ejemplo anterior el método 'findAll' debe devolver 'AllCategoriesInDB'. De esta forma sabemos cual es la intención del test, y si por cualquier motivo diera un fallo, sabemos que es lo que NO está funcionando de nuestra aplicación.

Para comprobar que el test funciona, podemos darle botón derecho sobre la clase de `CategoryTest` y pulsar en `Run as` -> `JUnit Test`. Si todo funciona correctamente, deberá aparecer una pantalla de ejecución y todos nuestros tests (en este caso solo uno) corriendo correctamente (en verde).

![step2-java6](../assets/images/step2-java6.png)


### Pruebas de creación

Vamos con los siguientes test, los que probarán una creación de una nueva `Categoría`. Añadimos el siguiente método a la clase de test:


=== "CategoryTest.java"
    ``` Java

    @Test
    public void saveWithoutIdShouldCreateNewCategory() {

        assertNotNull(categoryController);

        String newCategoryName = "Nueva Categoria";
        long newCategoryId = 4;
        long newCategoriesSize = newCategoryId;

        CategoryDto dto = new CategoryDto();
        dto.setName(newCategoryName);

        categoryController.save(null, dto);

        List<CategoryDto> categories = categoryController.findAll();
        assertNotNull(categories);
        assertEquals(newCategoriesSize, categories.size());

        CategoryDto categorySearch = categories.stream().filter(item -> item.getId().equals(newCategoryId)).findFirst().orElse(null);
        assertNotNull(categorySearch);
        assertEquals(newCategoryName, categorySearch.getName());

    }
    ```

En este caso, estamos construyendo un objeto `CategoryDto` para darle un nombre a la `Categoría` e invocamos al método `save` pasandole un ID a nulo.
Seguidamente, recuperamos de nuevo la lista de categorías y en este caso debería tener 4 resultados. Hacemos un filtrado buscando la nueva `Categoría` que debería tener un ID = 4 y debería ser la que acabamos de crear. 

Si ejecutamos, veremos que ambos test ahora aparecen en verde.


### Pruebas de modificación

Para este caso de prueba, vamos a realizar dos test, como hemos comentado anteriormente. Tenemos que probar que es lo que pasa cuando intentamos modificar un elemento que existe pero también debemos probar que es lo que pasa cuando intentamos modificar un elemento que **no** existe.

Empezamos con el sencillo, un test que pruebe una modificación existente.


=== "CategoryTest.java"
    ``` Java

    @Test
    public void modifyWithExistsIdShouldModifyCategory() {

        assertNotNull(categoryController);

        String newCategoryName = "Nueva Categoria";
        long categoryId = 3;
        long categoriesSize = 3;

        CategoryDto dto = new CategoryDto();
        dto.setName(newCategoryName);

        categoryController.save(categoryId, dto);

        List<CategoryDto> categories = categoryController.findAll();
        assertNotNull(categories);
        assertEquals(categoriesSize, categories.size());

        CategoryDto categorySearch = categories.stream().filter(item -> item.getId().equals(categoryId)).findFirst().orElse(null);
        assertNotNull(categorySearch);
        assertEquals(newCategoryName, categorySearch.getName());

    }
    ```

La misma filosofía que en el test anterior pero esta vez modificamos la `Categoría` de ID = 3. Luego la filtramos y vemos que realmente se ha modificado. Además comprobamos que el listado de todas los registros sigue siengo 3 y no se ha creado un nuevo registro.

En el siguiente test, probaremos un resultado erróneo. Es un pelín más compleja, pero no mucho.


=== "CategoryTest.java"
    ``` Java

    @Test
    public void modifyWithNotExistsIdShouldThrowException() {

        assertNotNull(categoryController);

        String newCategoryName = "Nueva Categoria";
        long categoryId = 4;

        CategoryDto dto = new CategoryDto();
        dto.setName(newCategoryName);

        assertThrows(NullPointerException.class, () -> categoryController.save(categoryId, dto));
    }
    ```

Intentamos modificar el ID = 4, que no debería existir en BBDD y por tanto lo que se espera en el test es que lance un `NullPointerException` al llamar al método `save`.


### Pruebas de borrado

Ya por último implementamos las pruebas de borrado.

=== "CategoryTest.java"
    ``` Java

    @Test
    public void deleteWithExistsIdShouldDeleteCategory() {

        assertNotNull(categoryController);

        long newCategoriesSize = 2;
        long deleteCategoryId = 3;

        categoryController.delete(deleteCategoryId);

        List<CategoryDto> categories = categoryController.findAll();

        assertNotNull(categories);
        assertEquals(newCategoriesSize, categories.size());

    }

    @Test
    public void deleteWithNotExistsIdShouldThrowException() {

        assertNotNull(categoryController);

        long deleteCategoryId = 4;

        assertThrows(Exception.class, () -> categoryController.delete(deleteCategoryId));

    }
    ```

En el primer test, se comprueba que el listado tiene un tamaño de 2 (uno menos que el original) y en el segundo test se comprueba que con ID no válido, devuelve una `Exception`.


Con esto tendríamos más o menos probados los casos básicos de nuestra aplicación y tendríamos una pequeña red de seguridad que nos ayudaría por si a futuro necesitamos hacer algún cambio o evolutivo.


## ¿Que hemos aprendido?

Resumiendo un poco los pasos que hemos seguido:

* Hay que definir y agrupar por ámbito funcional, hemos creado el package `com.capgemini.ccsw.tutorial.category` para aglutinar todas las clases.
* Lo primero que debemos empezar a construir **siempre** son los test, aunque en este tutorial lo hemos hecho al revés solo con fines didácticos. En los siguientes puntos lo haremos de forma correcta, y esto nos ayudará a pensar y diseñar que es lo que queremos implementar realmente.
* La implementación de la aplicación se debería separar por capas:
    * `Controller` → Maneja las peticiones de entrada del cliente y realiza transformaciones. No ejecuta directamente lógica de negocio, para eso utiliza llamadas a la siguiente capa.
    * `Service` → Ejecuta la lógica de negocio en sus métodos o llamando a otros objetos de la misma capa. No ejecuta directamente accesos a datos, para eso utiliza la siguiente capa.
    * `Repository` → Realiza los accesos a datos de lectura y escritura. **NUNCA** debe llamar a otros objetos de la misma capa ni de capas anteriores.
* Hay que tener en cuenta los objetos modelo que se mueven en cada capa. Generalmente son:
    * `Json` → Los datos que vienen y van del cliente al `Controller`.
    * `DTO` → Los datos se mueven dentro del `Controller` y sirven para invocar llamadas. También son los datos que devuelve un `Controller`.
    * `Entity` → Los datos que sirven para persistir y leer datos de una BBDD y que **NUNCA** deberían ir más allá del `Controller`.