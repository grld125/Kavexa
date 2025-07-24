# Doumentacion de la base de datos Kavexa 

 ## Tabla de organizaciones

 - **organizacion_id (UUID, PK)** : Identificador único generado automáticamente usando gen_random_uuid().

 - **nombre (TEXT)**: Nombre de la organización.

 - **descripcion (TEXT)**: Descripción opcional de la organización *(Actualmente rellenar el campo no es obligatoprio pero se podria obligar mas adelante)*.

 - **created_at (TIMESTAMP)**: Fecha en que se registró la organización.

 - **configuracion (JSONB)**: Parámetros o preferencias de configuración específicos por organización.

 ## Tabla de usuarios

 - **usuario_id (UUID, PK)**: Identificador único del usuario *(referencia externa a auth.users)*.


 - **organizacion_id (UUID, FK)**: Relación con la organización a la que pertenece.


 - **nombre (TEXT)**: Nombre completo del usuario.


 - **correo (TEXT)**: Correo electrónico del usuario *(Este no debe de repetirse)*.


 - **fecha_registro (TIMESTAMP)**: Fecha de la creación del usuario.


 - **ultimo_login (TIMESTAMP)**: Última vez que el usuario accedió al sistema.  

 ## Tabla de roles de usuarios

 - **id (UUID, PK)**: Identificador único del registro.


 - **usuario_id (UUID, FK)**: Usuario al que se asigna el rol.


 - **rol (TEXT)**: Puede ser 'admin', 'analista', o 'operador'.


 - **creado (TIMESTAMP)**: Fecha en que se asignó el rol.  

 ## Tabla de modulos activos

 - **usuario_id (UUID, PK+FK)**: Identificador del usuario es una llave combinada.


 - **modulo (TEXT, PK)**: Módulo habilitado: 'finanzas', 'inventario', 'predicciones'.


 - **descripcion (TEXT)**: Información adicional sobre el módulo activo.


 - **activado (BOOLEAN)**: Indica si el módulo está activo *(por defecto esta en TRUE)*.

 ## Tabla de categorías financieras.
 
 - **categoria_id (UUID, PK)**: Identificador único de la categoría.


 - **usuario_id (UUID, FK)**: Usuario propietario de la categoría.


 - **nombre (TEXT)**: Nombre definido por el usuario.


 - **tipo (TEXT)**: Tipo de categoría: 'ingreso', 'egreso', 'ambos'.

 ## Tabla de movimientos financieros.

 - **movimiento_id (UUID, PK)**: Identificador único del movimiento.

 - **usuario_id (UUID, FK)**: Usuario que registró el movimiento.

 - **tipo (TEXT)**: Indica si es 'ingreso' o 'egreso'.

 - **categoria_id (UUID, FK)**: Relación con una categoría financiera.

 - **descripcion (TEXT)**: Descripción libre del movimiento.

 - **monto (NUMERIC)**: Monto involucrado.

 - **fecha (TIMESTAMP)**: Fecha del movimiento.

 - **documento_ref (TEXT)**: Referencia a documento asociado *(ej. recibo, factura)*.

 - **monto_estimado (NUMERIC)**: Estimación *(si aplica)*.

 - **created_at, updated_at (TIMESTAMP)**: Fechas de creación y última modificación para trazabilidad.

 ## Tabla de los productos.

 - **producto_id (UUID, PK)**: Identificador único del producto.

 - **usuario_id (UUID, FK)**: Usuario que registró el producto.

 - **nombre (TEXT)**: Nombre del producto.

 - **descripcion (TEXT)**: Detalles del producto.

 - **unidad (TEXT)**: Unidad de medida (ej. kg, unidad, litro).

 - **precio_actual (NUMERIC)**: Precio vigente del producto.

 - **stock_minimo (INTEGER)**: Nivel mínimo antes de generar alerta.

 - **punto_reorden (INTEGER)**: Nivel que indica cuándo se debe reabastecer.

 - **proveedor (TEXT)**: Nombre del proveedor del producto.

 - **activo (BOOLEAN)**: Si el producto está activo (está en true por defecto).

 - **created_at (TIMESTAMP)**: Fecha en que fue creado el registro.

 - **updated_at (TIMESTAMP)**: Fecha de la última actualización.

 *created_at y updated_at:*
 *Permiten auditar cuándo fue creado el producto y cuándo se realizaron actualizaciones como cambio de precio, proveedor, unidad, etc.*


 ## Tabla de movimientos de stock.
 
 - **movimiento_stock_id (UUID, PK)**: Identificador único del movimiento de inventario.

 - **usuario_id (UUID, FK)**: Usuario que ejecutó o registró el movimiento (referencia a usuarios).

 - **producto_id (UUID, FK)**: Producto afectado en el movimiento (referencia a productos).

 - **tipo (TEXT)**: Tipo de movimiento, puede ser 'entrada' (aumenta stock) o 'salida' (reduce stock).

 - **cantidad (INTEGER)**: Número de unidades involucradas en el movimiento. Nota: Esto debe ser positivo.

 - **precio_unitario (NUMERIC)**: Precio por unidad en ese movimiento, utilizado para trazabilidad financiera o cálculo de costo promedio.

 - **motivo (TEXT)**: Razón o contexto del movimiento, por ejemplo, “compra a proveedor” o “venta al cliente”.

 - **documento_ref (TEXT)**: Referencia opcional a un documento externo como factura o guía de despacho.

 - **movimiento_financiero_id (UUID, FK)**: Enlace opcional al movimiento financiero correspondiente, útil para sincronización contable.

 - **fecha (TIMESTAMP)**: Fecha en que ocurrió el movimiento (por defecto NOW()).

 - **updated_at (TIMESTAMP)**: Marca de auditoría que indica la última vez que el movimiento fue actualizado.

 ## Tabla de predicciones de flujo.

 - **prediccion_id (UUID, PK)**: Identificador único de la predicción.

 - **usuario_id (UUID, FK)**: Usuario al que pertenece la predicción (referencia a usuarios).

 -**fecha_prediccion (TIMESTAMP)**: Fecha en que se generó la predicción.

 **-fecha_inicio_periodo (DATE)**: Fecha de inicio del período proyectado.

 - **fecha_fin_periodo (DATE)**: Fecha final del período proyectado.


 - **flujo_estimado (NUMERIC)**: Monto proyectado de flujo de efectivo para el período especificado.

 - **intervalo_confianza (NUMERIC)**: Porcentaje de certeza del modelo (ej. 95.00), indicando el margen de error.

 - **fuente (TEXT)**: Fuente de la predicción, puede ser 'modelo_lstm', 'modelo_arima' o 'manual'.

 - **parametros_modelo (JSONB)**: Hiperparámetros o configuración usada por el modelo predictivo.

 - **modelo_usado (TEXT)**: Nombre o versión específica del modelo aplicado.

 - **comentarios (TEXT)**: Notas o aclaraciones adicionales sobre la predicción.

 - **exactitud_historica (NUMERIC)**: Porcentaje que refleja la precisión del modelo con base en datos pasados.

 - **created_at (TIMESTAMP)**: Fecha de creación del registro.

 - **updated_at (TIMESTAMP)**: Fecha de la última modificación del registro.

 ## Tabla de alertas de inventario.

 - **alerta_id (UUID, PK)**: Identificador único de la alerta generada.

 - **usuario_id (UUID, FK)**: Usuario responsable o que registró la alerta.

 - **producto_id (UUID, FK)**: Producto asociado a la alerta.

 - **tipo (TEXT)**: Tipo de alerta relacionada con inventario. Puede ser:

  1. 'faltante' – stock insuficiente.

  2. 'merma' – pérdida o deterioro.

  3. 'exceso' – sobreabastecimiento.

  4. 'vencimiento_proximo' – fecha de caducidad cercana.

  5. 'movimiento_atipico' – actividad inusual detectada.

 - **gravedad (TEXT)**: Nivel de urgencia: 'baja', 'media', 'alta', 'critica'.

 - **mensaje (TEXT)**: Texto explicativo que describe la situación.

 - **cantidad_afectada (NUMERIC)**: Cantidad que disparó la alerta (por ejemplo, cantidad por debajo del mínimo).

 - **nivel_actual (NUMERIC)**: Nivel de stock en el momento en que se generó la alerta.

 - **nivel_minimo (NUMERIC)**: Nivel de stock mínimo configurado para el producto.

 - **fecha_deteccion (TIMESTAMP)**: Fecha y hora en que se detectó la situación anómala.

 - **fecha_resolucion (TIMESTAMP)**: Fecha en que se resolvió la alerta (puede ser nula si sigue activa).

 - **estado (TEXT)**: Estado de la alerta:

 1. 'pendiente', 'revisada', 'resuelta', 'descartada'.

 - **relacionado_a (UUID)**:  Puede referenciar un movimiento de stock u otro evento relacionado.

 - **metadata (JSONB)**: Información adicional específica del tipo de alerta (como motivo, detalles técnicos, etc.).

 - **created_at (TIMESTAMP)**: Fecha de creación del registro.

 ## Tabla de alertas financieras.

 - **alerta_id (UUID, PK)**: Identificador único de la alerta financiera.

 - **usuario_id (UUID, FK)**: Usuario al que pertenece la alerta.

 - **tipo (TEXT)**: Tipo de alerta financiera. Puede tomar uno de los siguientes valores:

 1. 'saldo_negativo'**: El balance neto proyectado es menor a 0.

 2. 'gasto_atipico': Se detectó un gasto fuera de patrón.

 3. 'ingreso_atipico': Se registró un ingreso inesperado o inusual.

 4. 'presupuesto_excedido': El gasto supera el presupuesto planificado.

 5. 'flujo_negativo_prediccion': El modelo predice flujo de caja negativo.

 - **gravedad (TEXT)**: Nivel de urgencia de la alerta: 'baja', 'media', 'alta', 'critica'.

 - **mensaje (TEXT)**: Descripción breve del problema o evento detectado.

 - **fecha_deteccion (TIMESTAMP)**: Fecha y hora en que el sistema generó la alerta.

 - **fecha_resolucion (TIMESTAMP)**: Fecha en que la alerta fue resuelta o marcada como cerrada.

 - **estado (TEXT)**: Estado actual de la alerta:

 1. 'pendiente', 'revisada', 'resuelta', 'descartada'.

 - **relacionado_a (UUID)**: Identificador del registro al que se refiere la alerta, como un movimiento financiero o predicción.

 - **tipo_relacion (TEXT)**: Indica a qué tipo de entidad corresponde relacionado_a. Ejemplos:

 1. 'movimiento', 'prediccion'.

 - **metadata (JSONB)**: Información adicional específica del tipo de alerta (detalles del modelo, anomalía detectada, márgenes, etc.).

 - **created_at (TIMESTAMP)**: Fecha de creación del registro de alerta.

 ## Tabla de configuración de las alertas.

 - **configuracion_id (UUID, PK)**: Identificador único de la configuración.

 - **usuario_id (UUID, FK)**: Usuario al que pertenece esta configuración.

 - **tipo_alerta (TEXT)**: Define si la configuración aplica a:

 1. 'financiera' – Alertas relacionadas con movimientos o predicciones financieras.

 2. 'inventario' - Alertas vinculadas a control de stock y productos.

 - **parametros (JSONB)**: Objeto en formato JSON que contiene reglas y valores personalizados según el tipo de alerta (por ejemplo, límites, condiciones de activación, métricas específicas).

 - **notificar (BOOLEAN)**: Indica si el usuario desea recibir notificaciones (por defecto TRUE).

 - **metodo_notificacion (TEXT)**: Canal preferido para ser notificado:

 1. 'email', 'push', 'ambos'.

 - **umbral_gravedad (TEXT)**: Nivel mínimo de gravedad que debe alcanzar una alerta para ser notificada. Puede ser:

 1. 'baja', 'media', 'alta', 'critica'.

 - **created_at (TIMESTAMP)**: Fecha de creación del registro.

 - **updated_at (TIMESTAMP)**: Fecha de la última actualización.











  # Título Principal

## Subtítulo

Este es un párrafo de texto. Puedes usar **negritas** o *cursivas* para resaltar texto.

### Lista Desordenada
- Elemento 1
- Elemento 2
- Elemento 3

### Lista Ordenada
1. Primer elemento
2. Segundo elemento
3. Tercer elemento

### Enlaces
Puedes incluir [enlaces](https://www.e## Imágenes
![Texto alternativo](https://www.ejemplo.com/ódigo, usa tres tildes invertidas:
```python
def hola_mundo():
    print("¡Hola, mundo!")

 




