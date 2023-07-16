/*
  Warnings:

  - You are about to drop the column `escutarId` on the `Alternativa` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[perguntaId,alternativaId]` on the table `Escutar` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `escutarId` to the `Pergunta` table without a default value. This is not possible if the table is not empty.

*/
BEGIN TRY

BEGIN TRAN;

-- DropForeignKey
ALTER TABLE [dbo].[Escutar] DROP CONSTRAINT [Escutar_alternativaId_fkey];

-- DropForeignKey
ALTER TABLE [dbo].[Escutar] DROP CONSTRAINT [Escutar_perguntaId_fkey];

-- AlterTable
ALTER TABLE [dbo].[Alternativa] DROP COLUMN [escutarId];

-- AlterTable
ALTER TABLE [dbo].[Pergunta] ADD [escutarId] INT NOT NULL;

-- CreateIndex
ALTER TABLE [dbo].[Escutar] ADD CONSTRAINT [Escutar_perguntaId_alternativaId_key] UNIQUE NONCLUSTERED ([perguntaId], [alternativaId]);

-- AddForeignKey
ALTER TABLE [dbo].[Pergunta] ADD CONSTRAINT [Pergunta_escutarId_fkey] FOREIGN KEY ([escutarId]) REFERENCES [dbo].[Escutar]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
