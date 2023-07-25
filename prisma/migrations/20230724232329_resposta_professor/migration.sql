BEGIN TRY

BEGIN TRAN;

-- DropIndex
ALTER TABLE [dbo].[Escutar] DROP CONSTRAINT [Escutar_escutarPerguntaId_escutarAlternativaId_key];

-- CreateTable
CREATE TABLE [dbo].[RespostaProfessor] (
    [descricao] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [RespostaProfessor_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [RespostaProfessor_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [perguntaId] INT NOT NULL,
    [professorId] INT NOT NULL,
    CONSTRAINT [RespostaProfessor_pkey] PRIMARY KEY CLUSTERED ([perguntaId],[professorId])
);

-- AddForeignKey
ALTER TABLE [dbo].[RespostaProfessor] ADD CONSTRAINT [RespostaProfessor_perguntaId_fkey] FOREIGN KEY ([perguntaId]) REFERENCES [dbo].[Pergunta]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[RespostaProfessor] ADD CONSTRAINT [RespostaProfessor_professorId_fkey] FOREIGN KEY ([professorId]) REFERENCES [dbo].[Professor]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
