BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Estado] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [sigla] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [Estado_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [Estado_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [Estado_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Estado_sigla_key] UNIQUE NONCLUSTERED ([sigla])
);

-- CreateTable
CREATE TABLE [dbo].[Regional] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [Regional_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [Regional_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [estadoId] INT NOT NULL,
    CONSTRAINT [Regional_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Municipio] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [codigoIBGE] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [Municipio_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [Municipio_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [regionalId] INT NOT NULL,
    CONSTRAINT [Municipio_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Municipio_codigoIBGE_key] UNIQUE NONCLUSTERED ([codigoIBGE])
);

-- CreateTable
CREATE TABLE [dbo].[Escola] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [codigoMec] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [Escola_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [Escola_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [municipioId] INT NOT NULL,
    CONSTRAINT [Escola_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Escola_codigoMec_key] UNIQUE NONCLUSTERED ([codigoMec])
);

-- CreateTable
CREATE TABLE [dbo].[Turma] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [createdAt] DATETIME2 CONSTRAINT [Turma_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 CONSTRAINT [Turma_updatedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [escolaId] INT NOT NULL,
    CONSTRAINT [Turma_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Aluno] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [dataNascimento] NVARCHAR(1000) NOT NULL,
    [matricula] NVARCHAR(1000) NOT NULL,
    [nomeMae] NVARCHAR(1000) NOT NULL,
    [turmaId] INT NOT NULL,
    CONSTRAINT [Aluno_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Professor] (
    [id] INT NOT NULL IDENTITY(1,1),
    [nome] NVARCHAR(1000) NOT NULL,
    [dataNascimento] NVARCHAR(1000) NOT NULL,
    [cpf] NVARCHAR(1000) NOT NULL,
    [municipioId] INT NOT NULL,
    CONSTRAINT [Professor_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Professor_cpf_key] UNIQUE NONCLUSTERED ([cpf])
);

-- AddForeignKey
ALTER TABLE [dbo].[Regional] ADD CONSTRAINT [Regional_estadoId_fkey] FOREIGN KEY ([estadoId]) REFERENCES [dbo].[Estado]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Municipio] ADD CONSTRAINT [Municipio_regionalId_fkey] FOREIGN KEY ([regionalId]) REFERENCES [dbo].[Regional]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Escola] ADD CONSTRAINT [Escola_municipioId_fkey] FOREIGN KEY ([municipioId]) REFERENCES [dbo].[Municipio]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Turma] ADD CONSTRAINT [Turma_escolaId_fkey] FOREIGN KEY ([escolaId]) REFERENCES [dbo].[Escola]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Aluno] ADD CONSTRAINT [Aluno_turmaId_fkey] FOREIGN KEY ([turmaId]) REFERENCES [dbo].[Turma]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Professor] ADD CONSTRAINT [Professor_municipioId_fkey] FOREIGN KEY ([municipioId]) REFERENCES [dbo].[Municipio]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
