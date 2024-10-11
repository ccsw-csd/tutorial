# Listado filtrado - Angular

En este punto ya tenemos dos listados, uno básico y otro paginado. Ahora vamos a implementar un listado un poco diferente, con filtros y con una presentación un tanto distinta.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

## Crear componentes

Vamos a desarrollar el listado de `Juegos`. Este listado es un tanto peculiar, porque no tiene una tabla como tal, sino que tiene una tabla con "tiles" para cada uno de los juegos. Necesitaremos un componente para el listado y otro componente para el detalle del juego. También necesitaremos otro componente para el diálogo de edición / alta.

Manos a la obra:

```
ng generate component game/game-list
ng generate component game/game-list/game-item
ng generate component game/game-edit

ng generate service game/game
```

## Crear el modelo 

Lo primero que vamos a hacer es crear el modelo en `game/model/Game.ts` con todas las propiedades necesarias para trabajar con un juego:

=== "Game.ts"
    ``` TypeScript
    import { Author } from "../../author/model/Author";
    import { Category } from "../../category/model/Category";

    export class Game {
        id: number;
        title: string;
        age: number;
        category: Category;
        author: Author;
    }
    ```

Como ves, el juego tiene dos objetos para mapear categoría y autor.

## Añadir el punto de entrada

Añadimos la ruta al menú para que podamos navegar a esta pantalla:

=== "app.routes.ts"
    ``` TypeScript hl_lines="4 7"
    import { Routes } from '@angular/router';

    export const routes: Routes = [
        { path: '', redirectTo: '/games', pathMatch: 'full'},
        { path: 'categories', loadComponent: () => import('../category/category-list/category-list.component').then(m => m.CategoryListComponent)},
        { path: 'authors', loadComponent: () => import('../author/author-list/author-list.component').then(m => m.AuthorListComponent)},
        { path: 'games', loadComponent: () => import('../game/game-list/game-list.component').then(m => m.GameListComponent)}
    ];
    ```

Además, hemos añadido una regla adicional con el path vacío para indicar que si no pone ruta, por defecto la página inicial redirija al path `/games`, que es nuevo path que hemos añadido.


