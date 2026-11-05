# Expediente del caso Ventas

Semana 12 · Grupo A · UIKit y Core Data  
Integrantes propuestos según el trabajo anterior: Luis Dionicio Bartolo y Andy Campos Escandon.  
App: Ventas. Referencia: GLAB-S11-JLEONS-2026-02.pdf, páginas 20 a 24 y 28 a 30.

## Modelo de datos

| Entidad | Atributos | Relaciones |
| --- | --- | --- |
| Usuario | nombre, usuario, clave y rol como String | ventas hacia Venta, muchos, Deny |
| Producto | nombre y categoria como String, precio como Double, stock como entero | ventas hacia Venta, muchos, Deny |
| Cliente | nombre y documento como String | ventas hacia Venta, muchos, Deny |
| Venta | fecha como Date, cantidad como entero, precioUnitario, descuento, igv y total como Double, anulada como Bool, motivoAnulacion como String opcional | vendedor hacia Usuario, producto hacia Producto, cliente hacia Cliente, uno cada una |

Cada relación tiene inversa. Las relaciones de Venta hacia sus padres utilizan Nullify. Las relaciones de los padres hacia Venta utilizan Deny y bloquean el borrado cuando existen ventas, incluidas las anuladas. El modelo inicial tendrá nombre Ventas y contenedor NSPersistentContainer del mismo nombre.

Usuario 1 ← N Venta N → 1 Producto  
Cliente 1 ← N Venta

La categoría del cliente se calcula desde sus ventas vigentes. El precio de cada operación se conserva en precioUnitario aunque luego cambie el catálogo.

## Roles y permisos

| Acción | Vendedor | Supervisor |
| --- | --- | --- |
| Pestañas | Productos, Clientes, Venta, Mis ventas, Cuenta | Resumen, Ventas, Productos, Clientes, Cuenta |
| Productos | Consultar y buscar | Crear, consultar, editar y borrar |
| Clientes | Crear, consultar y editar | Crear, consultar, editar y borrar |
| Ventas | Registrar y consultar las propias | Consultar todas, filtrar y anular con motivo |
| Resumen | Sin acceso | Indicadores, gráfico, ranking y stock bajo |
| Cuenta | Nombre, usuario, rol y cerrar sesión | Nombre, usuario, rol y cerrar sesión |

Los permisos se validan tanto en los controles como en las operaciones. El usuario que registra una venta procede de la sesión.

## Reglas con ejemplos

- Usuario único sin distinguir mayúsculas. Registrar lparedes impide registrar LPAREDES. Clave mínima de seis caracteres con confirmación coincidente.
- Un registro válido inicia sesión. Un login inválido muestra “Usuario o clave incorrectos”. Cerrar sesión vuelve al login.
- Categoría según total vigente acumulado. S/ 999.99 corresponde a Regular, S/ 1,000.00 a Frecuente y S/ 5,000.00 a VIP. Se evalúa la categoría previa a la nueva venta.
- Venta VIP de dos Laptop de S/ 200.00. Subtotal S/ 400.00, descuento S/ 40.00, base S/ 360.00, IGV S/ 64.80 y total S/ 424.80. Stock de 40 a 38.
- Venta Regular de tres Mouse de S/ 35.00. Subtotal S/ 105.00, descuento cero, IGV S/ 18.90 y total S/ 123.90.
- Cantidad entera positiva hasta el stock disponible. Pedir 50 con stock 40 rechaza la operación y mantiene el stock.
- Guardar venta y reducir stock en una misma operación del contexto. Un fallo revierte ambos cambios.
- Solo el supervisor anula. Motivo obligatorio tras quitar espacios. Anular devuelve el stock una sola vez y excluye la venta de los reportes y de la categoría.
- Eliminar un cliente, producto o usuario con ventas muestra una alerta por la regla Deny.
- Para los importes, usar Decimal en las operaciones y redondear a dos decimales antes de guardar los atributos Double solicitados.
- Stock verde por encima de 10, ámbar entre 6 y 10, rojo hasta 5. Ejemplos de límites: 11 verde, 10 y 6 ámbar, 5 rojo.

