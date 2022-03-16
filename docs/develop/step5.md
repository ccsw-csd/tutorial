# Desarrollo de un listado filtrado

En este punto ya tenemos dos listados, uno básico y otro paginado. Ahora vamos a implementar un listado un poco diferente, con filtros y con una presentación un tanto distinta.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

## Desarrollo Angular

### Crear componentes

Vamos a desarrollar el listado de `Juegos`. Este listado es un tanto peculiar, porque no tiene una tabla como tal, sino que tiene una tabla con "tiles" para cada uno de los juegos. Necesitaremos un componente para el listado y otro componente para el detalle del juego. También necesitaremos otro componente para el dialogo de edición / alta.

Manos a la obra:

```
ng generate module game

ng generate component game/game-list
ng generate component game/game-list/game-item
ng generate component game/game-edit

ng generate service game/game
```

Y añadimos el nuevo módulo al `app.module.ts` como hemos hecho con el resto de módulos.

=== "Game.ts"
    ``` TypeScript
    import { NgModule } from '@angular/core';
    import { BrowserModule } from '@angular/platform-browser';

    import { AppRoutingModule } from './app-routing.module';
    import { AppComponent } from './app.component';
    import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
    import { CoreModule } from './core/core.module';
    import { CategoryModule } from './category/category.module';
    import { AuthorModule } from './author/author.module';
    import { GameModule } from './game/game.module';

    @NgModule({
        declarations: [
            AppComponent
        ],
        imports: [
            BrowserModule,
            AppRoutingModule,
            CoreModule,
            CategoryModule,
            AuthorModule,
            GameModule,
            BrowserAnimationsModule
        ],
        providers: [],
        bootstrap: [AppComponent]
    })
    export class AppModule { }
    ```



### Crear el modelo 

Lo primero que vamos a hacer es crear el modelo en `game/model/Game.ts` con todas las propiedades necesarias para trabajar con un juego:

=== "Game.ts"
    ``` TypeScript
    import { Category } from "src/app/category/model/Category";
    import { Author } from "src/app/author/model/Author";

    export class Game {
        id: number;
        title: string;
        age: number;
        category: Category;
        author: Author;
    }
    ```

Como ves, el juego tiene dos objetos para mapear categoría y autor.

### Añadir el punto de entrada

Añadimos la ruta al menú para que podamos navegar a esta pantalla:

=== "app-routing.module.ts"
    ``` TypeScript hl_lines="5 9 12"
    import { NgModule } from '@angular/core';
    import { Routes, RouterModule } from '@angular/router';
    import { AuthorListComponent } from './author/author-list/author-list.component';
    import { CategoryListComponent } from './category/category-list/category-list.component';
    import { GameListComponent } from './game/game-list/game-list.component';


    const routes: Routes = [
        { path: '', redirectTo: '/games', pathMatch: 'full'},
        { path: 'categories', component: CategoryListComponent },
        { path: 'authors', component: AuthorListComponent },
        { path: 'games', component: GameListComponent },
    ];

    @NgModule({
        imports: [RouterModule.forRoot(routes)],
        exports: [RouterModule]
    })
    export class AppRoutingModule { }
    ```



Además, hemos añadido una regla adicional con el path vacío para indicar que si no pone ruta, por defecto la página inicial redirija al path `/games`, que es nuevo path que hemos añadido.


### Implementar servicio

A continuación implementamos el servicio y mockeamos datos de ejemplo:

=== "mock-games.ts"
    ``` TypeScript
    import { Game } from "./Game";

    export const GAME_DATA: Game[] = [
        { id: 1, title: 'Juego 1', age: 6, category: { id: 1, name: 'Categoría 1' }, author: { id: 1, name: 'Autor 1', nationality: 'Nacionalidad 1' } },
        { id: 2, title: 'Juego 2', age: 8, category: { id: 1, name: 'Categoría 1' }, author: { id: 2, name: 'Autor 2', nationality: 'Nacionalidad 2' } },
        { id: 3, title: 'Juego 3', age: 4, category: { id: 1, name: 'Categoría 1' }, author: { id: 3, name: 'Autor 3', nationality: 'Nacionalidad 3' } },
        { id: 4, title: 'Juego 4', age: 10, category: { id: 2, name: 'Categoría 2' }, author: { id: 1, name: 'Autor 1', nationality: 'Nacionalidad 1' } },
        { id: 5, title: 'Juego 5', age: 16, category: { id: 2, name: 'Categoría 2' }, author: { id: 2, name: 'Autor 2', nationality: 'Nacionalidad 2' } },
        { id: 6, title: 'Juego 6', age: 16, category: { id: 2, name: 'Categoría 2' }, author: { id: 3, name: 'Autor 3', nationality: 'Nacionalidad 3' } },
        { id: 7, title: 'Juego 7', age: 12, category: { id: 3, name: 'Categoría 3' }, author: { id: 1, name: 'Autor 1', nationality: 'Nacionalidad 1' } },
        { id: 8, title: 'Juego 8', age: 14, category: { id: 3, name: 'Categoría 3' }, author: { id: 2, name: 'Autor 2', nationality: 'Nacionalidad 2' } },
    ]
    ```
