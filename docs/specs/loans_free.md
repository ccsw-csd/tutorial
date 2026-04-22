# Gestión de préstamos (modelo gratuito)


!!! warning Atención
    Esta sección se encuentra en desarrollo 🚧.  
    **NO se recomienda realizarla** a menos que te lo hayan indicado expresamente.

## Punto de partida

Si has llegado hasta aquí, entiendo que ya has completado la funcionalidad de **gestión de clientes** utilizando el modelo gratuito.

A partir de ahora vamos a dar por hecho que partimos de ese estado del sistema, donde:

- Existe un CRUD funcional de clientes
- La funcionalidad está implementada, validada y archivada
- Los patrones de backend y frontend introducidos ya forman parte del sistema

Una vez llegados a este punto, asumimos que el proyecto **ya está descargado y configurado**, y que hemos trabajado previamente sobre la funcionalidad de **gestión de clientes**.

Por tanto, **continuaremos utilizando los mismos proyectos y directorios**, sin realizar ninguna instalación ni configuración adicional.

En este tutorial seguiremos trabajando sobre:

- ``server-springboot`` como **``backend``**
- ``client-angular17`` como **``frontend``**


## Requisitos funcionales

- Gestión de préstamos entre clientes y juegos.
- Listado paginado con filtros por juego, cliente y fecha.
- Alta/edición en modal con campos obligatorios (salvo identificador).
- Validaciones de fechas y restricciones de solapamiento.
- Máximo 14 días por préstamo.
- Un juego no puede estar prestado a dos clientes en el mismo día.
- Un cliente no puede tener más de dos préstamos activos en el mismo día.

## Estrategia del modo gratuito

Continuaremos trabajando con un **modelo gratuito**, utilizando **``Claude Haiku``** y el mismo workspace que en la funcionalidad de **gestión de clientes**.

Antes de comenzar, ten en cuenta lo siguiente:

- Para cada **nueva funcionalidad**, es recomendable iniciar una **nueva conversación de chat** dentro del mismo proyecto

Esto ayuda a mantener el contexto limpio y a que el modelo se centre exclusivamente en la funcionalidad que vamos a abordar.

Recuerda que en cualquier momento puedes ver el consumo mensual de tu cuenta pulsando el icono de la rana 🐸 en la esquina inferior derecha. El contador **se reinicia cada mes**.

Al igual que el ejercicio anterior, vamos a dividir el ejercicio en **dos grandes bloques**:

1. Primero trabajaremos únicamente con el **``backend``**
2. Después abordaremos el **``frontend``**

De esta forma limitamos el contexto a un solo proyecto y facilitamos el trabajo al modelo.


Además, recuerda que el comportamiento del modelo **no es determinista**. Si a ti te genera algo diferente a lo que ves aquí, probablemente seguirá siendo válido. No te frustres y ajusta los prompts si es necesario.

## Flujo de trabajo OpenSpec

Seguiremos el ciclo completo de :

```

1. Explore
2. Propose
3. Apply
4. Archive

```

## Generación de backend

Aunque no es obligatorio, es altamente recomendable volver a ejecutar la fase de **``Explore``**. El sistema ha podido cambiar desde tu último cambio, alguien ha podido hacer modificaciones, etc. En tu caso no sería necesario ya que estás trabajando tu solo y no has cambiado nada, pero es buena práctica hacerlo siempre.


### Explore

El objetivo de esta fase es **analizar el sistema existente**, sin modificar nada.

A diferencia de la gestión de clientes, este caso de uso introduce una mayor complejidad, principalmente por:

- Relaciones entre entidades (cliente, juego, préstamo)
- Uso de **paginación** en los listados
- Aplicación de **filtros combinados**
- Necesidad de **validaciones de negocio más complejas**

En esta fase se analizará qué partes del sistema actual ya resuelven este tipo de problemas y pueden reutilizarse, y qué aspectos no están implementados y deberán abordarse en fases posteriores.

Aspectos a revisar:

**Paginación**

-	Cómo se implementa en backend (uso de Page)

**Filtros**

-	Cómo se implementa en el catálogo de juegos
-	Cómo se implementan filtros por rangos de fechas (si existen)
-	DTOs de filtro utilizados
-	Construcción de queries en backend
-	Cómo se construyen queries con condiciones combinadas y operadores distintos de igualdad

**Relaciones entre entidades**

