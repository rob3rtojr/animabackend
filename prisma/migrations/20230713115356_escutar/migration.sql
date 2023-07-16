/*
  Warnings:

  - You are about to drop the column `escutar` on the `Pergunta` table. All the data in the column will be lost.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Pergunta] DROP COLUMN [escutar];

-- CreateTable
CREATE TABLE [dbo].[Escutar] (
    [id] INT NOT NULL IDENTITY(1,1),
    [perguntaId] INT NOT NULL,
    [alternativaId] INT NOT NULL,
    CONSTRAINT [Escutar_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[Escutar] ADD CONSTRAINT [Escutar_perguntaId_fkey] FOREIGN KEY ([perguntaId]) REFERENCES [dbo].[Pergunta]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Escutar] ADD CONSTRAINT [Escutar_alternativaId_fkey] FOREIGN KEY ([alternativaId]) REFERENCES [dbo].[Alternativa]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
