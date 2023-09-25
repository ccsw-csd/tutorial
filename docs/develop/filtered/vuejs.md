# Listado filtrado - VUE
Aquí vamos a volver a la pantalla de catálogo para realizar un filtrado en la propia tabla.

Empezaremos por modificar el template de la tabla que modificamos para añadir el botón de añadir nueva fila para añadir también tres inputs: uno de texto para el nombre del juego y dos seleccionables para la categoría y el autor (les tendremos que asignar las opciones que haya en ese momento). 

También añadiremos un botón para que no se lance la petición cada vez que el usuario introduce una letra en el input de texto. Esto quedaría así:

```
<template v-slot:top>
        <div class="q-table__title">Catálogo</div>
        <q-btn flat round color="primary" icon="add" @click="showAdd = true" />
        <q-space />
        <q-input dense v-model="filter.title" placeholder="Título">
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>
        <q-separator inset />
        <div style="width: 10%">
          <q-select
            dense
            name="category"
            v-model="filter.category"
            :options="categories"
            emit-value
            map-options
            option-value="id"
            option-label="name"
            label="Categoría"
          />
        </div>
        <q-separator inset />
        <div style="width: 10%">
          <q-select
            dense
            name="author"
            v-model="filter.author"
            :options="authors"
            emit-value
            map-options
            option-value="id"
            option-label="name"
            label="Autor"
          />
        </div>
        <q-separator inset />
        <q-btn flat round color="primary" icon="filter_alt" @click="getGames" />
      </template>

```

Además, también vamos a añadir un estado para todos los filtros juntos:

```
const filter = ref({ title: '', category: '', author: '' });
```

Por último, para no estar haciendo las tres peticiones (juegos, categorías y autores) las hemos extraído en funciones diferentes de la siguiente manera:

```
const getGames = () => {
  const { data } = useFetch(url.value).get().json();
  whenever(data, () => (catalogData.value = data.value));
};

const getCategories = () => {
  const { data: categoriesData } = useFetch('http://localhost:8080/category')
    .get()
    .json();
  whenever(categoriesData, () => (categories.value = categoriesData.value));
};

const getAuthors = () => {
  const { data: authorsData } = useFetch('http://localhost:8080/author')
    .get()
    .json();
  whenever(authorsData, () => (authors.value = authorsData.value));
};

const firstLoad = () => {
  getGames();
  getCategories();
  getAuthors();
};
firstLoad();
```

Y como podemos ver, ahora la petición de juegos no tiene la url. Esto es porque hemos hecho que sea una variable computada para añadirle los parámetros de filtrado y ha quedado así:

```
const url = computed(() => {
  const _url = new URL('http://localhost:8080/game');
  _url.search = new URLSearchParams({
    title: filter.value.title,
    idCategory: filter.value.category ?? '',
    idAuthor: filter.value.author ?? '',
  });
  return _url.toString();
});
```