=== "game.service.ts"
    ``` TypeScript
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Game } from './model/Game';
    import { GAME_DATA } from './model/mock-games';

    @Injectable({
        providedIn: 'root'
    })
    export class GameService {

        constructor() { }

        getGames(title?: String, categoryId?: number): Observable<Game[]> {
            return of(GAME_DATA);
        }

        saveGame(game: Game): Observable<void> {
            return of(null);
        }

    }
    ```

### Implementar listado

Ya tenemos las operaciones del servicio con datoos, así que ahora vamos a por el listado filtrado.


=== "game-list.component.html"
    ``` HTML
    <div class="container">
        <h1>Catálogo de juegos</h1>

        <div class="filters">
            <form>
                <mat-form-field>
                    <mat-label>Título del juego</mat-label>
                    <input type="text" matInput placeholder="Título del juego" [(ngModel)]="filterTitle" name="title">
                </mat-form-field>

                <mat-form-field>
                    <mat-label>Categoría del juego</mat-label>
                    <mat-select disableRipple [(ngModel)]="filterCategory" name="category">
                        <mat-option *ngFor="let category of categories" [value]="category">{{category.name}}</mat-option>
                    </mat-select>
                </mat-form-field>    
            </form>

            <div class="buttons">
                <button mat-stroked-button (click)="onCleanFilter()">Limpiar</button> 
                <button mat-stroked-button (click)="onSearch()">Filtrar</button> 
            </div>   
        </div>   

        <div class="game-list">
            <app-game-item *ngFor="let game of games; let i = index;" (click)="editGame(game)">
            </app-game-item>
        </div>
        
        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createGame()">Nuevo juego</button>            
        </div>   
    </div>
    ```
=== "game-list.component.scss"
    ``` CSS
    .container {
        margin: 20px;

        .filters {
            display: flex;

            mat-form-field {
                width: 300px;
                margin-right: 20px;
            }

            .buttons {
                flex: auto;
                align-self: center;

                button {
                    margin-left: 15px;
                }
            }
        }
    
        .game-list { 
            margin-top: 20px;
            margin-bottom: 20px;

            display: flex;
            flex-flow: wrap;
            overflow: auto;  
        }
        
        .buttons {
            text-align: right;
        }
    }

    button {
        width: 125px;
    }
    ```
=== "game-list.component.ts"
    ``` TypeScript
    import { Component, OnInit } from '@angular/core';
    import { MatDialog } from '@angular/material/dialog';
    import { CategoryService } from 'src/app/category/category.service';
    import { Category } from 'src/app/category/model/Category';
    import { GameEditComponent } from '../game-edit/game-edit.component';
    import { GameService } from '../game.service';
    import { Game } from '../model/Game';

    @Component({
        selector: 'app-game-list',
        templateUrl: './game-list.component.html',
        styleUrls: ['./game-list.component.scss']
    })
    export class GameListComponent implements OnInit {

        categories : Category[];
        games: Game[];
        filterCategory: Category;
        filterTitle: string;

        constructor(
            private gameService: GameService,
            private categoryService: CategoryService,
            public dialog: MatDialog,
        ) { }

        ngOnInit(): void {

            this.gameService.getGames().subscribe(
                games => this.games = games
            );

            this.categoryService.getCategories().subscribe(
                categories => this.categories = categories
            );
        }

        onCleanFilter(): void {
            this.filterTitle = null;
            this.filterCategory = null;

            this.onSearch();
        }

        onSearch(): void {

            let title = this.filterTitle;
            let categoryId = this.filterCategory != null ? this.filterCategory.id : null;

            this.gameService.getGames(title, categoryId).subscribe(
                games => this.games = games
            );
        }

        createGame() {    
            const dialogRef = this.dialog.open(GameEditComponent, {
                data: {}
            });

            dialogRef.afterClosed().subscribe(result => {
                this.ngOnInit();
            });    
        }  

        editGame(game: Game) {
            const dialogRef = this.dialog.open(GameEditComponent, {
                data: { game: game }
            });

            dialogRef.afterClosed().subscribe(result => {
                this.onSearch();
            });
        }
    }
    ```

Recuerda, de nuevo, que todos los componentes de Angular que utilicemos hay que importarlos en el módulo padre correspondiente para que se puedan precargar correctamente.

=== "game.module.ts"
    ``` TypeScript
    import { NgModule } from '@angular/core';
    import { CommonModule } from '@angular/common';
    import { GameListComponent } from './game-list/game-list.component';
    import { GameEditComponent } from './game-edit/game-edit.component';
    import { GameItemComponent } from './game-list/game-item/game-item.component';
    import { FormsModule, ReactiveFormsModule } from '@angular/forms';
    import { MatButtonModule } from '@angular/material/button';
    import { MatOptionModule } from '@angular/material/core';
    import { MatDialogModule } from '@angular/material/dialog';
    import { MatFormFieldModule } from '@angular/material/form-field';
    import { MatIconModule } from '@angular/material/icon';
    import { MatInputModule } from '@angular/material/input';
    import { MatPaginatorModule } from '@angular/material/paginator';
    import { MatSelectModule } from '@angular/material/select';
    import { MatTableModule } from '@angular/material/table';
    import { MatCardModule } from '@angular/material/card';


    @NgModule({
    declarations: [
        GameListComponent,
        GameEditComponent,
        GameItemComponent
    ],
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
        MatOptionModule,
        MatSelectModule,
        MatCardModule,
    ]
    })
    export class GameModule { }
    ```


