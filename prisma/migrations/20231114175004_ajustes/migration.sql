/*
  Warnings:

  - You are about to alter the column `nome` on the `Turma` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Turma] ALTER COLUMN [nome] VARCHAR(50) NOT NULL;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