-	Cómo se modelan relaciones en JPA
-	Ejemplos existentes en el proyecto
-	Cómo se representan en DTOs
-	Cómo se cargan y exponen los datos relacionados

**Validaciones en backend**

-	Dónde se implementan (Service)
-	Cómo se gestionan errores
-	Cómo se propagan al frontend
-	Cómo se implementan validaciones sobre rangos de fechas 
-	Cómo se validan restricciones que dependen de registros existentes (solapamientos, límites por cliente, etc.)

⚠️ En esta fase:

- **NO** se escribe código
- **NO** se diseña la solución
- **NO** se inventan estructuras nuevas

Solo se analiza el **sistema actual**.

---

**📜 Prompt**

Lo que haremos será escribir en el chat de ``Visual Studio Code`` el comando y las instrucciones que queramos darle. ``Recuerda haber elegido Claude Haiku y estar trabajando en modo Agent``.

```

/opsx:explore

Analiza el proyecto actual que está en el directorio "backend", es una aplicación Spring Boot. Una vez analizado, responde:

1. ¿Cómo están implementados los CRUD existentes?
- Controller
- Service
- Repository
- Paginación y respuestas paginadas

2. ¿Qué estructura siguen los dominios?

3. ¿Cómo se implementan las operaciones?
- Listado
- Creación/edición
- Borrado
- DTOs de filtro utilizados y construcción de queries en backend
- Uso de condiciones combinadas (no solo igualdad)
- Ejemplos de filtros por rango de fechas (si existen)
- Ejemplos de consultas donde una fecha debe estar contenida dentro de un rango (si existen)

4. ¿Cómo se gestionan relaciones entre entidades?
- Modelado en JPA
- Ejemplos en el proyecto
- Cómo se representan en DTOs
- Cómo se exponen los datos relacionados

5. ¿Cómo se implementan validaciones en backend?
- Dónde se ubican (Service)
- Cómo se gestionan errores
- Cómo se propagan al frontend
- Si existen validaciones que dependan de múltiples registros o condiciones
- Si existen validaciones relacionadas con fechas o rangos
- Cómo se validan restricciones basadas en datos existentes

6. ¿Qué formato tienen los endpoints y que relación tiene con los métodos HTTP?

7. ¿Qué patrones o estructuras comunes se repiten en los CRUD existentes?
- Clases reutilizables
- Lógica repetida
- Estructuras comunes entre dominios

8. ¿Existen test unitarios y de integración? ¿Cómo están implementados? ¿Utiliza algo especial al arrancar o al mockear?


Analiza únicamente la parte de backend (Spring Boot)
NO propongas soluciones.
NO diseñes nuevas funcionalidades.
Solo analiza el sistema actual.
Ya tienes un contexto previo en el fichero backend-explore.md en el directorio de las specs, utilizalo y lo actualizas con lo que analices y no esté.

```

Si te fijas, le hemos indicado que aproveche el contexto previo generado en el ejercicio anterior y le hemos pedido que lo actualice con los cambios que considere.


Este comando realizará un análisis exhaustivo de tu sistema que servirá como base para definir la nueva funcionalidad en la siguiente fase.

!!! tip "Sobre los permisos"
    Es posible que durante el análisis te pida permiso para hacer ciertas tareas. Le puedes ir dando permiso una a una o darle permiso en todo el workspace, eso lo dejamos a tu elección.

### Propose

Una vez analizado el sistema en la fase Explore, el siguiente paso es definir de forma clara y estructurada **la nueva funcionalidad a implementar**.

En esta fase establecemos **qué vamos a construir**, apoyándonos en el conocimiento ya consolidado del sistema y en el resultado del Explore.

Esta fase actúa como puente entre el análisis y la implementación, permitiendo diseñar la solución antes de escribir código y reduciendo el riesgo de errores durante el desarrollo.

Durante esta fase debes especificar:

**Descripción funcional**

- Qué hace la funcionalidad
- Qué problema resuelve

**Reglas de negocio**

-	Validaciones sobre fechas:
    - La fecha de fin no podrá ser anterior a la fecha de inicio
-	Restricciones de duración del préstamo:
    - El período de préstamo máximo solo podrá ser de 14 días
-	Validaciones de solapamiento de préstamos:
    - El mismo juego no puede estar prestado a más de un cliente para ninguno de los días incluidos en el rango del préstamo
