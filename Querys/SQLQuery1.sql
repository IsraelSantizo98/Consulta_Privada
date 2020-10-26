CREATE DATABASE ConsultasPrivadas;
USE ConsultasPrivadas;
/*Creacion de tablas*/
/*Paciente*/
CREATE TABLE paciente(
	id_paciente int IDENTITY (1,1),
	nombre varchar(45),
	apellido varchar(45),
	domicilio varchar(100),
	sexo varchar(15),
	fecha_nacimiento varchar(10),
	CONSTRAINT PK_paciente PRIMARY KEY (id_paciente)
);
/*Aseguradora*/
CREATE TABLE aseguradora(
	id_aseguradora int IDENTITY (1,1),
	nombre varchar(45),
	domicilio_social varchar(100),
	CIF varchar(10),
	id_paciente int NOT NULL,
	CONSTRAINT PK_aseguradora PRIMARY KEY (id_aseguradora),
	CONSTRAINT FK_pacienteA FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente)
);
/*Cita*/
CREATE TABLE cita(
	id_cita int IDENTITY (1,1),
	nombre varchar(45),
	apellido varchar(45),
	fecha_cita varchar(10),
	id_paciente int NOT NULL,
	CONSTRAINT PK_cita PRIMARY KEY (id_cita),
	CONSTRAINT FK_pacienteC FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente)
);
/*Factura*/
CREATE TABLE factura(
	id_factura varchar,
	fecha_factura varchar(10),
	nit_factura varchar(10),
	nombre_factura varchar(45),
	descripcion_factura varchar(100),
	total_factura decimal (18,2),
	id_consulta int,
	id_urgencia int,
	CONSTRAINT PK_factura PRIMARY KEY (id_factura),
	CONSTRAINT FK_consultaF FOREIGN KEY (id_consulta) REFERENCES dbo.consulta (id_consulta),
	CONSTRAINT FK_urgenciaF FOREIGN KEY (id_urgencia) REFERENCES dbo.urgencia (id_urgencia),
);
DROP TABLE factura
/*Urgencia*/
CREATE TABLE urgencia(
	id_urgencia int IDENTITY(1,1),
	fecha_urgencia varchar(20),
	descripcion varchar(100),
	id_paciente int NOT NULL,
	CONSTRAINT PK_urgencia PRIMARY KEY (id_urgencia),
	CONSTRAINT FK_pacienteU FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente)
);
/*Medicamento*/
CREATE TABLE medicamento (
	id_medicamento int IDENTITY(1,1),
	denominacion varchar (45),
	principio_activo varchar(45),
	CONSTRAINT PK_medicamento PRIMARY KEY(id_medicamento)
);
/*Diagnostico*/
CREATE TABLE diagnostico(
	id_diagnostico int IDENTITY (1,1),
	duracion_diagnostico varchar(45),
	dosis_diagnostico varchar(45),
	descripcion_diagnostico varchar (100),
	id_medicamento int NOT NULL,
	id_consulta int NOT NULL,
	CONSTRAINT PK_diagnostico PRIMARY KEY(id_diagnostico),
	CONSTRAINT FK_medicamento FOREIGN KEY (id_medicamento) REFERENCES dbo.medicamento(id_medicamento)
);
DROP TABLE diagnostico
/*Consulta*/
CREATE TABLE consulta(
	id_consulta int IDENTITY (1,1),
	justificante varchar(100),
	fecha_nueva_consulta varchar (100),
	tipo_consulta varchar(45),
	id_aseguradora int NOT NULL,
	id_paciente int NOT NULL,
	id_cita int NOT NULL,
	CONSTRAINT PK_consulta PRIMARY KEY(id_consulta),
	CONSTRAINT FK_aseguradoraCO FOREIGN KEY (id_aseguradora) REFERENCES dbo.aseguradora(id_aseguradora),
	CONSTRAINT FK_pacienteCO FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente),
	CONSTRAINT FK_citaCO FOREIGN KEY (id_cita) REFERENCES dbo.cita(id_cita),
);
drop table consulta;
/*INSERT Paciente*/
INSERT INTO dbo.paciente (nombre, apellido, domicilio, sexo, fecha_nacimiento)
VALUES ('Jose Israel', 'Santizo Santos', 'Guatemala, Guatemala', 'Masculino', '01-12-1998'),
('Ericka Luisa', 'Peralta Tapia', 'Guatemala, Guatemala', 'Femenino', '22-10-1996'); 
SELECT * FROM dbo.paciente;
/*INSERT Aseguradora*/
INSERT INTO dbo.aseguradora(nombre, domicilio_social, CIF, id_paciente)
VALUES ('El Roble', 'Guatemala, Guatemala', 'A37001369', '1'), 
('Seguros G&T', 'Guatemala, Guatemala', 'A40222647', '2'); 
SELECT * FROM dbo.aseguradora;
/*Insert cita Paciente 1*/
INSERT INTO dbo.cita (nombre, apellido, fecha_cita, id_paciente)
VALUES ('Jose Israel', 'Santizo Santos', '25/10 4pm', '1'),
('Ericka Luisa', 'Peralta Tapia', '24/10 5pm', '2');
SELECT * FROM dbo.cita;
/*INSERT MEDICAMENTO*/
INSERT INTO dbo.medicamento(denominacion, principio_activo)
VALUES ('Paracetamol', 'Paracetamol'),
('Ibuprofeno', 'Ibuprofeno');
SELECT * FROM dbo.medicamento;
/*INSERT Diagnostico*/
INSERT INTO dbo.diagnostico(duracion_diagnostico, dosis_diagnostico, descripcion_diagnostico, id_medicamento)
VALUES('3-5 dias', '2 pastillas cada 6hrs', 'Analgesico para dolor muscular', '1'),
('1-2', '3 pastillas cada 12hrs', 'Analgesico para fiebre', '2');
SELECT * FROM dbo.diagnostico;
/*Insert Consulta*/
INSERT INTO dbo.consulta (justificante, fecha_nueva_consulta, tipo_consulta, id_aseguradora, id_paciente, id_cita)
VALUES('Enfermo de gripe', '16/10/2020 4pm', 'Revision', '1', '1', '2');
SELECT * FROM dbo.consulta;
/*INSERT urgencia*/
INSERT INTO dbo.urgencia (fecha_urgencia, descripcion, id_paciente)
VALUES('24/10/2020 4PM', 'Ingreso de urgencia fractura de brazo', '2');
SELECT * FROM dbo.urgencia
/*INSERT factura*/
INSERT INTO dbo.factura(fecha_factura, nit_factura, nombre_factura, descripcion_factura, total_factura, id_consulta, id_urgencia)
/*PROCEDURE*/