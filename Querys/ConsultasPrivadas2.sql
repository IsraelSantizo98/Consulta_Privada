CREATE DATABASE ConsultasPrivadas2;
USE ConsultasPrivadas2;
/*Creacion tabla Seguro*/
CREATE TABLE aseguradora(
	id_aseguradora int IDENTITY (1,1),
	nombre_aseguradora varchar(45),
	domicilio_social_aseguradora varchar(100),
	CIF_aseguradora varchar(45),
	CONSTRAINT PK_aseguradora PRIMARY KEY (id_aseguradora)
);
/*Creacion tabla paciente*/
CREATE TABLE paciente(
	id_paciente int IDENTITY (1,1),
	nombre_paciente varchar(45),
	apellido_paciente varchar(45),
	domicilio_paciente varchar(100),
	sexo_paciente varchar(12),
	fecha_naciemiento_paciente varchar(45),
	id_aseguradora int,
	CONSTRAINT PK_paciente PRIMARY KEY (id_paciente),
	CONSTRAINT FK_aseguradoraP FOREIGN KEY (id_paciente) REFERENCES dbo.paciente (id_paciente)
);
/*Creacion tabla Urgencia*/
CREATE TABLE urgencia(
	id_urgencia int IDENTITY (1,1),
	nombre_urgencia varchar(45),
	apellido_urgencia varchar(45),
	fecha_hora_urgencia varchar(45),
	descripcion_urgencia varchar(100),
	id_paciente int,
	CONSTRAINT PK_urgencia PRIMARY KEY (id_urgencia),
	CONSTRAINT FK_pacienteU FOREIGN KEY (id_urgencia) REFERENCES dbo.urgencia (id_urgencia)
);
/*Creacion tabla cita*/
CREATE TABLE cita(
	id_cita int IDENTITY (1,1),
	fecha_hora_cita varchar(45),
	id_paciente int NOT NULL,
	CONSTRAINT PK_cita PRIMARY KEY (id_cita),
	CONSTRAINT FK_pacienteC FOREIGN KEY (id_paciente) REFERENCES dbo.paciente (id_paciente)
);
/*Creacion tabla consulta*/
CREATE TABLE consulta(
	id_consulta int IDENTITY (1,1),
	tipo_hora_nueva_consulta varchar(10),
	fecha_nueva_consulta varchar(45),
	justificante_consulta varchar(100),
	id_cita int NOT NULL,
	CONSTRAINT PK_consulta PRIMARY KEY(id_consulta),
	CONSTRAINT FK_citaCO FOREIGN KEY (id_cita) REFERENCES dbo.cita(id_cita)
);
EXEC sp_RENAME 'dbo.consulta.tipo_hora_nueva_consulta', 'tipo_consulta', 'COLUMN';
/*Creacion tabla medicamento*/
CREATE TABLE medicamento(
	id_medicamento int IDENTITY(1,1),
	principio_activo varchar(45),
	denominacion varchar(45),
	CONSTRAINT PK_medicamento PRIMARY KEY (id_medicamento)
);
/*Creacion tabla diagnostico*/
CREATE TABLE diagnostico(
	id_diagnostico int IDENTITY (1,1),
	dosis_diagnostico varchar(45),
	descripcion_diagnostico varchar(100),
	id_consulta int,
	id_urgencia int,
	id_medicamento int,
	CONSTRAINT PK_diagnostico PRIMARY KEY(id_diagnostico),
	CONSTRAINT FK_consultaD FOREIGN KEY (id_consulta) REFERENCES dbo.consulta (id_consulta),
	CONSTRAINT FK_urgencia FOREIGN KEY (id_urgencia) REFERENCES dbo.urgencia (id_urgencia),
	CONSTRAINT FK_medicamento FOREIGN KEY (id_medicamento) REFERENCES dbo.medicamento (id_medicamento)
);
/*Creation tabla factura*/
CREATE TABLE factura(
	id_factura int IDENTITY (1,1),
	nit_factura varchar(8),
	descripcion_factura varchar(100),
	total_factura decimal(18,2),
	id_paciente int NOT NULL,
	id_consulta int,
	id_urgencia int,
	CONSTRAINT PK_factura PRIMARY KEY (id_factura),
	CONSTRAINT FK_pacienteF FOREIGN KEY (id_paciente) REFERENCES dbo.paciente (id_paciente),
	CONSTRAINT FK_consultaF FOREIGN KEY (id_consulta) REFERENCES dbo.consulta (id_consulta),
	CONSTRAINT FK_urgenciaF FOREIGN KEY (id_urgencia) REFERENCES dbo.urgencia (id_urgencia)
);
/*Inssert Aseguradora*/
INSERT INTO dbo.aseguradora(nombre_aseguradora, domicilio_social_aseguradora, CIF_aseguradora)
VALUES ('El Roble', 'Guatemala, Guatemala', 'A000001'),
('G&T', 'Guatemala, Guatemala', 'A000002');
SELECT * FROM dbo.aseguradora;
/*Insert Paciente*/
INSERT INTO dbo.paciente(nombre_paciente, apellido_paciente, domicilio_paciente, sexo_paciente, fecha_naciemiento_paciente, id_aseguradora)
VALUES('Jose Israel', 'Santizo Santos', 'Colonia 2, Guatemala Ciudad', 'Masculino', '01/12/1998', '1'),
('Dilia Isabel', 'Valle Caceres', 'Residencial 4, Guatemal Ciudad', 'Femenino', '22/02/1999', '2');
SELECT * FROM dbo.paciente;
/*Insert Urgencia*/
INSERT INTO dbo.urgencia(nombre_urgencia, apellido_urgencia, fecha_hora_urgencia, descripcion_urgencia, id_paciente)
VALUES('Jose Israel', 'Santizo Santos', '25/10/2020 4pm', 'Ingreso de emergencia posible fractura de brazo', '1');
SELECT * FROM dbo.urgencia;
/*Insert Cita*/
INSERT INTO dbo.cita(fecha_hora_cita, id_paciente)
VALUES ('26/10/2020 10am', '2');
SELECT * FROM dbo.cita;
/*Insert medicamento*/
INSERT INTO dbo.medicamento(principio_activo, denominacion)
VALUES ('Vitamina C', 'Antigripal'),
('Vitamina B', 'Analgesico');
SELECT * FROM dbo.medicamento;
/*Insert consulta*/
INSERT INTO dbo.consulta(tipo_consulta, fecha_nueva_consulta, justificante_consulta, id_cita)
VALUES('Revision', '15/11/2020', 'Aseguradora cubre el gasto', '1');
SELECT * FROM dbo.consulta;
/*Insert Diagnostico*/
INSERT INTO dbo.diagnostico(dosis_diagnostico, descripcion_diagnostico, id_consulta, id_medicamento)
VALUES ('1 vez cada 12hrs por 3 dias', 'Paciente con sintamos de gripe se receta antiviral', '1', '1');
INSERT INTO dbo.diagnostico(dosis_diagnostico, descripcion_diagnostico, id_urgencia, id_medicamento)
VALUES ('2 vez cada 6hrs por 6 dias', 'Paciente fractura de brazo izquierdo se receta analgesico', '1', '2');
SELECT * FROM dbo.diagnostico;
/*Insert factura*/
INSERT INTO dbo.factura(nit_factura, descripcion_factura, total_factura, id_paciente, id_consulta)
VALUES('674598-5', 'Aseguradora cubre gastos', 125.00, '2', '1');
INSERT INTO dbo.factura(nit_factura, descripcion_factura, total_factura, id_paciente, id_urgencia)
VALUES('324587-1', 'Aseguradora cubre gastos', 125.00, '1', '1');
SELECT * FROM dbo.factura;
/*Backup*/
BACKUP DATABASE ConsultasPrivadas2
TO DISK = 'D:\UMG\6to-Semestre\Bases_de_datos\Proyecto_Final\Backup\fullbackup.bak';
/*Prodecimiento*/
/*CREATE PROCEDURE [dbo].[spInsertPacientes]
	@nombre_paciente		varchar(45),
	@apellido_paciente		varchar(45),
	@domicilio_paciente		varchar(100),
	@sexo_paciente			varchar(12),
	@fecha_naciemiento_paciente	varchar(45),
	@id_aseguradora			int
AS
BEGIN
	INSERT INTO dbo.paciente (nombre_paciente,apellido_paciente,domicilio_paciente,sexo_paciente,fecha_naciemiento_paciente,id_aseguradora)
	VALUES (@nombre_paciente,@apellido_paciente,@domicilio_paciente,@sexo_paciente,@fecha_naciemiento_paciente,@id_aseguradora)
END*/
/*Select*/
CREATE PROCEDURE sp_SelectPaciente
AS
BEGIN
SELECT * FROM dbo.paciente
END;