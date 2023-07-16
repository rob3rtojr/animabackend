BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Formulario] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [tipo] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Formulario_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[FormularioPorEstado] (
    [id] INT NOT NULL IDENTITY(1,1),
    [estadoId] INT NOT NULL,
    CONSTRAINT [FormularioPorEstado_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[FormularioPorEstado] ADD CONSTRAINT [FormularioPorEstado_estadoId_fkey] FOREIGN KEY ([estadoId]) REFERENCES [dbo].[Estado]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
