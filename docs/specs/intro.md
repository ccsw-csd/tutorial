# Introducción a Spec-Driven Development

!!! warning Atención
    Esta sección se encuentra en desarrollo 🚧.  
    **NO se recomienda realizarla** a menos que te lo hayan indicado expresamente.

## Contexto

En este bloque del tutorial vamos a implementar nuevas funcionalidades usando **Spec-Driven Development (SDD)** con **OpenSpec**.

El objetivo no es únicamente desarrollar nuevas funcionalidades, sino hacerlo siguiendo un proceso estructurado que permita separar claramente las distintas fases del desarrollo y garantizar **trazabilidad entre análisis, definición, implementación y validación**.

Para llevar a cabo este enfoque de manera práctica, se utiliza la metodología **OpenSpec**, que proporciona un flujo de trabajo claro y repetible para definir, implementar y consolidar cambios en el sistema.

Las funcionalidades abordadas se organizan en dos bloques principales:

- **Gestión de clientes**
- **Gestión de préstamos**

Ambas se implementan siguiendo las fases definidas por **OpenSpec**, reutilizando los patrones existentes del sistema y manteniendo coherencia técnica y funcional con el resto de la aplicación.

---

## ¿Qué es Spec-Driven Development?

**Spec-Driven Development (SDD)** es un enfoque de desarrollo en el que el comportamiento del sistema se define de forma explícita **antes de escribir código**.

En lugar de comenzar directamente con la implementación, SDD propone describir primero:

- Qué debe hacer el sistema
- Qué reglas y restricciones deben cumplirse
- Qué comportamiento se espera en cada escenario

Las especificaciones (*specs*) se convierten en el eje central del desarrollo y sirven como referencia común durante todo el proceso.

Este enfoque permite:

- Reducir ambigüedades sobre el comportamiento esperado
- Detectar errores de diseño de forma temprana
- Mantener coherencia en sistemas que evolucionan con el tiempo
- Facilitar la comunicación entre personas y herramientas implicadas en el desarrollo

---

## OpenSpec como metodología de trabajo

**OpenSpec** es una metodología que materializa el enfoque de **Spec-Driven Development**, proporcionando un flujo de trabajo estructurado para implementar cambios de forma controlada y trazable.

OpenSpec organiza el desarrollo en una serie de fases bien definidas que permiten:

- Analizar el contexto y el alcance del cambio
- Definir el comportamiento funcional esperado
- Implementar la solución de forma alineada con lo definido
- Cerrar y consolidar el cambio de manera ordenada

A lo largo de esta guía se utilizará OpenSpec como marco de trabajo para aplicar SDD en la implementación de las funcionalidades de gestión de clientes y gestión de préstamos.

!!! tip "SDD y agentes de IA"
    Al trabajar con agentes de IA, el código puede generarse rápidamente, pero sin una guía clara existe el riesgo de que la IA tome decisiones no deseadas para que “el código funcione”.  

    OpenSpec traslada el foco a las especificaciones, que definen explícitamente el comportamiento esperado del sistema y sirven como contrato para la IA, reduciendo ambigüedades y asegurando trazabilidad entre lo definido y lo implementado.

Es **sumamente importante** que se defina de forma concreta y muy concisa los requisitos y las reglas que debe seguir la IA a la hora de analizar y generar.


## Fases de OpenSpec

El flujo de trabajo de OpenSpec se estructura en cuatro fases principales:

```

1. Explore
2. Propose
3. Apply
4. Archive

```

Cada una de estas fases cumple un propósito específico y se apoya en la anterior, formando un ciclo completo de definición, implementación y cierre del cambio.

---

### Explore

Fase inicial orientada a **comprender el contexto** en el que se va a trabajar.

**Objetivo**

- Analizar la información disponible
- Entender la necesidad, iniciativa o cambio a abordar
- Identificar posibles limitaciones, dependencias y patrones existentes

Esta fase no implica necesariamente la existencia de un sistema previo. 
 
Puede consistir en:

- Analizar un sistema existente
- Revisar documentación o requisitos
- Definir el contexto cuando se parte desde cero

**Resultado**

Una comprensión clara del punto de partida y del alcance del cambio a realizar.

---

### Propose

Fase orientada a la **definición de la solución** a implementar.

