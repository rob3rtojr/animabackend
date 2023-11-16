/*
  Warnings:

  - You are about to alter the column `numero` on the `Alternativa` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(5)`.
  - You are about to alter the column `nome` on the `Aluno` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(200)`.
  - You are about to alter the column `dataNascimento` on the `Aluno` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(10)`.
  - You are about to alter the column `matricula` on the `Aluno` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.
  - You are about to alter the column `nomeMae` on the `Aluno` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(200)`.
  - You are about to alter the column `cpf` on the `Aluno` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(11)`.
  - You are about to alter the column `nome` on the `Escola` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(150)`.
  - You are about to alter the column `nome` on the `Estado` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.
  - You are about to alter the column `nome` on the `Formulario` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(100)`.
  - You are about to alter the column `tipo` on the `Formulario` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(10)`.
  - You are about to alter the column `duracao` on the `Formulario` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(20)`.
  - You are about to alter the column `nome` on the `Municipio` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.
  - You are about to alter the column `numero` on the `Pergunta` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(5)`.
  - You are about to alter the column `mascaraResposta` on the `Pergunta` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(30)`.
  - You are about to alter the column `nome` on the `Professor` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(200)`.
  - You are about to alter the column `dataNascimento` on the `Professor` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(10)`.
  - You are about to alter the column `cpf` on the `Professor` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(11)`.
  - You are about to alter the column `masp` on the `Professor` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(20)`.
  - You are about to alter the column `matricula` on the `Professor` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(20)`.
  - You are about to alter the column `nome` on the `Regional` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.
  - You are about to alter the column `descricao` on the `RespostaAluno` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.
  - You are about to alter the column `descricao` on the `RespostaProfessor` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(50)`.
  - You are about to alter the column `descricao` on the `TipoPergunta` table. The data in that column could be lost. The data in that column will be cast from `NVarChar(1000)` to `VarChar(30)`.

*/
BEGIN TRY

BEGIN TRAN;

-- AlterTable
ALTER TABLE [dbo].[Alternativa] ALTER COLUMN [numero] VARCHAR(5) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Aluno] ALTER COLUMN [nome] VARCHAR(200) NOT NULL;
ALTER TABLE [dbo].[Aluno] ALTER COLUMN [dataNascimento] VARCHAR(10) NOT NULL;
ALTER TABLE [dbo].[Aluno] ALTER COLUMN [matricula] VARCHAR(50) NOT NULL;
ALTER TABLE [dbo].[Aluno] ALTER COLUMN [nomeMae] VARCHAR(200) NOT NULL;
ALTER TABLE [dbo].[Aluno] ALTER COLUMN [cpf] VARCHAR(11) NULL;

-- AlterTable
ALTER TABLE [dbo].[Escola] ALTER COLUMN [nome] VARCHAR(150) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Estado] ALTER COLUMN [nome] VARCHAR(50) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Formulario] ALTER COLUMN [nome] VARCHAR(100) NOT NULL;
ALTER TABLE [dbo].[Formulario] ALTER COLUMN [tipo] VARCHAR(10) NOT NULL;
ALTER TABLE [dbo].[Formulario] ALTER COLUMN [duracao] VARCHAR(20) NULL;

-- AlterTable
ALTER TABLE [dbo].[Municipio] ALTER COLUMN [nome] VARCHAR(50) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[Pergunta] ALTER COLUMN [numero] VARCHAR(5) NOT NULL;
ALTER TABLE [dbo].[Pergunta] ALTER COLUMN [mascaraResposta] VARCHAR(30) NULL;

-- AlterTable
ALTER TABLE [dbo].[Professor] ALTER COLUMN [nome] VARCHAR(200) NOT NULL;
ALTER TABLE [dbo].[Professor] ALTER COLUMN [dataNascimento] VARCHAR(10) NOT NULL;
ALTER TABLE [dbo].[Professor] ALTER COLUMN [cpf] VARCHAR(11) NULL;
ALTER TABLE [dbo].[Professor] ALTER COLUMN [masp] VARCHAR(20) NULL;
ALTER TABLE [dbo].[Professor] ALTER COLUMN [matricula] VARCHAR(20) NULL;

-- AlterTable
ALTER TABLE [dbo].[Regional] ALTER COLUMN [nome] VARCHAR(50) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[RespostaAluno] ALTER COLUMN [descricao] VARCHAR(50) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[RespostaProfessor] ALTER COLUMN [descricao] VARCHAR(50) NOT NULL;

-- AlterTable
ALTER TABLE [dbo].[TipoPergunta] ALTER COLUMN [descricao] VARCHAR(30) NOT NULL;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