Con todos estos cambios y si refrescamos el navegador, debería verse una pantalla similar a esta:

![step5-angular1](../assets/images/step5-angular1.png)

Tenemos una pantalla con una sección de filtros en la parte superior, donde podemos introducir un texto o seleccionar una categoría de un dropdown, un listado que de momento tiene todos los componentes básicos en una fila uno detrás del otro, y un botón para crear juegos nuevos.

!!! tip "Dropdown"
    El componente `Dropdown` es uno de los componentes más utilizados en las pantallas y formularios de Angular. Ves familiarizándote con él porque lo vas a usar mucho. Es bastante potente y medianamente sencillo de utilizar. Los datos del listado pueden ser dinámicos (desde servidor) o estáticos (si los valores ya los tienes prefijados).


### Implementar detalle del item

Ahora vamos a implementar el detalle de cada uno de los items que forman el listado. Para ello lo primero que haremos será pasarle la información del juego a cada componente como un dato de entrada `Input` hacia el componente.

=== "games.component.html"
    ``` HTML hl_lines="26"
    <div class="container">
        <h1>Catálogo de juegos</h1>

        <div class="filters">
            <form>
                <mat-form-field>
                    <mat-label>Título del juego</mat-label>
                    <input type="text" matInput placeholder="Título del juego" [(ngModel)]="filterName" name="title">
                </mat-form-field>

                <mat-form-field>
                    <mat-label>Categoría del juego</mat-label>
                    <mat-select disableRipple [(ngModel)]="filterCategory" name="category">
                        <mat-option *ngFor="let category of categories" [value]="category">{{category.name}}</mat-option>
                    </mat-select>
                </mat-form-field>    
            </form>

            <div class="buttons">
                <button mat-stroked-button (click)="onCleanFilter()">Limpiar</button> 
                <button mat-stroked-button (click)="onSearch()">Filtrar</button> 
            </div>   
        </div>   

        <div class="game-list">
            <app-game-item *ngFor="let game of games; let i = index;" (click)="editGame(game)" [game]="game">
            </app-game-item>
        </div>
        
        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createGame()">Nuevo juego</button>            
        </div>   
    </div>
    ```

También vamos a necesitar una foto de ejemplo para poner dentro de la tarjeta detalle de los juegos. Vamos a utilizar esta imagen:

<img src="../../assets/images/foto.png" width="100">

Descárgala y déjala dentro del proyecto en `assets/foto.png`. Y ya para terminar, implementamos el componente de detalle:

=== "game-item.component.html"
    ``` HTML
    <div class="container">
        <mat-card>
            <div class="photo">
                <img src="./assets/foto.png">
            </div>
            <div class="detail">
                <div class="title">{{game.title}}</div>
                <div class="properties">
                    <div><i>Edad recomendada: </i>+{{game.age}}</div>
                    <div><i>Categoría: </i>{{game.category.name}}</div>
                    <div><i>Autor: </i>{{game.author.name}}</div>
                    <div><i>Nacionalidad: </i>{{game.author.nationality}}</div>
                </div>
            </div>
        </mat-card>
    </div>
    ```
=== "game-item.component.scss"
    ``` CSS
    .container {
        display: flex;
        width: 325px;

        mat-card {
            width: 100%;
            margin: 10px;
            display: flex;

            .photo {
                margin-right: 10px;

                img {
                    width: 80px;
                    height: 80px;
                }
            }

            .detail {
                .title {
                    font-size: 14px;
                    font-weight: bold;
                }

                .properties {
                    font-size: 11px;

                    div {
                        height: 15px;
                    }                
                }
            }
        }
    }    
    ```
=== "game-item.component.ts"
    ``` TypeScript hl_lines="11"
    import { Component, OnInit, Input } from '@angular/core';
    import { Game } from '../../model/Game';

    @Component({
        selector: 'app-game-item',
        templateUrl: './game-item.component.html',
        styleUrls: ['./game-item.component.scss']
    })
    export class GameItemComponent implements OnInit {

        @Input() game: Game;

        constructor() { }

        ngOnInit(): void {
        }

    }
    ```

Ahora si que debería quedar algo similar a esta pantalla:

![step5-angular2](../assets/images/step5-angular2.png)


### Implementar dialogo de edición

Ya solo nos falta el último paso, implementar el cuadro de edición / alta de un nuevo juego. Pero tenemos un pequeño problema, y es que al crear o editar un juego debemos seleccionar una `Categoría` y un `Autor`. 

Para la `Categoría` no tenemos ningún problema, pero para el `Autor` no tenemos un servicio que nos devuelva todos los autores, solo tenemos un servicio que nos devuelve una `Page` de autores.

Así que lo primero que haremos será implementar una operación `getAllAuthors` para poder recuperar una lista.

