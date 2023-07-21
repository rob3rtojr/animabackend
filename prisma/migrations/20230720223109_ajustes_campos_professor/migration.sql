/*
  Warnings:

  - You are about to drop the column `codigoIBGE` on the `Municipio` table. All the data in the column will be lost.

*/
BEGIN TRY

BEGIN TRAN;

-- DropIndex
ALTER TABLE [dbo].[Municipio] DROP CONSTRAINT [Municipio_codigoIBGE_key];

-- DropIndex
ALTER TABLE [dbo].[Professor] DROP CONSTRAINT [Professor_cpf_key];

-- AlterTable
ALTER TABLE [dbo].[Municipio] DROP COLUMN [codigoIBGE];

-- AlterTable
ALTER TABLE [dbo].[Professor] ALTER COLUMN [cpf] NVARCHAR(1000) NULL;
ALTER TABLE [dbo].[Professor] ADD [masp] NVARCHAR(1000),
[matricula] NVARCHAR(1000);

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
