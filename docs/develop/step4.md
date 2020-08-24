# Desarrollo de un listado paginado

Ya tienes tu primer listado desarrollado, tanto en front como en back. ¿Ha sido sencillo, verdad?.

Ahora vamos a implementar un listado un poco más complejo, este tiene datos paginados en servidor, esto quiere decir que no nos sirve un array de datos como en el anterior ejemplo. 
Un listado paginado en servidor, debe enviar en cada petición que página está mostrando y cual es el tamaño de la página, para que el servidor devuelva un subconjunto de datos.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

## Desarrollo Angular

### Crear componentes

Vamos a desarrollar el listado de `Autores` así que, debemos crear los componentes:

```
ng generate component views/authors
ng generate component views/authors/author-dialog

ng generate service services/authors/author
```

### Crear el modelo 

Creamos el modelo en `models/authors/Author.ts` con las propiedades necesarias para trabajar con la información de un autor:

=== "Author.ts"
    ``` TypeScript
    export class Author {
        id: number;
        name: string;
        nationality: string;
    }
    ```

### Añadir el punto de entrada

Añadimos la ruta al menú para que podamos acceder a la pantalla:

=== "app-routing.module.ts" 
    ``` Typescript hl_lines="9"
    import { NgModule } from '@angular/core';
    import { Routes, RouterModule } from '@angular/router';
    import { CategoriesComponent } from './views/categories/categories.component';
    import { AuthorsComponent } from './views/authors/authors.component';


    const routes: Routes = [
        { path: 'categories', component: CategoriesComponent },
        { path: 'authors', component: AuthorsComponent },
    ];

    @NgModule({
        imports: [RouterModule.forRoot(routes)],
        exports: [RouterModule]
    })
    export class AppRoutingModule { }
    ```

### Implementar servicio

Y realizamos las diferentes implementaciones. Empezaremos por el servicio. En este caso, hay un cambio sustancial con el anterior ejemplo. Al tratarse de un listado paginado, la operación `getAuthors` necesita información extra acerca de que página de datos debe mostrar, además de que el resultado ya no será un listado sino una página. 

Por defecto el esquema de datos de Spring para la paginación es como el siguiente:

=== "Esquema de datos de paginación"
    ``` JSON
    {
        "content": [ ... <listado con los resultados paginados> ... ],
        "pageable": {
            "pageNumber": <número de página empezando por 0>,
            "pageSize": <tamaño de página>,
            "sort": [
                { 
                    "property": <nombre de la propiedad a ordenar>, 
                    "direction": <dirección de la ordenación ASC / DESC> 
                }
            ]
        },
        "totalElements": <numero total de elementos en la tabla>
    }
    ```

Así que necesitamos poder enviar y recuperar esa información desde Angular, nos hace falta crear esos objetos. Los objetos de paginación los crearé en `models/page`, mientras que la paginación de `Author` la crearé en `models/authors`.

=== "SortPage.ts"
    ``` TypeScript
    export class SortPage {
        property: String;
        direction: String;
    }
    ```
=== "Pageable.ts"
    ``` TypeScript
    import { SortPage } from './SortPage';

    export class Pageable {
        pageNumber: number;
        pageSize: number;
        sort: SortPage[];
    }
    ```
=== "AuthorPage.ts"
    ``` TypeScript
    import { Author } from './Author';
    import { Pageable } from '../page/Pageable';

    export class AuthorPage {
        content: Author[];
        pageable: Pageable;
        totalElements: number;
    }
    ```

Con estos objetos creados ya podemos implementar el servicio y sus datos mockeados.

=== "mock-authors.ts"
    ``` TypeScript
    import { AuthorPage } from 'src/app/models/authors/AuthorPage';

    export const AUTHOR_DATA: AuthorPage = {
        content: [
            { id: 1, name: 'Klaus Teuber', nationality: 'Alemania' },
            { id: 2, name: 'Matt Leacock', nationality: 'Estados Unidos' },
            { id: 3, name: 'Keng Leong Yeo', nationality: 'Singapur' },
            { id: 4, name: 'Gil Hova', nationality: 'Estados Unidos'},
            { id: 5, name: 'Kelly Adams', nationality: 'Estados Unidos' },
            { id: 6, name: 'J. Alex Kavern', nationality: 'Estados Unidos' },
            { id: 7, name: 'Corey Young', nationality: 'Estados Unidos' },
        ],  
        pageable : {
            pageSize: 7,
            pageNumber: 0,
            sort: [
                {property: "id", direction: "ASC"}
            ]
        },
        totalElements: 7
    }
    ```