-	Límites de préstamos simultáneos por cliente:
    - Un mismo cliente no puede tener más de 2 préstamos activos para ninguno de los días incluidos en el rango del préstamo

**Diseño backend**

- Endpoints necesarios
- Estructura del dominio (Entity, DTO, Service, Repository)
- Tipo de operaciones (listado, creación, edición, borrado)
- Estrategia para filtros por fecha dentro de rangos

**Decisiones técnicas**

-	Qué patrones existentes se reutilizan
-	Qué partes deben extenderse
-	Cómo se gestionarán los filtros de fecha y condiciones combinadas
-	Cómo se implementarán validaciones basadas en múltiples registros (solapamientos y límites)

**Plan de implementación**

- Tareas ordenadas
- Separación backend / frontend
- Prioridad de desarrollo (listado → filtros → validaciones)

Aquí dejamos claro:

- Qué funcionalidad se va a añadir
- Qué reglas de negocio existen
- Qué piezas del sistema se ven afectadas
- Qué tareas habrá que ejecutar
  
⚠️ En esta fase:

- **NO** se implementa código
- **NO** se redefine el sistema

---

**📜 Prompt**

Para nuestro ejemplo, lo que haremos será escribir en el chat de ``Visual Studio Code`` el siguiente prompt:

```
/opsx:propose manage-loans-backend

Define la funcionalidad de gestión de préstamos de juegos basándote en el sistema actual y en los patrones identificados en la fase Explore, tienes el resultado en el fichero "backend-explore.md".

Nos han pedido esta nueva funcionalidad.

Se quiere hacer uso de su catálogo de juegos y de sus clientes, y quiere saber que juegos ha prestado a cada cliente. Para ello nos ha pedido una página bastante compleja donde se podrá consultar diferente información y se permitirá realizar el préstamo de los juegos.

Nos ha pasado el siguiente boceto y requisitos.

La pantalla tendrá dos zonas:

- Una zona de filtrado donde se permitirá filtrar por:
	- Título del juego, que deberá ser un combo seleccionable con los juegos del catálogo de la Ludoteca.
	- Cliente, que deberá ser un combo seleccionable con los clientes dados de alta en la aplicación.
	- Fecha, que deberá ser de tipo Datepicker y que permitirá elegir una fecha de búsqueda. Al elegir un día nos deberá mostrar que juegos están prestados para dicho día. OJO que los préstamos son con fecha de inicio y de fin, si elijo un día intermedio debería aparecer el elemento en la tabla.
- Una zona de listado paginado que deberá mostrar
	- El identificador del préstamo
	- El nombre del juego prestado
	- El nombre del cliente que lo solicitó
	- La fecha de inicio del préstamo
	- La fecha de fin del préstamo
	- Un botón que permite eliminar el préstamo


Al pulsar el botón de Nuevo préstamo se abrirá una pantalla donde se podrá ingresar la siguiente información, toda ella obligatoria:
- Identificador, inicialmente vacío y en modo lectura
- Nombre del cliente, mediante un combo seleccionable
- Nombre del juego, mediante un combo seleccionable
- Fechas del préstamo, donde se podrá introducir dos fechas, de inicio y fin del préstamo.

Las validaciones son sencillas aunque laboriosas:
- La fecha de fin NO podrá ser anterior a la fecha de inicio
- El periodo de préstamo máximo solo podrá ser de 14 días. Si el usuario quiere un préstamo para más de 14 días la aplicación no debe permitirlo mostrando una alerta al intentar guardar.
- El mismo juego no puede estar prestado a dos clientes distintos en un mismo día. OJO que los préstamos tienen fecha de inicio y fecha fin, el juego no puede estar prestado a más de un cliente para ninguno de los días que contemplan las fechas actuales del rango.
- Un mismo cliente no puede tener prestados más de 2 juegos en un mismo día. OJO que los préstamos tienen fecha de inicio y fecha fin, el cliente no puede tener más de dos préstamos para ninguno de los días que contemplan las fechas actuales del rango.

Para empezar te daré unos consejos:

- Recuerda crear la tabla de la BBDD y sus datos
- Intenta primero hacer el listado paginado sin filtros, en el orden que más te guste: frontend o backend. Recuerda que se trata de un listado paginado, así que deberás utilizar el objeto Page.
- Completa el listado conectando ambas capas.
- Ahora implementa los filtros, presta atención al filtro de fecha, es el más complejo.
- Para la paginación filtrada solo tienes que mezclar los conceptos que hemos visto en los puntos del tutorial anteriores.
- Si hiciste el backend en Springboot recuerda revisar Baeldung por si tienes dudas sobre las queries y recuerda que las Specifications son muy útiles, pero en este caso deberás implementar otro tipo de operaciones, no te sirve solo con la operación de igualdad :, que ya vimos en el tutorial.
- Implementa la pantalla de alta de préstamo, sin ninguna validación.
- Cuando ya te funcione, intenta ir añadiendo una a una las validaciones. Algunas de ellas pueden hacerse en frontend, mientras que otras deberán validarse en backend
- Os recordamos que han de poder crearse y editarse préstamos según las reglas de validación indicadas anteriormente. Aplican las mismas reglas para ambas operaciones.
- El Backend ha de validar siempre, independientemente de que el Frontend ya lo haya validado. Nunca confíes de manera exclusiva en terceras partes (Frontend o en otro Backend).




Te voy a dar otras directrices que pienso que te pueden servir:
- Se necesita un CRUD de prestamos
- Debe tener una búsqueda y una paginación, todo en el mismo endpoint
- Fíjate en como están relacionadas las entidades del modelo ya que aquí tendrás que relacionar juego y cliente
- Tienes que implementar las validaciones dentro del método de guardado y creación y, siempre que se pueda, la validación se debe delegar en una query de BBDD.


Necesito que definas:

1. Descripción de la funcionalidad

2. Reglas de negocio

3. Diseño backend:
- Endpoints necesarios
- Estructura del dominio (Entity, DTO, Service, Repository)

4. Decisiones técnicas:
- Qué patrones del sistema actual se reutilizan


NO implementes código.
NO analices de nuevo el proyecto.
Basa la propuesta en los patrones detectados en la fase Explore.
Haz la propuesta únicamente de backend.
Como última tarea añade al fichero de tasks generar un resumen del cambio realizado, con el contrato de los endpoints y la información necesaria para que luego el frontend pueda implementar sus llamadas de forma sencilla.

Tendrás que escribir los ficheros de proposal, design, spec y tasks en la propuesta correspondiente.

```

