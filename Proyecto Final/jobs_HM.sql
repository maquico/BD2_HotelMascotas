--Job actualizar estatus de reservaciones
USE msdb;
GO

DECLARE @jobId BINARY(16); 
EXEC sp_add_job
    @job_name = 'Actualizar estatus de reservaciones',
    @enabled = 1,
    @description = 'Cada 1 hora actualizar los estados de las reservaciones a no iniciada, en curso o finalizada';

EXEC sp_add_jobserver @job_name = 'Actualizar estatus de reservaciones', @server_name = "hotel-mascotas-server.database.windows.net";

-- Set the job schedule to run every hour, every day
DECLARE @scheduleId INT;
EXEC sp_add_schedule
    @schedule_name = 'Por Hora',
    @freq_type = 4, --Por Dia
    @freq_interval = 1, --Cada 1 dia
    @freq_subday_type = 4, --Por Hora
    @freq_subday_interval = 1, --Cada 1 hora
    @active_start_time = 080000, --(8 am)
    @active_end_time = 200000, --(8 pm)
    @schedule_id = @scheduleId OUTPUT;

EXEC sp_attach_schedule
    @job_name = 'Actualizar estatus de reservaciones',
    @schedule_name = 'Por Hora';

-- Add a job step
EXEC sp_add_jobstep
    @job_name = 'Actualizar estatus de reservaciones',
    @step_name = 'Paso 1',
    @subsystem = 'TSQL',
    @command = 'EXEC Hotel_Mascotas_DB.registro.spActualizarEstatusReservaciones',
    @retry_attempts = 5,
    @retry_interval = 5;
GO
