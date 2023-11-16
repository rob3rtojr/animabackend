BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[ProfessorEscola] (
    [professorId] INT NOT NULL,
    [escolaId] INT NOT NULL,
    CONSTRAINT [ProfessorEscola_pkey] PRIMARY KEY CLUSTERED ([escolaId],[professorId])
);

-- AddForeignKey
ALTER TABLE [dbo].[ProfessorEscola] ADD CONSTRAINT [ProfessorEscola_professorId_fkey] FOREIGN KEY ([professorId]) REFERENCES [dbo].[Professor]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[ProfessorEscola] ADD CONSTRAINT [ProfessorEscola_escolaId_fkey] FOREIGN KEY ([escolaId]) REFERENCES [dbo].[Escola]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