Igual que en la gestión de clientes, este comando genera dentro del directorio ``changes`` la propuesta correspondiente, que incluye los siguientes ficheros: `proposal.md`, `design.md`, `spec.md`, `tasks.md`.

Estos artefactos están adaptados a la funcionalidad de **gestión de préstamos**, incorporando las reglas de negocio, filtros y validaciones específicas de este caso de uso.

Constituyen la base para la siguiente fase: **Apply**, donde se ejecutará la implementación siguiendo las tareas definidas.

!!! tip "Responsabilidades como developer IA"
    En este punto la IA te ha hecho una propuesta que puede ser correcta o no, recordemos que se trata de un modelo matemático-probabilístico. Si hay algo de lo propuesto que no te encaja o es erróneo deberías comentarlo mediante el chat o corregirlo de forma manual en el fichero que corresponda. Por ejemplo si quieres añadir una tarea porqué se te ha olvidado incluirla en el prompt original, deberías decirle al modelo que te incluya la nueva tarea.

Una vez estemos de acuerdo con la propuesta que nos ha hecho la IA, podemos pasar al siguiente punto.

### Apply

Una vez validada la propuesta, ejecutamos la implementación:

El objetivo de esta fase es transformar los artefactos generados  
(`proposal.md`, `design.md`, `spec.md`, `tasks.md`) en **código funcional**, asegurando que:

- Se respetan los requisitos funcionales definidos en `spec.md`
- Se siguen las decisiones técnicas establecidas en `design.md`
- Se ejecutan las tareas en el orden definido en `tasks.md`

---

**📜 Prompt**

Esto es tan fácil como escribir en el chat de ``Visual Studio Code`` el siguiente prompt:

```
/opsx:apply
```

El agente empezará a realizar un montón de tareas y pedirnos permisos. Es posible que algunas de esas tareas fallen y él mismo lo reintente de otra forma. El resultado debería ser el código generado e implementado dentro de la carpeta de ``backend`` y un resumen de todas las tareas realizadas y checkeadas por la IA.

### Verificación del backend

Un paso que no pertenece a OpenSpec pero que es altamente recomendable es probar los cambios realizados. 
Arranca el backend y verifica:

