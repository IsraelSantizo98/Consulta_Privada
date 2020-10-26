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