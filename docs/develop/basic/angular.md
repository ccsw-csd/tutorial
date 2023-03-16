# Listado simple - Angular

Ahora que ya tenemos listo el proyecto frontend de Angular (en el puerto 4200), ya podemos empezar a codificar la solución.

## Primeros pasos

!!! success "Antes de empezar"
    Quiero hacer hincapié que Angular tiene una documentación muy extensa y completa, así que te recomiendo que hagas uso de ella cuando tengas cualquier duda. Tanto en la propia web de documentación de [Angular](https://angular.io/docs) como en la web de componentes [Angular Material](https://material.angular.io/components/categories) puedes buscar casi cualquier ejemplo que necesites.


Si abrimos el proyecto con el IDE que tengamos (Visual Studio Code en el caso del tutorial) podemos ver que en la carpeta `src/app` existen unos ficheros ya creados por defecto. Estos ficheros son:

* `app.component.ts` → contiene el código inicial del proyecto escrito en TypeScript.
* `app.component.html` → contiene la plantilla inicial del proyecto escrita en HTML.
* `app.component.scss` → contiene los estilos CSS privados de la plantilla inicial.

Vamos a modificar este código inicial para ver como funciona. Abrimos el fichero `app.component.ts` y modificamos la línea donde se asigna un valor a la variable `title`.

=== "app.component.ts"
    ``` TypeScript
    ...
    title = 'Tutorial de Angular';
    ...
    ```

Ahora abrimos el fichero `app.component.html`, borramos todo el código de la plantilla y añadimos el siguiente código:

=== "app.component.html"
    ``` HTML
    <h1>{{title}}</h1>
    ```

Las llaves dobles permiten hacen un binding entre el código del componente y la plantilla. Es decir, en este caso irá al código TypeScript y buscará el valor de la variable `title`.

!!! tip "Consejo"
    El binding también nos sirve para ejecutar los métodos de TypeScript desde el código HTML. Además si el valor que contiene la variable se modificara durante la ejecución de algún método, automáticamente el código HTML refrescaría el nuevo valor de la variable `title` 

Si abrimos el navegador y accedemos a `http://localhost:4200/` podremos ver el resultado del código.


## Layout general
### Crear componente

Lo primero que vamos a hacer es escoger un tema y una paleta de componentes para trabajar. Lo más cómodo es trabajar con `Material` que ya viene perfectamente integrado en Angular. Ejecutamos el comando y elegimos la paleta de colores que más nos guste o bien creamos una custom:

```
ng add @angular/material
```

!!! todo "Recuerda"
    Al añadir una nueva librería tenemos que parar el servidor y volver a arrancarlo para que compile y precargue las nuevas dependencias.

Una vez añadida la dependencia, lo que queremos es crear una primera estructura inicial a la página. Si te acuerdas cual era la estructura (y si no te acuerdas, vuelve a la sección `Contexto de la aplicación` y lo revisas), teníamos una cabecera superior con un logo y título y unas opciones de menú.

Pues vamos a ello, crearemos esa estructura común para toda la aplicación. Este componente al ser algo core para toda la aplicación deberíamos crearlo dentro del módulo `core` como ya vimos anteriormente.

Pero antes de todo, vamos a crear los módulos generales de la aplicación, así que ejecutamos en consola el comando que nos permite crear un módulo nuevo:

```
ng generate module core
```

Y añadimos esos módulos al módulo padre de la aplicación:

=== "app.module.ts"
``` Typescript hl_lines="7 16"
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CoreModule } from './core/core.module';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    CoreModule,
    BrowserAnimationsModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```


Y después crearemos el componente header, dentro del módulo core. Para eso ejecutaremos el comando:

```
ng generate component core/header
```

### Código de la pantalla

Esto nos creará una carpeta con los ficheros del componente, donde tendremos que copiar el siguiente contenido:

=== "header.component.html"
    ``` HTML
    <mat-toolbar>
        <mat-toolbar-row>
            <div class="header_container">
                <div class="header_title">              
                    <mat-icon>storefront</mat-icon> Ludoteca Tan
                </div>

                <div class="header_separator"> | </div>

                <div class="header_menu">
                    <div class="header_button">
                        <a routerLink="/games" routerLinkActive="active">Catálogo</a>
                    </div>
                    <div class="header_button">
                        <a routerLink="/categories" routerLinkActive="active">Categorías</a>
                    </div>
                    <div class="header_button">
                        <a routerLink="/authors" routerLinkActive="active">Autores</a>
                    </div>
                </div>
                
                <div class="header_login">
                    <mat-icon>account_circle</mat-icon> Sign in
                </div>
            </div>
        </mat-toolbar-row>
    </mat-toolbar>
    ```
=== "header.component.scss"
    ``` CSS
    .mat-toolbar {
      background-color: blue;
      color: white;
    }

    .header_container {
        display: flex;
        width: 100%;
        .header_title {
            .mat-icon {
                vertical-align: sub;
            }
        }

        .header_separator {
            margin-left: 30px;
            margin-right: 30px;
        }

        .header_menu {
            flex-grow: 4;
            display: flex;
            flex-direction: row;

            .header_button {
                margin-left: 1em;
                margin-right: 1em;
                font-size: 16px;
              
                a {
                  font-weight: lighter;
                  text-decoration: none;
                  cursor: pointer;
                  color: white;
                }

                a:hover {
                  color: grey;
                }

                a.active {
                  font-weight: normal;
                  text-decoration: underline;
                  color: lightyellow;
                }

            }
        }

        .header_login {
          font-size: 16px;
          cursor: pointer;
          .mat-icon {
              vertical-align: sub;
          }
      }
    }
    ```

Al utilizar etiquetas de material como `mat-toolbar` o `mat-icon` y `routerLink` necesitaremos importar las dependencias. Esto lo podemos hacer directamente en el módulo del que depende, es decir en el fichero `core.module.ts`

=== "core.module.ts"
    ``` Typescript hl_lines="3 4 6 13 14 15 17 18 19"
    import { NgModule } from '@angular/core';
    import { CommonModule } from '@angular/common';
    import { MatIconModule } from '@angular/material/icon';
    import { MatToolbarModule } from '@angular/material/toolbar';
    import { HeaderComponent } from './header/header.component';
    import { RouterModule } from '@angular/router';


    @NgModule({
      declarations: [HeaderComponent],
      imports: [
        CommonModule,
        RouterModule,
        MatIconModule, 
        MatToolbarModule,
      ],
      exports: [
        HeaderComponent
      ]
    })
    export class CoreModule { }
    ```

Además de añadir las dependencias, diremos que este módulo va a exportar el componente `HeaderComponent` para poder utilizarlo desde otras páginas.

Ya por último solo nos queda modificar la página general de la aplicación `app.component.html` para añadirle el componente `HeaderComponent`.

=== "app.component.html"
    ``` HTML hl_lines="2"
    <div>
      <app-header></app-header>
      <div>
        <router-outlet></router-outlet>
      </div>
    </div>
    ```

Vamos al navegador y refrescamos la página, debería aparecer una barra superior (Header) con las opciones de menú. Algo similar a esto:

![step1-angular1](../../assets/images/step1-angular1.png)


!!! todo "Recuerda"
    Cuando se añaden componentes a los ficheros `html`, siempre se deben utilizar los selectores definidos para el componente. En el caso anterior hemos añadido `app-header` que es el mismo nombre selector que tiene el componente en el fichero `header.component.ts`.
    Además, recuerda que para poder utilizar componentes de otros módulos, los debes exportar ya que de lo contrario tan solo podrán utilizarse dentro del módulo donde se declaran.

## Creando un listado básico
### Crear componente 

Ya tenemos la estructura principal, ahora vamos a crear nuestra primera pantalla. Vamos a empezar por la de `Categorías` que es la más sencilla, ya que se trata de un listado, que muestra datos sin filtrar ni paginar.

Como categorías es un dominio funcional de la aplicación, vamos a crear un módulo que contenga toda la funcionalidad de ese dominio. Ejecutamos en consola:

```
ng generate module category
```

Y por tanto, al igual que hicimos anteriormente, hay que añadir el módulo al fichero `app.module.ts`

=== "app.module.ts"
``` Typescript hl_lines="8 19"
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { CoreModule } from './core/core.module';
import { CategoryModule } from './category/category.module';


@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    CoreModule,
    CategoryModule,
    BrowserAnimationsModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```


Ahora todas las pantallas, componentes y servicios que creemos, referidos a este dominio funcional, deberán ir dentro del modulo `cagegory`.

Vamos a crear un primer componente que será un listado de categorías. Para ello vamos a ejecutar el siguiente comando:

```
ng generate component category/category-list
```

Para terminar de configurar la aplicación, vamos a añadir la ruta del componente dentro del componente routing de Angular, para poder acceder a él, para ello modificamos el fichero `app-routing.module.ts`

=== "app-routing.module.ts"
    ``` Typescript hl_lines="3 6"
    import { NgModule } from '@angular/core';
    import { Routes, RouterModule } from '@angular/router';
    import { CategoryListComponent } from './category/category-list/category-list.component';

    const routes: Routes = [
      { path: 'categories', component: CategoryListComponent },
    ];

    @NgModule({
      imports: [RouterModule.forRoot(routes)],
      exports: [RouterModule]
    })
    export class AppRoutingModule { }
    ```

Si abrimos el navegador y accedemos a `http://localhost:4200/` podremos navegar mediante el menú `Categorías` el cual abrirá el componente que acabamos de crear.

### Código de la pantalla

Ahora vamos a construir la pantalla. Para manejar la información del listado, necesitamos almacenar los datos en un objeto de tipo `model`. Para ello crearemos un fichero en `category\model\Category.ts` donde implementaremos la clase necesaria. Esta clase será la que utilizaremos en el código html y ts de nuestro componente.

=== "Category.ts"
    ``` Typescript
    export class Category {
        id: number;
        name: string;
    }
    ```


También, escribiremos el código de la pantalla de listado.

=== "category-list.component.html"
    ``` HTML hl_lines="4 5 10 15 23 24"
    <div class="container">
        <h1>Listado de Categorías</h1>

        <mat-table [dataSource]="dataSource">
            <ng-container matColumnDef="id">
                <mat-header-cell *matHeaderCellDef> Identificador </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.id}} </mat-cell>
            </ng-container>
            
            <ng-container matColumnDef="name">
                <mat-header-cell *matHeaderCellDef> Nombre categoría  </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.name}} </mat-cell>
            </ng-container>
            
            <ng-container matColumnDef="action">
                <mat-header-cell *matHeaderCellDef></mat-header-cell>
                <mat-cell *matCellDef="let element">
                    <button mat-icon-button color="primary"><mat-icon>edit</mat-icon></button>
                    <button mat-icon-button color="accent"><mat-icon>clear</mat-icon></button>
                </mat-cell>
            </ng-container>

            <mat-header-row *matHeaderRowDef="displayedColumns; sticky: true"></mat-header-row>
            <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
        </mat-table>

        <div class="buttons">
            <button mat-flat-button color="primary">Nueva categoría</button>
        </div>   
    </div>
    ```
=== "category-list.component.scss"
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
=== "category-list.component.ts"
    ``` Typescript hl_lines="2 3 12 13"
    import { Component, OnInit } from '@angular/core';
    import { MatTableDataSource } from '@angular/material/table';
    import { Category } from '../model/Category';
    
    @Component({
      selector: 'app-category-list',
      templateUrl: './category-list.component.html',
      styleUrls: ['./category-list.component.scss']
    })
    export class CategoryListComponent implements OnInit {

      dataSource = new MatTableDataSource<Category>();
      displayedColumns: string[] = ['id', 'name', 'action'];

      constructor() { }

      ngOnInit(): void {
      }

    }
    ```

El código HTML es fácil de seguir pero por si acaso:

* Línea 4: Creamos la tabla con la variable `dataSource` definida en el fichero .ts
* Línea 5: Definición de la primera columna, su cabecera y el dato que va a contener
* Línea 10: Definición de la segunda columna, su cabecera y el dato que va a contener
* Línea 15: Definición de la tercera columna, su cabecera vacía y los dos botones de acción
* Línea 23 y 24: Construcción de la cabecera y las filas

Y ya por último, añadimos los componentes que se han utilizado de Angular Material a las dependencias del módulo donde está definido el componente en este caso `category\category.module.ts`:

=== "category.module.ts"
    ``` TypeScript hl_lines="3 4 5 12 13 14"
    import { NgModule } from '@angular/core';
    import { CommonModule } from '@angular/common';
    import { MatTableModule } from '@angular/material/table';
    import { MatIconModule } from '@angular/material/icon';
    import { MatButtonModule } from '@angular/material/button';
    import { CategoryListComponent } from './category-list/category-list.component';

    @NgModule({
      declarations: [CategoryListComponent],
      imports: [
        CommonModule,
        MatTableModule,
        MatIconModule, 
        MatButtonModule
      ],
    })
    export class CategoryModule { }
    ```

Si abrimos el navegador y accedemos a `http://localhost:4200/` y pulsamos en el menú de `Categorías` obtendremos una pantalla con un listado vacío (solo con cabeceras) y un botón de crear Nueva Categoría que aun no hace nada.

## Añadiendo datos

En este punto y para ver como responde el listado, vamos a añadir datos. Si tuvieramos el backend implementado podríamos consultar los datos directamente de una operación de negocio de backend, pero ahora mismo no lo tenemos implementado así que para no bloquear el desarrollo vamos a mockear los datos.

### Creando un servicio

En angular, cualquier acceso a datos debe pasar por un `service`, así que vamos a crearnos uno para todas las operaciones de categorías. Vamos a la consola y ejecutamos:

```
ng generate service category/category
```

Esto nos creará un servicio, que además podemos utilizarlo inyectándolo en cualquier componente que lo necesite. 

### Implementando un servicio

Vamos a implementar una operación de negocio que recupere el listado de categorías y lo vamos a hacer de forma reactiva (asíncrona) para simular una petición a backend. Modificamos los siguientes ficheros:

=== "category.service.ts"
    ``` TypeScript hl_lines="2 3 12 13 14"
    import { Injectable } from '@angular/core';
    import { Observable } from 'rxjs';
    import { Category } from './model/Category';

    @Injectable({
      providedIn: 'root'
    })
    export class CategoryService {

      constructor() { }

      getCategories(): Observable<Category[]> {
        return new Observable();
      }
    }
    ```
=== "category-list.component.ts"
    ``` TypeScript hl_lines="4 17 21 22 23"
    import { Component, OnInit } from '@angular/core';
    import { MatTableDataSource } from '@angular/material/table';
    import { Category } from '../model/Category';
    import { CategoryService } from '../category.service';
    
    @Component({
      selector: 'app-category-list',
      templateUrl: './category-list.component.html',
      styleUrls: ['./category-list.component.scss']
    })
    export class CategoryListComponent implements OnInit {

      dataSource = new MatTableDataSource<Category>();
      displayedColumns: string[] = ['id', 'name', 'action'];

      constructor(
        private categoryService: CategoryService,
      ) { }

      ngOnInit(): void {
        this.categoryService.getCategories().subscribe(
          categories => this.dataSource.data = categories
        );
      }
    }
    ```

### Mockeando datos

Como hemos comentado anteriormente, el backend todavía no está implementado así que vamos a mockear datos. Nos crearemos un fichero `mock-categories.ts` dentro de model, con datos ficticios y modificaremos el servicio para que devuelva esos datos. De esta forma, cuando tengamos implementada la operación de negocio en backend, tan solo tenemos que sustuir el código que devuelve datos estáticos por una llamada http.

=== "mock-categories.ts"
    ``` TypeScript
    import { Category } from "./Category";

    export const CATEGORY_DATA: Category[] = [
        { id: 1, name: 'Dados' },
        { id: 2, name: 'Fichas' },
        { id: 3, name: 'Cartas' },
        { id: 4, name: 'Rol' },
        { id: 5, name: 'Tableros' },
        { id: 6, name: 'Temáticos' },
        { id: 7, name: 'Europeos' },
        { id: 8, name: 'Guerra' },
        { id: 9, name: 'Abstractos' },
    ]    
    ```
=== "category.service.ts"
    ``` TypeScript hl_lines="2 4 14"
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Category } from './model/Category';
    import { CATEGORY_DATA } from './model/mock-categories';

    @Injectable({
      providedIn: 'root'
    })
    export class CategoryService {

      constructor() { }

      getCategories(): Observable<Category[]> {
        return of(CATEGORY_DATA);
      }
    }
    ``` 

Si ahora refrescamos la página web, veremos que el listado ya tiene datos con los que vamos a interactuar.

![step1-angular2](../../assets/images/step1-angular2.png)

### Simulando las otras peticiones

Para terminar, vamos a simular las otras dos peticiones, la de editar y la de borrar para cuando tengamos que utilizarlas. El servicio debe quedar más o menos así:

=== "category.service.ts"
    ``` TypeScript hl_lines="17 18 19 21 22 23"
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Category } from './model/Category';
    import { CATEGORY_DATA } from './model/mock-categories';

    @Injectable({
      providedIn: 'root'
    })
    export class CategoryService {

      constructor() { }

      getCategories(): Observable<Category[]> {
        return of(CATEGORY_DATA);
      }

      saveCategory(category: Category): Observable<Category> {
        return of(null);
      }

      deleteCategory(idCategory : number): Observable<any> {
        return of(null);
      }  
    }
    ``` 


## Añadiendo acciones al listado
### Crear componente

Ahora nos queda añadir las acciones al listado: crear, editar y eliminar. Empezaremos primero por las acciones de crear y editar, que ambas deberían abrir una ventana modal con un formulario para poder modificar datos de la entidad `Categoría`.
Como siempre, para crear un componente usamos el asistente de Angular, esta vez al tratarse de una pantalla que solo vamos a utilizar dentro del dominio de categorías, tiene sentido que lo creemos dentro de ese módulo:

```
ng generate component category/category-edit
```

Ahora vamos a hacer que se abra al pulsar el botón `Nueva categoría`. Para eso, vamos al fichero `category-list.component.ts` y añadimos un nuevo método:

=== "category-list.component.ts"
    ``` TypeScript hl_lines="2 3 7 10 11 12 13 14 15 16 17 18"
    ...
    import { MatDialog } from '@angular/material/dialog';
    import { CategoryEditComponent } from '../category-edit/category-edit.component';
    ...
      constructor(
        private categoryService: CategoryService,
        public dialog: MatDialog,
      ) { }
    ...
      createCategory() {    
        const dialogRef = this.dialog.open(CategoryEditComponent, {
          data: {}
        });

        dialogRef.afterClosed().subscribe(result => {
          this.ngOnInit();
        });    
      }  
    ...
    ``` 

Para poder abrir un componente dentro de un dialogo necesitamos obtener en el constructor un MatDialog. De ahí que hayamos tenido que añadirlo como import y en el constructor.

Dentro del método `createCategory` lo que hacemos es crear un dialogo con el componente `CategoryEditComponent` en su interior, pasarle unos datos de creación, donde podemos poner estilos del dialog y un objeto `data` donde pondremos los datos que queremos pasar entre los componentes. Por último, nos suscribimos al evento `afterClosed` para ejecutar las acciones que creamos oportunas, en nuestro caso volveremos a cargar el listado inicial.

Como hemos utilizado un `MatDialog` en el componente, necesitamos añadirlo también al módulo, así que abrimos el fichero `category.module.ts` y añadimos:

=== "category.module.ts"
    ``` TypeScript hl_lines="2 8 10 11 12 13 14 15"
    ...
    import { MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';

    @NgModule({
      declarations: [CategoryListComponent, CategoryEditComponent],
      imports: [
        ...
        MatDialogModule
      ],
      providers: [
        {
          provide: MAT_DIALOG_DATA,
          useValue: {},
        },
      ]
    })
    export class CategoryModule { }
    ```

Y ya por último enlazamos el click en el botón con el método que acabamos de crear para abrir el dialogo. Modificamos el fichero `category-list.component.html` y añadimos el evento click:

=== "category-list.component.html"
    ``` TypeScript hl_lines="3"
    ...
        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createCategory()">Nueva categoría</button> 
        </div>   
    </div>
    ```

Si refrescamos el navegador y pulsamos el botón `Nueva categoría` veremos como se abre una ventana modal de tipo Dialog con el componente nuevo que hemos creado, aunque solo se leerá `category-edit works!` que es el contenido por defecto del componente.

### Código del dialogo

Ahora vamos a darle forma al formulario de editar y crear. Para ello vamos al html, ts y css del componente y pegamos el siguiente contenido:

=== "category-edit.component.html"
    ``` HTML
    <div class="container">
        <h1>Crear categoría</h1>

        <form>
            <mat-form-field>
                <mat-label>Identificador</mat-label>
                <input type="text" matInput placeholder="Identificador" [(ngModel)]="category.id" name="id" disabled>
            </mat-form-field>

            <mat-form-field>
                <mat-label>Nombre</mat-label>
                <input type="text" matInput placeholder="Nombre de categoría" [(ngModel)]="category.name" name="name" required>
                <mat-error>El nombre no puede estar vacío</mat-error>
            </mat-form-field>
        </form>

        <div class="buttons">
            <button mat-stroked-button (click)="onClose()">Cerrar</button>
            <button mat-flat-button color="primary" (click)="onSave()">Guardar</button>
        </div>
    </div>
    ```
=== "category-edit.component.scss"
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
=== "category-edit.component.ts"
    ``` TypeScript
    import { Component, OnInit } from '@angular/core';
    import { MatDialogRef } from '@angular/material/dialog';
    import { CategoryService } from '../category.service';
    import { Category } from '../model/Category';

    @Component({
      selector: 'app-category-edit',
      templateUrl: './category-edit.component.html',
      styleUrls: ['./category-edit.component.scss']
    })
    export class CategoryEditComponent implements OnInit {

      category : Category;

      constructor(
        public dialogRef: MatDialogRef<CategoryEditComponent>,
        private categoryService: CategoryService
      ) { }

      ngOnInit(): void {
        this.category = new Category();
      }

      onSave() {
        this.categoryService.saveCategory(this.category).subscribe(result => {
          this.dialogRef.close();
        });    
      }  

      onClose() {
        this.dialogRef.close();
      }

    }
    ```

Si te fijas en el código TypeScript, hemos añadido en el método `onSave` una llamada al servicio de `CategoryService` que aunque no realice ninguna operación de momento, por lo menos lo dejamos preparado para conectar con el servidor.

Además, como siempre, al utilizar componentes `matInput`, `matForm`, `matError` hay que añadirlos como dependencias en el módulo `category.module.ts`:

=== "category.module.ts"
    ``` TypeScript hl_lines="3 4 5 12 13 14 15"
    ...
    import { MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
    import { MatFormFieldModule } from '@angular/material/form-field';
    import { MatInputModule } from '@angular/material/input';
    import { FormsModule, ReactiveFormsModule } from '@angular/forms';

    @NgModule({
      declarations: [CategoryListComponent, CategoryEditComponent],
      imports: [
        ...
        MatDialogModule,
        MatFormFieldModule,
        MatInputModule,
        FormsModule,
        ReactiveFormsModule,
      ],
      providers: [
        {
          provide: MAT_DIALOG_DATA,
          useValue: {},
        },
      ]
    })
    export class CategoryModule { }
    ```

Ahora podemos navegar y abrir el cuadro de dialogo mediante el botón `Nueva categoría` para ver como queda nuestro formulario.

### Utilizar el dialogo para editar

El mismo componente que hemos utilizado para crear una nueva categoría, nos sirve también para editar una categoría existente. Tan solo tenemos que utilizar la funcionalidad que Angular nos proporciona y pasarle los datos a editar en la llamada de apertura del Dialog.
Vamos a implementar funcionalidad sobre el icono `editar`, tendremos que modificar unos cuantos ficheros:

=== "category-list.component.html"
    ``` HTML hl_lines="18 19 20"
    <div class="container">
        <h1>Listado de Categorías</h1>

        <mat-table [dataSource]="dataSource"> 
            <ng-container matColumnDef="id">
                <mat-header-cell *matHeaderCellDef> Identificador </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.id}} </mat-cell>
            </ng-container>
            
            <ng-container matColumnDef="name">
                <mat-header-cell *matHeaderCellDef> Nombre categoría  </mat-header-cell>
                <mat-cell *matCellDef="let element"> {{element.name}} </mat-cell>
            </ng-container>
            
            <ng-container matColumnDef="action">
                <mat-header-cell *matHeaderCellDef></mat-header-cell>
                <mat-cell *matCellDef="let element">
                    <button mat-icon-button color="primary" (click)="editCategory(element)">
                        <mat-icon>edit</mat-icon>
                    </button>
                    <button mat-icon-button color="accent"><mat-icon>clear</mat-icon></button>
                </mat-cell>
            </ng-container>

            <mat-header-row *matHeaderRowDef="displayedColumns; sticky: true"></mat-header-row>
            <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
        </mat-table>

        <div class="buttons">
            <button mat-flat-button color="primary" (click)="createCategory()">Nueva categoría</button> 
        </div>   
    </div>
    ```
=== "category-list.component.ts"
    ``` TypeScript hl_lines="27 28 29 30 31 32 33 34 35"
    export class CategoryListComponent implements OnInit {

      dataSource = new MatTableDataSource<Category>();
      displayedColumns: string[] = ['id', 'name', 'action'];

      constructor(
        private categoryService: CategoryService,
        public dialog: MatDialog,
      ) { }

      ngOnInit(): void {
        this.categoryService.getCategories().subscribe(
          categories => this.dataSource.data = categories
        );
      }
    
      createCategory() {    
        const dialogRef = this.dialog.open(CategoryEditComponent, {
          data: {}
        });

        dialogRef.afterClosed().subscribe(result => {
          this.ngOnInit();
        });    
      }  

      editCategory(category: Category) {
        const dialogRef = this.dialog.open(CategoryEditComponent, {
          data: { category: category }
        });

        dialogRef.afterClosed().subscribe(result => {
          this.ngOnInit();
        });
      }
    }
    ```

Y los Dialog:

=== "category-edit.component.html"
    ``` TypeScript hl_lines="2 3"
    <div class="container">
        <h1 *ngIf="category.id == null">Crear categoría</h1>
        <h1 *ngIf="category.id != null">Modificar categoría</h1>

        <form>
            <mat-form-field>
    ...
    ```
=== "category-edit.component.ts"
    ``` TypeScript hl_lines="1 2 17 22 23 24 25 26 27"
    import { Component, OnInit, Inject } from '@angular/core';
    import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
    import { CategoryService } from '../category.service';
    import { Category } from '../model/Category';

    @Component({
      selector: 'app-category-edit',
      templateUrl: './category-edit.component.html',
      styleUrls: ['./category-edit.component.scss']
    })
    export class CategoryEditComponent implements OnInit {

      category : Category;

      constructor(
        public dialogRef: MatDialogRef<CategoryEditComponent>,
        @Inject(MAT_DIALOG_DATA) public data: any,
        private categoryService: CategoryService
      ) { }

      ngOnInit(): void {
        if (this.data.category != null) {
          this.category = this.data.category;
        }
        else {
          this.category = new Category();
        }
      }

      onSave() {
        this.categoryService.saveCategory(this.category).subscribe(result => {
          this.dialogRef.close();
        });    
      }  

      onClose() {
        this.dialogRef.close();
      }

    }
    ```

Navegando ahora por la página y pulsando en el icono de editar, se debería abrir una ventana con los datos que hemos seleccionado, similar a esta imagen:

![step1-angular3](../../assets/images/step1-angular3.png)

Si te fijas, al modificar los datos dentro de la ventana de diálogo se modifica también en el listado. Esto es porque estamos pasando el mismo objeto desde el listado a la ventana dialogo y al ser el listado y el formulario reactivos los dos, cualquier cambio sobre los datos se refresca directamente en la pantalla. 

Hay veces en la que este comportamiento nos interesa, pero en este caso no queremos que se modifique el listado. Para solucionarlo debemos hacer una copia del objeto, para que ambos modelos (formulario y listado) utilicen objetos diferentes. Es tan sencillo como modificar `category-edit.component.ts` y añadirle una copia del dato

=== "category-edit.component.ts"
    ``` TypeScript hl_lines="4"
        ...
        ngOnInit(): void {
          if (this.data.category != null) {
            this.category = Object.assign({}, this.data.category);
          }
          else {
            this.category = new Category();
          }
        }
        ...
    ```

!!! tip "Cuidado"
    Hay que tener mucho cuidado con el binding de los objetos. Hay veces que al modificar un objeto NO queremos que se modifique en todas sus instancias y tenemos que poner especial cuidado en esos aspectos.


### Acción de borrado

Por norma general, toda acción de borrado de un dato de pantalla requiere una confirmación previa por parte del usuario. Es decir, para evitar que el dato se borre accidentalmente el usuario tendrá que confirmar su acción. Por tanto vamos a crear un componente que nos permita pedir una confirmación al usuario.

Como esta pantalla de confirmación va a ser algo común a muchas acciones de borrado de nuestra aplicación, vamos a crearla dentro del módulo `core`. Como siempre, ejecutamos el comando en consola:

```
ng generate component core/dialog-confirmation
```

E implementamos el código que queremos que tenga el componente. Al ser un componente genérico vamos a aprovechar y leeremos las variables que le pasemos en `data`.

=== "dialog-confirmation.component.html"
    ``` HTML
    <div class="container">
        <h1>{{title}}</h1>
        <div [innerHTML]="description" class="description"></div>
        
        <div class="buttons">
            <button mat-stroked-button (click)="onNo()">No</button>
            <button mat-flat-button color="primary" (click)="onYes()">Sí</button>
        </div>
    </div>    
    ```
=== "dialog-confirmation.component.scss"
    ``` CSS
    .container {
        min-width: 350px;
        max-width: 500px;
        width: 100%;
      
        .description {
          margin-bottom: 20px;
        }
        
        .buttons {
          text-align: right;

          button {
              margin-left: 10px;
          }
        }
    }    
    ```
=== "dialog-confirmation.component.ts"
    ``` Typescript
    import { Component, OnInit, Inject } from '@angular/core';
    import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

    @Component({
      selector: 'app-dialog-confirmation',
      templateUrl: './dialog-confirmation.component.html',
      styleUrls: ['./dialog-confirmation.component.scss']
    })
    export class DialogConfirmationComponent implements OnInit {

      title : string;
      description : string;

      constructor(
        public dialogRef: MatDialogRef<DialogConfirmationComponent>,
        @Inject(MAT_DIALOG_DATA) public data: any
      ) { }

      ngOnInit(): void {
        this.title = this.data.title;
        this.description = this.data.description;
      }

      onYes() {
        this.dialogRef.close(true);
      }

      onNo() {
        this.dialogRef.close(false);
      }
    }
    ```

!!! info "Recuerda"
    Recuerda que los componentes utilizados en el diálogo de confirmación se deben añadir al módulo padre al que pertenecen, en este caso a `core.module.ts`
    ```
    imports: [
      CommonModule,
      RouterModule,
      MatIconModule, 
      MatToolbarModule,
      MatDialogModule,
      MatButtonModule,
    ],
    providers: [
      {
        provide: MAT_DIALOG_DATA,
        useValue: {},
      },
    ],
    ```

Ya por último, una vez tenemos el componente genérico de dialogo, vamos a utilizarlo en nuestro listado al pulsar el botón eliminar:

=== "category-list.component.html"
    ``` HTML hl_lines="9"
        ...
        <ng-container matColumnDef="action">
            <mat-header-cell *matHeaderCellDef></mat-header-cell>
            <mat-cell *matCellDef="let element">
                <button mat-icon-button color="primary" (click)="editCategory(element)">
                    <mat-icon>edit</mat-icon>
                </button>
                <button mat-icon-button color="accent" (click)="deleteCategory(element)">
                    <mat-icon>clear</mat-icon>
                </button>
            </mat-cell>
        </ng-container>
        ...
    ```
=== "category-list.component.ts"
    ``` Typescript hl_lines="2 3 4 5 6 7 8 9 10 11 12 13 14"
      ...
      deleteCategory(category: Category) {    
        const dialogRef = this.dialog.open(DialogConfirmationComponent, {
          data: { title: "Eliminar categoría", description: "Atención si borra la categoría se perderán sus datos.<br> ¿Desea eliminar la categoría?" }
        });

        dialogRef.afterClosed().subscribe(result => {
          if (result) {
            this.categoryService.deleteCategory(category.id).subscribe(result => {
              this.ngOnInit();
            }); 
          }
        });
      }  
      ...    
    ```

Aquí también hemos realizado la llamada a `categoryService`, aunque no se realice ninguna acción, pero así lo dejamos listo para enlazarlo.

Llegados a este punto, ya solo nos queda enlazar las acciones de la pantalla con las operaciones de negocio del backend.


## Conectar con Backend

!!! warning "Antes de seguir"
    Antes de seguir con este punto, debes implementar el código de backend en la tecnología que quieras ([Springboot](springboot.md) o [Nodejs](nodejs.md)). Si has empezado este capítulo implementando el frontend, por favor accede a la sección correspondiente de backend para poder continuar con el tutorial. Una vez tengas implementadas todas las operaciones para este listado, puedes volver a este punto y continuar con Angular.


El siguiente paso, como es obvio será hacer que Angular llame directamente al servidor backend para leer y escribir datos y eliminar los datos mockeados en Angular.

Manos a la obra!

### Llamada del listado

La idea es que el método `getCategories()` de `category.service.ts` en lugar de devolver datos estáticos, realice una llamada al servidor a la ruta `http://localhost:8080/category`.

Abrimos el fichero y susituimos la línea que antes devolvía los datos estáticos por esto:

=== "category.service.ts"
    ``` Typescript hl_lines="1 12 16"
    import { HttpClient } from '@angular/common/http';
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Category } from './model/Category';

    @Injectable({
    providedIn: 'root'
    })
    export class CategoryService { 

        constructor(
            private http: HttpClient
        ) { }

        getCategories(): Observable<Category[]> {
            return this.http.get<Category[]>('http://localhost:8080/category');
        }

        saveCategory(category: Category): Observable<Category> {
            return of(null);
        }

        deleteCategory(idCategory : number): Observable<any> {
            return of(null);
        }  
    }
    ```

Como hemos añadido un componente nuevo `HttpClient` tenemos que añadir la dependencia al módulo padre.

=== "category.module.ts"
``` Typescript hl_lines="12 26"
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { CategoryListComponent } from './category-list/category-list.component';
import { CategoryEditComponent } from './category-edit/category-edit.component';
import { MAT_DIALOG_DATA, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  declarations: [CategoryListComponent, CategoryEditComponent],
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
    HttpClientModule,
  ],
  providers: [
    {
      provide: MAT_DIALOG_DATA,
      useValue: {},
    },
  ]
})
export class CategoryModule { }
```

Si ahora refrescas el navegador (recuerda tener arrancado también el servidor) y accedes a la pantalla de `Categorías` debería aparecer el listado con los datos que vienen del servidor.

![step3-angular1](../../assets/images/step3-angular1.png)

### Llamada de guardado / edición

Para la llamada de guardado haríamos lo mismo, pero invocando la operación de negocio `put`.

=== "category.service.ts"
    ``` Typescript hl_lines="21-24"
    import { HttpClient } from '@angular/common/http';
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Category } from './model/Category';

    @Injectable({
    providedIn: 'root'
    })
    export class CategoryService { 

        constructor(
            private http: HttpClient
        ) { }

        getCategories(): Observable<Category[]> {
            return this.http.get<Category[]>('http://localhost:8080/category');
        }

        saveCategory(category: Category): Observable<Category> {

            let url = 'http://localhost:8080/category';
            if (category.id != null) url += '/'+category.id;

            return this.http.put<Category>(url, category);
        }

        deleteCategory(idCategory : number): Observable<any> {
            return of(null);
        }  

    } 
    ```

Ahora podemos probar a modificar o añadir una nueva categoría desde la pantalla y debería aparecer los nuevos datos en el listado.


### Llamada de borrado

Y ya por último, la llamada de borrado, deberíamos cambiarla e invocar a la operación de negocio `delete`.

=== "category.service.ts"
    ``` Typescript hl_lines="28"
    import { HttpClient } from '@angular/common/http';
    import { Injectable } from '@angular/core';
    import { Observable, of } from 'rxjs';
    import { Category } from './model/Category';

    @Injectable({
    providedIn: 'root'
    })
    export class CategoryService { 

        constructor(
            private http: HttpClient
        ) { }

        getCategories(): Observable<Category[]> {
            return this.http.get<Category[]>('http://localhost:8080/category');
        }

        saveCategory(category: Category): Observable<Category> {

            let url = 'http://localhost:8080/category';
            if (category.id != null) url += '/'+category.id;

            return this.http.put<Category>(url, category);
        }

        deleteCategory(idCategory : number): Observable<any> {
            return this.http.delete('http://localhost:8080/category/'+idCategory);
        }  

    } 
    ```

Ahora podemos probar a modificar o añadir una nueva categoría desde la pantalla y debería aparecer los nuevos datos en el listado.

Como ves, es bastante sencillo conectar server y client.

##Depuración

Una parte muy importante del desarrollo es tener la capacidad de depurar nuestro código, en este apartado vamos a explicar como se realiza `debug` en Front.

Esta parte se puede realizar con nuestro navegador favorito, en este caso vamos a utilizar Chrome.

El primer paso es abrir las herramientas del desarrollador del navegador presionando `F12`.

![front1-debug1](../../assets/images/front1-debug1.png)

En esta herramienta tenemos varias partes importantes:

- Elements: Inspector de los elementos del DOM de nuestra aplicación que nos ayuda identificar el código generado.
- Console: Consola donde podemos ver mensajes importantes que nos ayudan a identificar posibles problemas.
- Source: El navegador de ficheros que componen nuestra aplicación.
- Network: El registro de peticiones que realiza nuestra aplicación.

Identificados los elementos importantes, vamos a depurar la operación de crear categoría.

Para ello nos dirigimos a la pestaña de `Source`, en el árbol de carpetas nos dirigimos a la ruta donde está localizado el código de nuestra aplicación `webpack://src/app`.

Dentro de esta carpeta esté localizado todo el código fuente de la aplicación, en nuestro caso vamos a localizar componente `category-edit.component` que crea una nueva categoría.

Dentro del fichero ya podemos añadir puntos de ruptura (breakpoint), en nuestro caso queremos comprobar que el nombre introducido se captura bien y se envía al service correctamente.

Colocamos el breakpoint en la línea de invocación del service (click sobre el número de la línea) y desde la interfaz creamos una nueva categoría.

Hecho esto, podemos observar que a nivel de interfaz, la aplicación se detiene y aparece un panel de manejo de los puntos de interrupción:

![front1-debug2](../../assets/images/front1-debug2.png)

En cuanto a la herramienta del desarrollador nos lleva al punto exacto donde hemos añadido el breakpoint y se para en este punto ofreciéndonos la posibilidad de explorar el contenido de las variables del código:

![front1-debug3](../../assets/images/front1-debug3.png)

Aquí podemos comprobar que efectivamente la variable `category` tiene el valor que hemos introducido por pantalla y se propaga correctamente hacia el service.

Para continuar con la ejecución basta con darle al botón de `play` del panel de manejo de interrupción o al que aparece dentro de la herramienta de desarrollo (parte superior derecha).

Por último, vamos a revisar que la petición REST se ha realizado correctamente al backend, para ello nos dirigimos a la pestaña `Network` y comprobamos las peticiones realizadas:

![front1-debug4](../../assets/images/front1-debug4.png)

Aquí podemos observar el registro de todas las peticiones y haciendo click sobre una de ellas, obtenemos el detalle de esta.

- Header: Información de las cabeceras enviadas (aquí podemos ver que se ha hecho un PUT a la ruta correcta).
- Payload: El cuerpo de la petición (vemos el cuerpo del mensaje con el nombre enviado).
- Preview: Respuesta de la petición normalizada (vemos la respuesta con el identificador creado para la nueva categoría).