=== "mock-authors-list.ts"
    ``` TypeScript
    import { Author } from "./Author";

    export const AUTHOR_DATA_LIST : Author[] = [
        { id: 1, name: 'Klaus Teuber', nationality: 'Alemania' },
        { id: 2, name: 'Matt Leacock', nationality: 'Estados Unidos' },
        { id: 3, name: 'Keng Leong Yeo', nationality: 'Singapur' },
        { id: 4, name: 'Gil Hova', nationality: 'Estados Unidos'},
        { id: 5, name: 'Kelly Adams', nationality: 'Estados Unidos' },
    ]    
    ```
=== "author.service.ts"
    ``` TypeScript hl_lines="7 34-36"
    import { HttpClient } from '@angular/common/http';
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Pageable } from '../core/model/page/Pageable';
    import { Author } from './model/Author';
    import { AuthorPage } from './model/AuthorPage';
    import { AUTHOR_DATA_LIST } from './model/mock-authors-list';

    @Injectable({
        providedIn: 'root'
    })
    export class AuthorService {

        constructor(
            private http: HttpClient
        ) { }

        getAuthors(pageable: Pageable): Observable<AuthorPage> {
            return this.http.post<AuthorPage>('http://localhost:8080/author', {pageable:pageable});
        }

        saveAuthor(author: Author): Observable<void> {

            let url = 'http://localhost:8080/author';
            if (author.id != null) url += '/'+author.id;

            return this.http.put<void>(url, author);
        }

        deleteAuthor(idAuthor : number): Observable<void> {
            return this.http.delete<void>('http://localhost:8080/author/'+idAuthor);
        }    

        getAllAuthors(): Observable<Author[]> {
            return of(AUTHOR_DATA_LIST);
        }

    }
    ```    

Ahora sí que tenemos todo listo para implementar el cuadro de dialogo para dar de alta o editar juegos.

=== "game-edit.component.html"
    ``` HTML
    <div class="container">
        <h1 *ngIf="game.id == null">Crear juego</h1>
        <h1 *ngIf="game.id != null">Modificar juego</h1>

        <form>
            <mat-form-field>
                <mat-label>Identificador</mat-label>
                <input type="number" matInput placeholder="Identificador" [(ngModel)]="game.id" name="id" disabled>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Título</mat-label>
                <input type="text" matInput placeholder="Título del juego" [(ngModel)]="game.title" name="title" required>
                <mat-error>El título no puede estar vacío</mat-error>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Edad recomendada</mat-label>
                <input type="number" matInput placeholder="Edad recomendada" [(ngModel)]="game.age" name="age" required>
                <mat-error>La edad no puede estar vacía</mat-error>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Categoría</mat-label>
                <mat-select disableRipple [(ngModel)]="game.category" name="category" required>
                    <mat-option *ngFor="let category of categories" [value]="category">{{category.name}}</mat-option>
                </mat-select>
                <mat-error>La categoría no puede estar vacía</mat-error>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Autor</mat-label>
                <mat-select disableRipple [(ngModel)]="game.author" name="author" required>
                    <mat-option *ngFor="let author of authors" [value]="author">{{author.name}}</mat-option>
                </mat-select>
                <mat-error>El autor no puede estar vacío</mat-error>
            </mat-form-field>
        </form>

        <div class="buttons">
            <button mat-stroked-button (click)="onClose()">Cerrar</button>
            <button mat-flat-button color="primary" (click)="onSave()">Guardar</button>
        </div>
    </div>
    ```
=== "game-edit.component.scss"
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
=== "game-edit.component.ts"
    ``` TypeScript
    import { Component, Inject, OnInit } from '@angular/core';
    import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
    import { AuthorService } from 'src/app/author/author.service';
    import { Author } from 'src/app/author/model/Author';
    import { CategoryService } from 'src/app/category/category.service';
    import { Category } from 'src/app/category/model/Category';
    import { GameService } from '../game.service';
    import { Game } from '../model/Game';

    @Component({
        selector: 'app-game-edit',
        templateUrl: './game-edit.component.html',
        styleUrls: ['./game-edit.component.scss']
    })
    export class GameEditComponent implements OnInit {

        game: Game; 
        authors: Author[];
        categories: Category[];

        constructor(
            public dialogRef: MatDialogRef<GameEditComponent>,
            @Inject(MAT_DIALOG_DATA) public data: any,
            private gameService: GameService,
            private categoryService: CategoryService,
            private authorService: AuthorService,
        ) { }

        ngOnInit(): void {
            if (this.data.game != null) {
                this.game = Object.assign({}, this.data.game);
            }
            else {
                this.game = new Game();
            }
            
            this.categoryService.getCategories().subscribe(
                categories => {
                    this.categories = categories;

                    if (this.data.game.category != null) {
                        let categoryFilter: Category[] = categories.filter(category => category.id == this.data.game.category.id);
                        if (categoryFilter != null) {
                            this.game.category = categoryFilter[0];
                        }
                    }
                }
            );

            this.authorService.getAllAuthors().subscribe(
                authors => {
                    this.authors = authors

                    if (this.data.game.author != null) {
                        let authorFilter: Author[] = authors.filter(author => author.id == this.data.game.author.id);
                        if (authorFilter != null) {
                            this.game.author = authorFilter[0];
                        }
                    }
                }
            );
        }

        onSave() {
            this.gameService.saveGame(this.game).subscribe(result => {
                this.dialogRef.close();
            });    
        }  

        onClose() {
            this.dialogRef.close();
        }

    }
    ```

