# Listado paginado - VUE
Ahora nos ponemos con la pantalla de autores y vamos a realizar los cambios para poder realizar un paginado en la tabla de autores, además de realizar los cambios oportunos para poder añadir, editar y borrar autores.

## Acciones posibles

### Añadir una fila
Para poder añadir una fila, vamos a tener que añadir al componente de dialog de adición un nuevo campo que será la nacionalidad habiendo quitado los que habíamos copiado del catálogo dejando finalmente solo dos: el nombre y la nacionalidad.

Veremos el estado del código en el apartado de borrado.

### Editar una fila
A la hora de editar una fila, modificaremos la columna de “edad” para reutilizarla con la nacionalidad, reutilizaremos la columna de “nombre” tal cual está y borraremos las demás exceptuando la de opciones que ahí pondremos el botón para el borrado.

Veremos el estado del código en el apartado de borrado.

### Borrar una fila
Y, por último, haremos lo mismo que hicimos en la pantalla de categorías, que es añadir la función delete después del dialog de confirmación.

El estado del código ahora mismo quedaría así:
```
<template>
  <q-page padding>
    <q-table
      hide-bottom
      :rows="authorsData"
      :columns="columns"
      v-model:pagination="pagination"
      title="Catálogo"
      class="my-sticky-header-table"
      no-data-label="No hay resultados"
      row-key="id"
    >
      <template v-slot:top>
        <q-btn flat round color="primary" icon="add" @click="showAdd = true" />
      </template>
      <template v-slot:body="props">
        <q-tr :props="props">
          <q-td key="id" :props="props">{{ props.row.id }}</q-td>
          <q-td key="name" :props="props">
            {{ props.row.name }}
            <q-popup-edit
              v-model="props.row.name"
              title="Cambiar nombre"
              v-slot="scope"
            >
              <q-input
                v-model="scope.value"
                dense
                autofocus
                counter
                @keyup.enter="editRow(props, scope, 'name')"
              >
                <template v-slot:append>
                  <q-icon name="edit" />
                </template>
              </q-input>
            </q-popup-edit>
          </q-td>
          <q-td key="nationality" :props="props">
            {{ props.row.nationality }}
            <q-popup-edit
              v-model="props.row.nationality"
              title="Cambiar nacionalidad"
              v-slot="scope"
            >
              <q-input
                v-model="scope.value"
                dense
                autofocus
                counter
                @keyup.enter="editRow(props, scope, 'nationality')"
              >
                <template v-slot:append>
                  <q-icon name="edit" />
                </template>
              </q-input>
            </q-popup-edit>
          </q-td>
          <q-td key="options" :props="props">
            <q-btn
              flat
              round
              color="negative"
              icon="delete"
              @click="showDeleteDialog(props.row)"
            />
          </q-td>
        </q-tr>
      </template>
    </q-table>
    <q-dialog v-model="showDelete" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-icon
            name="delete"
            size="sm"
            color="negative"
            @click="showDelete = true"
          />
          <span class="q-ml-sm">
            ¿Estás seguro de que quieres borrar este elemento?
          </span>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Cancelar" color="primary" v-close-popup />
          <q-btn
            flat
            label="Confirmar"
            color="primary"
            v-close-popup
            @click="deleteAuthor"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="showAdd">
      <q-card style="width: 300px" class="q-px-sm q-pb-md">
        <q-card-section>
          <div class="text-h6">Nuevo autor</div>
        </q-card-section>

        <q-item-label header>Nombre</q-item-label>
        <q-item dense>
          <q-item-section avatar>
            <q-icon name="badge" />
          </q-item-section>
          <q-item-section>
            <q-input dense v-model="authorToAdd.name" autofocus />
          </q-item-section>
        </q-item>

        <q-item-label header>Nacionalidad</q-item-label>
        <q-item dense>
          <q-item-section avatar>
            <q-icon name="flag" />
          </q-item-section>
          <q-item-section>
            <q-input
              dense
              v-model="authorToAdd.nationality"
              autofocus
              @keyup.enter="addAuthor"
            />
          </q-item-section>
        </q-item>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancelar" v-close-popup />
          <q-btn flat label="Añadir autor" v-close-popup @click="addAuthor" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useFetch, whenever } from '@vueuse/core';

const columns = [
  { name: 'id', align: 'left', label: 'ID', field: 'id', sortable: true },
  {
    name: 'name',
    align: 'left',
    label: 'Nombre',
    field: 'name',
    sortable: true,
  },
  {
    name: 'nationality',
    align: 'left',
    label: 'Nacionalidad',
    field: 'nationality',
    sortable: true,
  },
  { name: 'options', align: 'left', label: 'Options', field: 'options' },
];
const pagination = {
  page: 1,
  rowsPerPage: 0,
};
const newAuthor = {
  name: '',
  nationality: '',
};

const authorsData = ref([]);
const showDelete = ref(false);
const showAdd = ref(false);
const selectedRow = ref({});
const authorToAdd = ref({ ...newAuthor });

const getAuthors = () => {
  const { data } = useFetch('http://localhost:8080/author').get().json();
  whenever(data, () => (authorsData.value = data.value));
};
getAuthors();

const showDeleteDialog = (item: any) => {
  selectedRow.value = item;
  showDelete.value = true;
};

const addAuthor = async () => {
  await useFetch('http://localhost:8080/author', {
    method: 'PUT',
    redirect: 'manual',
    headers: {
      accept: '*/*',
      origin: window.origin,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(authorToAdd.value),
  })
    .put()
    .json();

  getAuthors();
  authorToAdd.value = newAuthor;
  showAdd.value = false;
};

const editRow = (props: any, scope: any, field: any) => {
  const row = {
    name: props.row.name,
    nationality: props.row.nationality,
  };
  row[field] = scope.value;
  scope.set();
  editAuthor(props.row.id, row);
};

const editAuthor = async (id: string, reqBody: any) => {
  await useFetch(`http://localhost:8080/author/${id}`, {
    method: 'PUT',
    redirect: 'manual',
    headers: {
      accept: '*/*',
      origin: window.origin,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(reqBody),
  })
    .put()
    .json();

  getAuthors();
};

