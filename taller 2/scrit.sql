CREATE DATABASE tallerld2;

USE tallerld2;
SHOW TABLE;

CREATE TABLE hogar (
    id INTEGER PRIMARY KEY,
    persona_contacto VARCHAR(100) NOT NULL,
    cantidad_personas INTEGER NOT NULL,
    condicion_prioridad VARCHAR(255),
    tipo_zona VARCHAR(20) NOT NULL,
    division_territorial VARCHAR (100) NOT NULL,
    referencia_ubicacion VARCHAR (255)
);

INSERT INTO hogar (id, persona_contacto, cantidad_personas, condicion_prioridad, tipo_zona, 
division_territoriaL, referencia_ubicacion) 
VALUES 
(1, "Daniel", 1, "Urgente", "rural", "Valle buenaventura", "caseta06"),
(2, "Juan", 3, "Media", "urbana", "Valle buenaventura", "caseta07"),
(3, "Pedro", 2, "Baja", "rural", "Valle buenaventura", "caseta08"),
(4, "Maria", 4, "Urgente", "urbana", "Valle buenaventura", "caseta09"),
(5, "Luisa", 1, "Media", "rural", "Valle buenaventura", "caseta10");

CREATE TABLE necesidad ( 
    id INTEGER PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL UNIQUE,
);

INSERT INTO necesidad (id, categoria)
VALUES 
(1, "Alimentos"),
(2, "Ropa"),
(3, "Medicamentos"),
(4, "Higiene"),
(5, "Educación");


CREATE TABLE reporte_necesidad (
    id INTEGER PRIMARY KEY,
    id_hogar INTEGER NOT NULL FOREIGN KEY REFERENCES hogar(id),
    id_necesidad INTEGER NOT NULL FOREIGN KEY REFERENCES necesidad(id),
    urgencia VARCHAR(20) NOT NULL,
    cantidad_estimada INTEGER,
    estado VARCHAR(20) NOT NULL,
    observaciones VARCHAR(255),
    fecha_reporte DATE NOT NULL
);

INSERT INTO reporte_necesidad (id, id_hogar, id_necesidad, urgencia, cantidad_estimada, estado, observaciones, fecha_reporte)
VALUES
(1, 1, 1, "Alta", 10, "Pendiente", "Necesitamos alimentos para la semana", "2023-05-01"),
(2, 2, 2, "Media", 5, "Pendiente", "Ropa para los niños", "2023-05-02"),
(3, 3, 3, "Baja", 2, "Pendiente", "Medicamentos para la gripe", "2023-05-03"),
(4, 4, 4, "Alta", 8, "Pendiente", "Artículos de higiene personal", "2023-05-04"),
(5, 5, 5, "Media", 3, "Pendiente", "Material educativo para los niños", "2023-05-05");

CREATE TABLE punto_atencion (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo_zona VARCHAR(50) NOT NULL,
);

INSER INTO punto_atencion (id, nombre, tipo_zona)
VALUES
(1, "Punto de Atención 1", "Urbana"),
(2, "Punto de Atención 2", "Rural"),
(3, "Punto de Atención 3", "Urbana"),
(4, "Punto de Atención 4", "Rural"),
(5, "Punto de Atención 5", "Urbana");

CREATE TABLE tipo_ayuda (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    csntidad_medida VARCHAR(50) NOT NULL,
);

INSERT INTO tipo_ayuda (id, nombre, cantidad_medida)
VALUES 

(1, "Alimentos", "kg"),
(2, "Ropa", "prendas"),
(3, "Medicamentos", "unidades"),
(4, "Higiene", "unidades"),
(5, "Educación", "materiales");


CREATE TABLE inventario (
    id INTEGER PRIMARY KEY,
    id_tipo_ayuda INTEGER NOT NULL FOREIGN KEY REFERENCES tipo_ayuda(id),
    cantidad_stock INTEGER NOT NULL,

);

INSER INTO inventario (id, id_tipo_ayuda, cantidad_stock)
VALUES
(1, 1, 100),
(2, 2, 50),
(3, 3, 30),
(4, 4, 20),
(5, 5, 10);

CREATE TABLE donador (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    numero_identificacion VARCHAR(50) NOT NULL UNIQUE,
    tipo_donante VARCHAR(50) NOT NULL,
);

INSERT INTO donador (id, nombre, numero_identificacion, tipo_donante)
VALUES
(1, "Donador 1", "123456789", "Individual"),
(2, "Donador 2", "987654321", "Empresa"),
(3, "Donador 3", "456789123", "ONG"),
(4, "Donador 4", "789123456", "Individual"),
(5, "Donador 5", "321654987", "Empresa");

//segunda parte 


Daniel Fernando Ciro García <cirogarciadanielfernando@gmail.com>
20:33 (hace 2 minutos)
para mí

CREATE TABLE donacion (
id INTEGER PRIMARY KEY,
id_donador INTEGER NOT NULL,
categoria_donacion VARCHAR(100),
fecha_recepcion DATETIME NOT NULL,
FOREIGN KEY (id_donador) REFERENCES donador(id)
);

CREATE TABLE detalle_donacion (
id INTEGER PRIMARY KEY,
id_donacion INTEGER NOT NULL,
id_tipo_ayuda INTEGER NOT NULL,
cantidad_recibida INTEGER NOT NULL,
FOREIGN KEY (id_donacion) REFERENCES donacion(id),
FOREIGN KEY (id_tipo_ayuda) REFERENCES tipo_ayuda(id)
);

CREATE TABLE usuario (
id INTEGER PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
correo VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE funcion (
id INTEGER PRIMARY KEY,
nombre_funcion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE usuario_funcion (
id INTEGER PRIMARY KEY,
id_usuario INTEGER NOT NULL,
id_funcion INTEGER NOT NULL,
fecha_inicio DATETIME NOT NULL,
fecha_fin DATETIME,
activo BOOLEAN NOT NULL,
FOREIGN KEY (id_usuario) REFERENCES usuario(id),
FOREIGN KEY (id_funcion) REFERENCES funcion(id)
);

CREATE TABLE entrega (
id INTEGER PRIMARY KEY,
id_hogar INTEGER NOT NULL,
id_punto_atencion INTEGER NOT NULL,
registro_usuario INTEGER NOT NULL,
fecha_entrega DATETIME NOT NULL,
fecha_registro DATETIME NOT NULL,
FOREIGN KEY (id_hogar) REFERENCES hogar(id),
FOREIGN KEY (id_punto_atencion) REFERENCES punto_atencion(id),
FOREIGN KEY (registro_usuario) REFERENCES usuario(id)
);

CREATE TABLE detalle_entrega (
id INTEGER PRIMARY KEY,
id_entrega INTEGER NOT NULL,
id_tipo_ayuda INTEGER NOT NULL,
cantidad_entregada INTEGER NOT NULL,
FOREIGN KEY (id_entrega) REFERENCES entrega(id),
FOREIGN KEY (id_tipo_ayuda) REFERENCES tipo_ayuda(id)
);