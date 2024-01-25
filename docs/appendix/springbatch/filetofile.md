# Autor - Spring Batch

Ya tenemos todo configurado del paso anterior asi que proseguimos con el siguiente ejemplo.


## Código

Vamos a implementar un batch para leer un fichero de `Autores` trasformar la nacionalidad del autor a código de region y general un fichero con los datos trasformados. 

### Modelo

En primer lugar, vamos a crear el modelo dentro del package `com.ccsw.tutorialbatch.model` de la misma forma que en el ejemplo anterior.

=== "Author.java"
    ``` Java
    package com.ccsw.tutorialbatch.model;
    
    public class Author {
    
        private String name;
        private String nationality;
    
        public Author() {
        }
    
        public Author(String name, String nationality) {
            this.name = name;
            this.nationality = nationality;
        }
    
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    
        public String getNationality() {
            return nationality;
        }
    
        public void setNationality(String nationality) {
            this.nationality = nationality;
        }
    
        @Override
        public String toString() {
            return "Author [name=" + getName() + ", nationality=" + getNationality() + "]";
        }
    
    }
    ```

### Processor

Posteriormente, emplazamos él `Processor` dentro del package `com.ccsw.tutorialbatch.processor`.

=== "AuthorItemProcessor.java"
    ``` Java
    package com.ccsw.tutorialbatch.processor;
    
    
    import com.ccsw.tutorialbatch.model.Author;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.batch.item.ItemProcessor;
    
    
    public class AuthorItemProcessor implements ItemProcessor<Author, Author> {
    
        private static final Logger LOGGER = LoggerFactory.getLogger(AuthorItemProcessor.class);
    
        @Override
        public Author process(final Author author) {
            String name = author.getName();
            String nationality = author.getNationality().toLowerCase() + "_" + author.getNationality().toUpperCase();
    
            Author transformedAuthor = new Author(name, nationality);
            LOGGER.info("Converting ( {} ) into ( {} )", author, transformedAuthor);
    
            return transformedAuthor;
        }
    }
    ```

De la misma forma que en el caso anterior hemos implementado un `Processor` personalizado, esta clase implementa `ItemProcessor` donde especificamos de qué clase a qué clase se va a realizar la trasformación. 

En nuestro caso, va a ser de `Author` a `Author` donde vamos a implementar la lógica requerida para este caso de uso.


### Reader, Writer, Step y Job

Posteriormente, como en el caso anterior, emplazamos la configuración junto al resto de beans dentro del package `com.ccsw.tutorialbatch.config`.

=== "CategoryBatchConfiguration.java"
    ``` Java
    package com.ccsw.tutorialbatch.config;
    
    
    import com.ccsw.tutorialbatch.model.Author;
    import com.ccsw.tutorialbatch.processor.AuthorItemProcessor;
    import org.springframework.batch.core.Job;
    import org.springframework.batch.core.Step;
    import org.springframework.batch.core.job.builder.JobBuilder;
    import org.springframework.batch.core.launch.support.RunIdIncrementer;
    import org.springframework.batch.core.repository.JobRepository;
    import org.springframework.batch.core.step.builder.StepBuilder;
    import org.springframework.batch.item.file.FlatFileItemReader;
    import org.springframework.batch.item.file.FlatFileItemWriter;
    import org.springframework.batch.item.file.builder.FlatFileItemReaderBuilder;
    import org.springframework.batch.item.file.builder.FlatFileItemWriterBuilder;
    import org.springframework.batch.item.file.mapping.BeanWrapperFieldSetMapper;
    import org.springframework.batch.item.file.transform.PassThroughLineAggregator;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;
    import org.springframework.core.io.ClassPathResource;
    import org.springframework.core.io.FileSystemResource;
    import org.springframework.transaction.PlatformTransactionManager;
    
    @Configuration
    public class AuthorBatchConfiguration {
    
        @Bean
        public FlatFileItemReader<Author> readerAuthor() {
            return new FlatFileItemReaderBuilder<Author>().name("authorItemReader")
                    .resource(new ClassPathResource("author-list.csv"))
                    .delimited()
                    .names(new String[] { "name", "nationality" })
                    .fieldSetMapper(new BeanWrapperFieldSetMapper<>() {{
                        setTargetType(Author.class);
                    }})
                    .build();
        }
    
        @Bean
        public AuthorItemProcessor processorAuthor() {
    
            return new AuthorItemProcessor();
        }
    
        @Bean
        public FlatFileItemWriter<Author> writerAuthor() {
            return  new FlatFileItemWriterBuilder<Author>().name("writerAuthor")
                    .resource(new FileSystemResource("target/test-outputs/author-output.txt"))
                    .lineAggregator(new PassThroughLineAggregator<>())
                    .build();
        }
    
        @Bean
        public Step step1Author(JobRepository jobRepository, PlatformTransactionManager transactionManager) {
            return new StepBuilder("step1Author", jobRepository)
                    .<Author, Author> chunk(10, transactionManager)
                    .reader(readerAuthor())
                    .processor(processorAuthor())
                    .writer(writerAuthor())
                    .build();
        }
    
        @Bean
        public Job jobAuthor(JobRepository jobRepository, Step step1Author) {
            return new JobBuilder("jobAuthor", jobRepository)
                    .incrementer(new RunIdIncrementer())
                    .flow(step1Author)
                    .end()
                    .build();
        }
    
    }
    ```

