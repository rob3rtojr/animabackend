BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[TipoPergunta] (
    [id] INT NOT NULL IDENTITY(1,1),
    [descricao] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [TipoPergunta_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Pergunta] (
    [id] INT NOT NULL IDENTITY(1,1),
    [descricao] NVARCHAR(1000) NOT NULL,
    [tipoPerguntaId] INT NOT NULL,
    [escutarId] INT,
    CONSTRAINT [Pergunta_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Alternativa] (
    [id] INT NOT NULL IDENTITY(1,1),
    [descricao] NVARCHAR(1000) NOT NULL,
    [perguntaId] INT NOT NULL,
    [escutarId] INT,
    CONSTRAINT [Alternativa_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Resposta] (
    [id] INT NOT NULL IDENTITY(1,1),
    [descricao] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Resposta_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Escutar] (
    [id] INT NOT NULL IDENTITY(1,1),
    CONSTRAINT [Escutar_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[Pergunta] ADD CONSTRAINT [Pergunta_tipoPerguntaId_fkey] FOREIGN KEY ([tipoPerguntaId]) REFERENCES [dbo].[TipoPergunta]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Pergunta] ADD CONSTRAINT [Pergunta_escutarId_fkey] FOREIGN KEY ([escutarId]) REFERENCES [dbo].[Escutar]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Alternativa] ADD CONSTRAINT [Alternativa_perguntaId_fkey] FOREIGN KEY ([perguntaId]) REFERENCES [dbo].[Pergunta]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Alternativa] ADD CONSTRAINT [Alternativa_escutarId_fkey] FOREIGN KEY ([escutarId]) REFERENCES [dbo].[Escutar]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