- Que el servidor levanta
- Que los endpoints existen y funcionan
- Que los tests pasan

!!! warning "Ojo no te fies"
    Ojo no te fies de todo lo que construya la IA. Tu estás al mando, tu debes decidir si el sistema está correctamente implementado o no. Es tu responsabilidad.

Si **NO** estás a gusto con la implementación o se ha dejado algo por hacer, es el momento de escribirlo por el chat indicándole exactamente que es lo que falta. Cuanto más preciso y conciso seas, mejor implementará la IA.





### Archive

Y llegamos a la última etapa que nos define OpenSpec, donde se archiva el cambio y se da por finalizada la funcionalidad.

El objetivo de esta fase es marcar la funcionalidad como completada, consolidar todos los artefactos generados durante el proceso y dejar el sistema en un estado estable, coherente y preparado para nuevas evoluciones.

---

**📜 Prompt**

De nuevo nos vamos al chat de ``Visual Studio Code`` el siguiente prompt:

```

/opsx:archive

```

Durante el proceso de Archive, el sistema solicitará confirmación para sincronizar los requisitos antes de archivar el cambio.

Recuerda que al sincronizar, los requisitos definidos en `spec.md` pasan de ser un cambio temporal a formar parte permanente del sistema.  

Si no se sincroniza, el código queda implementado, pero los requisitos no se registran en los specs principales afectando a la trazabilidad y futuras evoluciones del sistema.


**📜 Actualización del contexto**


Además, para forzar al ``modelo gratuito`` y dejarlo todo listo, es recomendable lanzar un último prompt que nos actualice el fichero de `backend-explore.md`

```

Actualiza el fichero de backend-explore con los nuevos datos implementados

```


## Generación de frontend

Una vez implementado el backend, nos ponemos a trabajar con el frontend. De nuevo recordar que **es muy importante** que cada nuevo cambio que hagamos, lo empecemos en un chat nuevo, para limpiar el contexto anterior y no arrastrar posibles errores o incoherencias.

### Explore

Al igual que en backend, aquí también lanzamos una exploración del sistema por si hubiera algún cambio con respecto a la anterior versión.

--- 

**📜 Prompt**

Vamos **a un nuevo** chat de ``Visual Studio Code`` y escribimos el comando:

```

/opsx:explore

Analiza el proyecto actual que está en el directorio "frontend", es una aplicación Angular. Ojo no escanees la carpeta de "node_modules" no tiene sentido. Una vez analizado, responde:

1. ¿Cómo están implementados los CRUD existentes?
- Componentes
- Servicios
- Modelos

2. ¿Qué estructura siguen los dominios?

3. ¿Cómo se implementan las operaciones?
- Listado
- Creación/edición
- Borrado
- Cómo funcionan las ventanas de creación y edición (modales)

4. ¿Como se comunican frontend con backend?
- Servicios en Angular
- Construcción de URLs

5. ¿Cómo se implementa la paginación?
- Consumo de datos paginados
- Integración en tablas


6. ¿Cómo se implementan los filtros en los listados?
- Especialmente en el catálogo de juegos
- Cómo se envían los filtros desde Angular

7. ¿Cómo se cargan datos en combos (selects) en frontend?
- Servicios Angular utilizados
- Cómo se obtienen los datos
- Flujo de carga en componentes


8. ¿Qué patrones o estructuras comunes se repiten en los CRUD existentes?
- Clases reutilizables
- Lógica repetida
- Estructuras comunes entre dominios


Analiza únicamente la parte de frontend (Angular)
NO propongas soluciones.
NO diseñes nuevas funcionalidades.
Solo analiza el sistema actual.
Ya tienes un contexto previo en el fichero frontend-explore.md en el directorio de las specs, utilizalo y lo actualizas con lo que analices y no esté.

```

Si te fijas en este explore hemos añadido tanto la paginación como los filtros. Al finalizar debería actualizar el fichero explore de frontend y además ofrecernos un resumen.

### Propose

Una vez analizado el sistema en la fase Explore, el siguiente paso es definir de forma clara y estructurada **la nueva funcionalidad a implementar**.

**📜 Prompt**

De nuevo en el chat de ``Visual Studio Code`` escribimos el siguiente prompt:

```

/opsx:propose manage-loans-frontend

Define la funcionalidad de gestión de préstamos de juegos basándote en el sistema actual y en los patrones identificados en la fase Explore, tienes el resultado en el fichero "frontend-explore.md". Además tendrás que ver el cambio realizado en la spec de "manage-loans-backend", sobre todo los endpoints generados. Por si acaso también deberías tener en cuenta el fichero de "backend-explore.md".


Nos han pedido esta nueva funcionalidad.

Se quiere hacer uso de su catálogo de juegos y de sus clientes, y quiere saber que juegos ha prestado a cada cliente. Para ello nos ha pedido una página bastante compleja donde se podrá consultar diferente información y se permitirá realizar el préstamo de los juegos.

Nos ha pasado el siguiente boceto y requisitos.

La pantalla tendrá dos zonas:

- Una zona de filtrado donde se permitirá filtrar por:
	- Título del juego, que deberá ser un combo seleccionable con los juegos del catálogo de la Ludoteca.
	- Cliente, que deberá ser un combo seleccionable con los clientes dados de alta en la aplicación.
	- Fecha, que deberá ser de tipo Datepicker y que permitirá elegir una fecha de búsqueda. Al elegir un día nos deberá mostrar que juegos están prestados para dicho día. OJO que los préstamos son con fecha de inicio y de fin, si elijo un día intermedio debería aparecer el elemento en la tabla.
- Una zona de listado paginado que deberá mostrar
	- El identificador del préstamo
	- El nombre del juego prestado
	- El nombre del cliente que lo solicitó
	- La fecha de inicio del préstamo
	- La fecha de fin del préstamo
	- Un botón que permite eliminar el préstamo


Al pulsar el botón de Nuevo préstamo se abrirá una pantalla donde se podrá ingresar la siguiente información, toda ella obligatoria:
- Identificador, inicialmente vacío y en modo lectura
- Nombre del cliente, mediante un combo seleccionable
- Nombre del juego, mediante un combo seleccionable
- Fechas del préstamo, donde se podrá introducir dos fechas, de inicio y fin del préstamo.

Las validaciones son sencillas aunque laboriosas:
- La fecha de fin NO podrá ser anterior a la fecha de inicio
- El periodo de préstamo máximo solo podrá ser de 14 días. Si el usuario quiere un préstamo para más de 14 días la aplicación no debe permitirlo mostrando una alerta al intentar guardar.
- El mismo juego no puede estar prestado a dos clientes distintos en un mismo día. OJO que los préstamos tienen fecha de inicio y fecha fin, el juego no puede estar prestado a más de un cliente para ninguno de los días que contemplan las fechas actuales del rango.
- Un mismo cliente no puede tener prestados más de 2 juegos en un mismo día. OJO que los préstamos tienen fecha de inicio y fecha fin, el cliente no puede tener más de dos préstamos para ninguno de los días que contemplan las fechas actuales del rango.

Para empezar te daré unos consejos:

- Recuerda crear la tabla de la BBDD y sus datos
- Intenta primero hacer el listado paginado sin filtros, en el orden que más te guste: frontend o backend. Recuerda que se trata de un listado paginado, así que deberás utilizar el objeto Page.
- Completa el listado conectando ambas capas.
- Ahora implementa los filtros, presta atención al filtro de fecha, es el más complejo.
- Para la paginación filtrada solo tienes que mezclar los conceptos que hemos visto en los puntos del tutorial anteriores.
- Si hiciste el backend en Springboot recuerda revisar Baeldung por si tienes dudas sobre las queries y recuerda que las Specifications son muy útiles, pero en este caso deberás implementar otro tipo de operaciones, no te sirve solo con la operación de igualdad :, que ya vimos en el tutorial.
- Implementa la pantalla de alta de préstamo, sin ninguna validación.
- Cuando ya te funcione, intenta ir añadiendo una a una las validaciones. Algunas de ellas pueden hacerse en frontend, mientras que otras deberán validarse en backend
- Os recordamos que han de poder crearse y editarse préstamos según las reglas de validación indicadas anteriormente. Aplican las mismas reglas para ambas operaciones.
- El Backend ha de validar siempre, independientemente de que el Frontend ya lo haya validado. Nunca confíes de manera exclusiva en terceras partes (Frontend o en otro Backend).




Te voy a dar otras directrices que pienso que te pueden servir:
- Se necesita un CRUD de prestamos
- Debe tener una búsqueda y una paginación, así que fíjate en como está hecho en otras pantallas
- Todo lo que se pueda tendrá que estar con componentes de tipo dropdown
- Es posible que tengas que implementar algún nuevo endpoint para rellenar los componentes dropdown, diseña eso también para el backend.


Necesito que definas:

1. Descripción de la funcionalidad

2. Reglas de negocio

3. Diseño frontend:
- Componentes necesarios
- Flujos de interacción (listado, abrir modal, guardar borrar)

4. Uso de endpoints para llamar a backend

5. Decisiones técnicas:
- Qué patrones del sistema actual se reutilizan


NO implementes código.
NO analices de nuevo el proyecto.
Basa la propuesta en los patrones detectados en la fase Explore.
Haz la propuesta únicamente de frontend.
Olvídate de los test, en frontend no tenemos tests.
Añade el nuevo punto de menú en el header para que se pueda acceder.
No te inventes estilos, respeta los estilos de las pantallas (anchuras, alturas, colores, disposición de las tablas).
Utiliza los componentes de Angular Material para todo lo que puedas, no componentes nativos del navegador.

Tendrás que escribir los ficheros de proposal, design, spec y tasks en la propuesta correspondiente.


```