=== "author.service.ts"
    ``` TypeScript
    import { Injectable } from '@angular/core';
    import { Pageable } from 'src/app/models/page/Pageable';
    import { AuthorPage } from 'src/app/models/authors/AuthorPage';
    import { Observable, of } from 'rxjs';
    import { Author } from 'src/app/models/authors/Author';
    import { AUTHOR_DATA } from './mock-authors';

    @Injectable({
        providedIn: 'root'
    })
    export class AuthorService {

        constructor() { }

        getAuthors(pageable: Pageable): Observable<AuthorPage> {
            return of(AUTHOR_DATA);
        }

        saveAuthor(author: Author): Observable<Author> {
            return of(null);
        }

        deleteAuthor(idAuthor : number): Observable<any> {
            return of(null);
        }    
    }
    ```

### Implementar listado

Ya tenemos el servicio con los datos, ahora vamos a por el listado paginado.

=== "authors.component.html"
    ``` HTML hl_lines="36"
    <div class="container">
        <h1>Listado de Autores</h1>

        <mat-table [dataSource]="dataSource"> 
            <ng-container matColumnDef="id">
                <mat-header-cell *matHeaderCellDef> Identificador </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.id}} </mat-cell>
            </ng-container>
            
            <ng-container matColumnDef="name">
                <mat-header-cell *matHeaderCellDef> Nombre autor  </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.name}} </mat-cell>
            </ng-container>

            <ng-container matColumnDef="nationality">
                <mat-header-cell *matHeaderCellDef> Nacionalidad  </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.nationality}} </mat-cell>
            </ng-container>
            
            <ng-container matColumnDef="action">
                <mat-header-cell *matHeaderCellDef></mat-header-cell>
                <mat-cell *matCellDef="let element">
                    <button mat-icon-button color="primary">
                        <mat-icon (click)="editAuthor(element)">edit</mat-icon>
                    </button>
                    <button mat-icon-button color="accent">
                        <mat-icon (click)="deleteAuthor(element)">clear</mat-icon>
                    </button>
                </mat-cell>
            </ng-container>

            <mat-header-row *matHeaderRowDef="displayedColumns; sticky: true"></mat-header-row>
            <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
        </mat-table> 

        <mat-paginator (page)="loadPage($event)" [pageSizeOptions]="[5, 10, 20]" [pageIndex]="pageNumber" [pageSize]="pageSize" [length]="totalElements" showFirstLastButtons></mat-paginator>
    
        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createAuthor()">Nuevo autor</button> 
        </div>   
    </div>
    ```
=== "authors.component.scss"
    ``` CSS
    .container {
        margin: 20px;
    
        mat-table {
            margin-top: 10px;
            margin-bottom: 20px;
        
            .mat-header-row {
                background-color:#f5f5f5;
        
                .mat-header-cell {
                    text-transform: uppercase;
                    font-weight: bold;
                    color: #838383;
                }      
            }
        
            .mat-column-id {
                flex: 0 0 20%;
                justify-content: center;
            }
        
            .mat-column-action {
                flex: 0 0 10%;
                justify-content: center;
            }
        }
        
        .buttons {
            text-align: right;
        }
    }
    ```
