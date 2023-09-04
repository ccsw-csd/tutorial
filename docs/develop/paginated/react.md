# Listado paginado - React

Ya tienes tu primer CRUD desarrollado. ¿Ha sido sencillo, verdad?.

Ahora vamos a implementar un CRUD un poco más complejo, este tiene datos paginados en servidor, esto quiere decir que no nos sirve un array de datos como en el anterior ejemplo. 
Para que un listado paginado en servidor funcione, el cliente debe enviar en cada petición que página está solicitando y cual es el tamaño de la página, para que el servidor devuelva solamente un subconjunto de datos, en lugar de devolver el listado completo.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.


## Crear componente author

Lo primero que vamos a hacer es crear una carpeta llamada types dentro de `src`. Aquí crearemos los tipos de typescript. Creamos un nuevo fichero llamado `Author.ts` cuyo contenido será el siguiente:

=== "Author.ts" 
    ``` Typescript hl_lines="9 20"
    export interface Author {
        id: string,
        name: string,
        nationality: string
    }

    export interface AuthorResponse {
        content: Author[];
        totalElements: number;
    }
    ```

Ahora vamos a crear un archivo de estilos que será solo utilizado por la página de author. Para ello dentro de la carpeta `Author` creamos un archivo llamado `Author.module.css`. Al llamar al archivo de esta manera React reconoce este archivo como un archivo único para un componente y hace que sus reglas css sean más prioritarias, aunque por ejemplo exista una clase con el mismo nombre en el archivo `index.css`.

El contenido de nuestro archivo css será el siguiente:

=== "index.css" 
    ``` css
    .tableActions {
        margin-right: 20px;
        display: flex;
        justify-content: flex-end;
        align-content: flex-start;
        gap: 19px;
    }
    ```

Al igual que hicimos con categorías vamos a crear un nuevo componente para el formulario de alta y edición, para ello creamos una nueva carpeta llamada components en `src/pages/Author` y dentro de esta carpeta crearemos un fichero llamado `CreateAuthor.tsx`:

=== "CreateAuthor.tsx" 
    ``` Typescript
    import { ChangeEvent, useEffect, useState } from "react";
    import Button from "@mui/material/Button";
    import TextField from "@mui/material/TextField";
    import Dialog from "@mui/material/Dialog";
    import DialogActions from "@mui/material/DialogActions";
    import DialogContent from "@mui/material/DialogContent";
    import DialogTitle from "@mui/material/DialogTitle";
    import { Author } from "../../../types/Author";

    interface Props {
      author: Author | null;
      closeModal: () => void;
      create: (author: Author) => void;
    }

    const initialState = {
      name: "",
      nationality: "",
    };

    export default function CreateAuthor(props: Props) {
      const [form, setForm] = useState(initialState);

      useEffect(() => {
        setForm(props?.author || initialState);
      }, [props?.author]);

      const handleChangeForm = (
        event: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
      ) => {
        setForm({
          ...form,
          [event.target.id]: event.target.value,
        });
      };

      return (
        <div>
          <Dialog open={true} onClose={props.closeModal}>
            <DialogTitle>
              {props.author ? "Actualizar Autor" : "Crear Autor"}
            </DialogTitle>
            <DialogContent>
              {props.author && (
                <TextField
                  margin="dense"
                  disabled
                  id="id"
                  label="Id"
                  fullWidth
                  value={props.author.id}
                  variant="standard"
                />
              )}
              <TextField
                margin="dense"
                id="name"
                label="Nombre"
                fullWidth
                variant="standard"
                onChange={handleChangeForm}
                value={form.name}
              />
              <TextField
                margin="dense"
                id="nationality"
                label="Nacionalidad"
                fullWidth
                variant="standard"
                onChange={handleChangeForm}
                value={form.nationality}
              />
            </DialogContent>
            <DialogActions>
              <Button onClick={props.closeModal}>Cancelar</Button>
              <Button
                onClick={() =>
                  props.create({
                    id: props.author ? props.author.id : "",
                    name: form.name,
                    nationality: form.nationality,
                  })
                }
                disabled={!form.name || !form.nationality}
              >
                {props.author ? "Actualizar" : "Crear"}
              </Button>
            </DialogActions>
          </Dialog>
        </div>
      );
    }
    ```

Como los autores tienen más campos hemos añadido un poco de funcionalidad extra que no teníamos en el formulario de categorías, pero no es demasiado complicada.

Vamos a añadir los métodos necesarios para el crud de autores en el fichero `src/redux/services/ludotecaApi.ts`:

=== "ludotecaApi.ts" 
    ``` Typescript hl_lines="9 20"
        getAllAuthors: builder.query<Author[], null>({
      query: () => "author",
      providesTags: ["Author" ],
    }),
    getAuthors: builder.query<
      AuthorResponse,
      { pageNumber: number; pageSize: number }
    >({
      query: ({ pageNumber, pageSize }) => {
        return {
          url: "author/",
          method: "POST",
          body: {
            pageable: {
              pageNumber,
              pageSize,
            },
          },
        };
      },
      providesTags: ["Author"],
    }),
    createAuthor: builder.mutation({
      query: (payload) => ({
        url: "/author",
        method: "PUT",
        body: payload,
        headers: {
          "Content-type": "application/json; charset=UTF-8",
        },
      }),
      invalidatesTags: ["Author"],
    }),
    deleteAuthor: builder.mutation({
      query: (id: string) => ({
        url: `/author/${id}`,
        method: "DELETE",
      }),
      invalidatesTags: ["Author"],
    }),
    updateAuthor: builder.mutation({
      query: (payload: Author) => ({
        url: `author/${payload.id}`,
        method: "PUT",
        body: payload,
      }),
      invalidatesTags: ["Author", "Game"],
    }),
    ```
Añadimos también los imports, tags y exports necesarios y guardamos.
``` Typescript
import { Author, AuthorResponse } from "../../types/Author";

tagTypes: ["Category", "Author", "Game"],

export const {
  useGetCategoriesQuery,
  useCreateCategoryMutation,
  useDeleteCategoryMutation,
  useUpdateCategoryMutation,
  useCreateAuthorMutation,
  useDeleteAuthorMutation,
  useGetAllAuthorsQuery,
  useGetAuthorsQuery,
  useUpdateAuthorMutation,
} = ludotecaAPI;
```

Y por último el contenido de nuestro fichero `Author.tsx` quedaría así:

=== "Author.tsx" 
    ``` Typescript hl_lines="9 20"
    import { useEffect, useState, useContext } from "react";
    import Button from "@mui/material/Button";
    import TableHead from "@mui/material/TableHead";
    import Table from "@mui/material/Table";
    import TableBody from "@mui/material/TableBody";
    import TableCell from "@mui/material/TableCell";
    import TableContainer from "@mui/material/TableContainer";
    import TableFooter from "@mui/material/TableFooter";
    import TablePagination from "@mui/material/TablePagination";
    import TableRow from "@mui/material/TableRow";
    import Paper from "@mui/material/Paper";
    import IconButton from "@mui/material/IconButton";
    import EditIcon from "@mui/icons-material/Edit";
    import ClearIcon from "@mui/icons-material/Clear";
    import styles from "./Author.module.css";
    import CreateAuthor from "./components/CreateAuthor";
    import { ConfirmDialog } from "../../components/ConfirmDialog";
    import { useAppDispatch } from "../../redux/hooks";
    import { setMessage } from "../../redux/features/messageSlice";
    import { BackError } from "../../types/appTypes";
    import { Author as AuthorModel } from "../../types/Author";
    import {
      useDeleteAuthorMutation,
      useGetAuthorsQuery,
      useCreateAuthorMutation,
      useUpdateAuthorMutation,
    } from "../../redux/services/ludotecaApi";
    import { LoaderContext } from "../../context/LoaderProvider";

    export const Author = () => {
      const [pageNumber, setPageNumber] = useState(0);
      const [pageSize, setPageSize] = useState(5);
      const [total, setTotal] = useState(0);
      const [authors, setAuthors] = useState<AuthorModel[]>([]);
      const [openCreate, setOpenCreate] = useState(false);
      const [idToDelete, setIdToDelete] = useState("");
      const [authorToUpdate, setAuthorToUpdate] = useState<AuthorModel | null>(
        null
      );

      const dispatch = useAppDispatch();
      const loader = useContext(LoaderContext);

      const handleChangePage = (
        _event: React.MouseEvent<HTMLButtonElement> | null,
        newPage: number
      ) => {
        setPageNumber(newPage);
      };

      const handleChangeRowsPerPage = (
        event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
      ) => {
        setPageNumber(0);
        setPageSize(parseInt(event.target.value, 10));
      };

      const { data, error, isLoading } = useGetAuthorsQuery({
        pageNumber,
        pageSize,
      });

      const [deleteAuthorApi, { isLoading: isLoadingDelete, error: errorDelete }] =
        useDeleteAuthorMutation();

      const [createAuthorApi, { isLoading: isLoadingCreate }] =
        useCreateAuthorMutation();

      const [updateAuthorApi, { isLoading: isLoadingUpdate }] =
        useUpdateAuthorMutation();

      useEffect(() => {
        loader.showLoading(
          isLoadingCreate || isLoading || isLoadingDelete || isLoadingUpdate
        );
      }, [isLoadingCreate, isLoading, isLoadingDelete, isLoadingUpdate]);

      useEffect(() => {
        if (data) {
          setAuthors(data.content);
          setTotal(data.totalElements);
        }
      }, [data]);

      useEffect(() => {
        if (errorDelete) {
          if ("status" in errorDelete) {
            dispatch(
              setMessage({
                text: (errorDelete?.data as BackError).msg,
                type: "error",
              })
            );
          }
        }
      }, [errorDelete, dispatch]);

      useEffect(() => {
        if (error) {
          dispatch(setMessage({ text: "Se ha producido un error", type: "error" }));
        }
      }, [error]);

      const createAuthor = (author: AuthorModel) => {
        setOpenCreate(false);
        if (author.id) {
          updateAuthorApi(author)
            .then(() => {
              dispatch(
                setMessage({
                  text: "Autor actualizado correctamente",
                  type: "ok",
                })
              );
              setAuthorToUpdate(null);
            })
            .catch((err) => console.log(err));
        } else {
          createAuthorApi(author)
            .then(() => {
              dispatch(
                setMessage({ text: "Autor creado correctamente", type: "ok" })
              );
              setAuthorToUpdate(null);
            })
            .catch((err) => console.log(err));
        }
      };

      const deleteAuthor = () => {
        deleteAuthorApi(idToDelete)
          .then(() => {
            setIdToDelete("");
          })
          .catch((err) => console.log(err));
      };

      return (
        <div className="container">
          <h1>Listado de Autores</h1>
          <TableContainer component={Paper}>
            <Table sx={{ minWidth: 500 }} aria-label="custom pagination table">
              <TableHead
                sx={{
                  "& th": {
                    backgroundColor: "lightgrey",
                  },
                }}
              >
                <TableRow>
                  <TableCell>Identificador</TableCell>
                  <TableCell>Nombre Autor</TableCell>
                  <TableCell>Nacionalidad</TableCell>
                  <TableCell align="right"></TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {authors.map((author: AuthorModel) => (
                  <TableRow key={author.id}>
                    <TableCell component="th" scope="row">
                      {author.id}
                    </TableCell>
                    <TableCell style={{ width: 160 }}>{author.name}</TableCell>
                    <TableCell style={{ width: 160 }}>
                      {author.nationality}
                    </TableCell>
                    <TableCell align="right">
                      <div className={styles.tableActions}>
                        <IconButton
                          aria-label="update"
                          color="primary"
                          onClick={() => {
                            setAuthorToUpdate(author);
                            setOpenCreate(true);
                          }}
                        >
                          <EditIcon />
                        </IconButton>
                        <IconButton
                          aria-label="delete"
                          color="error"
                          onClick={() => {
                            setIdToDelete(author.id);
                          }}
                        >
                          <ClearIcon />
                        </IconButton>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
              <TableFooter>
                <TableRow>
                  <TablePagination
                    rowsPerPageOptions={[5, 10, 25]}
                    colSpan={4}
                    count={total}
                    rowsPerPage={pageSize}
                    page={pageNumber}
                    SelectProps={{
                      inputProps: {
                        "aria-label": "rows per page",
                      },
                      native: true,
                    }}
                    onPageChange={handleChangePage}
                    onRowsPerPageChange={handleChangeRowsPerPage}
                  />
                </TableRow>
              </TableFooter>
            </Table>
          </TableContainer>
          <div className="newButton">
            <Button variant="contained" onClick={() => setOpenCreate(true)}>
              Nuevo autor
            </Button>
          </div>
          {openCreate && (
            <CreateAuthor
              create={createAuthor}
              author={authorToUpdate}
              closeModal={() => {
                setAuthorToUpdate(null);
                setOpenCreate(false);
              }}
            />
          )}
          {!!idToDelete && (
            <ConfirmDialog
              title="Eliminar Autor"
              text="Atención si borra el autor se perderán sus datos. ¿Desea eliminar el autor?"
              confirm={deleteAuthor}
              closeModal={() => setIdToDelete("")}
            />
          )}
        </div>
      );
    };
    ```

Al tratarse de un listado paginado hemos creado dos nuevas variables en nuestro estado para almacenar la página y el número de registros a mostrar en la página. Cuando cambiamos estos valores en el navegador como estas variables van como parámetro en nuestro `hook` para recuperar datos automáticamente el listado se va a modificar.

El resto de funcionalidad es muy parecida a la de categorías. 