## Implementar servicio

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

        getGames(title?: string, categoryId?: number): Observable<Game[]> {
            return of(GAME_DATA);
        }

        saveGame(game: Game): Observable<void> {
            return of(null);
        }

    }
    ```

## Implementar listado

Ya tenemos las operaciones del servicio con datos, así que ahora vamos a por el listado filtrado.


=== "game-list.component.html"
    ``` HTML
    <div class="container">
        <h1>Catálogo de juegos</h1>

        <div class="filters">
            <form>
                <mat-form-field>
                    <mat-label>Título del juego</mat-label>
                    <input
                        type="text"
                        matInput
                        placeholder="Título del juego"
                        [(ngModel)]="filterTitle"
                        name="title"
                    />
                </mat-form-field>

                <mat-form-field>
                    <mat-label>Categoría del juego</mat-label>
                    <mat-select disableRipple [(ngModel)]="filterCategory" name="category">
                        @for (category of categories; track category.id) {
                            <mat-option [value]="category">{{ category.name }}</mat-option>
                        }
                    </mat-select>
                </mat-form-field>
            </form>

            <div class="buttons">
                <button mat-stroked-button (click)="onCleanFilter()">Limpiar</button>
                <button mat-stroked-button (click)="onSearch()">Filtrar</button>
            </div>
        </div>

        <div class="game-list">
            @for (game of games; trackBy game.id) {
                <app-game-item (click)="editGame(game)" />
            }
        </div>

        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createGame()">
                Nuevo juego
            </button>
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
    import { GameEditComponent } from '../game-edit/game-edit.component';
    import { GameService } from '../game.service';
    import { Game } from '../model/Game';
    import { CategoryService } from '../../category/category.service';
    import { Category } from '../../category/model/Category';
    import { CommonModule } from '@angular/common';
    import { MatButtonModule } from '@angular/material/button';
    import { MatIconModule } from '@angular/material/icon';
    import { MatTableModule } from '@angular/material/table';
    import { FormsModule } from '@angular/forms';
    import { MatFormFieldModule } from '@angular/material/form-field';
    import { MatInputModule } from '@angular/material/input';
    import { MatSelectModule } from '@angular/material/select';
    import { GameItemComponent } from './game-item/game-item.component';

    @Component({
        selector: 'app-game-list',
        standalone: true,
        imports: [
            MatButtonModule,
            MatIconModule,
            MatTableModule,
            CommonModule,
            FormsModule,
            MatFormFieldModule,
            MatInputModule,
            MatSelectModule,
            GameItemComponent
        ],
        templateUrl: './game-list.component.html',
        styleUrl: './game-list.component.scss',
    })
    export class GameListComponent implements OnInit {
        categories: Category[];
        games: Game[];
        filterCategory: Category;
        filterTitle: string;

        constructor(
            private gameService: GameService,
            private categoryService: CategoryService,
            public dialog: MatDialog
        ) {}

        ngOnInit(): void {
            this.gameService.getGames().subscribe((games) => (this.games = games));

            this.categoryService
                .getCategories()
                .subscribe((categories) => (this.categories = categories));
        }

        onCleanFilter(): void {
            this.filterTitle = null;
            this.filterCategory = null;
            this.onSearch();
        }

        onSearch(): void {
            const title = this.filterTitle;
            const categoryId =
                this.filterCategory != null ? this.filterCategory.id : null;

            this.gameService
                .getGames(title, categoryId)
                .subscribe((games) => (this.games = games));
        }

        createGame() {
            const dialogRef = this.dialog.open(GameEditComponent, {
                data: {},
            });

            dialogRef.afterClosed().subscribe((result) => {
                this.ngOnInit();
            });
        }

        editGame(game: Game) {
            const dialogRef = this.dialog.open(GameEditComponent, {
                data: { game: game },
            });

            dialogRef.afterClosed().subscribe((result) => {
                this.onSearch();
            });
        }
    }
    ```
Con todos estos cambios y si refrescamos el navegador, debería verse una pantalla similar a esta:

![step5-angular1](../../assets/images/step5-angular1.png)

Tenemos una pantalla con una sección de filtros en la parte superior, donde podemos introducir un texto o seleccionar una categoría de un dropdown, un listado que de momento tiene todos los componentes básicos en una fila, uno detrás del otro, y un botón para crear juegos nuevos.

!!! tip "Dropdown"
    El componente `Dropdown` es uno de los componentes más utilizados en las pantallas y formularios de Angular. Ves familiarizándote con él porque lo vas a usar mucho. Es bastante potente y medianamente sencillo de utilizar. Los datos del listado pueden ser dinámicos (desde servidor) o estáticos (si los valores ya los tienes prefijados).


## Implementar detalle del item

Ahora vamos a implementar el detalle de cada uno de los items que forman el listado. Para ello lo primero que haremos será pasarle la información del juego a cada componente como un dato de entrada `Input` hacia el componente.

=== "game-list.component.html"
    ``` HTML hl_lines="35"
    <div class="container">
        <h1>Catálogo de juegos</h1>

        <div class="filters">
            <form>
                <mat-form-field>
                    <mat-label>Título del juego</mat-label>
                    <input
                        type="text"
                        matInput
                        placeholder="Título del juego"
                        [(ngModel)]="filterTitle"
                        name="title"
                    />
                </mat-form-field>

                <mat-form-field>
                    <mat-label>Categoría del juego</mat-label>
                    <mat-select disableRipple [(ngModel)]="filterCategory" name="category">
                        @for (category of categories; track category.id) {
                            <mat-option [value]="category">{{ category.name }}</mat-option>
                        }
                    </mat-select>
                </mat-form-field>
            </form>

            <div class="buttons">
                <button mat-stroked-button (click)="onCleanFilter()">Limpiar</button>
                <button mat-stroked-button (click)="onSearch()">Filtrar</button>
            </div>
        </div>

        <div class="game-list">
            @for (game of games; track game.id) {
                <app-game-item (click)="editGame(game)" [game]="game" />
            }
        </div>

        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createGame()">
                Nuevo juego
            </button>
        </div>
    </div>

    ```

También vamos a necesitar una foto de ejemplo para poner dentro de la tarjeta detalle de los juegos. Vamos a utilizar esta imagen:

<img src="../../../assets/images/foto.png" width="100">

Descárgala y déjala dentro del proyecto en `public/img/foto.png`. Y ya para terminar, implementamos el componente de detalle:

=== "game-item.component.html"
    ``` HTML
    <div class="container">
        <mat-card>
            <div class="photo">
                <img src="img/foto.png">
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
            padding: 1rem;

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
    ``` TypeScript hl_lines="13"
    import { Component, OnInit, Input } from '@angular/core';
    import { Game } from '../../model/Game';
    import {MatCardModule} from '@angular/material/card';

    @Component({
        selector: 'app-game-item',
        standalone: true,
        imports: [MatCardModule],
        templateUrl: './game-item.component.html',
        styleUrl: './game-item.component.scss'
    })
    export class GameItemComponent {
        @Input() game: Game;
    }

    ```

