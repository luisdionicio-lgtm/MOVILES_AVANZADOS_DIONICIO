# Consultas del caso Ventas

## Preparación del expediente

**Contexto**  
Semana 11, Grupo A, aplicación Ventas con UIKit y Core Data. Actividad guiada de contactos completada.

**Tarea solicitada**  
“Inicia con esto Grupo A · Caso Ventas (UIKit + Core Data)”.

**Restricciones**  
Seguir las cuatro entidades, permisos, nueve pantallas y reglas del laboratorio. Utilizar iPhone 16. Preparar el expediente previo y confirmar visto bueno antes de la construcción asistida.

**Formato esperado**  
Expediente de planificación con modelo, permisos, ejemplos numéricos, pantallas, once pruebas y plan de commits.

**Uso de la respuesta**  
Borrador preparado para revisión de los integrantes y del docente. Confirmación de aceptación pendiente.

## Construcción y revisión efectivamente realizadas

**Solicitud del usuario (resumen):** desarrollar solo Grupo A, UIKit + Core Data, en SEMANA_12 y rama Ejercicio, cumplir reglas y pantallas, commits progresivos, push, ejecutar en iPhone 16 y evidenciar. Mejorar diseño sin turquesa.

**Contexto:** cuatro entidades Usuario, Cliente, Producto y Venta; roles vendedor/supervisor; A1–A9; categorías por compras, VIP 10 %, IGV 18 %, stock, anulación y reglas Deny.

**Restricciones:** conservar otros trabajos, usar solo iPhone 16, no dependencias externas, demostración identificada como ficticia, no simular aprobación docente.

**Formato producido:** fuentes Swift, modelo Core Data, proyecto Xcode, icono, expediente, README y capturas reales; pruebas con resultados JSON.

**Cambios incorporados:** separación Store/controladores, protección de operaciones por rol, guardado de importes históricos, validación de anulación y stock, comprobaciones en memoria, paleta marino/cobre y gráfico semanal. En la revisión de ejecución se corrigieron imports Core Data, uso de defaultDirectoryURL y acceso a categoría sin índice seleccionado.

**Decisiones de implementación:** interfaz UIKit programática con Auto Layout; gráfico Swift Charts embebido. El filtro de vendedor usa UIMenu. No se atribuye a esta versión navegación mediante segues de Storyboard.

**Validación humana pendiente:** revisión académica y defensa por los integrantes. Este registro describe solicitudes reales y su interpretación, no una conversación ficticia con un docente.

**Corrección final del usuario:** «que no salga nada de demo o así pide?». Se retiraron de la app el botón y textos de demostración y el generador; se conserva solo la evidencia histórica de pruebas.
