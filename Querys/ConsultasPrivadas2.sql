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
/*TRIGGER*/
CREATE TABLE AseguradoraLog(
	idAseguradoraLog int IDENTITY (1,1),
	id_aseguradora int NOT NULL,
	nombre_aseguradora varchar(45),
	domicilio_social_aseguradora varchar(100), 
	CIF_aseguradora varchar(45),
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_AseguradoraAudit
ON dbo.aseguradora
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.AseguradoraLog(id_aseguradora, nombre_aseguradora, domicilio_social_aseguradora, CIF_aseguradora, updateAt, operacion)
	SELECT
		i.id_aseguradora, i.nombre_aseguradora,
		i.domicilio_social_aseguradora, i.CIF_aseguradora,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_aseguradora, d.nombre_aseguradora,
		d.domicilio_social_aseguradora, d.CIF_aseguradora,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.AseguradoraLog;
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
	tipo_consulta varchar(10),
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
/*Creacion tabla LOG*/
CREATE TABLE PacienteLog(
	idPacienteLog int IDENTITY (1,1),
	id_paciente int NOT NULL,
	nombre_paciente varchar(45),
	apellido_paciente varchar(45),
	domicilio_paciente varchar(100), 
	sexo_paciente varchar(12),
	fecha_naciemiento_paciente varchar(45),
	id_aseguradora int,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
/*Trigger*/
GO
CREATE TRIGGER trg_PacienteAudit
ON dbo.paciente
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.PacienteLog(id_paciente, nombre_paciente, apellido_paciente, sexo_paciente, fecha_naciemiento_paciente, id_aseguradora, updateAt, operacion)
	SELECT
		i.id_paciente, i.nombre_paciente,
		i.domicilio_paciente, i.sexo_paciente,
		i.fecha_naciemiento_paciente, i.id_aseguradora,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_paciente, d.nombre_paciente,
		d.domicilio_paciente, d.sexo_paciente,
		d.fecha_naciemiento_paciente, d.id_aseguradora,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.PacienteLog;
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
GO
/*Insert*/
CREATE PROCEDURE sp_InsertPaciente
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
END;
EXEC sp_InsertPaciente 'Jessica', 'Pearson', 'Guatemala', 'Femenino', '10/05/1970', 2;
/*Upadate*/
GO
CREATE PROCEDURE sp_UpdatePaciente
(	
	@id_paciente			int,
	@nombre_paciente		varchar(45),
	@apellido_paciente		varchar(45),
	@domicilio_paciente		varchar(100),
	@sexo_paciente			varchar(12),
	@fecha_naciemiento_paciente	varchar(45),
	@id_aseguradora			int
)
AS 
BEGIN
UPDATE dbo.paciente SET nombre_paciente = @nombre_paciente, apellido_paciente = @apellido_paciente, domicilio_paciente = @domicilio_paciente, sexo_paciente = @sexo_paciente, fecha_naciemiento_paciente = @fecha_naciemiento_paciente, id_aseguradora = @id_aseguradora WHERE id_paciente = @id_paciente
END;
EXEC sp_UpdatePaciente 3,'Steven', 'Mazariegos', 'Guatemala, Ciudad', 'Masculino', '02/09/1998', 2;
/*Delete*/
GO
CREATE PROCEDURE sp_DeletePaciente
(
@id_paciente int
)
AS
BEGIN
DELETE FROM dbo.paciente WHERE id_paciente = @id_paciente
END;
EXEC sp_DeletePaciente 3;
/*Select*/
GO
CREATE PROCEDURE sp_SelectPaciente
AS
BEGIN
SELECT * FROM dbo.paciente
END;
EXEC sp_SelectPaciente;
/*Insert Aseguradora*/
GO
CREATE PROCEDURE sp_InsertAseguradora
	@nombre_aseguradora		varchar(45),
	@domicilio_social_aseguradora		varchar(100),
	@CIF_aseguradora		varchar(45)
AS
BEGIN
	INSERT INTO dbo.aseguradora(nombre_aseguradora, domicilio_social_aseguradora, CIF_aseguradora)
	VALUES (@nombre_aseguradora,@domicilio_social_aseguradora, @CIF_aseguradora)
END;
EXEC sp_InsertAseguradora 'MAPFRE', 'Guatemala, Zona 10', 'A000003';
/*Update*/

GO
CREATE PROCEDURE sp_UpdateAseguradora
(	
	@id_aseguradora int,
	@nombre_aseguradora		varchar(45),
	@domicilio_social_aseguradora		varchar(100),
	@CIF_aseguradora		varchar(45)
)
AS 
BEGIN
UPDATE dbo.aseguradora SET nombre_aseguradora = @nombre_aseguradora, domicilio_social_aseguradora = @domicilio_social_aseguradora, CIF_aseguradora = @CIF_aseguradora WHERE id_aseguradora = @id_aseguradora
END;
EXEC sp_UpdateAseguradora 2, 'Seguros G&T', 'Guatemala, Zona 14', 'A000002';
SELECT *FROM dbo.aseguradora;
GO
CREATE PROCEDURE sp_DeleteAseguradora 
(
	@id_aseguradora int
)
AS
BEGIN
DELETE FROM dbo.aseguradora WHERE id_aseguradora = @id_aseguradora
END;
EXEC sp_DeleteAseguradora 3;
GO
CREATE PROCEDURE sp_InsertUrgencia
	@nombre_urgencia varchar(45),
	@apellido_urgencia varchar(45),
	@fecha_hora_urgencia varchar(45),
	@descripcion_urgencia varchar(100),
	@id_paciente int
AS
BEGIN
	INSERT INTO dbo.urgencia (nombre_urgencia,apellido_urgencia, fecha_hora_urgencia, descripcion_urgencia, id_paciente)
	VALUES (@nombre_urgencia,@apellido_urgencia, @fecha_hora_urgencia, @descripcion_urgencia, @id_paciente)
END;
EXEC sp_InsertUrgencia 'Jessica', 'Pearson', '27/10/2020', 'Roptura de ligamento cruzado', 5;
GO
CREATE PROCEDURE sp_UpdateUrgencia
(	
	@id_urgencia int,
	@nombre_urgencia varchar(45),
	@apellido_urgencia varchar(45),
	@fecha_hora_urgencia varchar(45),
	@descripcion_urgencia varchar(100),
	@id_paciente int
)
AS 
BEGIN
UPDATE dbo.urgencia SET nombre_urgencia = @nombre_urgencia, apellido_urgencia = @apellido_urgencia, fecha_hora_urgencia = @fecha_hora_urgencia, descripcion_urgencia = @descripcion_urgencia, id_paciente = @id_paciente WHERE id_urgencia = @id_urgencia
END;
EXEC sp_UpdateUrgencia 2, 'Jessica', 'Pearson', '25/10/2020 6am', 'Roptura de ligamento cruzado', 5;
GO
CREATE PROCEDURE sp_DeleteUrgencia
(
@id_urgencia int
)
AS
BEGIN
DELETE FROM dbo.urgencia WHERE id_urgencia = @id_urgencia
END;
EXEC sp_DeleteUrgencia 2;

GO
CREATE PROCEDURE sp_InsertCita
	@fecha_hora_cita varchar(45),
	@id_paciente int
AS
BEGIN
	INSERT INTO dbo.cita (fecha_hora_cita, id_paciente)
	VALUES (@fecha_hora_cita, @id_paciente)
END;
EXEC sp_InsertCita '12/02/2020', 1;
GO
CREATE PROCEDURE sp_UpdateCita
(	
	@id_cita int,
	@fecha_hora_cita varchar(45),
	@id_paciente int
)
AS 
BEGIN
UPDATE dbo.cita SET fecha_hora_cita = @fecha_hora_cita, id_paciente = @id_paciente WHERE id_cita = @id_cita
END;
EXEC sp_UpdateCita 2, '12/02/2020 4pm', 1;
GO
CREATE PROCEDURE sp_DeleteCita
(
@id_cita int
)
AS
BEGIN
DELETE FROM dbo.cita WHERE id_cita = @id_cita
END;
EXEC sp_DeleteCita 3;
GO
CREATE PROCEDURE sp_InsertConsulta
	@tipo_consulta		varchar(10),
	@fecha_nueva_consulta		varchar(45),
	@justificante_consulta	varchar(100),
	@id_cita		int
AS
BEGIN
	INSERT INTO dbo.consulta (tipo_consulta, fecha_nueva_consulta, justificante_consulta, id_cita)
	VALUES (@tipo_consulta, @fecha_nueva_consulta, @justificante_consulta, @id_cita)
END;
EXEC sp_InsertConsulta 'Control', '20/11/2020', 'Se debe realizar examenes en un mes', 2;
GO
CREATE PROCEDURE sp_UpdateConsulta
(	
	@id_consulta			int,
	@tipo_consulta		varchar(10),
	@fecha_nueva_consulta		varchar(45),
	@justificante_consulta	varchar(100),
	@id_cita		int
)
AS 
BEGIN
UPDATE dbo.consulta SET tipo_consulta = @tipo_consulta, fecha_nueva_consulta = @fecha_nueva_consulta, justificante_consulta = @justificante_consulta, id_cita = @id_cita WHERE id_consulta = @id_consulta
END;
EXEC sp_UpdateConsulta 2,'Control', '20/11/2020', 'Control mensual', 2;
GO
CREATE PROCEDURE sp_DeleteConsulta
(
@id_consulta int
)
AS
BEGIN
DELETE FROM dbo.consulta WHERE id_consulta = @id_consulta
END;
EXEC sp_DeleteConsulta 3;
GO
CREATE PROCEDURE sp_InsertMedicamento
	@principio_activo		varchar(45),
	@denominacion		varchar(45)
AS
BEGIN
	INSERT INTO dbo.medicamento(principio_activo, denominacion)
	VALUES (@principio_activo, @denominacion)
END;
EXEC sp_InsertMedicamento 'Calcio', 'Fortizica Huesos';
GO
CREATE PROCEDURE sp_UpdateMedicamento
(	
	@id_medicamento int,
	@principio_activo		varchar(45),
	@denominacion		varchar(45)
)
AS 
BEGIN
UPDATE dbo.medicamento SET principio_activo = @principio_activo, denominacion = @denominacion WHERE id_medicamento = @id_medicamento
END;
EXEC sp_UpdateMedicamento 3,'Vitamina D', 'Fortifica los huesos';
GO
CREATE PROCEDURE sp_DeleteMedicamento
(
@id_medicamento int
)
AS
BEGIN
DELETE FROM dbo.medicamento WHERE id_medicamento = @id_medicamento
END;
EXEC sp_DeleteMedicamento 3;
GO
CREATE PROCEDURE sp_InsertDiagnostico
	@dosis_diagnostico		varchar(45),
	@descripcion_diagnostico		varchar(100),
	@id_consulta int,
	@id_urgencia int,
	@id_medicamento int
AS
BEGIN
	INSERT INTO dbo.diagnostico (dosis_diagnostico, descripcion_diagnostico, id_consulta, id_urgencia, id_medicamento)
	VALUES (@dosis_diagnostico, @descripcion_diagnostico, @id_consulta, @id_urgencia, @id_medicamento)
END;
EXEC sp_InsertDiagnostico '2 veces cada 48 hrs por 1 semana', 'Paciente con problemas en los huesos', 2, NULL,3;
GO
CREATE PROCEDURE sp_UpdateDiagnostico
(	
	@id_diagnostico int,
	@dosis_diagnostico		varchar(45),
	@descripcion_diagnostico		varchar(100),
	@id_consulta int,
	@id_urgencia int,
	@id_medicamento int
)
AS 
BEGIN
UPDATE dbo.diagnostico SET dosis_diagnostico = @dosis_diagnostico, descripcion_diagnostico = @descripcion_diagnostico, id_consulta = @id_consulta, id_urgencia = @id_urgencia, id_medicamento = @id_medicamento WHERE id_diagnostico = @id_diagnostico
END;
EXEC sp_UpdateDiagnostico 12,'2 veces al dia', 'Paciente con problemas en los huesos', 2, NULL, 3;
GO
CREATE PROCEDURE sp_DeleteDiagnostico
(
@id_diagnostico int
)
AS
BEGIN
DELETE FROM dbo.diagnostico WHERE id_diagnostico = @id_diagnostico
END;
EXEC sp_DeleteDiagnostico 12;
GO
CREATE PROCEDURE sp_InsertFactura
	@nit_factura varchar(8),
	@descripcion_factura	varchar(100),
	@total_factura		decimal(18,2),
	@id_paciente		int,
	@id_consulta		int,
	@id_urgencia		int
AS
BEGIN
	INSERT INTO dbo.factura (nit_factura, descripcion_factura, total_factura, id_paciente, id_consulta, id_urgencia)
	VALUES (@nit_factura, @descripcion_factura, @total_factura, @id_paciente, @id_consulta, @id_urgencia)
END;
EXEC sp_InsertFactura '875963-8', 'Pago por servicio', 125.00, '1', '1', NULL;
GO
CREATE PROCEDURE sp_UpdateFactura
(	
	@id_factura int,
	@nit_factura varchar(8),
	@descripcion_factura	varchar(100),
	@total_factura		decimal(18,2),
	@id_paciente		int,
	@id_consulta		int,
	@id_urgencia		int
)
AS 
BEGIN
UPDATE dbo.factura SET nit_factura = @nit_factura, descripcion_factura = @descripcion_factura, total_factura = @total_factura, id_paciente = @id_paciente, id_consulta = @id_consulta, id_urgencia = @id_urgencia WHERE id_factura = @id_factura
END;
EXEC sp_UpdateFactura 3,'874587-9', 'Pago por diagnostico', 150.00, '1', '1', NULL;
GO
CREATE PROCEDURE sp_DeleteFactura
(
@id_factura int
)
AS
BEGIN
DELETE FROM dbo.factura WHERE id_factura = @id_factura
END;
EXEC sp_Deletefactura 1;
GO
/*TRIGGER*/
CREATE TABLE UrgenciaLog(
	idUrgenciaLog int IDENTITY (1,1),
	id_urgencia int NOT NULL,
	nombre_urgencia varchar(45),
	apellido_urgencia varchar(45),
	fecha_hora_urgencia varchar(45),
	descripcion_urgencia varchar(100),
	id_paciente int,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_UrgenciaAudit
ON dbo.urgencia
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.UrgenciaLog(id_urgencia, nombre_urgencia, apellido_urgencia, fecha_hora_urgencia, descripcion_urgencia, id_paciente, updateAt, operacion)
	SELECT
		i.id_urgencia, i.nombre_urgencia,
		i.apellido_urgencia, i.fecha_hora_urgencia,
		i.descripcion_urgencia, i.id_paciente,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_urgencia, d.nombre_urgencia,
		d.apellido_urgencia, d.fecha_hora_urgencia,
		d.descripcion_urgencia, d.id_paciente,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.AseguradoraLog;
GO
/*TRIGGER*/
CREATE TABLE CitaLog(
	idCitaLog int IDENTITY (1,1),
	id_cita int NOT NULL,
	fecha_hora_cita varchar(45),
	id_paciente int NOT NULL,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_CitaAudit
ON dbo.cita
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.CitaLog(id_cita, fecha_hora_cita, id_paciente, updateAt, operacion)
	SELECT
		i.id_cita, i.fecha_hora_cita,
		i.id_paciente,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_cita, d.fecha_hora_cita,
		d.id_paciente,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.CitaLog;
GO
/*TRIGGER*/
CREATE TABLE ConsultaLog(
	idCitaLog int IDENTITY (1,1),
	id_consulta int NOT NULL,
	tipo_consulta varchar(10),
	fecha_nueva_consulta varchar(45),
	justificante_consulta varchar(100),
	id_cita int NOT NULL,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_ConsultaAudit
ON dbo.consulta
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.ConsultaLog(id_consulta, tipo_consulta, fecha_nueva_consulta, justificante_consulta, id_cita, updateAt, operacion)
	SELECT
		i.id_consulta, i.tipo_consulta, i.fecha_nueva_consulta, i.justificante_consulta, i.id_cita,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_consulta, d.tipo_consulta, d.fecha_nueva_consulta, d.justificante_consulta, d.id_cita,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.ConsultaLog;
GO
/*TRIGGER*/
CREATE TABLE ConsultaLog(
	idCitaLog int IDENTITY (1,1),
	id_consulta int NOT NULL,
	tipo_consulta varchar(10),
	fecha_nueva_consulta varchar(45),
	justificante_consulta varchar(100),
	id_cita int NOT NULL,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_ConsultaAudit
ON dbo.consulta
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.ConsultaLog(id_consulta, tipo_consulta, fecha_nueva_consulta, justificante_consulta, id_cita, updateAt, operacion)
	SELECT
		i.id_consulta, i.tipo_consulta, i.fecha_nueva_consulta, i.justificante_consulta, i.id_cita,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_consulta, d.tipo_consulta, d.fecha_nueva_consulta, d.justificante_consulta, d.id_cita,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.ConsultaLog;
GO
/*TRIGGER*/
CREATE TABLE MedicamenteLog(
	idMedicamentoLog int IDENTITY (1,1),
	id_medicamento int NOT NULL,
	principio_activo varchar(45),
	denominacion varchar(45),
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_MedicamentoAudit
ON dbo.medicamento
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.MedicamenteLog(id_medicamento, principio_activo, denominacion, updateAt, operacion)
	SELECT
		i.id_medicamento, i.principio_activo, i.denominacion,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_medicamento, d.principio_activo, d.denominacion,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.MedicamenteLog;
GO
/*TRIGGER*/
CREATE TABLE DiagnosticoLog(
	idDiagnosticoLog int IDENTITY (1,1),
	id_diagnostico int NOT NULL,
	dosis_diagnostico varchar(45),
	descripcion_diagnostico varchar(100),
	id_consulta int,
	id_urgencia int,
	id_medicamento int,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_DiagnosticoAudit
ON dbo.diagnostico
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.DiagnosticoLog(id_diagnostico, dosis_diagnostico, descripcion_diagnostico, id_consulta, id_urgencia, id_medicamento, updateAt, operacion)
	SELECT
		i.id_diagnostico, i.dosis_diagnostico, i.descripcion_diagnostico, i.id_consulta, i.id_urgencia, i.id_medicamento,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_diagnostico, d.dosis_diagnostico, d.descripcion_diagnostico, d.id_consulta, d.id_urgencia, d.id_medicamento,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.DiagnosticoLog;
GO
/*TRIGGER*/
CREATE TABLE FacturaLog(
	idFacturaLog int IDENTITY (1,1),
	id_factura int NOT NULL,
	nit_factura varchar(8),
	descripcion_factura varchar(100),
	total_factura decimal(18,2),
	id_paciente int NOT NULL,
	id_consulta int,
	id_urgencia int,
	updateAt DATETIME NOT NULL,
	operacion CHAR(3) NOT NULL,
	CHECK (operacion = 'INS' or operacion = 'DEL')
);
GO
CREATE TRIGGER trg_FacturaAudit
ON dbo.factura
AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.FacturaLog(id_factura, nit_factura, descripcion_factura, total_factura, id_paciente, id_consulta, id_urgencia, updateAt, operacion)
	SELECT
		i.id_factura, i.nit_factura, i.descripcion_factura, i.total_factura, i.id_paciente, i.id_consulta, i.id_urgencia,
		GETDATE(), 'INS'
	FROM inserted AS i
	UNION ALL
	SELECT 
		d.id_factura, d.nit_factura, d.descripcion_factura, d.total_factura, d.id_paciente, d.id_consulta, d.id_urgencia,
		GETDATE(), 'DEL'
	FROM deleted AS d
END;
SELECT * FROM dbo.FacturaLog;