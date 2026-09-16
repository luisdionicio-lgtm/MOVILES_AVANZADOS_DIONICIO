# Móviles Avanzados

## Semana 04 — Programación orientada a objetos en Swift

Este módulo contiene dos actividades desarrolladas en Swift Playgrounds para
aplicar estructuras, clases, herencia, sobrescritura de métodos y polimorfismo.

### Actividad 01: Matrícula de cursos

La aplicación debe registrar los datos de un estudiante, administrar los cursos
de su matrícula y generar una factura con los importes, impuestos y descuentos
correspondientes.

#### Requerimientos funcionales

- **RF-01 — Registrar al estudiante:** El sistema debe almacenar el nombre, el
  DNI y la condición que indica si el estudiante pertenece a Tecsup.
- **RF-02 — Registrar cursos:** El sistema debe permitir agregar uno o más
  cursos a la matrícula. Por cada curso debe registrar el nombre, el precio
  unitario y la cantidad de inscripciones.
- **RF-03 — Calcular el importe por curso:** El sistema debe obtener el importe
  de cada curso multiplicando su precio unitario por la cantidad registrada.
- **RF-04 — Calcular la cantidad total:** El sistema debe sumar las cantidades
  de todos los cursos registrados, incluso cuando un curso tenga más de una
  inscripción.
- **RF-05 — Calcular el subtotal:** El sistema debe sumar los importes de todos
  los cursos antes de aplicar el impuesto y los descuentos.
- **RF-06 — Calcular el IGV:** El sistema debe calcular el IGV equivalente al
  18 % del subtotal.
- **RF-07 — Calcular el total con IGV:** El sistema debe sumar el subtotal y el
  IGV para obtener el importe previo a los descuentos.
- **RF-08 — Aplicar descuento por cantidad:** Si la matrícula contiene tres o
  más inscripciones, el sistema debe descontar el 10 % del total con IGV. Si no
  cumple esa condición, el descuento debe ser cero.
- **RF-09 — Aplicar descuento Tecsup:** Si el estudiante pertenece a Tecsup y
  registra tres o más inscripciones, el sistema debe aplicar un descuento fijo
  adicional de S/ 400.00. Si alguna condición no se cumple, el descuento debe
  ser cero.
- **RF-10 — Calcular el total final:** El sistema debe restar del total con IGV
  el descuento por cantidad y el descuento especial Tecsup.
- **RF-11 — Emitir la factura:** El sistema debe mostrar los datos del
  estudiante, el detalle de cada curso, el subtotal, el IGV, el total con IGV,
  los descuentos aplicados y el total final por pagar. Todos los importes deben
  presentarse en soles con dos decimales.

#### Reglas de cálculo

```text
Importe del curso = precio unitario × cantidad
Subtotal          = suma de los importes
IGV               = subtotal × 0.18
Total con IGV     = subtotal + IGV
Total final       = total con IGV − descuento por cantidad − descuento Tecsup
```

### Actividad 02: Gestión de clientes

La aplicación debe representar clientes bancarios mediante una clase base y
dos tipos especializados: cliente natural y cliente jurídico. Debe poder
mostrar correctamente la información correspondiente a cada tipo de cliente.

#### Requerimientos funcionales

- **RF-01 — Registrar datos comunes:** El sistema debe almacenar para cada
  cliente su código, dirección, fecha de registro, número de cuenta y monto
  mínimo de apertura.
- **RF-02 — Registrar un cliente natural:** El sistema debe permitir registrar
  una persona natural con su nombre completo y DNI, además de los datos comunes
  del cliente.
- **RF-03 — Registrar un cliente jurídico:** El sistema debe permitir registrar
  una empresa con su razón social, RUC y representante legal, además de los
  datos comunes del cliente.
- **RF-04 — Especializar los tipos de cliente:** Los clientes naturales y
  jurídicos deben heredar los atributos y comportamientos compartidos de la
  clase base `Cliente`.
- **RF-05 — Mostrar un cliente natural:** El sistema debe identificar el tipo de
  cliente y mostrar su nombre completo, DNI y todos sus datos bancarios comunes.
- **RF-06 — Mostrar un cliente jurídico:** El sistema debe identificar el tipo
  de cliente y mostrar su razón social, RUC, representante legal y todos sus
  datos bancarios comunes.
- **RF-07 — Administrar clientes en una colección común:** El sistema debe poder
  almacenar clientes naturales y jurídicos en una misma colección basada en el
  tipo `Cliente`.
- **RF-08 — Aplicar polimorfismo al mostrar datos:** Al recorrer la colección,
  el sistema debe ejecutar automáticamente la presentación adecuada según el
  tipo real de cada cliente.
- **RF-09 — Formatear la información financiera:** El monto mínimo de apertura
  debe mostrarse en soles con dos decimales.
- **RF-10 — Listar todos los clientes:** El sistema debe recorrer la colección y
  mostrar la información completa de cada cliente de forma separada y legible.

## Ejecución

Abra los siguientes archivos con Xcode y ejecute cada playground:

- `SEMANA_04/Actividad_01_Cursos/Actividad_01_Cursos.playground`
- `SEMANA_04/Actividad_02_Clientes/Actividad_02_Clientes.playground`
