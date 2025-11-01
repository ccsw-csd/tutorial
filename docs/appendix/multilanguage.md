# Multidioma

En las aplicaciones reales, un detalle de suma importancia es la capacidad de soportar múltiples idiomas para llegar a una audiencia más amplia. Afortunadamente, tanto en el frontend como en el backend, existen herramientas y bibliotecas que facilitan la implementación de esta funcionalidad.

En especial nos centraremos en el frontend.

## Backend

La comunicación del backend ha de ser agnóstica al idioma del cliente (frontend). Para conseguir este resultado, nos comunicaremos con códigos de error (o éxito). Estableceremos un estándar de códigos que el frontend interpretará y mostrará el mensaje adecuado en función del idioma seleccionado por el usuario.

Para cualquier información extra, por ejemplo, indicar el número máximo de juegos que pueden prestarse. Acordaremos un campo asociado al código de error que contendrá dicha información adicional.

## Frontend

Para el frontend, existen varias bibliotecas que facilitan la implementación de la funcionalidad multilingüe. Usaremos el estándar `i18n` de Angular, que permite definir archivos de traducción para cada idioma soportado. (Guía oficial de Internalización)[https://angular.dev/guide/i18n]

Los términos que has de tener en cuenta en esta nueva etapa son:

- `i18n`: Abreviatura de "internationalization" (internacionalización), donde 18 representa el número de letras entre la 'i' y la 'n'.
- `locale`: Configuración regional que define el idioma y las convenciones culturales (formato de fecha, moneda, etc.) para una región específica. Ej. `es-ES` para español de España, `en-US` para inglés de Estados Unidos.

### Material

Angular Material también soporta la internacionalización. Para ello, es necesario importar los módulos de localización correspondientes y configurar el proveedor de localización en el módulo principal de la aplicación.

```typescript
import { MAT_DATE_LOCALE } from "@angular/material/core";
@NgModule({
  providers: [
    { provide: MAT_DATE_LOCALE, useValue: "es-ES" }, // Cambia 'es-ES' por el locale deseado
  ],
})
export class AppModule {}
```

Esto evitará que tengamos un `Items per page: 10` en inglés en las tablas de paginación de Angular Material.

### Estructura de un fichero de traducciones

Crearemos ficheros de traducciones que contendrán `keys` (los códigos de acceso) y sus correspondientes valores en cada idioma. Por ejemplo, podríamos tener un fichero `en.json` para inglés y otro `es.json` para español.

- translations
    - en.json
    - es.json

Aunque solemos preferir nombres más explícitos:

- translations
    - en-US.json
    - es-ES.json

Un fichero de traducciones en Angular suele tener la siguiente estructura:

```json
{
  "VIEWS": {
    "HOME": {
      "TITLE": "Título de la aplicación",
      "WELCOME_MESSAGE": "Bienvenido a nuestra aplicación",
      "LOGIN": "Iniciar sesión",
      "LOGOUT": "Cerrar sesión"
    },
    "DASHBOARD": {
      "TITLE": "Panel de control",
      "STATISTICS": "Estadísticas",
      "SETTINGS": "Configuraciones"
    }
  }
}
```

Ahora ya tienes todo lo necesario para crear aplicaciones multidioma. ¡Manos a la obra!