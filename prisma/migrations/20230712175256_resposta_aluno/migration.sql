/*
  Warnings:

  - You are about to drop the `Resposta` table. If the table is not empty, all the data it contains will be lost.

*/
BEGIN TRY

BEGIN TRAN;

-- DropForeignKey
ALTER TABLE [dbo].[Resposta] DROP CONSTRAINT [Resposta_perguntaId_fkey];

-- DropTable
DROP TABLE [dbo].[Resposta];

-- CreateTable
CREATE TABLE [dbo].[RespostaAluno] (
    [id] INT NOT NULL IDENTITY(1,1),
    [descricao] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [RespostaAluno_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [RespostaAluno_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [perguntaId] INT NOT NULL,
    [alunoId] INT NOT NULL,
    CONSTRAINT [RespostaAluno_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[RespostaAluno] ADD CONSTRAINT [RespostaAluno_perguntaId_fkey] FOREIGN KEY ([perguntaId]) REFERENCES [dbo].[Pergunta]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[RespostaAluno] ADD CONSTRAINT [RespostaAluno_alunoId_fkey] FOREIGN KEY ([alunoId]) REFERENCES [dbo].[Aluno]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