Ahora sí que debería quedar algo similar a esta pantalla:

![step5-angular2](../../assets/images/step5-angular2.png)


## Implementar diálogo de edición

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
    ``` TypeScript hl_lines="7 31-33"
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Pageable } from '../core/model/page/Pageable';
    import { Author } from './model/Author';
    import { AuthorPage } from './model/AuthorPage';
    import { HttpClient } from '@angular/common/http';
    import { AUTHOR_DATA_LIST } from './model/mock-authors-list';

    @Injectable({
        providedIn: 'root',
    })
    export class AuthorService {
    constructor(private http: HttpClient) {}

        private baseUrl = 'http://localhost:8080/author';

        getAuthors(pageable: Pageable): Observable<AuthorPage> {
            return this.http.post<AuthorPage>(this.baseUrl, { pageable: pageable });
        }

        saveAuthor(author: Author): Observable<Author> {
            const { id } = author;
            const url = id ? `${this.baseUrl}/${id}` : this.baseUrl;
            return this.http.put<Author>(url, author);
        }

        deleteAuthor(idAuthor: number): Observable<void> {
            return this.http.delete<void>(`${this.baseUrl}/${idAuthor}`);
        }

        getAllAuthors(): Observable<Author[]> {
            return of(AUTHOR_DATA_LIST);
        }
    }
    ```    

Ahora sí que tenemos todo listo para implementar el cuadro de diálogo para dar de alta o editar juegos.

=== "game-edit.component.html"
    ``` HTML
    <div class="container">
        @if (game.id) {
            <h1>Modificar juego</h1>
        } @else {
            <h1>Crear juego</h1>
        }

        <form>
            <mat-form-field>
                <mat-label>Identificador</mat-label>
                <input type="text" matInput placeholder="Identificador" [(ngModel)]="game.id" name="id" disabled>
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
                    @for (category of categories; track category.id) {
                        <mat-option [value]="category">{{category.name}}</mat-option>
                    }
                </mat-select>
                <mat-error>La categoría no puede estar vacía</mat-error>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Autor</mat-label>
                <mat-select disableRipple [(ngModel)]="game.author" name="author" required>
                    @for (author of authors; track author.id) {
                        <mat-option [value]="author">{{author.name}}</mat-option>
                    }
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
        padding: 20px;
    
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
    import { GameService } from '../game.service';
    import { Game } from '../model/Game';
    import { AuthorService } from '../../author/author.service';
    import { Author } from '../../author/model/Author';
    import { CategoryService } from '../../category/category.service';
    import { Category } from '../../category/model/Category';
    import { FormsModule, ReactiveFormsModule } from '@angular/forms';
    import { MatButtonModule } from '@angular/material/button';
    import { MatFormFieldModule } from '@angular/material/form-field';
    import { MatInputModule } from '@angular/material/input';
    import { MatSelectModule } from '@angular/material/select';

    @Component({
        selector: 'app-game-edit',
        standalone: true,
        imports: [FormsModule, ReactiveFormsModule, MatFormFieldModule, MatInputModule, MatButtonModule, MatSelectModule ],
        templateUrl: './game-edit.component.html',
        styleUrl: './game-edit.component.scss',
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
            private authorService: AuthorService
        ) {}

        ngOnInit(): void {
            this.game = this.data.game ? Object.assign({}, this.data.game) : new Game();

            this.categoryService.getCategories().subscribe((categories) => {
                this.categories = categories;

                if (this.game.category != null) {
                    const categoryFilter: Category[] = categories.filter(
                        (category) => category.id == this.data.game.category.id
                    );
                    if (categoryFilter != null) {
                        this.game.category = categoryFilter[0];
                    }
                }
            });

            this.authorService.getAllAuthors().subscribe((authors) => {
                this.authors = authors;

                if (this.game.author != null) {
                    const authorFilter: Author[] = authors.filter(
                        (author) => author.id == this.data.game.author.id
                    );
                    if (authorFilter != null) {
                        this.game.author = authorFilter[0];
                    }
                }
            });
        }

        onSave() {
            this.gameService.saveGame(this.game).subscribe((result) => {
                this.dialogRef.close();
            });
        }

        onClose() {
            this.dialogRef.close();
        }
    }
    ```

