# Listado filtrado - Angular

En este punto ya tenemos dos listados, uno básico y otro paginado. Ahora vamos a implementar un listado un poco diferente, con filtros y con una presentación un tanto distinta.

Como ya conocemos como se debe desarrollar, en este ejemplo vamos a ir más rápidos y nos vamos a centrar únicamente en las novedades.

Vamos a desarrollar el listado de `Juegos`. Este listado es un tanto peculiar, porque no tiene una tabla como tal, sino que vamos a mostrar los juegos como cards. Ya tenemos creado nuestro componentes pagina pero vamos a necesitar un componente para mostrar cada uno de los juegos  y otro para crear y editar los juegos.

Manos a la obra:

Creamos el fichero `Game.ts` dentro de la carpeta `types`:

=== "Game.ts"
    ``` TypeScript
import { Category } from "./Category";
import { Author } from "./Author";

export interface Game {
  id: string;
  title: string;
  age: number;
  category?: Category;
  author?: Author;
}
    ```

Modificamos nuestra api de `Toolkit` para añadir los `endpoints` de juegos y aparte creamos un `endpoint` para recuperar los autores que necesitaremos para crear un nuevo juego:

``` TypeScript
import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";
import { Game } from "../../types/Game";
import { Category } from "../../types/Category";
import { Author } from "../../types/Author";

export const ludotecaAPI = createApi({
  reducerPath: "ludotecaApi",
  baseQuery: fetchBaseQuery({
    baseUrl: "http://localhost:8080",
  }),
  tagTypes: ["Game", "Category", "Author"],
  endpoints: (builder) => ({
    getGames: builder.query<Game[], { title: string; idCategory: string }>({
      query: ({ title, idCategory }) => {
        return {
          url: "game/",
          params: { title, idCategory },
        };
      },
      providesTags: ["Game"],
    }),
    createGame: builder.mutation({
      query: (payload: Game) => ({
        url: "/game",
        method: "PUT",
        body: { ...payload },
        headers: {
          "Content-type": "application/json; charset=UTF-8",
        },
      }),
      invalidatesTags: ["Game"],
    }),
    updateGame: builder.mutation({
      query: (payload: Game) => ({
        url: `game/${payload.id}`,
        method: "PUT",
        body: { ...payload },
      }),
      invalidatesTags: ["Game"],
    }),
    getCategories: builder.query<Category[], null>({
      query: () => "category",
      providesTags: ["Category"],
    }),
    createCategory: builder.mutation({
      query: (payload) => ({
        url: "/category",
        method: "PUT",
        body: payload,
        headers: {
          "Content-type": "application/json; charset=UTF-8",
        },
      }),
      invalidatesTags: ["Category"],
    }),
    deleteCategory: builder.mutation({
      query: (id: string) => ({
        url: `/category/${id}`,
        method: "DELETE",
      }),
      invalidatesTags: ["Category"],
    }),
    updateCategory: builder.mutation({
      query: (payload: Category) => ({
        url: `category/${payload.id}`,
        method: "PUT",
        body: payload,
      }),
      invalidatesTags: ["Category", "Game"],
    }),
    getAllAuthors: builder.query<Author[], null>({
      query: () => "author",
      providesTags: ["Author"],
    }),
  }),
});

export const {
  useGetGamesQuery,
  useCreateGameMutation,
  useUpdateGameMutation,
  useGetCategoriesQuery,
  useCreateCategoryMutation,
  useUpdateCategoryMutation,
  useDeleteCategoryMutation,
  useGetAllAuthorsQuery,
} = ludotecaAPI;
```

Creamos una nueva carpeta `components` dentro de `src/pages/Game` y dentro creamos un archivo llamado `CreateGame.tsx` con el siguiente contenido:

