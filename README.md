# TALLER-OPERACION-MAREA-ALTA-GRUPO-LUYGY-MIGUEL-DANIEL-BOLANOS

## Integrantes
#1 Juan Camilo Bolaños Salcedo
#2 Miguel Ángel Ruiz Gil
#3 Daniel Ciro Grarcia
#4 luygy Ruben Vivas Moreno

## Decisiones principales de diseño
1. **Separación de hechos (Reporte vs. Entrega):** Se separó el acto de reportar una necesidad (`REPORTE_NECESIDAD`) del acto de entregar una ayuda (`ENTREGA`). Una necesidad tiene un ciclo de vida propio (urgencia, estado) independiente del inventario.
2. **Normalización del Inventario y Unidades:** Centralizamos el catálogo en `TIPO_AYUDA` definiendo allí la unidad de medida estándar. Esto garantiza que las entradas (`DETALLE_DONACION`) y salidas (`DETALLE_ENTREGA`) se comparen bajo la misma magnitud matemática, dejando las conversiones (ej. arrobas a libras) a la lógica de la aplicación antes de la inserción.
3. **Gestión de roles flexible:** Implementamos una entidad asociativa `USUARIO_FUNCION` con historial (fechas de inicio/fin y bandera `activo`). Esto permite que un usuario asuma múltiples roles en la emergencia o sea reasignado sin perder la trazabilidad ni sobrescribir sus permisos.
4. **Fechas operativas:** En la entidad `ENTREGA` incluimos tanto la `fecha_entrega` (momento físico en el punto de atención) como la `fecha_registro` (momento en que el digitador ingresó el dato al sistema), cumpliendo con la regla de trazabilidad operativa.