=== "authors.component.ts"
    ``` TypeScript hl_lines="17 18 19 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57"
    import { Component, OnInit } from '@angular/core';
    import { MatTableDataSource } from '@angular/material/table';
    import { Author } from 'src/app/models/authors/Author';
    import { MatDialog } from '@angular/material/dialog';
    import { AuthorPage } from 'src/app/models/authors/AuthorPage';
    import { Pageable } from 'src/app/models/page/Pageable';
    import { DialogConfirmationComponent } from 'src/app/shared/dialog-confirmation/dialog-confirmation/dialog-confirmation.component';
    import { AuthorDialogComponent } from './author-dialog/author-dialog.component';

    @Component({
        selector: 'app-authors',
        templateUrl: './authors.component.html',
        styleUrls: ['./authors.component.scss']
    })
    export class AuthorsComponent implements OnInit {

        pageNumber: number = 0;
        pageSize: number = 5;
        totalElements: number = 0;

        dataSource = new MatTableDataSource<Author>();
        displayedColumns: string[] = ['id', 'name', 'nationality', 'action'];

        constructor(
            private authorService: AuthorService,
            public dialog: MatDialog,
        ) { }

        ngOnInit(): void {
            this.loadPage();
        }

        loadPage(event?: PageEvent) {

            let pageable : Pageable =  {
                pageNumber: this.pageSize,
                pageSize: this.pageSize,
                sort: [{
                property: 'id',
                direction: 'ASC'
                }]
            }

            if (event != null) {
                pageable.pageSize = event.pageSize
                pageable.pageNumber = event.pageIndex;
            }

            this.authorService.getAuthors(pageable).subscribe(data => {
                this.dataSource.data = data.content;
                this.pageNumber = data.pageable.pageNumber;
                this.pageSize = data.pageable.pageSize;
                this.totalElements = data.totalElements;
            }
            );

        }  
        
        createAuthor() {      
            const dialogRef = this.dialog.open(AuthorDialogComponent, {
                data: {}
            });

            dialogRef.afterClosed().subscribe(result => {
                this.ngOnInit();
            });      
        }  

        editAuthor(author: Author) {    
            const dialogRef = this.dialog.open(AuthorDialogComponent, {
                data: { author: author }
            });

            dialogRef.afterClosed().subscribe(result => {
                this.ngOnInit();
            });    
        }

        deleteAuthor(author: Author) {    
            const dialogRef = this.dialog.open(DialogConfirmationComponent, {
                data: { title: "Eliminar autor", description: "Atención si borra el autor se perderán sus datos.<br> ¿Desea eliminar el autor?" }
            });

            dialogRef.afterClosed().subscribe(result => {
                if (result) {
                    this.authorService.deleteAuthor(author.id).subscribe(result =>  {
                        this.ngOnInit();
                    }); 
                }
            });
        }  
    }
    ```

Fíjate como hemos añadido la paginación. 

*   Al HTML le hemos añadido un componente nuevo `mat-paginator`, lo que nos va a obligar a añadirlo al módulo también como dependencia. Ese componente le hemos definido un método `page` que se ejecuta cada vez que la página cambia, y unas propiedades con las que calculará la página, el tamaño y el número total de páginas.
*   Al Typescript le hemos tenido que añadir esas variables y hemos creado un método para cargar datos que lo que hace es construir un objeto `pageable` con los valores actuales del componente paginador y lanza la petición con esos datos en el body. Obviamente al ser un mock no funcionará el cambio de página y demás.

Como hemos comentado, añadimos la dependencia al módulo para que todo funcione.

=== "views.module.ts"
    ``` TypeScript hl_lines="14 28"
    import { NgModule } from '@angular/core';
    import { CommonModule } from '@angular/common';
    import { MatTableModule } from '@angular/material/table';
    import { MatIconModule } from '@angular/material/icon';
    import { MatButtonModule } from '@angular/material/button';
    import { CategoriesComponent } from './categories/categories.component';
    import { CategoryDialogComponent } from './categories/category-dialog/category-dialog.component';
    import { MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
    import { MatFormFieldModule } from '@angular/material/form-field';
    import { MatInputModule } from '@angular/material/input';
    import { FormsModule, ReactiveFormsModule } from '@angular/forms';
    import { AuthorsComponent } from './authors/authors.component';
    import { AuthorDialogComponent } from './authors/author-dialog/author-dialog.component';
    import { MatPaginatorModule } from '@angular/material/paginator';

    @NgModule({
    declarations: [CategoriesComponent, CategoryDialogComponent, AuthorsComponent, AuthorDialogComponent],
    imports: [
        CommonModule,
        MatTableModule,
        MatIconModule, 
        MatButtonModule,
        MatDialogModule,
        MatFormFieldModule,
        MatInputModule,
        FormsModule,
        ReactiveFormsModule,
        MatPaginatorModule,
    ],
    providers: [
        {
            provide: MAT_DIALOG_DATA,
            useValue: {},
        },
    ]
    })
    export class ViewsModule { }
    ```

