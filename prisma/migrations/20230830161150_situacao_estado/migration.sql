BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Estado] ADD [situacao] CHAR(1);

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
