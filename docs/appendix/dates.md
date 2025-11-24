# Fechas

Uno de los elementos más problemáticos en las aplicaciones son las fechas. Más concretamente, cómo las gestionamos.

Pero podemos afrontarlo de una manera más clara. Vamos a empezar con unas definiciones básicas, veremos por qué hay problemas y la solución que proponemos para que no te supongan un problema en tus aplicaciones.

## Definiciones básicas

Antes de nada, vamos a definir unos conceptos básicos que nos ayudarán a entender mejor el problema.

- **Fecha (Date)**: Una fecha es una representación de un día concreto en el calendario. Por ejemplo, "15 de junio de 2024".
- **Hora (Time)**: La hora representa un momento específico dentro de un día.
- **Zona horaria (Timezone)**: La zona horaria es una región geográfica que tiene la misma hora estándar. Por ejemplo, "CET" (Central European Time) o "GMT" (Greenwich Mean Time).
- **Fecha y hora (DateTime)**: La combinación de fecha y hora representa un momento específico en el tiempo, incluyendo la zona horaria. Por ejemplo, "15 de junio de 2024 a las 14:30 CET".
- **Timestamp**: Un timestamp es una representación numérica de un momento específico en el tiempo, generalmente expresado en segundos o milisegundos desde una fecha de referencia (por ejemplo, el 1 de enero de 1970, conocido como la "época Unix").

## Problemas comunes

Al trabajar con fechas y horas, pueden surgir varios problemas comunes:

- **Conversión de zonas horarias**: Si una aplicación maneja usuarios en diferentes zonas horarias, es crucial convertir correctamente las fechas y horas para evitar confusiones.
- **Formato inconsistente**: Diferentes regiones utilizan diferentes formatos de fecha y hora, lo que puede llevar a errores de interpretación. Ej. DD/MM/AAAA (Europa) vs MM/DD/AAAA (EE.UU.).
- **Diferencias en el horario de verano**: Las fechas y horas pueden verse afectadas por el horario de verano, lo que puede causar confusiones si no se maneja correctamente.
- **Errores de cálculo**: Al realizar cálculos con fechas y horas (por ejemplo, sumar días o restar horas), es fácil cometer errores si no se consideran todos los factores relevantes.
- **Me quita un día**: Es la más común al principio, ¿por qué ocurre esto? La respuesta está en cómo se manejan las zonas horarias y el horario de verano. Cuando le pasamos una fecha, estamos indicándole un día sin zona horaria, por lo que se detecta nuestra zona horaria local y se aplica el desfase correspondiente. GMT+1 en horario estándar y GMT+2 en horario de verano.

Lo importante es recordar que un día en una zona horaria puede no ser el mismo día en otra zona horaria. Por ejemplo, el 15 de junio de 2024 en CET puede ser el 14 de junio de 2024 en GMT, que es por lo que ocurre un descuento de día.

## Solución propuesta

Para evitar estos problemas, os proponemos adheriros al estándar ISO 8601 para representar fechas y horas en vuestras aplicaciones. Este estándar define un formato claro y consistente para las fechas y horas, que incluye la zona horaria.

El formato ISO 8601 para una fecha y hora completa con zona horaria es el siguiente:

```
AAAA-MM-DDTHH:MM:SS.mmmZ±HH:MM
```

Por ejemplo, "2024-06-15T14:30:00.000Z+02:00" representa el 15 de junio de 2024 a las 14:30 en la zona horaria GMT+2.

### Backend

En Java, para manejar fechas con ISO 8601 de forma segura, recomendamos el uso de `Date`, así, siempre que le pasen una fecha en formato ISO 8601, se gestionará correctamente la zona horaria.

```java
import java.util.Date;

// ...

    private Date fecha;
```

### Frontend

El uso de fechas lo gestionaremos con ISO Date

```javascript
// Para leer fechas en formato ISO 8601
const fecha = new Date(`2024-06-15T14:30:00.000Z`);

// Para enviar fechas en formato ISO 8601
const fechaISO = fecha.toISOString();
```

## Buenas prácticas

- Siempre utiliza el formato ISO 8601 para representar fechas y horas en tus aplicaciones.
- Asegúrate de manejar correctamente las zonas horarias al mostrar fechas y horas a los usuarios.
- Realiza pruebas exhaustivas para verificar que las fechas y horas se manejan correctamente en diferentes escenarios y zonas horarias.
- Nunca elimines las horas ni la zona horaria al manejar fechas. Siempre trabaja con fechas completas en formato ISO 8601.

Si te cuestionan por qué pasan un día y el servidor entiende otro, explícales que es por la zona horaria y que la solución es usar siempre ISO 8601. De esta manera la consistencia en los datos estará garantizada.