Como puedes ver, para rellenar los componentes seleccionables de dropdown, hemos realizado una consulta al servicio para recuperar todos los autores y categorias, y en la respuesta de cada uno de ellos, hemos buscado en los resultados cual es el que coincide con el ID enviado desde el listado, y ese es el que hemos fijado en el objeto `Game`.

De esta forma, no estamos cogiendo directamente los datos del listado, sino que no estamos asegurando que los datos de autor y de categoría son los que vienen del servicio, siempre filtrando por su ID.


## Desarrollo Springboot

### Modelos

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
    package com.capgemini.ccsw.tutorial.game.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.ManyToOne;
    import javax.persistence.Table;

    import com.capgemini.ccsw.tutorial.author.model.Author;
    import com.capgemini.ccsw.tutorial.category.model.Category;

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
    package com.capgemini.ccsw.tutorial.game.model;

    import com.capgemini.ccsw.tutorial.author.model.AuthorDto;
    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;

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



### TDD - Pruebas

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


También crearemos una clase `GameController` dentro del package de `com.capgemini.ccsw.tutorial.game` con la implementación de los métodos vacíos, para que no falle la compilación.

¡Vamos a implementar test!


=== "GameController.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.web.bind.annotation.RestController;

    import com.capgemini.ccsw.tutorial.game.model.GameDto;

    @RestController
    public class GameController {

        public List<GameDto> find(String title, Long idCategory) {
            return null;
        }

        public void save(Long id, GameDto dto) {

        }

    }
    ```
=== "GameTest.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.game;

    import static org.junit.jupiter.api.Assertions.assertEquals;
    import static org.junit.jupiter.api.Assertions.assertNotNull;
    import static org.junit.jupiter.api.Assertions.assertThrows;

    import java.util.List;

    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.transaction.annotation.Transactional;

    import com.capgemini.ccsw.tutorial.author.model.AuthorDto;
    import com.capgemini.ccsw.tutorial.category.model.CategoryDto;
    import com.capgemini.ccsw.tutorial.game.model.GameDto;

    @SpringBootTest
    @Transactional
    public class GameTest {

        @Autowired
        private GameController gameController;

        private final String notExistsTitle = "NotExists";
        private final String existsTitle = "Aventureros";
        private final Long notExistsCategory = 0L;
        private final Long existsCategory = 3L;

        @Test
        public void findWithoutFiltersShouldReturnAllGamesInDB() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 6;

            List<GameDto> games = gameController.find(null, null);

            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());
        }

        @Test
        public void findExistsTitleShouldReturnGames() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 1;

            List<GameDto> games = gameController.find(existsTitle, null);

            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());
        }

        @Test
        public void findExistsCategoryShouldReturnGames() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 2;

            List<GameDto> games = gameController.find(null, existsCategory);

            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());
        }

        @Test
        public void findExistsTitleAndCategoryShouldReturnGames() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 1;

            List<GameDto> games = gameController.find(existsTitle, existsCategory);

            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());
        }

        @Test
        public void findNotExistsTitleShouldReturnEmpty() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 0;

            List<GameDto> games = gameController.find(notExistsTitle, null);

            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());
        }

        @Test
        public void findNotExistsCategoryShouldReturnEmpty() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 0;

            List<GameDto> games = gameController.find(null, notExistsCategory);

            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());
        }

        @Test
        public void findNotExistsTitleOrCategoryShouldReturnEmpty() {

            assertNotNull(gameController);

            int GAMES_WITH_FILTER = 0;

            List<GameDto> games = gameController.find(notExistsTitle, notExistsCategory);
            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());

            games = gameController.find(notExistsTitle, existsCategory);
            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());

            games = gameController.find(existsTitle, notExistsCategory);
            assertNotNull(games);
            assertEquals(GAMES_WITH_FILTER, games.size());

        }

        @Test
        public void saveWithoutIdShouldCreateNewGame() {

            String newTitle = "Nuevo juego";

            GameDto dto = new GameDto();
            AuthorDto authorDto = new AuthorDto();
            authorDto.setId(1L);

            CategoryDto categoryDto = new CategoryDto();
            categoryDto.setId(1L);

            dto.setTitle(newTitle);
            dto.setAge("18");
            dto.setAuthor(authorDto);
            dto.setCategory(categoryDto);

            List<GameDto> games = gameController.find(newTitle, null);
            assertNotNull(games);
            assertEquals(0, games.size());

            gameController.save(null, dto);

            games = gameController.find(newTitle, null);
            assertNotNull(games);
            assertEquals(1, games.size());
        }

        @Test
        public void modifyWithExistIdShouldModifyGame() {

            Long gameId = 1L;
            String newTitle = "Nuevo juego";

            GameDto dto = new GameDto();
            AuthorDto authorDto = new AuthorDto();
            authorDto.setId(1L);

            CategoryDto categoryDto = new CategoryDto();
            categoryDto.setId(1L);

            dto.setTitle(newTitle);
            dto.setAge("18");
            dto.setAuthor(authorDto);
            dto.setCategory(categoryDto);

            List<GameDto> games = gameController.find(newTitle, null);
            assertNotNull(games);
            assertEquals(0, games.size());

            gameController.save(gameId, dto);

            games = gameController.find(newTitle, null);
            assertNotNull(games);
            assertEquals(1, games.size());

            GameDto game = games.get(0);
            assertEquals(gameId, game.getId());

        }

        @Test
        public void modifyWithNotExistIdShouldThrowException() {
            assertNotNull(gameController);

            String newTitle = "Nuevo juego";
            long gameId = 0;

            GameDto dto = new GameDto();
            dto.setTitle(newTitle);

            assertThrows(Exception.class, () -> gameController.save(gameId, dto));
        }

    }
    ```

