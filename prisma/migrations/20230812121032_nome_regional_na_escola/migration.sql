BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Escola] ADD [nomeRegional] VARCHAR(80);

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
