# Conclusiones

1. **Show y Present Modally:** `Show` conviene cuando la pantalla forma parte de una ruta jerarquica y el usuario debe poder volver con el boton Back, como entrar al detalle de un producto. `Present Modally` conviene para una tarea temporal que interrumpe el flujo, como confirmar datos o iniciar sesion.
2. **Show Detail y Present As Popover:** `Show Detail` reemplaza o actualiza la zona de detalle de una interfaz dividida, especialmente en iPad. `Present As Popover` muestra contenido contextual anclado a un control y tiene mayor sentido en iPad; en iPhone normalmente se adapta a una presentacion de pantalla completa o tipo hoja.
3. **Modelo como struct:** el paso de datos seguiria funcionando, pero la segunda pantalla recibiria una copia. Con `class`, ambas variables pueden apuntar al mismo objeto; con `struct`, cada modificacion ocurre sobre su propio valor.
4. **Manual frente a IA:** el ejercicio manual ayuda a comprender cada conexion del Storyboard y el ciclo de presentacion. La asistencia de IA acelera la escritura repetitiva y sugiere validaciones, pero es necesario revisar las formulas, los outlets y el identifier del segue.
