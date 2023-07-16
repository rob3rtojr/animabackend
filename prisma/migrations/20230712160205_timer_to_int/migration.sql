/*
  Warnings:

  - Added the required column `numero` to the `Alternativa` table without a default value. This is not possible if the table is not empty.
  - Added the required column `ordem` to the `Alternativa` table without a default value. This is not possible if the table is not empty.
  - Added the required column `numero` to the `Pergunta` table without a default value. This is not possible if the table is not empty.
  - Added the required column `ordem` to the `Pergunta` table without a default value. This is not possible if the table is not empty.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Alternativa] ADD [numero] NVARCHAR(1000) NOT NULL,
[ordem] INT NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Pergunta] ALTER COLUMN [timer] INT NULL;
ALTER TABLE [dbo].[Pergunta] ADD [numero] NVARCHAR(1000) NOT NULL,
[ordem] INT NOT NULL;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
