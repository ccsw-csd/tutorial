# Desarrollo de un listado filtrado

En este punto ya tenemos dos listados, uno básico y otro paginado. Ahora vamos a implementar un listado un poco diferente, con filtros y con una presentación un tanto distinta.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

## Desarrollo Angular

### Crear componentes

Vamos a desarrollar el listado de `Juegos`. Este listado es un tanto peculiar, porque no tiene una tabla como tal, sino que tiene una tabla con "tiles" para cada uno de los juegos. Necesitaremos un componente para el listado y otro componente para el detalle del juego. También necesitaremos otro componente para el dialogo de edición / alta.

Manos a la obra:

```
ng generate component views/games
ng generate component views/games/game-detail
ng generate component views/games/game-dialog

ng generate service services/games/game
```

### Crear el modelo 

Lo primero que vamos a hacer es crear el modelo en `models/games/Game.ts` con todas las propiedades necesarias para trabajar con un juego:

=== "Game.ts"
    ``` TypeScript
    import { Category } from '../categories/Category';
    import { Author } from '../authors/Author';

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
    import { CategoriesComponent } from './views/categories/categories.component';
    import { AuthorsComponent } from './views/authors/authors.component';
    import { GamesComponent } from './views/games/games.component';


    const routes: Routes = [
        { path: '', redirectTo: '/games', pathMatch: 'full'},
        { path: 'categories', component: CategoriesComponent },
        { path: 'authors', component: AuthorsComponent },
        { path: 'games', component: GamesComponent },
    ];

    @NgModule({
        imports: [RouterModule.forRoot(routes)],
        exports: [RouterModule]
    })
    export class AppRoutingModule { }
    ```



Además, hemos añadido una regla adicional para que cuando se cargue la página inicial (sin ruta) por defecto redirija al catálogo de juegos.


### Implementar servicio

A continuación implementamos el servicio y mockeamos datos de ejemplo:

=== "mock-games.ts"
    ``` TypeScript
    import { Game } from "src/app/models/games/Game";

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
    import { Game } from 'src/app/models/games/Game';
    import { Observable, of } from 'rxjs';
    import { GAME_DATA } from './mock-games';

    @Injectable({
        providedIn: 'root'
    })
    export class GameService {

        constructor() { }

        getGames(title?: String, categoryId?: number): Observable<Game[]> {
            return of(GAME_DATA);
        }

        saveGame(game: Game): Observable<Game> {
            return of(null);
        }

    }
    ```

### Implementar listado

Ya tenemos las operaciones del servicio con datoos, así que ahora vamos a por el listado filtrado.


