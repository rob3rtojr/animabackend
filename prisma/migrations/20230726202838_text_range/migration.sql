/*
  Warnings:

  - Added the required column `termo` to the `Formulario` table without a default value. This is not possible if the table is not empty.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Formulario] ADD [termo] NVARCHAR(1000) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Pergunta] ADD [step] INT,
[valorMaximo] INT,
[valorMinimo] INT;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
