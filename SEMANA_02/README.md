# Sistema de préstamo de libros

## Descripción

Este ejercicio implementa en Swift un sistema de préstamo de libros ejecutado desde consola. El programa solicita el título del libro, el tipo de usuario y las fechas del préstamo para validar la operación y calcular posibles multas por atraso.

Se contemplan tres tipos de usuario:

| Usuario | Días máximos | Multa base por día |
| --- | ---: | ---: |
| Alumno | 7 días | S/ 1.50 |
| Docente | 15 días | S/ 2.00 |
| Administrador | 10 días | S/ 3.00 |

## Funcionamiento

El programa realiza las siguientes operaciones:

1. Solicita el título del libro y el tipo de usuario.
2. Valida que la fecha de préstamo coincida con la fecha actual.
3. Comprueba que la fecha prometida no sea anterior al préstamo ni exceda los días permitidos para el usuario.
4. Registra la fecha real de devolución y calcula los días de atraso.
5. Aplica una multa progresiva:
   - Días 1 al 3: 100 % de la multa base.
   - Días 4 al 6: 150 % de la multa base.
   - Día 7 en adelante: 200 % de la multa base.
6. Muestra un calendario con la fecha, los días de atraso, la multa diaria y el monto acumulado.
7. Presenta un resumen final. Si el atraso alcanza 10 días o más, el usuario queda suspendido.

El código fuente se encuentra en [`EjercicioPractico.playground/Contents.swift`](EjercicioPractico.playground/Contents.swift).

## Prompt utilizado

> Crear un programa en Swift para gestionar el préstamo de libros. El sistema debe solicitar el título del libro y permitir seleccionar el tipo de usuario: Alumno, Docente o Administrador. Cada usuario tendrá un máximo de días de préstamo y una multa diaria diferente: Alumno, 7 días y S/ 1.50; Docente, 15 días y S/ 2.00; Administrador, 10 días y S/ 3.00. El programa debe pedir y validar la fecha de préstamo, la fecha prometida y la fecha real de devolución usando el formato dd/MM/yyyy. La fecha de préstamo debe ser la fecha actual, la fecha prometida no puede ser anterior ni superar el máximo permitido y la fecha real no puede ser anterior al préstamo. Si existe atraso, calcular una multa progresiva: 100 % durante los días 1 al 3, 150 % durante los días 4 al 6 y 200 % desde el día 7. Mostrar un calendario con cada fecha de atraso, la multa del día y el monto acumulado. Finalmente, mostrar un resumen con las fechas, días solicitados, días de atraso, multa total, estado del préstamo y situación del usuario. Si el atraso es de 10 días o más, el usuario debe quedar suspendido.

## Evidencias de funcionamiento

### Caso 1: Alumno

El sistema rechaza primero una fecha de préstamo distinta de la fecha actual. Después acepta el préstamo del alumno por 6 días, debido a que se encuentra dentro del máximo permitido de 7 días.

![Ingreso y validación de fechas para Alumno](evidencias/alumno-ingreso-fechas.png)

La devolución presenta 5 días de atraso. El calendario aplica S/ 1.50 durante los tres primeros días y S/ 2.25 durante los días cuarto y quinto. El resultado final es una multa acumulada de **S/ 9.00** y el usuario permanece habilitado.

![Calendario y resultado final para Alumno](evidencias/alumno-resultado-multa.png)

### Caso 2: Docente

El docente solicita el libro *Harry Potter* desde el 27/08/2026 hasta el 09/09/2026. Los 13 días solicitados se encuentran dentro del máximo permitido de 15 días.

![Ingreso y validación de fechas para Docente](evidencias/docente-ingreso-fechas.png)

La devolución se realiza el 30/09/2026 y genera 21 días de atraso. El sistema aplica las tres etapas de la multa progresiva y obtiene un total de **S/ 75.00**. Como el atraso supera los 10 días, el docente queda suspendido para nuevos préstamos.

![Calendario y resultado final para Docente](evidencias/docente-resultado-multa.png)

## Resultado

Las pruebas demuestran que el programa valida correctamente los límites de préstamo, calcula las multas progresivas, acumula los importes por fecha y determina el estado final del usuario.
