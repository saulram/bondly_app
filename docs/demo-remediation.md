# Remediación de riesgos para demo

## Corregido en código

- Perfil deja de reintentar indefinidamente y muestra un estado recuperable con botón de reintento.
- El costo de insignias se calcula con los valores cargados y muestra un costo único o un rango real.
- Los filtros de recompensas se generan desde las categorías activas devueltas por el backend.
- La pantalla de notificaciones carga actividades reales, muestra errores y permite marcar elementos como leídos.
- Recuperar contraseña valida el OTP de Supabase con correo y código, actualiza la contraseña y cierra la sesión de recuperación.
- Las rutas de Admin validan al usuario de forma asíncrona antes de redirigir.
- Home deja de mostrar un skeleton indefinido si falla la carga del usuario y ofrece reintento.
- Las recompensas inactivas o invisibles no permiten selección desde la UI.
- El carrito no permite confirmar un canje vacío y el total siempre aparece después de los productos.
- La sincronización del carrito acepta el identificador usado por la UI (`id`) además de `reward_id`.
- Cambiar el rol o el estado de un usuario desde Admin requiere confirmación.
- “Ver todos los comentarios” abre el listado completo.
- Las tarjetas de Embajadas abren un detalle con la información disponible.
- Los errores de personalización del feed y recomendaciones de recompensas se muestran al usuario.

## Producto

- Definir qué acciones debe ofrecer cada notificación al tocarla (abrir feed, canje, insignia, etc.).
- Definir el alcance de una pantalla de detalle de Embajada si el modal actual no es suficiente.
- Acordar la taxonomía y nombres canónicos de categorías de recompensas para evitar variantes futuras.

## Datos y operación

- Rotar las contraseñas de todas las cuentas seed en cualquier ambiente compartido y confirmar que no se reutilicen en producción.
- Publicar en Supabase la plantilla de recuperación incluida en `supabase/templates/recovery.html`, que ahora muestra `{{ .Token }}`; el archivo local no actualiza por sí solo el proyecto alojado.
- Configurar y validar Site URL y redirect URLs de Auth para los dominios finales de la demo.
- Elegir y configurar el proveedor de push (por ejemplo FCM), credenciales, permisos de iOS/Android y registro de tokens. La bandeja interna ya funciona sin push.
- Definir retención o archivado para `activities`; la bandeja muestra como máximo las 100 más recientes.

