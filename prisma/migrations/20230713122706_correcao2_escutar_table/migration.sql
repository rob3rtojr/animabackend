/*
  Warnings:

  - You are about to drop the column `alternativaId` on the `Escutar` table. All the data in the column will be lost.
  - You are about to drop the column `escutarId` on the `Pergunta` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[escutarPerguntaId,escutarAlternativaId]` on the table `Escutar` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `escutarAlternativaId` to the `Escutar` table without a default value. This is not possible if the table is not empty.
  - Added the required column `escutarPerguntaId` to the `Escutar` table without a default value. This is not possible if the table is not empty.

*/
BEGIN TRY

BEGIN TRAN;

-- DropForeignKey
ALTER TABLE [dbo].[Pergunta] DROP CONSTRAINT [Pergunta_escutarId_fkey];

-- DropIndex
ALTER TABLE [dbo].[Escutar] DROP CONSTRAINT [Escutar_perguntaId_alternativaId_key];

-- AlterTable
ALTER TABLE [dbo].[Escutar] DROP COLUMN [alternativaId];
ALTER TABLE [dbo].[Escutar] ADD [escutarAlternativaId] INT NOT NULL,
[escutarPerguntaId] INT NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Pergunta] DROP COLUMN [escutarId];

-- CreateIndex
ALTER TABLE [dbo].[Escutar] ADD CONSTRAINT [Escutar_escutarPerguntaId_escutarAlternativaId_key] UNIQUE NONCLUSTERED ([escutarPerguntaId], [escutarAlternativaId]);

-- AddForeignKey
ALTER TABLE [dbo].[Escutar] ADD CONSTRAINT [Escutar_perguntaId_fkey] FOREIGN KEY ([perguntaId]) REFERENCES [dbo].[Pergunta]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