Debería verse algo similar a esto:

![step4-angular1](../assets/images/step4-angular1.png)

### Implementar dialogo edición

El último paso, es definir la pantalla de dialogo que realizará el alta y modificado de los datos de un `Autor`.

=== "author-dialog.component.html"
    ``` HTML
    <div class="container">
        <h1 *ngIf="author.id == null">Crear autor</h1>
        <h1 *ngIf="author.id != null">Modificar autor</h1>

        <form>
            <mat-form-field>
                <mat-label>Identificador</mat-label>
                <input type="number" matInput placeholder="Identificador" [(ngModel)]="author.id" name="id" disabled>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Nombre</mat-label>
                <input type="text" matInput placeholder="Nombre del autor" [(ngModel)]="author.name" name="name" required>
                <mat-error>El nombre no puede estar vacío</mat-error>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Nacionalidad</mat-label>
                <input type="text" matInput placeholder="Nacionalidad del autor" [(ngModel)]="author.nationality" name="nationality" required>
                <mat-error>La nacionalidad no puede estar vacía</mat-error>
            </mat-form-field>
        </form>

        <div class="buttons">
            <button mat-stroked-button (click)="onClose()">Cerrar</button>
            <button mat-flat-button color="primary" (click)="onSave()">Guardar</button>
        </div>
    </div>
    ```
=== "author-dialog.component.scss"
    ``` CSS
    .container {
        min-width: 350px;
        max-width: 500px;
        width: 100%;
    
        form {
            display: flex;
            flex-direction: column;
            margin-bottom:20px;
        }

        .buttons {
        text-align: right;

        button {
            margin-left: 10px;
        }
        }
    }
    ```
=== "author-dialog.component.ts"
    ``` TypeScript
    import { Component, OnInit, Inject } from '@angular/core';
    import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
    import { Author } from 'src/app/models/authors/Author';
    import { AuthorService } from 'src/app/services/authors/author.service';

    @Component({
        selector: 'app-author-dialog',
        templateUrl: './author-dialog.component.html',
        styleUrls: ['./author-dialog.component.scss']
    })
    export class AuthorDialogComponent implements OnInit {

        author : Author;
    
        constructor(
            public dialogRef: MatDialogRef<AuthorDialogComponent>,
            @Inject(MAT_DIALOG_DATA) public data: any,
            private authorService: AuthorService
        ) { }
    
        ngOnInit(): void {
            if (this.data.author != null) {
                this.author = Object.assign({}, this.data.author);
            }
            else {
                this.author = new Author();
            }
        }
    
        onSave() {
            this.authorService.saveAuthor(this.author).subscribe(result =>  {
                this.dialogRef.close();
            }); 
        }  
    
        onClose() {
            this.dialogRef.close();
        }
    
    }
    ```

Que debería quedar algo así:

![step4-angular2](../assets/images/step4-angular2.png)


## Desarrollo Springboot

### Modelos

Lo primero que vamos a hacer es crear los modelos para trabajar con BBDD y con peticiones hacia el front. Además, también tenemos que añadir datos al script de inicialización de BBDD.

=== "V0001__Create_Schema.sql"
    ``` SQL hl_lines="11 13 14 15 16 17"
    CREATE SEQUENCE HIBERNATE_SEQUENCE START WITH 1000000;

    DROP TABLE IF EXISTS CATEGORY;

    CREATE TABLE CATEGORY (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(250) NOT NULL
    );


    DROP TABLE IF EXISTS AUTHOR;

    CREATE TABLE AUTHOR (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(400) NOT NULL,
        nationality VARCHAR(250) NOT NULL
    );
    ```
