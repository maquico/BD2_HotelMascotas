USE Hotel_Mascotas_DB;

INSERT INTO adm.TIPO_HABITACION (Nombre, Precio_Dia) VALUES
	('Estandar', 500),
	('Premium', 750),
	('Deluxe', 1000);

INSERT INTO adm.SEXO (Nombre) VALUES
	('Macho Castrado'),
	('Macho Intacto'),
	('Macho Indefinido'),
	('Hembra Esterilizada'),
	('Hembra Intacta'),
	('Hembra Indefinido');

INSERT INTO adm.VACUNAS (Nombre) VALUES
	('Bordetella'),
	('Rabia'),
	('DHPP (Multiple)'),
	('Control de pulgas y garrapatas'),
	('Desparasitante(Vermifugo)'),
	('Rinotraqueitis Viral Felina'),
	('Leucemia Viral Felina');

INSERT INTO adm.ESPECIES (Nombre) VALUES
	('Canino'),
	('Felino');

INSERT INTO adm.CONDICIONES_MEDICAS (Nombre) VALUES
	('Hipertiroidismo'),
	('Insuficiencia Renal'),
	('Ceguera Parcial'),
	('Ceguera Total'),
	('Amputacion de Pata'),
	('Diabetes Mellitus'),
	('Alergia'),
	('Soplo Cardiaco'),
	('Obesidad'),
	('Cancer');

INSERT INTO adm.UNIDAD (Nombre) VALUES
	('Unidad'),
	('Hora'),
	('Racion');

INSERT INTO adm.SERVICIOS (Nombre, Unidad_ID, Precio_Unidad, Multiplicador_Pequeño, Multiplicador_Mediano, Multiplicador_Grande) VALUES
	('Baño', 1.00, 700.00, 1.00, 1.25, 1.50),
	('Corte de uña', 1.00, 300.00, 1.00, 1.00, 1.00),
	('Paseo', 2.00, 1000.00, 1.00, 1.00, 1.25),
	('Corte de pelo', 1.00, 1000.00, 1.00, 1.50, 2.00),
	('Entrenamiento', 2.00, 1000.00, 1.00, 1.25, 1.50),
	('Comida Premium', 3.00, 1000.00, 1.00, 1.25, 1.50),
	('Spa', 1.00, 1700.00, 1.00, 1.25, 1.50),
	('Lavado de dientes', 1.00, 500.00, 1.00, 1.25, 1.50),
	('Masaje', 2.00, 400.00, 1.00, 1.00, 1.00);

INSERT INTO adm.ROLES (Nombre) VALUES
	('Veterinario'),
	('Paseador'),
	('Entrenador'),
	('Bañador'),
	('Masajista'),
	('Peluquero'),
	('Cajero'),
	('Gerente'),
	('Recepcionista'),
	('Conserje'),
	('Alimentador');

    INSERT INTO adm.CATEGORIAS (Nombre, Descripcion) VALUES
	('Alimentos', 'Productos comestibles de mascotas'),
	('Juguetes', 'Productos con fines de entretenimiento'),
	('Higiene' , 'Productos para el aseo e higienizacion'),
	('Ropa', 'Vestimentas, disfraces, zapatos'),
	('Medicamentos', 'Medicinas'),
	('Accesorios' ,'Correas, collares, entre otros');

    INSERT INTO adm.SECTOR (Nombre) VALUES
	('24 de abril'),
	('27 de febrero'),
	('30 de mayo'),
	('Altos de Arroyo Hondo'),
	('Arroyo Manzano'),
	('Atala'),
	('Bella Vista'),
	('Buenos Aires'),
	('El Cacique'),
	('Centro de los Héroes'),
	('Centro Olímpico'),
	('Cerros de Arroyo Hondo'),
	('Ciudad Colonial'),
	('Ciudad Nueva'),
	('Ciudad Universitaria'),
	('Cristo Rey'),
	('Domingo Savio'),
	('El Millón'),
	('Ensanche Capotillo'),
	('Ensanche Espaillat'),
	('Ensanche La Fe'),
	('Ensanche Luperón'),
	('Ensanche Naco'),
	('Ensanche Quisqueya'),
	('Gascue'),
	('General Antonio Duverge'),
	('Gualey'),
	('Honduras del Norte'),
	('Honduras del Oeste'),
	('Jardín Botánico'),
	('Jardín Zoológico'),
	('Jardines del Sur'),
	('Julieta Morales'),
	('La Agustina'),
	('La Castellana'),
	('La Esperilla'),
	('La Hondonada'),
	('La Isabela'),
	('La Julia'),
	('Las Praderas'),
	('La Zurza'),
	('Los Cacicazgos'),
	('Los Jardines'),
	('Los Peralejos'),
	('Los Prados'),
	('Los Restauradores'),
	('Los Ríos'),
	('María Auxiliadora'),
	('Mata Hambre'),
	('Mejoramiento Social'),
	('Mirador Norte'),
	('Mirador Sur'),
	('Miraflores'),
	('Miramar'),
	('Nuestra Señora de la Paz'),
	('Nuevo Arroyo Hondo'),
	('Palma Real'),
	('Paraíso'),
	('Paseo de los Indios'),
	('Piantini'),
	('Los Próceres'),
	('Renacimiento'),
	('San Carlos'),
	('San Diego'),
	('San Geronimo'),
	('San Juan Bosco'),
	('Simón Bolívar'),
	('Viejo Arroyo Hondo'),
	('Villas Agrícolas'),
	('Villa Consuelo'),
	('Villa Francisca'),
	('Villa Juana');

INSERT INTO adm.ESTATUS (Nombre) VALUES
	('No iniciada'),
	('En Curso'),
	('Finalizada'),
	('Cancelada');

INSERT INTO adm.METODOS_PAGOS (Nombre) VALUES
	('Tarjeta'),
	('Efectivo');