# Conectar Angular con las operaciones de Springboot

Ya casi lo tenemos listo! Por un lado tenemos la aplicación Angular funcionando con datos mockeados en local, y por otro lado tenemos el servidor Springboot con las operaciones funcionando.
El siguiente paso, como es obvio será hacer que Angular llame directamente al servidor Springboot para leer y escribir datos y eliminar los datos mockeados en Angular.

Manos a la obra!

## Llamada del listado

La idea es que el método `getCategories()` de `category.service.ts` en lugar de devolver datos estáticos, realice una llamada al servidor a la ruta `http://localhost:8080/category/v1/`.

Abrimos el fichero y susituimos la línea que antes devolvía los datos estáticos por esto:

=== "category.service.ts"
    ``` Typescript hl_lines="2 4 5 13 17"
    import { Injectable } from '@angular/core';

    import { Category } from 'src/app/models/categories/Category';
    import { Observable } from 'rxjs';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
    providedIn: 'root'
    })
    export class CategoryService { 

        constructor(
            private http: HttpClient
        ) { }

        getCategories(): Observable<Category[]> {
            return this.http.get<Category[]>('http://localhost:8080/category/v1/');
        }

        saveCategory(category: Category): Observable<Category> {
            return of(null);
        }

        deleteCategory(idCategory : number): Observable<any> {
            return of(null);
        }  
    }
    ```

Como hemos añadido un componente nuevo `HttpClient` tenemos que añadir la dependencial al módulo padre.

=== "services.module.ts"
``` Typescript hl_lines="3 9"
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  declarations: [],
  imports: [
    CommonModule,
    HttpClientModule
  ],
})
export class ServicesModule { }
```

Si ahora refrescas el navegador (recuerda tener arrancado también el servidor) y accedes a la pantalla de `Categorías` no saldrá ningún resultado, pero si miras la consola verás un mensaje similar a este:

```
Access to XMLHttpRequest at 'http://localhost:8080/category/v1/' from origin 'http://localhost:4200' has been blocked by CORS policy: 
    No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

Esto es debido a la política de CORS, que impide que desde un dominio+puerto se tenga acceso indiscriminado a otro dominio+puerto diferente, y así evita posibles ataques.

!!! Tip "Access Control Policy"
    El error de CORS es muy habitual cuando se está trabajando en local y se tienen varios servidores levantados. Hay que tener mucho ojo con este filtro. Para más ver más información de como funciona y su casuística visita [Control de acceso HTTP](https://developer.mozilla.org/es/docs/Web/HTTP/Access_control_CORS).

Para solucionarlo hay varias formas, pero la más cómoda en desarrollo es habilitar el permiso de CORS para cualquier origen en el servidor. Para ello vamos al código de servidor y añadimos una nueva anotación:

=== "CategoryController.java"
``` Java hl_lines="6 21"
package com.capgemini.coedevon.tutorial.category;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.capgemini.coedevon.tutorial.category.model.CategoryDto;
import com.devonfw.module.beanmapping.common.api.BeanMapper;

/**
 * @author coedevon
 */
@RequestMapping(value = "/category/v1")
@RestController
@CrossOrigin(origins = "*")
public class CategoryController {

  @Autowired
  CategoryService categoryService;

  @Autowired
  BeanMapper beanMapper;
  ...
```

Ahora sí, si refrescamos ya debería aparecer el listado con los datos que vienen del servidor.

![step3-angular1](../assets/images/step3-angular1.png)

## Llamada de guardado / edición

Para la llamada de guardado haríamos lo mismo, pero invocando la operación de negocio `put`.

=== "category.service.ts"
    ``` Typescript hl_lines="20"
    import { Injectable } from '@angular/core';
    import { Category } from 'src/app/models/categories/Category';
    import { Observable, of } from 'rxjs';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
    providedIn: 'root'
    })
    export class CategoryService { 

        constructor(
            private http: HttpClient
        ) { }

        getCategories(): Observable<Category[]> {
            return this.http.get<Category[]>('http://localhost:8080/category/v1/');
        }

        saveCategory(category: Category): Observable<Category> {
            return this.http.put<Category>('http://localhost:8080/category/v1/', category);
        }

        deleteCategory(idCategory : number): Observable<any> {
            return of(null);
        }  

    } 
    ```

Ahora podemos probar a modificar o añadir una nueva categoría desde la pantalla y debería aparecer los nuevos datos en el listado.


## Llamada de borrado

Y ya por último, la llamada de borrado, deberíamos cambiarla e invocar a la operación de negocio `delete`.

=== "category.service.ts"
    ``` Typescript hl_lines="24"
    import { Injectable } from '@angular/core';
    import { Category } from 'src/app/models/categories/Category';
    import { Observable } from 'rxjs';
    import { HttpClient } from '@angular/common/http';

    @Injectable({
    providedIn: 'root'
    })
    export class CategoryService { 

        constructor(
            private http: HttpClient
        ) { }

        getCategories(): Observable<Category[]> {
            return this.http.get<Category[]>('http://localhost:8080/category/v1/');
        }

        saveCategory(category: Category): Observable<Category> {
            return this.http.put<Category>('http://localhost:8080/category/v1/', category);
        }

        deleteCategory(idCategory : number): Observable<any> {
            return this.http.delete('http://localhost:8080/category/v1/'+idCategory);
        }  

    } 
    ```

Ahora podemos probar a modificar o añadir una nueva categoría desde la pantalla y debería aparecer los nuevos datos en el listado.
