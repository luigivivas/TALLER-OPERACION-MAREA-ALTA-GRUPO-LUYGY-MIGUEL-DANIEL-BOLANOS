# 03 - MODELO RELACIONAL
## Operación Marea Alta — Ayudas Humanitarias en Buenaventura

Este modelo relacional fue creado a partir de nuestro dibujo y modelo conceptual de clase, siguiendo las reglas sencillas que nos enseñó el profesor Gonzalo Lucio Lucio:

1. **Nombres en singular:** Todos los nombres de las tablas van en singular (`HOGAR`, `DONACION`, `ENTREGA`, etc.).
2. **Tablas fuertes (independientes):** Tienen su llave primaria llamada simplemente `id`.
3. **Tablas dependientes (débiles o intermedias):** Llevan `id` como su propia llave, y reciben la llave de la tabla fuerte con el nombre `id_nombreDeLaTabla` (la llave del 1 viaja al lado de muchos).
4. **Destruir relaciones de muchos a muchos:** Como vimos en clase con `Estudiante <- matricula -> Asignatura`, cuando dos cosas se relacionan de muchos a muchos, esa relación se rompe creando una tabla en la mitad (de 1 a muchos y de muchos a 1).
5. **Integridad referencial:** No se puede borrar información si otra tabla depende de ella.

---

### 1. Las Tablas del Sistema (Explicadas de Forma Sencilla)

---

#### 1. HOGAR (Tabla Fuerte / Independiente)
**¿Qué guarda?**  
La información de cada familia afectada por el sismo. Cada hogar tiene un número único (`id`) que nunca cambia, sin importar si la familia se traslada a un albergue o cambia de casa temporalmente.

**Estructura:**
```text
HOGAR ( id INTEGER PK, persona_contacto VARCHAR(100) NOT NULL, cantidad_personas INTEGER NOT NULL, condicion_prioridad VARCHAR(255), tipo_zona VARCHAR(20) NOT NULL, division_territorial VARCHAR(100) NOT NULL, referencia_ubicacion VARCHAR(255) )
```

**Explicación de sus datos:**
* `id`: El número único que identifica a la familia.
* `persona_contacto`: El nombre de la persona que responde por el hogar.
* `cantidad_personas`: Cuántas personas viven en la casa (número mayor a 0).
* `condicion_prioridad`: Si hay abuelos, bebés, mujeres embarazadas o personas en situación de discapacidad para atenderlos primero.
* `tipo_zona`: Si vive en zona "Urbana" o "Rural".
* `division_territorial`: El barrio (si es en la ciudad) o el corregimiento, vereda o comunidad (si es en el campo).
* `referencia_ubicacion`: Dirección de la casa o una seña para llegar en caso de que en el campo no haya calles ni nomenclatura (por ejemplo: "Detrás de la escuela comunal").

---

#### 2. NECESIDAD (Tabla Fuerte / Catálogo)
**¿Qué guarda?**  
La lista de los tipos de necesidades que se atienden en la emergencia (por ejemplo: Agua potable, Alimentos, Aseo, Refugio temporal, Medicinas).

**Estructura:**
```text
NECESIDAD ( id INTEGER PK, categoria VARCHAR(50) NOT NULL UNIQUE )
```

**Explicación de sus datos:**
* `id`: Número único de la necesidad.
* `categoria`: El nombre de la necesidad (no se repite).

---

#### 3. REPORTE_NECESIDAD (Tabla Intermedia: Nace de romper Hogar con Necesidad)
**¿Qué guarda?**  
Como una familia puede necesitar varias cosas (comida y agua), y una misma necesidad (agua) la tienen muchas familias, rompemos la relación de muchos a muchos creando esta tabla en el medio. Guarda lo que pidió cada familia y cómo va su atención.

