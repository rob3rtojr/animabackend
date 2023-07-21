BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[FormularioAluno] (
    [situacao] INT NOT NULL,
    [alunoId] INT NOT NULL,
    [formularioId] INT NOT NULL,
    CONSTRAINT [FormularioAluno_pkey] PRIMARY KEY CLUSTERED ([alunoId],[formularioId])
);

-- CreateTable
CREATE TABLE [dbo].[FormularioProfessor] (
    [situacao] INT NOT NULL,
    [professorId] INT NOT NULL,
    [formularioId] INT NOT NULL,
    CONSTRAINT [FormularioProfessor_pkey] PRIMARY KEY CLUSTERED ([professorId],[formularioId])
);

-- AddForeignKey
ALTER TABLE [dbo].[FormularioAluno] ADD CONSTRAINT [FormularioAluno_alunoId_fkey] FOREIGN KEY ([alunoId]) REFERENCES [dbo].[Aluno]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[FormularioAluno] ADD CONSTRAINT [FormularioAluno_formularioId_fkey] FOREIGN KEY ([formularioId]) REFERENCES [dbo].[Formulario]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[FormularioProfessor] ADD CONSTRAINT [FormularioProfessor_professorId_fkey] FOREIGN KEY ([professorId]) REFERENCES [dbo].[Professor]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[FormularioProfessor] ADD CONSTRAINT [FormularioProfessor_formularioId_fkey] FOREIGN KEY ([formularioId]) REFERENCES [dbo].[Formulario]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