## Pantallas y referencias

| Pantalla | Referencia PDF | Propósito y datos |
| --- | --- | --- |
| A1 Login | Página 21 | Logo, usuario, clave oculta, error genérico, Ingresar y Crear cuenta |
| A2 Registro | Página 21 | Nombre, usuario, clave y confirmación, selector de rol, acceso directo al registrarse |
| A3 Productos | Página 22 | Buscar, categorías, filas con stock por color, alta y eliminación según rol |
| A4 Clientes | Página 22 | Iniciales, nombre, documento, total acumulado y categoría calculada |
| A5 Nueva venta | Página 22 | Vendedor de sesión, cliente, producto, stepper y resumen con descuento e IGV |
| A6 Mis ventas | Página 22 | Indicadores propios, filtros Todas, Hoy y Mes, búsqueda por cliente y anuladas |
| A7 Ventas del equipo | Página 23 | Filtro por vendedor, relación visible y acción Anular para supervisor |
| A8 Anulación | Página 23 | Alerta con venta, devolución de stock y motivo obligatorio |
| A9 Resumen | Página 23 | Saludo, indicadores, comparación diaria, barras de siete días, ranking y stock bajo |

Cuenta es una pantalla auxiliar con nombre, usuario, rol y Cerrar sesión. La navegación usa Storyboard, segues y UITabBarController según rol. Cada tabla se enlaza con su controlador y se fija al área segura con constraints de cero.

## Casos de prueba

| Caso | Acción | Resultado esperado |
| --- | --- | --- |
| 1 | Registrar lparedes Supervisor y luego LPAREDES | Primero accede y segundo se rechaza |
| 2 | Claves distintas o cuatro caracteres | Error y usuario sin crear |
| 3 | Login con clave errónea | Error genérico y permanece en login |
| 4 | Dos Laptop de 200 para VIP con stock 40 | Total 424.80 y stock 38 |
| 5 | Tres Mouse de 35 para Regular | Total 123.90 |
| 6 | Vender 50 con stock 40 | Rechazo y stock 40 |
| 7 | Abrir Mis ventas como vendedor | Solo propias y acción Anular ausente |
| 8 | Anular caso 4 sin motivo y luego con motivo | Primero bloquea, luego stock 40 y resumen baja 424.80 |
| 9 | Borrar cliente con ventas | Deny y alerta |
| 10 adicional | Repetir la anulación del caso 4 | Stock permanece 40 |
| 11 adicional | Cerrar y abrir tras guardar una venta | Venta y stock persisten |

Para preparar el caso VIP, registrar ventas vigentes previas por al menos S/ 5,000. Antes de cada prueba se especificará el estado inicial y la sesión utilizada.

## Plan de commits y entrega

1. Modelo de cuatro entidades con inversas y reglas de borrado.
2. A1 login y sesión.
3. A2 registro y usuario único.
4. A3 productos y permisos.
5. A4 clientes y categoría.
6. A5 venta y actualización de stock.
7. A6 ventas propias y filtros.
8. A7 ventas del equipo.
9. A8 anulación y devolución de stock.
10. A9 resumen, Cuenta, icono, pruebas y evidencias.

Hacer commit y push después de cada pantalla validada. La guía establece main para expediente y entrega final, manual para trabajo sin ayuda e ia-asistida para construcción con IA. Por instrucción del usuario, el caso completo se desarrolla y entrega en SEMANA_12, rama Ejercicio. El expediente es un borrador asistido para revisión. El visto bueno docente continúa pendiente de confirmación.

## Plan de uso de IA

Solicitar revisión del modelo, propuesta de controladores y apoyo para errores concretos. Comprobar cada resultado con las nueve pruebas de la guía y las dos adicionales. Registrar las consultas reales en PROMPTS.md. Cada integrante debe poder explicar la persistencia, permisos y cálculos.

## Visto bueno del docente

Pendiente de confirmación. Registrar fecha, docente y medio de aprobación antes de la construcción asistida.