Como puedes ver, para rellenar los componentes seleccionables de dropdown, hemos realizado una consulta al servicio para recuperar todos los autores y categorías, y en la respuesta de cada uno de ellos, hemos buscado en los resultados cuál es el que coincide con el ID enviado desde el listado, y ese es el que hemos fijado en el objeto `Game`.

De esta forma, no estamos cogiendo directamente los datos del listado, sino que no estamos asegurando que los datos de autor y de categoría son los que vienen del servicio, siempre filtrando por su ID.


## Conectar con Backend

!!! warning "Antes de seguir"
    Antes de seguir con este punto, debes implementar el código de backend en la tecnología que quieras ([Springboot](springboot.md) o [Nodejs](nodejs.md)). Si has empezado este capítulo implementando el frontend, por favor accede a la sección correspondiente de backend para poder continuar con el tutorial. Una vez tengas implementadas todas las operaciones para este listado, puedes volver a este punto y continuar con Angular.


Una vez implementado front y back, lo que nos queda es modificar el servicio del front para que conecte directamente con las operaciones ofrecidas por el back.

=== "author-service.ts"
    ``` Typescript hl_lines="30-32"
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Pageable } from '../core/model/page/Pageable';
    import { Author } from './model/Author';
    import { AuthorPage } from './model/AuthorPage';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
        providedIn: 'root',
    })
    export class AuthorService {
        constructor(private http: HttpClient) {}

        private baseUrl = 'http://localhost:8080/author';

        getAuthors(pageable: Pageable): Observable<AuthorPage> {
            return this.http.post<AuthorPage>(this.baseUrl, { pageable: pageable });
        }

        saveAuthor(author: Author): Observable<Author> {
            const { id } = author;
            const url = id ? `${this.baseUrl}/${id}` : this.baseUrl;
            return this.http.put<Author>(url, author);
        }

        deleteAuthor(idAuthor: number): Observable<void> {
            return this.http.delete<void>(`${this.baseUrl}/${idAuthor}`);
        }

        getAllAuthors(): Observable<Author[]> {
            return this.http.get<Author[]>(this.baseUrl);
        }
    }
    ```
=== "game-service.ts"
    ``` Typescript hl_lines="11 17 20-25 27-37"
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Game } from './model/Game';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
    providedIn: 'root',
    })
    export class GameService {
        constructor(
            private http: HttpClient
        ) {}

        private baseUrl = 'http://localhost:8080/game';

        getGames(title?: string, categoryId?: number): Observable<Game[]> {
            return this.http.get<Game[]>(this.composeFindUrl(title, categoryId));
        }

        saveGame(game: Game): Observable<void> {
            const { id } = game;
            const url = id ? `${this.baseUrl}/${id}` : this.baseUrl;

            return this.http.put<void>(url, game);
        }

        private composeFindUrl(title?: string, categoryId?: number): string {
            const params = new URLSearchParams();
            if (title) {
              params.set('title', title);
            }  
            if (categoryId) {
                params.set('idCategory', categoryId.toString());
            }
            const queryString = params.toString();
            return queryString ? `${this.baseUrl}?${queryString}` : this.baseUrl;
        }
    }
    ```

Y ahora si, podemos navegar por la web y ver el resultado completo.