/*
  Warnings:

  - You are about to drop the column `escutarId` on the `Pergunta` table. All the data in the column will be lost.
  - You are about to drop the `Escutar` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `escutar` to the `Pergunta` table without a default value. This is not possible if the table is not empty.

*/
BEGIN TRY

BEGIN TRAN;

-- DropForeignKey
ALTER TABLE [dbo].[Alternativa] DROP CONSTRAINT [Alternativa_escutarId_fkey];

-- DropForeignKey
ALTER TABLE [dbo].[Pergunta] DROP CONSTRAINT [Pergunta_escutarId_fkey];

-- AlterTable
ALTER TABLE [dbo].[Pergunta] DROP COLUMN [escutarId];
ALTER TABLE [dbo].[Pergunta] ADD [escutar] NVARCHAR(1000) NOT NULL,
[timer] BIT;

-- DropTable
DROP TABLE [dbo].[Escutar];

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
