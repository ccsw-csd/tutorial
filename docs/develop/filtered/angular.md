# Listado filtrado - Angular

En este punto ya tenemos dos listados, uno básico y otro paginado. Ahora vamos a implementar un listado un poco diferente, con filtros y con una presentación un tanto distinta.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

## Crear componentes

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



## Crear el modelo 

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

## Añadir el punto de entrada

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

        getGames(title?: String, categoryId?: number): Observable<Game[]> {
            return of(GAME_DATA);
        }

        saveGame(game: Game): Observable<void> {
            return of(null);
        }

    }
    ```

## Implementar listado

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

![step5-angular1](../../assets/images/step5-angular1.png)

Tenemos una pantalla con una sección de filtros en la parte superior, donde podemos introducir un texto o seleccionar una categoría de un dropdown, un listado que de momento tiene todos los componentes básicos en una fila uno detrás del otro, y un botón para crear juegos nuevos.

!!! tip "Dropdown"
    El componente `Dropdown` es uno de los componentes más utilizados en las pantallas y formularios de Angular. Ves familiarizándote con él porque lo vas a usar mucho. Es bastante potente y medianamente sencillo de utilizar. Los datos del listado pueden ser dinámicos (desde servidor) o estáticos (si los valores ya los tienes prefijados).


## Implementar detalle del item

Ahora vamos a implementar el detalle de cada uno de los items que forman el listado. Para ello lo primero que haremos será pasarle la información del juego a cada componente como un dato de entrada `Input` hacia el componente.

=== "game-list.component.html"
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

<img src="../../../assets/images/foto.png" width="100">

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

![step5-angular2](../../assets/images/step5-angular2.png)


## Implementar dialogo de edición

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

                    if (this.game.category != null) {
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

                    if (this.game.author != null) {
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


## Conectar con Backend

!!! warning "Antes de seguir"
    Antes de seguir con este punto, debes implementar el código de backend en la tecnología que quieras ([Springboot](springboot.md) o [Nodejs](nodejs.md)). Si has empezado este capítulo implementando el frontend, por favor accede a la sección correspondiente de backend para poder continuar con el tutorial. Una vez tengas implementadas todas las operaciones para este listado, puedes volver a este punto y continuar con Angular.


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