=== "CreateGame.tsx"
``` Typescript
import { ChangeEvent, useContext, useEffect, useState } from "react";
import Button from "@mui/material/Button";
import MenuItem from "@mui/material/MenuItem";
import TextField from "@mui/material/TextField";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogTitle from "@mui/material/DialogTitle";
import {
  useGetAllAuthorsQuery,
  useGetCategoriesQuery,
} from "../../../redux/services/ludotecaApi";
import { LoaderContext } from "../../../context/LoaderProvider";
import { Game } from "../../../types/Game";
import { Category } from "../../../types/Category";
import { Author } from "../../../types/Author";

interface Props {
  game: Game | null;
  closeModal: () => void;
  create: (game: Game) => void;
}

const initialState = {
  id: "",
  title: "",
  age: 0,
  category: undefined,
  author: undefined,
};

export default function CreateGame(props: Props) {
  const [form, setForm] = useState<Game>(initialState);
  const loader = useContext(LoaderContext);
  const { data: categories, isLoading: isLoadingCategories } =
    useGetCategoriesQuery(null);
  const { data: authors, isLoading: isLoadingAuthors } =
    useGetAllAuthorsQuery(null);

  useEffect(() => {
    setForm({
      ...form,
      category: props.game?.category,
      author: props.game?.author,
    });
  }, [props?.game]);

  useEffect(() => {
    loader.showLoading(isLoadingCategories || isLoadingAuthors);
  }, [isLoadingCategories, isLoadingAuthors]);

  const handleChangeForm = (
    event: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    setForm({
      ...form,
      [event.target.id]: event.target.value,
    });
  };

  const handleChangeSelect = (
    event: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const values = event.target.name === "category" ? categories : authors;
    setForm({
      ...form,
      [event.target.name]: values?.find((val) => val.id === event.target.value),
    });
  };

  return (
    <div>
      <Dialog open={true} onClose={props.closeModal}>
        <DialogTitle>
          {props.game ? "Actualizar Juego" : "Crear Juego"}
        </DialogTitle>
        <DialogContent>
          {props.game && (
            <TextField
              margin="dense"
              disabled
              id="id"
              label="Id"
              fullWidth
              value={props.game.id}
              variant="standard"
            />
          )}
          <TextField
            margin="dense"
            id="title"
            label="Titulo"
            fullWidth
            variant="standard"
            onChange={handleChangeForm}
            value={form.title}
          />
          <TextField
            margin="dense"
            id="age"
            label="Edad Recomendada"
            fullWidth
            type="number"
            variant="standard"
            onChange={handleChangeForm}
            value={form.age}
          />
          <TextField
            id="category"
            select
            label="Categoría"
            defaultValue="''"
            fullWidth
            variant="standard"
            name="category"
            value={form.category ? form.category.id : ""}
            onChange={handleChangeSelect}
          >
            {categories &&
              categories.map((option: Category) => (
                <MenuItem key={option.id} value={option.id}>
                  {option.name}
                </MenuItem>
              ))}
          </TextField>
          <TextField
            id="author"
            select
            label="Autor"
            defaultValue="''"
            fullWidth
            variant="standard"
            name="author"
            value={form.author ? form.author.id : ""}
            onChange={handleChangeSelect}
          >
            {authors &&
              authors.map((option: Author) => (
                <MenuItem key={option.id} value={option.id}>
                  {option.name}
                </MenuItem>
              ))}
          </TextField>
        </DialogContent>
        <DialogActions>
          <Button onClick={props.closeModal}>Cancelar</Button>
          <Button
            onClick={() =>
              props.create({
                id: "",
                title: form.title,
                age: form.age,
                category: form.category,
                author: form.author,
              })
            }
            disabled={
              !form.title || !form.age || !form.category || !form.author
            }
          >
            {props.game ? "Actualizar" : "Crear"}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
```

Ahora en esa misma carpeta crearemos el componente `GameCard.tsx` para mostrar nuestros juegos con un diseño de carta:

=== "CreateGame.tsx"
``` Typescript
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import CardMedia from "@mui/material/CardMedia";
import CardHeader from "@mui/material/CardHeader";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemAvatar from "@mui/material/ListItemAvatar";
import ListItemText from "@mui/material/ListItemText";
import Avatar from "@mui/material/Avatar";
import PersonIcon from "@mui/icons-material/Person";
import LanguageIcon from "@mui/icons-material/Language";
import CardActionArea from "@mui/material/CardActionArea";
import red from "@mui/material/colors/red";
import imageGame from "./../../../assets/foto.png";
import { Game } from "../../../types/Game";

interface GameCardProps {
  game: Game;
}

export default function GameCard(props: GameCardProps) {
  const { title, age, category, author } = props.game;
  return (
    <Card sx={{ maxWidth: 265 }}>
      <CardHeader
        sx={{
          ".MuiCardHeader-title": {
            fontSize: "20px",
          },
        }}
        avatar={
          <Avatar sx={{ bgcolor: red[500] }} aria-label="age">
            +{age}
          </Avatar>
        }
        title={title}
        subheader={category?.name}
      />
      <CardActionArea>
        <CardMedia
          component="img"
          height="140"
          image={imageGame}
          alt="game image"
        />
        <CardContent>
          <List dense={true}>
            <ListItem>
              <ListItemAvatar>
                <Avatar>
                  <PersonIcon />
                </Avatar>
              </ListItemAvatar>
              <ListItemText primary={`Autor: ${author?.name}`} />
            </ListItem>
            <ListItem>
              <ListItemAvatar>
                <Avatar>
                  <LanguageIcon />
                </Avatar>
              </ListItemAvatar>
              <ListItemText primary={`Nacionalidad: ${author?.nationality}`} />
            </ListItem>
          </List>
        </CardContent>
      </CardActionArea>
    </Card>
  );
}
```

En la carpeta `src/pages/game` vamos a crear un fichero para los estilos llamado `Game.module.css`: 

=== "Game.module.css"
``` css
.filter {
    display: flex;
    align-items: center;
}

.cards {
    display: flex;
    gap: 20px;
    padding: 10px;
    flex-wrap: wrap;
}

.card {
    cursor: pointer;
}

@media (max-width: 800px) {
    .cards {
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .filter {
        display: flex;
        flex-direction: column;
    }
}
```

Y por último modificamos nuestro componente página `Game` y lo dejamos de esta manera:

=== "Game.tsx"
``` Typescript
import { useState, useContext, useEffect } from "react";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import GameCard from "./components/GameCard";
import styles from "./Game.module.css";
import {
  useCreateGameMutation,
  useGetCategoriesQuery,
  useGetGamesQuery,
  useUpdateGameMutation,
} from "../../redux/services/ludotecaApi";
import CreateGame from "./components/CreateGame";
import { LoaderContext } from "../../context/LoaderProvider";
import { useAppDispatch } from "../../redux/hooks";
import { setMessage } from "../../redux/features/messagesSlice";
import { Game as GameModel } from "../../types/Game";
import { Category } from "../../types/Category";

export const Game = () => {
  const [openCreate, setOpenCreate] = useState(false);
  const [filterTitle, setFilterTitle] = useState("");
  const [filterCategory, setFilterCategory] = useState("");
  const [gameToUpdate, setGameToUpdate] = useState<GameModel | null>(null);
  const loader = useContext(LoaderContext);
  const dispatch = useAppDispatch();

  const { data, error, isLoading, isFetching } = useGetGamesQuery({
    title: filterTitle,
    idCategory: filterCategory,
  });

  const [updateGameApi, { isLoading: isLoadingUpdate, error: errorUpdate }] =
    useUpdateGameMutation();

  const { data: categories } = useGetCategoriesQuery(null);

  const [createGameApi, { isLoading: isLoadingCreate, error: errorCreate }] =
    useCreateGameMutation();

  useEffect(() => {
    loader.showLoading(
      isLoadingCreate || isLoadingUpdate || isLoading || isFetching
    );
  }, [isLoadingCreate, isLoadingUpdate, isLoading, isFetching]);

  useEffect(() => {
    if (errorCreate || errorUpdate) {
      setMessage({
        text: "Se ha producido un error al realizar la operación",
        type: "error",
      });
    }
  }, [errorUpdate, errorCreate]);

  if (error) return <p>Error cargando!!!</p>;

  const createGame = (game: GameModel) => {
    setOpenCreate(false);
    if (gameToUpdate) {
      updateGameApi({
        ...game,
        id: gameToUpdate.id,
      })
        .then(() => {
          dispatch(
            setMessage({
              text: "Juego actualizado correctamente",
              type: "ok",
            })
          );
          setGameToUpdate(null);
        })
        .catch((err) => console.log(err));
    } else {
      createGameApi(game)
        .then(() => {
          dispatch(
            setMessage({
              text: "Juego creado correctamente",
              type: "ok",
            })
          );
          setGameToUpdate(null);
        })
        .catch((err) => console.log(err));
    }
  };

  return (
    <div className="container">
      <h1>Catálogo de juegos</h1>
      <div className={styles.filter}>
        <FormControl variant="standard" sx={{ m: 1, minWidth: 220 }}>
          <TextField
            margin="dense"
            id="title"
            label="Titulo"
            fullWidth
            value={filterTitle}
            variant="standard"
            onChange={(event) => setFilterTitle(event.target.value)}
          />
        </FormControl>
        <FormControl variant="standard" sx={{ m: 1, minWidth: 220 }}>
          <TextField
            id="category"
            select
            label="Categoría"
            defaultValue="''"
            fullWidth
            variant="standard"
            name="author"
            value={filterCategory}
            onChange={(event) => setFilterCategory(event.target.value)}
          >
            {categories &&
              categories.map((option: Category) => (
                <MenuItem key={option.id} value={option.id}>
                  {option.name}
                </MenuItem>
              ))}
          </TextField>
        </FormControl>
        <Button
          variant="outlined"
          onClick={() => {
            setFilterCategory("");
            setFilterTitle("");
          }}
        >
          Limpiar
        </Button>
      </div>
      <div className={styles.cards}>
        {data?.map((card) => (
          <div
            key={card.id}
            className={styles.card}
            onClick={() => {
              setGameToUpdate(card);
              setOpenCreate(true);
            }}
          >
            <GameCard game={card} />
          </div>
        ))}
      </div>
      <div className="newButton">
        <Button variant="contained" onClick={() => setOpenCreate(true)}>
          Nuevo juego
        </Button>
      </div>
      {openCreate && (
        <CreateGame
          create={createGame}
          game={gameToUpdate}
          closeModal={() => {
            setGameToUpdate(null);
            setOpenCreate(false);
          }}
        />
      )}
    </div>
  );
};
```

Y por último descargamos la siguiente imagen y la guardamos en la carpeta `src/assets`.

En este listado realizamos el filtro de manera dinámica, en el momento en que cambiamos el valor de la categoría o el título a filtrar, como estas variables están asociadas al estado de nuestro componente, se vuelve a renderizar y por lo tanto se actualiza el valor de "data" modificando así los resultados.

El resto es muy parecido a lo que ya hemos realizado antes. Aquí no tenemos una tabla, sino que mostramos nuestros juegos como Cards y si pulsamos sobre cualquier Card se mostrará el formulario de edición del juego.

Si ahora arrancamos el proyecto y nos vamos a la pagina de juegos podremos crear y ver nuestros juegos.
