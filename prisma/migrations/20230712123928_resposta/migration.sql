/*
  Warnings:

  - Added the required column `formularioId` to the `Pergunta` table without a default value. This is not possible if the table is not empty.
  - Added the required column `perguntaId` to the `Resposta` table without a default value. This is not possible if the table is not empty.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Pergunta] ADD [formularioId] INT NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Resposta] ADD [createdAt] DATETIME2 CONSTRAINT [Resposta_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
[perguntaId] INT NOT NULL,
[updatedAt] DATETIME2 CONSTRAINT [Resposta_updatedAt_df] DEFAULT CURRENT_TIMESTAMP;

-- AddForeignKey
ALTER TABLE [dbo].[Pergunta] ADD CONSTRAINT [Pergunta_formularioId_fkey] FOREIGN KEY ([formularioId]) REFERENCES [dbo].[Formulario]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Resposta] ADD CONSTRAINT [Resposta_perguntaId_fkey] FOREIGN KEY ([perguntaId]) REFERENCES [dbo].[Pergunta]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
