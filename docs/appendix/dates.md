# Fechas

!!! warning "Atención"
	Esta sección está incompleta y todavía en desarrollo. Puedes leerla pero seguramente cambiará o ampliará su información.


## Como trabajar con las fechas
El problema que presenta al trabajar con las fechas es que el navegador puede tener una zona horaria y el servidor estar en otra.

Aquí hay una deficiencia por parte de JavaScript que, al trabajar con fechas, le añade la zona horaria y no es posible de una forma optima remover la zona horaria del objeto Date.

A sí que vamos a intentar de trabajar en estos casos con formateos de fecha preestablecidas

Una propuesta es trabajar en el FRONT y Back con este formato

```
"dd/MM/yyyy HH:mm:ss"
```