!!! tip "Búsquedas en BBDD"
    Siempre deberíamos buscar a los hijos por primary keys, nunca hay que hacerlo por una descripción libre ya que el usuario podría teclear el mismo nombre de diferentes formas y no habría manera de buscar correctamente el resultado. Así que siempre que haya un dropdown, se debe filtrar por su ID.


Si ahora ejecutas los jUnits, verás que en este caso hemos construido 10 pruebas, para cubrir los casos básicos del `Controller`, y todas ellas fallan la ejecución. Vamos a seguir implementando el resto de capas para hacer que los test funcionen.

### Controller

De nuevo para poder compilar esta capa, nos hace falta delegar sus operaciones de lógica de negocio en un `Service` así que lo crearemos al mismo tiempo que lo vamos necesitando.

=== "GameService.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import com.capgemini.ccsw.tutorial.game.model.Game;
    import com.capgemini.ccsw.tutorial.game.model.GameDto;

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
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.CrossOrigin;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RequestParam;
    import org.springframework.web.bind.annotation.RestController;

    import com.capgemini.ccsw.tutorial.game.model.Game;
    import com.capgemini.ccsw.tutorial.game.model.GameDto;
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


### Service

Siguiente paso, la capa de lógica de negocio, es decir el `Service`, que por tanto hará uso de un `Repository`.


=== "GameServiceImpl.java"
    ``` Java hl_lines="30 46"
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.capgemini.ccsw.tutorial.game.model.Game;
    import com.capgemini.ccsw.tutorial.game.model.GameDto;

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
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.data.repository.CrudRepository;

    import com.capgemini.ccsw.tutorial.game.model.Game;

    public interface GameRepository extends CrudRepository<Game, Long> {

        List<Game> find(String title, Long category);

    }
    ```

Este servicio tiene dos peculiaridades, remarcadas en amarillo en la clase anterior. Por un lado tenemos la consulta, que no es un listado completo ni un listado paginado, sino que es un listado con filtros. Luego veremos como se hace eso, de momento lo dejaremos como un método que recibe los dos filtros.

La segunda peculiaridad es que de cliente nos está llegando un `GameDto`, que internamente tiene un `AuthorDto` y un `CategoryDto`, pero nosotros lo tenemos que traducir a entidades de BBDD. No sirve con copiar las propiedades tal cual, ya que entonces Spring lo que hará será crear un objeto nuevo y persistir ese objeto nuevo de `Author` y de `Category`. Además, de cliente generalmente tan solo nos llega el ID de esos objetos hijo, y no el resto de información de la entidad. Por esos motivos lo hemos *ignorado* del copyProperties.

Pero de alguna forma tendremos que setearle esos valores a la entidad `Game`. Si conocemos sus ID que es lo que generalmente llega, podemos recuperar esos objetos de BBDD y setearlos en el objeto `Game`. Si recuerdas las reglas básicas, un `Repository` debe pertenecer a un solo `Service`, por lo que en lugar de llamar a métodos de los `AuthorRepository` y `CategoryRepository` desde nuestro `GameServiceImpl`, debemos llamar a métodos expuestos en `AuthorService` y `CategoryService`, que son los que gestionan sus repositorios. Para ello necesitaremos crear esos métodos get en los otros `Services`. 

Y ya sabes, para implementar nuevos métodos, antes se deben hacer las pruebas jUnit. Recuerda que los test van en `src/test/java`