**Objetivo**

- Definir qué se va a construir
- Delimitar el alcance del cambio (qué se incluye y qué queda fuera)
- Establecer el comportamiento funcional esperado

**Resultado**

Una propuesta clara, estructurada y alineada con el objetivo del cambio, que servirá como base para su implementación. En esta fase se deberían generar 4 ficheros.


**📄 proposal.md**

Define la funcionalidad a alto nivel.

Incluye:

- El problema que se quiere resolver (Why) 
- Qué cambios se van a introducir (What Changes) 
- El alcance funcional 
- El impacto en la aplicación

Responde a: ¿Qué se va a construir y por qué?

**📄 design.md**

Describe el diseño técnico de la solución.

Incluye:

- Contexto del sistema actual 
- Objetivos (Goals / Non-Goals) 
- Decisiones técnicas y su justificación 
- Alternativas consideradas 
- Riesgos y trade-offs 

Responde a: ¿Cómo se va a construir y por qué se ha elegido este enfoque?

**📄 spec.md**

Define el comportamiento funcional esperado.

Incluye:

- Requisitos funcionales
- Casos de uso expresados como escenarios (WHEN / THEN) 
- Reglas de negocio 
- Validaciones y restricciones 

Responde a: ¿Qué debe hacer el sistema?

**📄 tasks.md**

Descompone la implementación en tareas ejecutables. Quizá es el fichero más importante.

Incluye:

- Lista ordenada de tareas 
- Pasos concretos para implementar la funcionalidad 

Responde a: ¿Cómo se implementa paso a paso?

**Relación entre los artefactos**

Cada uno de los ficheros generados cumple un rol específico dentro del flujo de OpenSpec:

- **spec.md** → define el comportamiento esperado (*qué debe hacer el sistema*)
- **design.md** → define la solución técnica (*cómo se va a construir*)
- **proposal.md** → aporta contexto y alcance (*por qué se construye*)
- **tasks.md** → guía la ejecución paso a paso (*cómo se implementa*)

Esta separación de responsabilidades permite:

- Evitar mezclar requisitos con implementación
- Revisar cada nivel de forma independiente
- Detectar errores e inconsistencias antes de escribir código

Estos artefactos constituyen la base para la siguiente fase.


---

### Apply

Fase en la que se lleva a cabo la **implementación** de la solución definida en la fase Propose.

**Objetivo**

- Desarrollar la solución definida
- Asegurar la coherencia entre lo definido y lo implementado
- Integrar y validar funcionalmente el resultado

**Resultado**

Una solución implementada, coherente con la propuesta definida y preparada para su validación final.

---

### Archive

Fase final de **cierre y consolidación** del cambio.

**Objetivo**

- Confirmar que el cambio está completo
- Consolidar la documentación generada durante el proceso
- Garantizar la trazabilidad para futuras evoluciones

**Resultado**

Un cambio finalizado, validado y correctamente documentado. 
En esta fase se pedirá sincronizar los requisitos antes de archivar y consolidar.

**¿Qué significa sincronizar?**

Al seleccionar la opción de sincronización:

- Se integran los nuevos requisitos definidos en spec.md 
- Se crea o actualiza el spec definitivo
- Los requisitos pasan a formar parte oficial del sistema 

Es decir, los requisitos pasan de ser un cambio temporal a formar parte permanente del sistema.

**¿Qué ocurre si no se sincroniza?**

Si se decide no sincronizar:

- El código permanece implementado
- Los requisitos no se registran en los specs principales

Esto puede provocar:

- Pérdida de trazabilidad 
- Dificultad para futuras evoluciones 
- Desalineación entre código y documentación

**Tras completar el proceso de Archive:**

- La funcionalidad queda documentada como completada
- El cambio deja de formar parte de los cambios activos
- Los requisitos quedan integrados definitivamente en el sistema (si se ha sincronizado)



## Principios de calidad

!!! tip "SDD y agentes de IA"
    Con agentes de IA se genera código muy rápido, pero la responsabilidad técnica sigue siendo tuya.

Durante todo el proceso:

- revisa siempre la propuesta antes de aplicar,
- valida funcionalmente lo implementado,
- corrige tareas o requisitos cuando detectes desviaciones,
- no asumas que la primera respuesta de la IA es correcta.