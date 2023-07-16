/*
  Warnings:

  - You are about to drop the `FormularioPorEstado` table. If the table is not empty, all the data it contains will be lost.

*/
BEGIN TRY

BEGIN TRAN;

-- DropForeignKey
ALTER TABLE [dbo].[FormularioPorEstado] DROP CONSTRAINT [FormularioPorEstado_estadoId_fkey];

-- DropTable
DROP TABLE [dbo].[FormularioPorEstado];

-- CreateTable
CREATE TABLE [dbo].[FormularioEstado] (
    [id] INT NOT NULL IDENTITY(1,1),
    [estadoId] INT NOT NULL,
    [formularioId] INT NOT NULL,
    CONSTRAINT [FormularioEstado_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[FormularioEstado] ADD CONSTRAINT [FormularioEstado_estadoId_fkey] FOREIGN KEY ([estadoId]) REFERENCES [dbo].[Estado]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[FormularioEstado] ADD CONSTRAINT [FormularioEstado_formularioId_fkey] FOREIGN KEY ([formularioId]) REFERENCES [dbo].[Formulario]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