=== "AuthorServiceTest.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.author;

    import static org.junit.jupiter.api.Assertions.assertEquals;
    import static org.junit.jupiter.api.Assertions.assertNotNull;
    import static org.junit.jupiter.api.Assertions.assertNull;

    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.transaction.annotation.Transactional;

    import com.capgemini.ccsw.tutorial.author.model.Author;

    @SpringBootTest
    @Transactional
    public class AuthorServiceTest {

        @Autowired
        private AuthorService authorService;

        @Test
        public void getExistsAuthorIdShouldReturnAuthor() {
            assertNotNull(authorService);

            Long authorId = 1L;

            Author author = authorService.get(1L);

            assertNotNull(author);

            assertEquals(authorId, author.getId());

        }

        @Test
        public void getNotExistsAuthorIdShouldReturnNull() {
            assertNotNull(authorService);

            Long authorId = 0L;

            Author author = authorService.get(authorId);

            assertNull(author);

        }

    }

    ```
=== "AuthorService.java"
    ``` Java hl_lines="14-19"
    package com.capgemini.ccsw.tutorial.author;

    import org.springframework.data.domain.Page;

    import com.capgemini.ccsw.tutorial.author.model.Author;
    import com.capgemini.ccsw.tutorial.author.model.AuthorDto;
    import com.capgemini.ccsw.tutorial.author.model.AuthorSearchDto;

    /**
    * @author ccsw
    */
    public interface AuthorService {

        /**
        * Recupera un {@link com.capgemini.ccsw.tutorial.author.model.Author} a través de su ID
        * @param id
        * @return
        */
        Author get(Long id);

        /**
        * Método para recuperar un listado paginado de {@link com.capgemini.ccsw.tutorial.author.model.Author}
        * @param dto
        * @return
        */
        Page<Author> findPage(AuthorSearchDto dto);

        /**
        * Método para crear o actualizar un {@link com.capgemini.ccsw.tutorial.author.model.Author}
        * @param id
        * @param data
        */
        void save(Long id, AuthorDto data);

        /**
        * Método para crear o actualizar un {@link com.capgemini.ccsw.tutorial.author.model.Author}
        * @param id
        */
        void delete(Long id);

    }

    ```
=== "AuthorServiceImpl.java"
    ``` Java hl_lines="24-31 50"
    package com.capgemini.ccsw.tutorial.author;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.domain.Page;
    import org.springframework.stereotype.Service;

    import com.capgemini.ccsw.tutorial.author.model.Author;
    import com.capgemini.ccsw.tutorial.author.model.AuthorDto;
    import com.capgemini.ccsw.tutorial.author.model.AuthorSearchDto;

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