* **FlatFileItemReader**: Para la ingesta de datos vamos a hacer uso de este `Reader` que nos proporciona Spring Batch. Como se puede observar se le proporciona el fichero a leer y el mapeo a la clase que deseamos. [Aquí](https://docs.spring.io/spring-batch/reference/readers-and-writers/item-reader-writer-implementations.html) el catálogo de Readers que proporciona `Spring Batch`.
* **CategoryItemProcessor**: El bean del `Processor` que hemos creado anteriormente.
* **FlatFileItemWriter**: A diferencia del ejemplo anterior utilizamos `Writer` diferente que en este caso nos ayuda a crear un fichero con los datos deseados. [Aquí](https://docs.spring.io/spring-batch/reference/readers-and-writers/item-reader-writer-implementations.html) el catálogo de Writers que proporciona `Spring Batch`.
* **Step**: La creación del `Step` se realiza mediante él `StepBuilder` al que le definimos el tamaño del `chunk` que es el número de elementos procesados por lote y le asignamos los tres beans creados previamente. En este caso solo vamos a tener un único `Step` pero podríamos tener todos los que quisiéramos.
* **Job**: Finalmente, debemos definir él `Job` que será lo que se ejecute al lanzar nuestro proceso. La creación se hace mediante el builder correspondiente como en el caso anterior. Se asigna el identificador de `Job`, el conjunto de steps, en este caso solo tenemos uno. En este caso no necesitamos un listener, ya que para verificar el resultado podemos ver el archivo generado.


### Fichero Carga

Finalmente, debemos crear el fichero que leeremos con los datos de los autores que deseamos procesar.

=== "author-list.csv"
    ``` CSV
    Alan R. Moon,US
    Vital Lacerda,PT
    Simone Luciani,IT
    Perepau Llistosella,ES
    Michael Kiesling,DE
    Phil Walker-Harding,US
    ```


### Pruebas

Ahora ya tenemos dos `Jobs` en nuestro batch por lo que debemos especificar en el arranque cual queremos ejecutar.

Esto se realiza pasando una `VM option` en el arranque de la aplicación:
```
-Dspring.batch.job.name=jobAuthor
```
ó
```
-Dspring.batch.job.name=jobCtegory
```

Hecho esto y ejecutado el batch, podremos ver la traza de la ejecución en nuestro `log` y el fichero generado en el `target` del proyecto:

=== "author-output.txt"
    ``` txt
    Author [name=Alan R. Moon, nationality=us_US]
    Author [name=Vital Lacerda, nationality=pt_PT]
    Author [name=Simone Luciani, nationality=it_IT]
    Author [name=Perepau Llistosella, nationality=es_ES]
    Author [name=Michael Kiesling, nationality=de_DE]
    Author [name=Phil Walker-Harding, nationality=us_US]
    ```