**Estructura:**
```text
REPORTE_NECESIDAD ( id INTEGER PK, id_hogar INTEGER NOT NULL FK -> HOGAR.id, id_necesidad INTEGER NOT NULL FK -> NECESIDAD.id, urgencia VARCHAR(20) NOT NULL, cantidad_estimada INTEGER, estado VARCHAR(20) NOT NULL, observacion VARCHAR(255), fecha_reporte DATETIME NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del reporte.
* `id_hogar`: A qué familia le pertenece esta solicitud.
* `id_necesidad`: Qué tipo de ayuda está pidiendo (agua, comida, etc.).
* `urgencia`: Si la ayuda se necesita con urgencia "Alta", "Media" o "Baja".
* `cantidad_estimada`: Cuánto calcula la familia que necesita.
* `estado`: Dice si está "Pendiente", "En proceso" o si ya fue "Atendida".
* `observacion`: Notas de lo que vieron los brigadistas en el terreno.
* `fecha_reporte`: Cuándo se tomó nota de la necesidad.

---

#### 4. PUNTO_ATENCION (Tabla Fuerte / Independiente)
**¿Qué guarda?**  
Los lugares donde se entrega la ayuda a la gente (por ejemplo: coliseos, casetas comunales o escuelas).

**Estructura:**
```text
PUNTO_ATENCION ( id INTEGER PK, nombre VARCHAR(100) NOT NULL, tipo_zona VARCHAR(50) NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del punto de atención.
* `nombre`: Nombre del lugar físico (ejemplo: "Coliseo Central").
* `tipo_zona`: Si el punto queda en zona urbana o rural.

---

#### 5. TIPO_AYUDA (Tabla Fuerte / Catálogo)
**¿Qué guarda?**  
La lista oficial de todos los productos y ayudas que se pueden recibir o entregar, y con qué medida se cuentan para no confundirse.

**Estructura:**
```text
TIPO_AYUDA ( id INTEGER PK, nombre VARCHAR(100) NOT NULL, cantidad_medida VARCHAR(50) NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del tipo de ayuda.
* `nombre`: Nombre del producto (ejemplo: Arroz, Agua en botella, Kit de aseo, Frazada).
* `cantidad_medida`: La unidad con la que siempre se va a contar (ejemplo: "libras", "litros", "unidades", "kits"). Si alguien dona en bultos o arrobas, primero se convierte a libras antes de meterlo al sistema.

---

#### 6. INVENTARIO (Tabla Dependiente de Tipo de Ayuda)
**¿Qué guarda?**  
Cuánto producto queda disponible en bodega en todo momento, para evitar entregar cosas que no hay y que el saldo nunca quede en negativo.

**Estructura:**
```text
INVENTARIO ( id INTEGER PK, id_tipo_ayuda INTEGER NOT NULL UNIQUE FK -> TIPO_AYUDA.id, cantidad_stock INTEGER NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del registro de inventario.
* `id_tipo_ayuda`: De qué producto estamos llevando la cuenta.
* `cantidad_stock`: La cantidad que hay disponible ahora mismo (nunca puede bajar de 0).

---

#### 7. DONADOR (Tabla Fuerte / Independiente)
**¿Qué guarda?**  
Los datos de las personas, empresas, entidades u organizaciones que regalan ayudas.

**Estructura:**
```text
DONADOR ( id INTEGER PK, nombre VARCHAR(100) NOT NULL, numero_identificacion VARCHAR(50), tipo_donante VARCHAR(50) NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del donador.
* `nombre`: Nombre de la persona o de la empresa.
* `numero_identificacion`: Cédula o NIT (si lo tienen).
* `tipo_donante`: Si es "Persona natural", "Empresa", "Organización comunitaria" o "Entidad pública".

---

#### 8. DONACION (Tabla Cabecera del Evento de Donación)
**¿Qué guarda?**  
Cada vez que un donador llega a entregar un cargamento de ayudas en una fecha determinada.

**Estructura:**
```text
DONACION ( id INTEGER PK, id_donador INTEGER NOT NULL FK -> DONADOR.id, categoria_donacion VARCHAR(100), fecha_recepcion DATETIME NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del recibo o evento de donación.
* `id_donador`: Quién trajo la donación (llave que viene de `DONADOR`).
* `categoria_donacion`: Descripción general (ejemplo: "Alimentos no perecederos").
* `fecha_recepcion`: El día y la hora en que se recibió el cargamento.

---

#### 9. DETALLE_DONACION (Tabla Intermedia: Nace de romper Donación con Tipo de Ayuda)
**¿Qué guarda?**  
Una donación puede traer varias cosas a la vez (arroz, agua, frazadas). Para no repetir los datos del donante en cada renglón, rompemos la relación de muchos a muchos con esta tabla de detalle.

**Estructura:**
```text
DETALLE_DONACION ( id INTEGER PK, id_donacion INTEGER NOT NULL FK -> DONACION.id, id_tipo_ayuda INTEGER NOT NULL FK -> TIPO_AYUDA.id, cantidad_recibida INTEGER NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del renglón.
* `id_donacion`: A qué donación corresponde.
* `id_tipo_ayuda`: Qué producto llegó.
* `cantidad_recibida`: Cuánto llegó (expresado en la medida estándar del producto, por ejemplo en libras).

---

#### 10. USUARIO (Tabla Fuerte / Independiente)
**¿Qué guarda?**  
Las personas que trabajan en el sistema (brigadistas, coordinadores, encargados de bodega).

**Estructura:**
```text
USUARIO ( id INTEGER PK, nombre VARCHAR(100) NOT NULL, correo VARCHAR(100) NOT NULL UNIQUE )
```

**Explicación de sus datos:**
* `id`: Número del usuario.
* `nombre`: Nombre del trabajador o voluntario.
* `correo`: Correo con el que entra al sistema (no se repite).

---

#### 11. FUNCION (Tabla Fuerte / Catálogo)
**¿Qué guarda?**  
Las tareas o roles que se pueden hacer en el sistema (por ejemplo: "Registrar Familias", "Manejar Bodega", "Hacer Entregas", "Ver Reportes").

**Estructura:**
```text
FUNCION ( id INTEGER PK, nombre_funcion VARCHAR(50) NOT NULL UNIQUE )
```

**Explicación de sus datos:**
* `id`: Número de la función.
* `nombre_funcion`: Nombre del cargo o permiso.

---

#### 12. USUARIO_FUNCION (Tabla Intermedia: Nace de romper Usuario con Función)
**¿Qué guarda?**  
Como un usuario puede tener varios roles (por ejemplo, registrar familias y también consultar inventario) y un rol lo pueden tener varias personas, rompemos el muchos a muchos con esta tabla. Permite quitarle un rol a alguien o darle uno nuevo sin tener que borrar a la persona del sistema.

**Estructura:**
```text
USUARIO_FUNCION ( id INTEGER PK, id_usuario INTEGER NOT NULL FK -> USUARIO.id, id_funcion INTEGER NOT NULL FK -> FUNCION.id, fecha_inicio DATETIME NOT NULL, fecha_fin DATETIME, activo BOOLEAN NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número de la asignación.
* `id_usuario`: A qué trabajador se le da el cargo.
* `id_funcion`: Qué cargo se le asigna.
* `fecha_inicio`: Desde qué fecha empieza a ejercer esa función.
* `fecha_fin`: Cuándo terminó de hacer esa tarea (si sigue haciéndola, se deja vacío).
* `activo`: `Verdadero` si tiene el permiso activo hoy, o `Falso` si ya se le quitó.

---

#### 13. ENTREGA (Tabla Cabecera del Evento de Entrega)
**¿Qué guarda?**  
Cada vez que una familia se acerca a un punto de atención y se le hace una entrega de ayudas.

**Estructura:**
```text
ENTREGA ( id INTEGER PK, id_hogar INTEGER NOT NULL FK -> HOGAR.id, id_punto_atencion INTEGER NOT NULL FK -> PUNTO_ATENCION.id, registro_usuario INTEGER NOT NULL FK -> USUARIO.id, fecha_entrega DATETIME NOT NULL, fecha_registro DATETIME NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número de la entrega.
* `id_hogar`: A qué familia se le entregó.
* `id_punto_atencion`: En qué lugar físico se le entregó.
* `registro_usuario`: Qué usuario del sistema registró la entrega (la persona que dejó la constancia).
* `fecha_entrega`: El día real en que la familia recibió la ayuda en sus manos.
* `fecha_registro`: El día y hora en que se sentaron en el computador a escribir los datos en el sistema (así se cumple la regla R-12 de separar ambas fechas).

---

#### 14. DETALLE_ENTREGA (Tabla Intermedia: Nace de romper Entrega con Tipo de Ayuda)
**¿Qué guarda?**  
En una misma entrega, una familia puede recibir varios productos diferentes (por ejemplo, 2 mercados y 10 botellas de agua). Esta tabla guarda artículo por artículo lo que se le entregó a la familia.

**Estructura:**
```text
DETALLE_ENTREGA ( id INTEGER PK, id_entrega INTEGER NOT NULL FK -> ENTREGA.id, id_tipo_ayuda INTEGER NOT NULL FK -> TIPO_AYUDA.id, cantidad_entregada INTEGER NOT NULL )
```

**Explicación de sus datos:**
* `id`: Número del renglón.
* `id_entrega`: A qué entrega corresponde.
* `id_tipo_ayuda`: Qué producto se le dio.
* `cantidad_entregada`: Cuánta cantidad se le entregó (en la medida estándar).

---

### 2. Resumen de Tablas, Llaves Primarias y Llaves Foráneas

Para ver de forma rápida cómo se conecta todo el sistema:

| Nombre de la Tabla | Llave Primaria (PK) | Llaves Foráneas (FK) | ¿De dónde vienen las llaves foráneas? |
| :--- | :--- | :--- | :--- |
| **HOGAR** | `id` | *Ninguna* (Fuerte) | Es tabla independiente |
| **NECESIDAD** | `id` | *Ninguna* (Fuerte) | Es tabla catálogo |
| **REPORTE_NECESIDAD** | `id` | `id_hogar`<br>`id_necesidad` | Viene de `HOGAR.id`<br>Viene de `NECESIDAD.id` |
| **PUNTO_ATENCION** | `id` | *Ninguna* (Fuerte) | Es tabla independiente |
| **TIPO_AYUDA** | `id` | *Ninguna* (Fuerte) | Es tabla catálogo |
| **INVENTARIO** | `id` | `id_tipo_ayuda` | Viene de `TIPO_AYUDA.id` |
| **DONADOR** | `id` | *Ninguna* (Fuerte) | Es tabla independiente |
| **DONACION** | `id` | `id_donador` | Viene de `DONADOR.id` |
| **DETALLE_DONACION** | `id` | `id_donacion`<br>`id_tipo_ayuda` | Viene de `DONACION.id`<br>Viene de `TIPO_AYUDA.id` |
| **USUARIO** | `id` | *Ninguna* (Fuerte) | Es tabla independiente |
| **FUNCION** | `id` | *Ninguna* (Fuerte) | Es tabla catálogo |
| **USUARIO_FUNCION** | `id` | `id_usuario`<br>`id_funcion` | Viene de `USUARIO.id`<br>Viene de `FUNCION.id` |
| **ENTREGA** | `id` | `id_hogar`<br>`id_punto_atencion`<br>`registro_usuario` | Viene de `HOGAR.id`<br>Viene de `PUNTO_ATENCION.id`<br>Viene de `USUARIO.id` |
| **DETALLE_ENTREGA** | `id` | `id_entrega`<br>`id_tipo_ayuda` | Viene de `ENTREGA.id`<br>Viene de `TIPO_AYUDA.id` |

---

### 3. ¿Cómo Resuelve este Modelo las Reglas del Reto?

Explicado de manera clara y directa:

1. **El hogar no pierde su número (R-01):** Cada familia tiene su `id`. Si se mudan a una escuela o a una carpa por la emergencia, su `id` sigue siendo el mismo.
2. **Pedir varias cosas sin confusiones (R-02, R-03, R-04):** En `REPORTE_NECESIDAD` se anota cada ayuda solicitada por separado. Si ya le dimos agua a la familia, ese reporte pasa a "Atendida", mientras el reporte de frazadas sigue "Pendiente".
3. **Donaciones variadas (R-05, R-06, R-07):** Una empresa puede donar 100 mercados y 200 botellas de agua. Los datos de la empresa se anotan una sola vez en `DONACION`, y en `DETALLE_DONACION` se listan los productos donados.
4. **Una familia puede recibir ayuda varias veces (R-08, R-09, R-10, R-11):** Cada vez que la familia va por ayuda se crea una nueva `ENTREGA`. Queda guardado el día, qué punto la atendió, quién fue el funcionario que la atendió y exactamente qué productos se le dieron en `DETALLE_ENTREGA`.
5. **Diferencia entre el día de la entrega y el día del registro (R-12):** En `ENTREGA` guardamos dos fechas: `fecha_entrega` (cuando la familia se llevó las cosas) y `fecha_registro` (cuando el digitador tuvo internet o tiempo para meterlo al sistema).
6. **No revolver medidas (R-13, R-17):** Cada producto tiene su unidad fija en `TIPO_AYUDA`. Si alguien dona 2 arrobas de arroz y el arroz se cuenta en libras, primero se pasa a 50 libras y así se anota. Todo lo que entra y sale se resta en la misma unidad.
7. **No quedar en números rojos en la bodega (R-14):** En la tabla `INVENTARIO`, el campo `cantidad_stock` tiene la regla de ser siempre mayor o igual a 0. Si quedan 8 mercados y alguien intenta registrar la salida de 10, el sistema no lo deja pasar.
8. **Asignar y cambiar funciones sin borrar a nadie (R-15, R-16):** Si un voluntario estaba registrando familias y ahora pasa a bodega, en `USUARIO_FUNCION` simplemente se marca la fecha en que terminó la primera tarea y se le activa la nueva, sin borrar su cuenta de usuario.