=== "CategoryServiceTest.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.category;

    import static org.junit.jupiter.api.Assertions.assertEquals;
    import static org.junit.jupiter.api.Assertions.assertNotNull;
    import static org.junit.jupiter.api.Assertions.assertNull;

    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.transaction.annotation.Transactional;

    import com.capgemini.ccsw.tutorial.category.model.Category;

    @SpringBootTest
    @Transactional
    public class CategoryServiceTest {

        @Autowired
        private CategoryService categoryService;

        @Test
        public void getExistsCategoryIdShouldReturnCategory() {
            assertNotNull(categoryService);

            Long categoryId = 1L;

            Category category = categoryService.get(1L);

            assertNotNull(category);

            assertEquals(categoryId, category.getId());

        }

        @Test
        public void getNotExistsCategoryIdShouldReturnNull() {
            assertNotNull(categoryService);

            Long categoryId = 0L;

            Category category = categoryService.get(categoryId);

            assertNull(category);

        }

    }
    ```
=== "CategoryService.java"
    ``` Java hl_lines="14-19"
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
        * Recupera una {@link com.capgemini.ccsw.tutorial.category.model.Category} a partir de su ID
        * @param id
        * @return
        */
        Category get(Long id);

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
=== "CategoryServiceImpl.java"
    ``` Java hl_lines="21-28 50"
    package com.capgemini.ccsw.tutorial.category;

    import java.util.List;

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
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.capgemini.ccsw.tutorial.author.AuthorService;
    import com.capgemini.ccsw.tutorial.category.CategoryService;
    import com.capgemini.ccsw.tutorial.game.model.Game;
    import com.capgemini.ccsw.tutorial.game.model.GameDto;

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


### Repository

Y llegamos a la última capa donde, si recordamos, teníamos un método `find` que recibe dos parámetros. Algo así:


=== "GameRepository.java"
    ``` Java
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.data.repository.CrudRepository;

    import com.capgemini.ccsw.tutorial.game.model.Game;

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
    package com.capgemini.ccsw.tutorial.game;

    import java.util.List;

    import org.springframework.data.repository.CrudRepository;

    import com.capgemini.ccsw.tutorial.game.model.Game;

    public interface GameRepository extends CrudRepository<Game, Long> {

        @Query("select g from Game g where (:title is null or g.title like '%'||:title||'%') and (:category is null or g.category.id = :category)")
        List<Game> find(@Param("title") String title, @Param("category") Long category);

    }
    ```

Si te fijas en las dos líneas que hemos modificado, por un lado hemos puesto nombre a los parámetros de entrada con la anotación @Param. Esto solo nos sirve para poder utilizar los parametros dentro de la query.

Por otro lado, hemos creado una query en un lenguaje similar a SQL, pero en lugar de hacer uso de tablas y columnas, hacemos uso de objetos entity y propiedades. Dentro del where hemos puesto las dos condiciones, o bien que el parámetro título sea nulo o bien si no es nulo, que la propiedad contenga el texto del parámetro título. Para categoría hemos hecho lo mismo. 
Con esta quuery, Spring JPA generará el SQL correcto y mapeará los resultados a un listado de `Game` que es lo que queremos obtener.

Es otra forma, bastante sencilla de implementar consultas a BBDD.


### Prueba de las operaciones


Si ahora ejecutamos de nuevo los jUnits, vemos que todos los que hemos desarrollado en `GameTest` ya funcionan correctamente, e incluso el resto de test de la aplicación también funcionan correctamente. 

!!! tip "Pruebas jUnit"
    Cada vez que desarrollemos un caso de uso nuevo, debemos relanzar todas las pruebas automáticas que tenga la aplicación. Es muy común que al implementar algún desarrollo nuevo, interfiramos de alguna forma en el funcionamiento de otra funcionalidad. Si lanzamos toda la batería de pruebas, nos daremos cuenta si algo ha dejado de funcionar y podremos solucionarlo antes de llevar ese error a Producción. Las pruebas jUnit son nuestra red de seguridad.


Además de las pruebas automáticas, podemos ver como se comporta la aplicación y que respuesta nos ofrece, lanzando peticiones Rest con Postman, como hemos hecho en los casos anteriores. Así que podemos levantar la aplicación y lanzar las operaciones:

** GET http://localhost:8080/game ** 

** GET http://localhost:8080/game?title=xxx **

** GET http://localhost:8080/game?idCategory=xxx **

Nos devuelve un listado filtrado de `Game`. Fíjate bien en la petición donde envíamos los filtros y la respuesta que tiene los objetos `Category` y `Author` incluídos.

![step5-java1](../assets/images/step5-java1.png)

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

![step5-java2](../assets/images/step5-java2.png)
![step5-java3](../assets/images/step5-java3.png)


!!! tip "Rendimiento en las consultas JPA"
    En este punto te recomiendo que visites el [Anexo. Funcionamiento JPA](../appendix/jpa.md) para conocer un poco más como funciona por dentro JPA y algún pequeño truco que puede mejorar el rendimiento.



### Implementar listado Autores

Antes de poder conectar front con back, si recuerdas, en la edición de un `Game`, nos hacía falta un listado de `Author` y un listado de `Category`. El segundo ya lo tenemos ya que lo reutilizaremos del listado de categorías que implementamos. Pero el primero no lo tenemos, porque en la pantalla que hicimos, se mostraban de forma paginada. 

Así que necesitamos implementar esa funcionalidad, y como siempre vamos de la capa de testing hacia las siguientes capas. Deberíamos añadir los siguientes métodos:


=== "AuthorTest.java"
    ``` Java
    ...

    @Test
    public void findAllShouldReturnAllAuthorInDB() {
        assertNotNull(authorController);

        List<AuthorDto> authors = authorController.findAll();

        assertNotNull(authors);

        assertEquals(TOTAL_AUTORS, authors.size());

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

Ahora sí, todo listo para seguir al siguiente punto.

## Conectar front con back

Una vez implementado front y back, lo que nos queda es modificar el servicio del front para que conecte directamente con las operaciones ofrecidas por el back.

=== "author-service.ts"
    ``` Typescript hl_lines="33-35"
    import { HttpClient } from '@angular/common/http';
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Pageable } from '../core/model/page/Pageable';
    import { Author } from './model/Author';
    import { AuthorPage } from './model/AuthorPage';

    @Injectable({
        providedIn: 'root'
    })
    export class AuthorService {

        constructor(
            private http: HttpClient
        ) { }

        getAuthors(pageable: Pageable): Observable<AuthorPage> {
            return this.http.post<AuthorPage>('http://localhost:8080/author', {pageable:pageable});
        }

        saveAuthor(author: Author): Observable<void> {

            let url = 'http://localhost:8080/author';
            if (author.id != null) url += '/'+author.id;

            return this.http.put<void>(url, author);
        }

        deleteAuthor(idAuthor : number): Observable<void> {
            return this.http.delete<void>('http://localhost:8080/author/'+idAuthor);
        }    

        getAllAuthors(): Observable<Author[]> {
            return this.http.get<Author[]>('http://localhost:8080/author');
        }

    }
    ```
=== "game-service.ts"
    ``` Typescript hl_lines="12 16 20-26 29-45"
    import { HttpClient } from '@angular/common/http';
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Game } from './model/Game';

    @Injectable({
        providedIn: 'root'
    })
    export class GameService {

        constructor(
            private http: HttpClient
        ) { }

        getGames(title?: String, categoryId?: number): Observable<Game[]> {            
            return this.http.get<Game[]>(this.composeFindUrl(title, categoryId));
        }

        saveGame(game: Game): Observable<void> {
            let url = 'http://localhost:8080/game';

            if (game.id != null) {
                url += '/'+game.id;
            }

            return this.http.put<void>(url, game);
        }

        private composeFindUrl(title?: String, categoryId?: number) : string {
            let params = '';
            
            if (title != null) {
                params += 'title='+title;
            }
            
            if (categoryId != null) {
                if (params != '') params += "&";
                params += "idCategory="+categoryId;
            }
            
            let url = 'http://localhost:8080/game'

            if (params == '') return url;
            else return url + '?'+params;
        }
    }
    ```

Y ahora si, podemos navegar por la web y ver el resultado completo.