const deleteAuthor = async () => {
  await useFetch(`http://localhost:8080/author/${selectedRow.value.id}`, {
    method: 'DELETE',
    redirect: 'manual',
    headers: {
      accept: '*/*',
      origin: window.origin,
      'Content-Type': 'application/json',
    },
  })
    .delete()
    .json();

  getAuthors();
};
</script>

```

## Paginado
Lo primero que tenemos que hacer es usar las nuevas características de nuestra tabla para poder añadir datos y así hacer funcionar el paginado correctamente.

Lo primero que vamos a hacer es cambiar el objeto de paginación para que tenga lo siguiente:

```
const pagination = ref({
  page: 0,
  rowsPerPage: 5,
  rowsNumber: 10,
});
```

Y debido a que la tabla y el back requieren de formatos diferentes para la paginación, vamos a tener que realizar una función que formatee el objeto para enviarlo al back. Esta función será, más o menos, así:

```
const formatPageableBody = (props: any) => {
  return {
    pageable: {
      pageSize:
        props.pagination.rowsPerPage !== 0
          ? props.pagination.rowsPerPage
          : props.pagination.rowsNumber,
      pageNumber: props.pagination.page - 1,
      sort: [
        {
          property: 'name',
          direction: 'ASC',
        },
      ],
    },
  };
};

```

Tal y como podemos ver, se realiza una condición en el formato ya que, si el usuario selecciona que quiere ver todas las filas de golpe el valor de dicha variable será 0 y el back necesitará el valor del número máximo de filas para que nosotros recibamos todas.

Y por último vamos a hacer que la función de recibir los datos reciba por parámetro el paginado (siempre habrá uno por defecto) y que cuando todo haya ido bien se actualice la paginación local.

```
const updateLocalPagination = (props: any) => {
  pagination.value.page = props.pagination.page;
  pagination.value.rowsPerPage = props.pagination.rowsPerPage;
};

const getAuthors = (props: any = { pagination: pagination.value }) => {
  const { data } = useFetch('http://localhost:8080/author', {
    method: 'POST',
    redirect: 'manual',
    headers: {
      accept: '*/*',
      origin: window.origin,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(formatPageableBody(props)),
  })
    .post()
    .json();
  whenever(data, () => {
    updateLocalPagination(props);
    authorsData.value = data.value.content;
    pagination.value.rowsNumber = data.value.totalElements;
  });
};

```

!!! warning "Importante"
    En la primera de las peticiones (y si quieres en las demás también) se ha de recoger el atributo de filas totales y setearlo en el objeto de paginación con el nombre de `rowsNumber`. Esto se realiza en la zona subrayada anterior.

Y por último, hacemos que se realicen peticiones siempre que el usuario cambie parámetros de la tabla, como el cambio de página o el cambio de filas mostradas. Esto se realiza añadiendo a la creación de la tabla la siguiente línea:

```
<q-table
      :rows="authorsData"
      :columns="columns"
      v-model:pagination="pagination"
      title="Autores"
      class="my-sticky-header-table"
      no-data-label="No hay resultados"
      row-key="id"
      @request="getAuthors"
    >

```

Con estos cambios, la pantalla debería funcionar correctamente con el paginado funcionando y todas sus funciones básicas.