# Pruebas · Grupo A

Ejecución en iPhone 16, iOS 26.5, 5 de noviembre de 2026. Las comprobaciones automáticas usan una base en memoria independiente de la base de la app. Resultado: [13 comprobaciones aprobadas](evidencias/pruebas-grupo-a.json).

| Caso de la guía | Resultado automático | Evidencia y alcance |
|---|---|---|
| 1. Usuario único sin distinguir mayúsculas | Aprobado | Registro e inicio directo y rechazo de duplicado en lógica |
| 2. Clave corta o confirmación diferente | Aprobado | [Clave corta en interfaz](evidencias/prueba-clave-corta.png); confirmación diferente comprobada en lógica |
| 3. Login incorrecto | Aprobado | [Mensaje genérico en interfaz](evidencias/prueba-login-invalido.png) |
| 4. Venta VIP | Aprobado | Descuento 40, IGV 64.80, total 424.80 y stock 40 a 38; [cálculo en interfaz](evidencias/A5-nueva-venta.png) |
| 5. Venta regular | Aprobado | IGV 18.90 y total 123.90 en lógica |
| 6. Stock insuficiente | Aprobado en lógica | Rechazo sin cambio de stock; el stepper limita la cantidad y no permite reproducir 50 con stock 40 desde la interfaz |
| 7. Ventas propias y permisos | Aprobado en lógica | Otro vendedor no ve la venta y no puede anular; [historial](evidencias/A6-mis-ventas.png) |
| 8. Anulación | Aprobado en lógica | Motivo obligatorio, stock restituido y reportes actualizados; [alerta y botón deshabilitado](evidencias/A8-anulacion.png) |
| 9. Borrado de cliente con ventas | Aprobado en lógica y regla Deny | Falta evidencia del mensaje de borrado en interfaz |

Adicionalmente se verificó el rechazo de una segunda anulación y la repetibilidad del cálculo. Las capturas del README documentan las pantallas y el filtro por vendedor. La persistencia tras reiniciar se comprobó previamente con la venta de S/ 424.80; la base local no forma parte del repositorio.

Estas pruebas de lógica no sustituyen una ejecución completa de cada caso por la interfaz. En particular, el caso 6 queda limitado por el control de cantidad; no se afirma que aparezca la alerta desde la pantalla.
