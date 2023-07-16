/*
  Warnings:

  - The primary key for the `RespostaAluno` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `RespostaAluno` table. All the data in the column will be lost.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[RespostaAluno] DROP CONSTRAINT [RespostaAluno_pkey];
ALTER TABLE [dbo].[RespostaAluno] DROP COLUMN [id];
ALTER TABLE [dbo].[RespostaAluno] ADD CONSTRAINT RespostaAluno_pkey PRIMARY KEY CLUSTERED ([perguntaId],[alunoId]);

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
