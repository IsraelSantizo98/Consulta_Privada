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
	CONSTRAINT PK_factura PRIMARY KEY (id_factura)
);
/*Urgencia*/
CREATE TABLE urgencia(
	id_urgencia int IDENTITY(1,1),
	fecha_urgencia varchar(20),
	descripcion varchar(100),
	id_paciente int NOT NULL,
	id_factura varchar NOT NULL,
	CONSTRAINT PK_urgencia PRIMARY KEY (id_urgencia),
	CONSTRAINT FK_pacienteU FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente),
	CONSTRAINT FK_facturaU FOREIGN KEY (id_factura) REFERENCES dbo.factura(id_factura)
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
	CONSTRAINT PK_diagnostico PRIMARY KEY(id_diagnostico),
	CONSTRAINT FK_medicamento FOREIGN KEY (id_medicamento) REFERENCES dbo.medicamento(id_medicamento)
);
/*Tipo Consulta*/
CREATE TABLE tipo_consulta(
	id_tipo_consulta int IDENTITY (1,1),
	tipo_consulta varchar(15),
	CONSTRAINT PK_tipo_consulta PRIMARY KEY (id_tipo_consulta)
);
/*Nueva Cita*/
CREATE TABLE nueva_cita(
	id_nueva_cita int IDENTITY (1,1),
	fecha_nueva_cita varchar(20),
	descripcion_nueva_cita varchar(100),
	id_paciente int NOT NULL,
	id_tipo_consulta int NOT NULL,
	CONSTRAINT PK_nueva_cita PRIMARY KEY (id_nueva_cita),
	CONSTRAINT FK_pacienteN FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente),
	CONSTRAINT FK_tipo_consultaN FOREIGN KEY (id_tipo_consulta) REFERENCES dbo.tipo_consulta (id_tipo_consulta)
);
/*Consulta*/
CREATE TABLE consulta(
	id_consulta int IDENTITY (1,1),
	justificante varchar(100),
	id_aseguradora int NOT NULL,
	id_paciente int NOT NULL,
	id_tipo_consulta int NOT NULL,
	id_diagnostico int NOT NULL,
	id_nueva_cita int,
	id_factura varchar NOT NULL,
	CONSTRAINT PK_consulta PRIMARY KEY(id_consulta),
	CONSTRAINT FK_aseguradoraCO FOREIGN KEY (id_aseguradora) REFERENCES dbo.aseguradora(id_aseguradora),
	CONSTRAINT FK_pacienteCO FOREIGN KEY (id_paciente) REFERENCES dbo.paciente(id_paciente),
	CONSTRAINT FK_tipo_consultaCO FOREIGN KEY (id_tipo_consulta) REFERENCES dbo.tipo_consulta(id_tipo_consulta),
	CONSTRAINT FK_diagnosticoCO FOREIGN KEY (id_diagnostico) REFERENCES dbo.diagnostico(id_diagnostico),
	CONSTRAINT FK_nueva_citaCO FOREIGN KEY (id_nueva_cita) REFERENCES dbo.nueva_cita(id_nueva_cita),
	CONSTRAINT FK_facturaCO FOREIGN KEY (id_factura) REFERENCES dbo.factura(id_factura),
);