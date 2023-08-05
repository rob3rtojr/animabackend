BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Aluno] ADD [possuiFormulario] CHAR(1);

-- AlterTable
ALTER TABLE [dbo].[Professor] ADD [possuiFormulario] CHAR(1);

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