=== "games.component.html"
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
            <app-game-detail *ngFor="let game of games; let i = index;" (click)="editGame(game)">
            </app-game-detail>
        </div>
        
        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createGame()">Nuevo juego</button>            
        </div>   
    </div>
    ```
=== "games.component.scss"
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
=== "games.component.ts"
    ``` TypeScript
    import { Component, OnInit } from '@angular/core';
    import { Category } from 'src/app/models/categories/Category';
    import { Game } from 'src/app/models/games/Game';
    import { GameService } from 'src/app/services/games/game.service';
    import { CategoryService } from 'src/app/services/categories/category.service';
    import { GameDialogComponent } from './game-dialog/game-dialog.component';
    import { MatDialog } from '@angular/material/dialog';

    @Component({
        selector: 'app-games',
        templateUrl: './games.component.html',
        styleUrls: ['./games.component.scss']
    })
    export class GamesComponent implements OnInit {

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
            const dialogRef = this.dialog.open(GameDialogComponent, {
                data: {}
            });

            dialogRef.afterClosed().subscribe(result => {
                this.ngOnInit();
            });    
        }  

        editGame(game: Game) {
            const dialogRef = this.dialog.open(GameDialogComponent, {
                data: { game: game }
            });

            dialogRef.afterClosed().subscribe(result => {
                this.onSearch();
            });
        }

    }
    ```

Recuerda que cada vez que utilizamos un componente nuevo (en este caso el mat-select y mat-option) debemos incluirlo en el módulo padre.

=== "views.module.ts"
    ``` TypeScript hl_lines="18 19 34 35"
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
    import { GamesComponent } from './games/games.component';
    import { GameDetailComponent } from './games/game-detail/game-detail.component';
    import { GameDialogComponent } from './games/game-dialog/game-dialog.component';
    import { MatOptionModule } from '@angular/material/core';
    import { MatSelectModule } from '@angular/material/select';

    @NgModule({
        declarations: [CategoriesComponent, CategoryDialogComponent, AuthorsComponent, AuthorDialogComponent, GamesComponent, GameDetailComponent, GameDialogComponent],
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



Debe quedar algo similar a esto:

![step5-angular1](../assets/images/step5-angular1.png)

Tenemos una pantalla con una sección de filtros en la parte superior, donde podemos introducir un texto o seleccionar una categoría de un dropdown, un listado que de momento tiene todos los componentes básicos en una fila uno detrás del otro, y un botón para crear juegos nuevos.

### Implementar detalle del item

Ahora vamos a implementar el detalle de cada uno de los items que forman el listado. Para ello lo primero que haremos será pasarle la información del juego a cada componente como un dato de entrada `Input`.

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
            <app-game-detail *ngFor="let game of games; let i = index;" (click)="editGame(game)" [game]="game">
            </app-game-detail>
        </div>
        
        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createGame()">Nuevo juego</button>            
        </div>   
    </div>
    ```

También vamos a necesitar una foto de ejemplo para poner dentro de la tarjeta detalle de los juegos. Vamos a utilizar esta imagen:

<img src="../../assets/images/foto.png" width="100">

Y ya para terminar, implementamos el componente de detalle:

=== "game-detail.component.html"
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
=== "game-detail.component.scss"
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
=== "game-detail.component.ts"
    ``` TypeScript hl_lines="11"
    import { Component, OnInit, Input } from '@angular/core';
    import { Game } from 'src/app/models/games/Game';

    @Component({
        selector: 'app-game-detail',
        templateUrl: './game-detail.component.html',
        styleUrls: ['./game-detail.component.scss']
    })
    export class GameDetailComponent implements OnInit {

        @Input() game: Game;

        constructor() { }

        ngOnInit(): void {
        }

    }
    ```

Y de nuevo, al utilizar un componente nuevo (en este caso el mat-card) debemos incluirlo en el módulo padre.

=== "views.module.ts"
    ``` TypeScript hl_lines="20 37"
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
    import { GamesComponent } from './games/games.component';
    import { GameDetailComponent } from './games/game-detail/game-detail.component';
    import { GameDialogComponent } from './games/game-dialog/game-dialog.component';
    import { MatOptionModule } from '@angular/material/core';
    import { MatSelectModule } from '@angular/material/select';
    import { MatCardModule } from '@angular/material/card';

    @NgModule({
        declarations: [CategoriesComponent, CategoryDialogComponent, AuthorsComponent, AuthorDialogComponent, GamesComponent, GameDetailComponent, GameDialogComponent],
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
            MatCardModule    
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

Ahora si que debería quedar algo similar a esta pantalla:

![step5-angular2](../assets/images/step5-angular2.png)


### Implementar dialogo de edición

Ya solo nos falta el último paso, implementar el cuadro de edición / alta de un nuevo juego. Pero tenemos un pequeño problema, y es que al crear o editar un juego debemos seleccionar una `Categoría` y un `Autor`. 

Para la `Categoría` no tenemos ningún problema, pero para el `Autor` no tenemos un servicio que nos devuelva todos los autores, solo tenemos un servicio que nos devuelve una `Page` de autores.

Así que lo primero que haremos será implementar una operación `getAllAuthors` para poder recuperar una lista.

=== "mock-authors-list.ts"
    ``` TypeScript
    import { Author } from 'src/app/models/authors/Author';

    export const AUTHOR_DATA_LIST : Author[] = [
        { id: 1, name: 'Klaus Teuber', nationality: 'Alemania' },
        { id: 2, name: 'Matt Leacock', nationality: 'Estados Unidos' },
        { id: 3, name: 'Keng Leong Yeo', nationality: 'Singapur' },
        { id: 4, name: 'Gil Hova', nationality: 'Estados Unidos'},
        { id: 5, name: 'Kelly Adams', nationality: 'Estados Unidos' },
    ]    
    ```
=== "mock-authors.ts"
    ``` TypeScript hl_lines="2 5"
    import { AuthorPage } from 'src/app/models/authors/AuthorPage';
    import { AUTHOR_DATA_LIST } from './mock-authors-list';

    export const AUTHOR_DATA: AuthorPage = {
        content: AUTHOR_DATA_LIST,  
        pageable : {
            pageSize: 5,
            pageNumber: 0,
            sort: [
                {property: "id", direction: "ASC"}
            ]
        },
        totalElements: 7
    }
    ```
=== "author.service.ts"
    ``` TypeScript hl_lines="7 30 31 32"
    import { Injectable } from '@angular/core';
    import { Pageable } from 'src/app/models/page/Pageable';
    import { AuthorPage } from 'src/app/models/authors/AuthorPage';
    import { Observable, of } from 'rxjs';
    import { Author } from 'src/app/models/authors/Author';
    import { HttpClient } from '@angular/common/http';
    import { AUTHOR_DATA_LIST } from './mock-authors-list';

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

        getAllAuthors(): Observable<Author[]> {
            return of(AUTHOR_DATA_LIST);
        }

    }
    ```    

!!! tip "Clean Code"
    Acuerdate de lo que hemos comentado antes, siempre debes tener presente el `Clean Code`. ¡No dupliques código!, es muy importante de cara al futuro mantenimiento. En este caso, en tanto en mock-authors como en mock-authors-list teníamos un listado de autores. Lo mejor es que no dupliquemos el código y uno de ellos haga uso del otro.

Ahora sí que tenemos todo listo para implementar el cuadro de dialogo para dar de alta o editar juegos.

=== "game-dialog.component.html"
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
=== "game-dialog.component.scss"
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
=== "game-dialog.component.ts"
    ``` TypeScript
    import { Component, OnInit, Inject } from '@angular/core';
    import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
    import { Game } from 'src/app/models/games/Game';
    import { GameService } from 'src/app/services/games/game.service';
    import { Author } from 'src/app/models/authors/Author';
    import { Category } from 'src/app/models/categories/Category';
    import { AuthorService } from 'src/app/services/authors/author.service';
    import { CategoryService } from 'src/app/services/categories/category.service';

    @Component({
        selector: 'app-game-dialog',
        templateUrl: './game-dialog.component.html',
        styleUrls: ['./game-dialog.component.scss']
    })
    export class GameDialogComponent implements OnInit {

        game: Game; 
        authors: Author[];
        categories: Category[];

        constructor(
            public dialogRef: MatDialogRef<GameDialogComponent>,
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

=== "V0001__Create_Schema.sql"
    ``` SQL hl_lines="20 22 23 24 25 26 27 28 30 31"
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


    DROP TABLE IF EXISTS GAME;

    CREATE TABLE GAME (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(250) NOT NULL,
        age VARCHAR(3) NOT NULL,
        category_id BIGINT DEFAULT NULL,
        author_id BIGINT DEFAULT NULL
    );

    ALTER TABLE GAME ADD FOREIGN KEY (category_id) REFERENCES CATEGORY(id);
    ALTER TABLE GAME ADD FOREIGN KEY (author_id) REFERENCES AUTHOR(id);
    ```
=== "V0002__Create_Data.sql"
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
    INSERT INTO GAME(id, title, age, category_id, author_id) VALUES (7, 'Osopark', '8', 3, 6);
    ```
=== "Game.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game.model;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.ManyToOne;
    import javax.persistence.Table;

    import com.capgemini.coedevon.tutorial.author.model.Author;
    import com.capgemini.coedevon.tutorial.category.model.Category;

    /**
    * @author coedevon
    */
    @Entity
    @Table(name = "Game")
    public class Game {

        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
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
    package com.capgemini.coedevon.tutorial.game.model;

    import com.capgemini.coedevon.tutorial.author.model.AuthorDto;
    import com.capgemini.coedevon.tutorial.category.model.CategoryDto;

    /**
    * @author coedevon
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

### Repository

Para esta ocasión, vamos a necesitar un listado filtrado por título o por categoría, así que necesitaremos pasarle esos datos y filtrar la query. Para el título vamos a buscar por una cadena contenida, así que el parámetro será de tipo `String`, mientras que para la categoría vamos a buscar por su primary key, así que el parámetro será de tipo `Long`.

!!! tip "Búsquedas en BBDD"
    Siempre deberíamos buscar a los hijos por primary keys, nunca hay que hacerlo por una descripción libre ya que el usuario podría teclear el mismo nombre de diferentes formas y no habría manera de buscar correctamente el resultado. Así que siempre que haya un dropdown, se debe filtrar por su ID.

Podríamos utilizar los [QueryMethods](https://www.baeldung.com/spring-data-derived-queries) para que Spring JPA haga su magia, pero en esta ocasión vamos a hacer una implementación concreta de este método de filtrado.
Esta implementación la haremos en un Repository normal, y el resto de métodos nos vendrán dados por un CrudRepository como hemos hecho hasta ahora.

=== "GameRepository.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game;

    import org.springframework.data.repository.CrudRepository;

    import com.capgemini.coedevon.tutorial.game.model.Game;

    /**
    * @author coedevon
    */
    public interface GameRepository extends CrudRepository<Game, Long>, GameCustomRepository {

    }
    ```
=== "GameCustomRepository.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game;

    import java.util.List;

    import com.capgemini.coedevon.tutorial.game.model.Game;

    /**
    * @author coedevon
    *
    */
    public interface GameCustomRepository {

        /**
        * Método para recuperar todas las {@link com.capgemini.coedevon.tutorial.game.model.Game} filtradas
        * @param title
        * @param category
        * @return
        */
        List<Game> findByFilter(String title, Long category);
    }
    ```
=== "GameCustomRepositoryImpl.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game;

    import java.util.List;

    import javax.persistence.EntityManager;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.util.StringUtils;

    import com.capgemini.coedevon.tutorial.game.model.Game;
    import com.devonfw.module.basic.common.api.query.LikePatternSyntax;
    import com.devonfw.module.jpa.dataaccess.api.QueryUtil;
    import com.querydsl.core.alias.Alias;
    import com.querydsl.jpa.impl.JPAQuery;

    /**
    * @author coedevon
    *
    */
    public class GameCustomRepositoryImpl implements GameCustomRepository {

        @Autowired
        private EntityManager entityManager;

        /**
        * {@inheritDoc}
        */
        public List<Game> findByFilter(String title, Long category) {

            Game alias = Alias.alias(Game.class);
            JPAQuery<Game> query = new JPAQuery<Game>(this.entityManager).from(Alias.$(alias));

            if (StringUtils.hasText(title)) {
                QueryUtil.get().whereLike(query, Alias.$(alias.getTitle()), title, LikePatternSyntax.SQL, true, true);
            }

            if (category != null) {
                query.where(Alias.$(alias.getCategory().getId()).eq(category));
            }

            return query.fetch();
        }

    }
    ```

No se puede implementar un `CrudRepository` ya que es una interface que tiene su propia implementación en Spring JPA. El truco que podemos hacer es crear una interface y una implementación custom con los métodos que necesitemos y en nuestro `GameRepository` extender la interface custom.

De esta forma únicamente utilizamos un objeto `Repository`, pero realmente Spring JPA provee los métodos de Crud y nosotros proveemos los métodos custom.

La implementación de las queries que hagamos dentro del custom repository ya es cosa nuestra y podemos utilizar lo que necesitemos. En este caso hemos optado por utilizar Criteria para hacer la Query ayudándonos de unas clases de utilidad que provee Devonfw, muy recomendables para hacer queries paginadas. 

### Service

Siguiente paso, la capa de lógica, es decir el `Service`.

=== "GameService.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game;

    import java.util.List;

    import com.capgemini.coedevon.tutorial.game.model.Game;
    import com.capgemini.coedevon.tutorial.game.model.GameDto;

    /**
    * @author coedevon
    */
    public interface GameService {

        /**
        * Método para recuperar todas las {@link com.capgemini.coedevon.tutorial.game.model.Game} filtradas
        * @param title
        * @param category
        * @return
        */
        List<Game> findByFilter(String title, Long category);

        /**
        * Método para crear o actualizar una {@link com.capgemini.coedevon.tutorial.game.model.Game}
        * @param dto
        * @return
        */
        public Game save(GameDto dto);

    }
    ```
=== "GameServiceImpl.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game;

    import java.util.List;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.capgemini.coedevon.tutorial.game.model.Game;
    import com.capgemini.coedevon.tutorial.game.model.GameDto;

    /**
    * @author coedevon
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
        public List<Game> findByFilter(String title, Long category) {

            return this.gameRepository.findByFilter(title, category);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public Game save(GameDto dto) {

            Game game = null;
            if (dto.getId() != null)
                game = this.gameRepository.findById(dto.getId()).orElse(null);
            else
                game = new Game();

            BeanUtils.copyProperties(dto, game, "author", "category");

            //TODO: Setear categoria y autor

            return this.gameRepository.save(game);
        }

    }
    ```

En este `Service` volvemos a utilizar el List en lugar del Page, y hemos eliminado el método `delete` ya que no se pueden borrar juegos. Pero, la novedad está en el `save`. Si recuerdas, un `Game` tiene una relación con `Author` y otra relación con `Category`. Estas relaciones se hacen a nivel de `Entity`, sin embargo en nuestro dto de entrada al método `GameDto` estamos tratando con `CategoryDto` y `AuthorDto`.

Una solución podría ser convertir esos DTOs a `Entity`, pero esto podría llevar a duplicidades en la cache interna de JPA, así que mejor no utilizar esta solución.

Lo correcto es realizar consultas a la BBDD y traernos esas entities. Pero si recuerdas las reglas básicas, un `Repository` debe pertenecer a un solo `Service`, por lo que en lugar de llamar a métodos de los `AuthorRepository` y `CategoryRepository` desde nuestro `GameService`, debemos llamar a métodos expuestos en `AuthorService` y `CategoryService`. Para ello necesitaremos crear esos métodos get en los otros `Services`. Quedaría algo así:

=== "AuthorService.java"
    ``` Java hl_lines="15 16 17 18 19 20"
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
        * Recupera un {@link com.capgemini.coedevon.tutorial.author.model.Author} a través de su ID
        * @param id
        * @return
        */
        Author get(Long id);

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
    ``` Java hl_lines="24 25 26 27 28 29 30 31 50"
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
        public Author save(AuthorDto data) {

            Author categoria = null;
            if (data.getId() != null)
                categoria = get(data.getId());
            else
                categoria = new Author();

            BeanUtils.copyProperties(data, categoria);

            return this.authorRepository.save(categoria);
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
=== "CategoryService.java"
    ``` Java hl_lines="14 15 16 17 18 19"
    package com.capgemini.coedevon.tutorial.category;

    import java.util.List;

    import com.capgemini.coedevon.tutorial.category.model.Category;
    import com.capgemini.coedevon.tutorial.category.model.CategoryDto;

    /**
    * @author coedevon
    *
    */
    public interface CategoryService {

        /**
        * Recupera una {@link com.capgemini.coedevon.tutorial.category.model.Category} a partir de su ID
        * @param id
        * @return
        */
        Category get(Long id);

        /**
        * Método para recuperar todas las {@link com.capgemini.coedevon.tutorial.category.model.Category}
        * @return
        */
        List<Category> findAll();

        /**
        * Método para crear o actualizar una {@link com.capgemini.coedevon.tutorial.category.model.Category}
        * @param dto
        * @return
        */
        Category save(CategoryDto dto);

        /**
        * Método para borrar una {@link com.capgemini.coedevon.tutorial.category.model.Category}
        * @param id
        */
        void delete(Long id);
    }
    ```
=== "CategoryServiceImpl.java"
    ``` Java hl_lines="22 23 24 25 26 27 28 29 48"
    package com.capgemini.coedevon.tutorial.category;

    import java.util.List;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.capgemini.coedevon.tutorial.category.model.Category;
    import com.capgemini.coedevon.tutorial.category.model.CategoryDto;

    /**
    * @author coedevon
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
        public Category save(CategoryDto dto) {

            Category categoria = null;
            if (dto.getId() != null)
                categoria = get(dto.getId());
            else
                categoria = new Category();

            BeanUtils.copyProperties(dto, categoria);

            return this.categoryRepository.save(categoria);
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


Y ahora ya podemos implementar correctamente nuestro `Service`.

=== "GameServiceImpl.java"
    ``` Java hl_lines="28 29 31 32 57 58 60 61"
    package com.capgemini.coedevon.tutorial.game;

    import java.util.List;

    import javax.transaction.Transactional;

    import org.springframework.beans.BeanUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.capgemini.coedevon.tutorial.author.AuthorService;
    import com.capgemini.coedevon.tutorial.author.model.Author;
    import com.capgemini.coedevon.tutorial.category.CategoryService;
    import com.capgemini.coedevon.tutorial.category.model.Category;
    import com.capgemini.coedevon.tutorial.game.model.Game;
    import com.capgemini.coedevon.tutorial.game.model.GameDto;

    /**
    * @author coedevon
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
        public List<Game> findByFilter(String title, Long category) {

            return this.gameRepository.findByFilter(title, category);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public Game save(GameDto dto) {

            Game game = null;
            if (dto.getId() != null)
                game = this.gameRepository.findById(dto.getId()).orElse(null);
            else
                game = new Game();

            BeanUtils.copyProperties(dto, game, "author", "category");

            Author author = this.authorService.get(dto.getAuthor().getId());
            game.setAuthor(author);

            Category category = this.categoryService.get(dto.getCategory().getId());
            game.setCategory(category);

            return this.gameRepository.save(game);
        }

    }
    ```

### Controller

Después de todo este mareo, ya podemos terminar ocn la última capa. Vamos a implementar el `Controller` para que ataque a la capa de `Service`, con los endpoints de las operaciones que vamos a publicar. Además, para realizar la búsqueda necesitaremos un nuevo `DTO` como ya vimos en el ejemplo del listado paginado.

=== "GameController.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.web.bind.annotation.CrossOrigin;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;

    import com.capgemini.coedevon.tutorial.config.mapper.BeanMapper;
    import com.capgemini.coedevon.tutorial.game.model.GameDto;
    import com.capgemini.coedevon.tutorial.game.model.GameSearchDto;

    /**
    * @author coedevon
    */
    @RequestMapping(value = "/game/v1")
    @RestController
    @CrossOrigin(origins = "*")
    public class GameController {

        @Autowired
        GameService gameService;

        @Autowired
        BeanMapper beanMapper;

        /*
        * Método para recuperar todos los {@link com.capgemini.coedevon.tutorial.game.model.Game} filtrados
        * @return
        */
        @RequestMapping(path = "/", method = RequestMethod.POST)
        public List<GameDto> findByFilter(@RequestBody GameSearchDto dto) {

            return this.beanMapper.mapList(this.gameService.findByFilter(dto.getTitle(), dto.getCategoryId()), GameDto.class);
        }

        /**
        * Método para crear o actualizar un {@link com.capgemini.coedevon.tutorial.game.model.Game}
        * @param dto
        * @return
        */
        @RequestMapping(path = "/", method = RequestMethod.PUT)
        public GameDto save(@RequestBody GameDto dto) {

            return this.beanMapper.map(this.gameService.save(dto), GameDto.class);
        }

    }

    ```
=== "GameSearchDto.java"
    ``` Java
    package com.capgemini.coedevon.tutorial.game.model;

    /**
    * @author coedevon
    */
    public class GameSearchDto {

        private String title;

        private Long categoryId;

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
        * @return categoryId
        */
        public Long getCategoryId() {

            return this.categoryId;
        }

        /**
        * @param categoryId new value of {@link #getcategoryId}.
        */
        public void setCategoryId(Long categoryId) {

            this.categoryId = categoryId;
        }

    }
    ```

Pues con esto ya tendríamos todas las consultas de `Game` implementadas. Ahora solo falta probarlas.

### Prueba de las operaciones

Si ahora levantamos la aplicación y probamos con el postman, podemos ver los resultados que nos ofrece el back.

** POST ** nos devuelve un listado paginado de `Juegos`, fíjate bien en la petición donde envíamos los filtros y la respuesta que tiene los objetos `Categoria` y `Autor` incluídos.

![step5-java1](../assets/images/step5-java1.png)

** PUT ** nos sirve para insertar `Juegos` nuevos (si no tienen el id informado) o para actualizar `Juegos` (si tienen el id informado). Fíjate que para enlazar `Categoria` y `Autor` tan solo hace falta el id de cada no de ellos, ya que en el método `save` se hace una consulta `get` para recuperarlos por su id. Además que no tendría sentido enviar toda la información de esas entidades ya que no estás dando de alta una `Categoria` ni un `Autor`.

![step5-java2](../assets/images/step5-java2.png)
![step5-java3](../assets/images/step5-java3.png)


### Implementar listado Autores

Como hemos visto anteriormente en la parte de frontend, para la edición de un `Juego` nos hace falta un método que devuelva un listado de `Autores`, ya que ahora mismo la operación que tenemos implementada devuelve un objeto `Page`.

Así que antes de finalizar la implementación de backend, vamos a desarrollar esta nueva operación. Por supuesto, respetaremos las operaciones previas que ya existían.

=== "AuthorController.java"
    ``` Java hl_lines="32 33 34 35 36 37 38 39 40 41"
    package com.capgemini.coedevon.tutorial.author;

    import java.util.List;

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
        @RequestMapping(path = "/", method = RequestMethod.GET)
        public List<AuthorDto> list() {

            return this.beanMapper.mapList(this.authorService.list(), AuthorDto.class);
        }

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
=== "AuthorService.java"
    ``` Java hl_lines="44 45 46 47 48"
    package com.capgemini.coedevon.tutorial.author;

    import java.util.List;

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
        * Recupera un {@link com.capgemini.coedevon.tutorial.author.model.Author} a través de su ID
        * @param id
        * @return
        */
        Author get(Long id);

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

        /**
        * Método para recuperar un listado completo de {@link com.capgemini.coedevon.tutorial.author.model.Author}
        * @return
        */
        List<Author> list();

    }
    ```
=== "AuthorServiceImpl.java"
    ``` Java hl_lines="70 71 72 73 74 75 76 77"
    package com.capgemini.coedevon.tutorial.author;

    import java.util.List;

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
        public Author save(AuthorDto data) {

            Author categoria = null;
            if (data.getId() != null)
                categoria = get(data.getId());
            else
                categoria = new Author();

            BeanUtils.copyProperties(data, categoria);

            return this.authorRepository.save(categoria);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public void delete(Long id) {

            this.authorRepository.deleteById(id);
        }

        /**
        * {@inheritDoc}
        */
        @Override
        public List<Author> list() {

            return (List<Author>) this.authorRepository.findAll();
        }

    }
    ```

Ahora sí, todo listo para seguir al siguiente punto.

## Conectar front con back

Una vez implementado front y back, lo que nos queda es modificar el servicio del front para que conecte directamente con las operaciones ofrecidas por el back.

=== "author-service.ts"
    ``` Typescript hl_lines="29 30 31"
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

        getAllAuthors(): Observable<Author[]> {
            return this.http.get<Author[]>('http://localhost:8080/author/v1/');
        }

    }
    ```
=== "game-service.ts"
    ``` Typescript hl_lines="12 16 17 18 19 20 21 22 26"
    import { Injectable } from '@angular/core';
    import { Game } from 'src/app/models/games/Game';
    import { Observable, of } from 'rxjs';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
        providedIn: 'root'
    })
    export class GameService {

        constructor(
            private http: HttpClient
        ) { }

        getGames(title?: String, categoryId?: number): Observable<Game[]> {

            let data = {
                title: title != null ? title : null, 
                categoryId: categoryId != null ? categoryId : null
            };

            return this.http.post<Game[]>('http://localhost:8080/game/v1/', data);
        }

        saveGame(game: Game): Observable<Game> {
            return this.http.put<Game>('http://localhost:8080/game/v1/', game);
        }

    }
    ```