Aquí es importante destacar que debe tener en cuenta:

- debe coger el contexto generado anteriormente
- además, le debe sumar el contexto del último cambio de backend con los endpoints
- debe respetar estilos y componentes de Angular material y no inventar
- debe revisar como se rellenan los dropdown

De nuevo este comando genera dentro del directorio ``changes`` la propuesta correspondiente, que incluye los siguientes ficheros: `proposal.md`, `design.md`, `spec.md`, `tasks.md`. Que deberemos revisar.


!!! tip "No nos cansaremos de decirlo"
    Esta es la fase más importante, aquí es donde debes revisar toda la propuesta y si algo no te encaja o es erróneo deberías comentarlo mediante el chat o corregirlo de forma manual en el fichero que corresponda. Es tú responsabilidad.

Una vez estemos de acuerdo con la propuesta que nos ha hecho la IA, podemos pasar al siguiente punto.


### Apply

Una vez validado todo, pasamos a ejecutarlo.

**📜 Prompt**

Esto es tan fácil como escribir en el chat de ``Visual Studio Code`` el siguiente prompt:

```
/opsx:apply
```

El agente empezará a realizar un montón de tareas y pedirnos permisos. Es posible que algunas de esas tareas fallen y él mismo lo reintente de otra forma. El resultado debería ser el código generado e implementado tanto en la carpeta ``backend`` como en la carpeta ``frontend`` y un resumen de todas las tareas realizadas y checkeadas por la IA.

### Verificación del frontend

Un paso que no pertenece a OpenSpec pero que es altamente recomendable es probar los cambios realizados. 

Arranca el **backend** y el **frontend** y verifica:

- La aplicación levanta correctamente
- Las nuevas funcionalidades añadidas están accesibles
- Los flujos principales definidos en `spec.md` funcionan como se espera

!!! warning "Ojo no te fies"
    Ojo no te fies de todo lo que construya la IA. Tu estás al mando, tu debes decidir si el sistema está correctamente implementado o no. Es tu responsabilidad.

Si **NO** estás a gusto con la implementación o se ha dejado algo por hacer, es el momento de escribirlo por el chat indicándole exactamente que es lo que falta. Cuanto más preciso y conciso seas, mejor implementará la IA.

### Archive

Y llegamos a la última etapa que nos define OpenSpec, donde se archiva el cambio y se da por finalizada la funcionalidad.

El objetivo de esta fase es marcar la funcionalidad como completada, consolidar todos los artefactos generados durante el proceso y dejar el sistema en un estado estable, coherente y preparado para nuevas evoluciones.

---

**📜 Prompt**

De nuevo nos vamos al chat de ``Visual Studio Code`` el siguiente prompt:

```
/opsx:archive
```

Durante el proceso de Archive, el sistema solicitará confirmación para sincronizar los requisitos antes de archivar el cambio.

Recuerda que al sincronizar, los requisitos definidos en `spec.md` pasan de ser un cambio temporal a formar parte permanente del sistema.  

Si no se sincroniza, el código queda implementado, pero los requisitos no se registran en los specs principales afectando a la trazabilidad y futuras evoluciones del sistema.