=== "V0002__Create_Data.sql"
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
    package com.capgemini.coedevon.tutorial.author.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Table;

    /**
    * @author coedevon
    */
    @Entity
    @Table(name = "Author")
    public class Author {

        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
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
    package com.capgemini.coedevon.tutorial.author.model;

    /**
    * @author coedevon
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

### Repository

Para desarrollar todas las operaciones, esta vez vamos a ir de más bajo a más alto nivel. Empezaremos por el acceso a datos, crearemos el Repository.

=== "AuthorRepository.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.author;

    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.Pageable;
    import org.springframework.data.repository.CrudRepository;

    import com.capgemini.coedevon.tutorial.author.model.Author;

    /**
    * @author coedevon
    */
    public interface AuthorRepository extends CrudRepository<Author, Long> {

        /**
        * Método para recuperar un listado paginado de {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param page
        * @return
        */
        Page<Author> findAll(Pageable page);

    }
    ```

Si te fijas, este `Repository` ya no está vacío como el anterior, no nos sirve con las operaciones básicas del `CrudRepository` en este caso tenemos que añadir un método nuevo al que pasandole un objeto de tipo `Pageable` nos devuelva una `Page`.

* El objeto `Pageable` no es más que una interface que le permite a Spring JPA saber que página se quiere buscar, cual es el tamaño de página y cuales son las propiedades de ordenación que se debe lanzar en la consulta.
* El objeto `Page` no es más que un contenedor que engloba la información básica de la página que se está consultando (número de página, tamaño de página, número total de resultados) y el conjunto de datos de la BBDD que contiene esa página una vez han sido buscados y ordenados.

Además, la mágina de Spring JPA hará su trabajo y nosotros no necesitamos implementar ninguna query, Spring ya entiende que un `findAll` significa que debe recuperar todos los datos de la tabla `Author` y además deben estar paginados. Nos ahorra tener que buscar una página concreta de datos y hacer un `count` de la tabla para obtener el total de resultados. Para ver otros ejemplos y más información, visita la página de [QueryMethods](https://www.baeldung.com/spring-data-derived-queries).

### Service

La siguiente capa que vamos a implementar es justamente la capa que hace uso del `Repository`, es decir el `Service`.

=== "AuthorService.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.author;

    import org.springframework.data.domain.Page;

    import com.capgemini.coedevon.tutorial.author.model.Author;
    import com.capgemini.coedevon.tutorial.author.model.AuthorDto;
    import com.capgemini.coedevon.tutorial.author.model.AuthorSearchDto;

    /**
    * @author coedevon
    *
    */
    public interface AuthorService {

        /**
        * Método para recuperar un listado paginado de {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param dto
        * @return
        */
        Page<Author> findPage(AuthorSearchDto dto);

        /**
        * Método para crear o actualizar un {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param data
        * @return
        */
        Author save(AuthorDto data);

        /**
        * Método para crear o actualizar un {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param id
        */
        void delete(Long id);

    }
    ```
=== "AuthorServiceImpl.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.author;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.stereotype.Service;

    import com.capgemini.coedevon.tutorial.author.model.Author;
    import com.capgemini.coedevon.tutorial.author.model.AuthorDto;
    import com.capgemini.coedevon.tutorial.author.model.AuthorSearchDto;

    /**
    * @author coedevon
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
        public Author save(AuthorDto data) {

            Author author = null;
            if (data.getId() != null)
                author = this.authorRepository.findById(data.getId()).orElse(null);
            else
                author = new Author();

            BeanUtils.copyProperties(data, author);

            return this.authorRepository.save(author);
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
=== "AuthorSearchDto.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.author.model;

    import org.springframework.data.domain.Pageable;

    /**
    * @author coedevon
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

En esta capa, si te fijas, ya no devolvemos un `List<Author>`, sino que ahora devolvemos un `Page<Author>` que es el método que hemos añadido al `Repository`. 

Además, hemos creado un objeto nuevo `AuthorSearchDto`, ya que es necesario para realizar la peticion con el objeto `Pageable`.

!!! note "¿Demasiados de DTOs?"
    No tengas miedo en crear muchos DTOs, de hecho la implementación óptima debería tener un DTO de entrada y de otro de salida para cada uno de los métodos del `Controller`. No llegaremos hasta ese extremo y reutilizaremos todo el código que podamos, pero no pasa nada si creas 3, 4 o incluso 10 DTOs si realmente los necesitas.



### Controller

Para terminar, vamos a implementar el `Controller` para que ataque a la capa de `Service`, con los endpoints de las operaciones que vamos a publicar.

=== "AuthorController.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.author;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.web.bind.annotation.CrossOrigin;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;

    import com.capgemini.coedevon.tutorial.author.model.AuthorDto;
    import com.capgemini.coedevon.tutorial.author.model.AuthorSearchDto;
    import com.capgemini.coedevon.tutorial.config.mapper.BeanMapper;

    /**
    * @author coedevon
    */
    @RequestMapping(value = "/author/v1")
    @RestController
    @CrossOrigin(origins = "*")
    public class AuthorController {

        @Autowired
        AuthorService authorService;

        @Autowired
        BeanMapper beanMapper;

        /**
        * Método para recuperar un listado paginado de {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param dto
        * @return
        */
        @RequestMapping(path = "/", method = RequestMethod.POST)
        public Page<AuthorDto> findPage(@RequestBody AuthorSearchDto dto) {

            return this.beanMapper.mapPage(this.authorService.findPage(dto), AuthorDto.class);

        }

        /**
        * Método para crear o actualizar un {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param data datos de la entidad
        * @return
        */
        @RequestMapping(path = "/", method = RequestMethod.PUT)
        public AuthorDto save(@RequestBody AuthorDto data) {

            return this.beanMapper.map(this.authorService.save(data), AuthorDto.class);
        }

        /**
        * Método para crear o actualizar un {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @param id PK de la entidad
        */
        @RequestMapping(path = "/{id}", method = RequestMethod.DELETE)
        public void delete(@PathVariable("id") Long id) {

            this.authorService.delete(id);

        }
    }
    ```

En esta capa hemos hecho la conversión de un `Page<Author>` (modelo entidad) a un `Page<AuthorDto>` (modelo DTO) con la ayuda del beanMapper de devonfw. Recuerda que al cliente no le deben llegar modelos entidades sino DTOs.

Además, el método de carga `findPage` ya no es un método de tipo `GET`, ahora es de tipo `POST` porque le tenemos que enviar los datos de la paginación para que Spring JPA pueda hacer su magia.

### Prueba de las operaciones

Si ahora levantamos la aplicación y probamos con el postman, podemos ver los resultados que nos ofrece el back.

** POST ** nos devuelve un listado paginado de `Autores`, fíjate bien en la petición `Pageable` y la respuesta tipo `Page`.

![step4-java1](../assets/images/step4-java1.png)

** PUT ** nos sirve para insertar `Autores` nuevas (si no tienen el id informado) o para actualizar `Autores` (si tienen el id informado). Fíjate que los datos que se reciben están en el body.

![step4-java2](../assets/images/step4-java2.png)
![step4-java3](../assets/images/step4-java3.png)

** DELETE ** nos sirve eliminar `Autores`. Fíjate que el dato del ID está en el path.

![step4-java4](../assets/images/step4-java4.png)


## Conectar front con back

Una vez implementado front y back, lo que nos queda es modificar el servicio del front para que conecte directamente con las operaciones ofrecidas por el back.

=== "author.service.ts"
    ``` TypeScript hl_lines="18 22 26"
    import { Injectable } from '@angular/core';
    import { Pageable } from 'src/app/models/page/Pageable';
    import { AuthorPage } from 'src/app/models/authors/AuthorPage';
    import { Observable, of } from 'rxjs';
    import { Author } from 'src/app/models/authors/Author';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
        providedIn: 'root'
    })
    export class AuthorService {

        constructor(
            private http: HttpClient
        ) { }

        getAuthors(pageable: Pageable): Observable<AuthorPage> {
            return this.http.post<AuthorPage>('http://localhost:8080/author/v1/', {pageable:pageable});
        }

        saveAuthor(author: Author): Observable<Author> {
            return this.http.put<Author>('http://localhost:8080/author/v1/', author);
        }

        deleteAuthor(idAuthor : number): Observable<any> {
            return this.http.delete('http://localhost:8080/author/v1/'+idAuthor);
        }    
    }
    ```

