USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'StatueStore')
	DROP DATABASE StatueStore
GO

CREATE DATABASE StatueStore
GO

USE StatueStore
GO

CREATE TABLE Envio (
	idEnvio INT PRIMARY KEY IDENTITY NOT NULL,
	frete MONEY NULL,
	meio VARCHAR(20) NULL,
	dataEnvio DATETIME NULL,
	dataEntrega DATETIME NULL,
	dataPrevisao DATE NULL
)
GO

CREATE TABLE TipoPgto (
	idTipoPgto INT PRIMARY KEY IDENTITY NOT NULL,
	nomeTipo VARCHAR(45) UNIQUE NULL,
	obs VARCHAR(100) NULL,
)
GO

CREATE TABLE StatusPedido (
	idStatusPedido INT PRIMARY KEY IDENTITY NOT NULL,
	nomeStatus VARCHAR(20) UNIQUE NULL,
	descricao VARCHAR(100) NULL 
)
GO

CREATE TABLE Cliente (
	idCliente INT PRIMARY KEY IDENTITY NOT NULL,
	email VARCHAR(100) UNIQUE NULL,
	senha VARCHAR(45) NULL,
	nome VARCHAR(45) NULL,
	sobrenome VARCHAR(45) NULL,
	sexo CHAR(1) NULL,
	cpf VARCHAR(11) NULL,
	dataNasc DATE NULL, 
	dataInsc DATE NULL,
	codSenha varchar(30) NULL,
)
GO

CREATE TABLE CartaoCredito (
	idCartao INT PRIMARY KEY IDENTITY NOT NULL,
	bandeira VARCHAR(100) NULL,
	numCartao VARCHAR(100) NOT NULL,
	cvv VARCHAR(100) NULL,
	validade VARCHAR(100) NULL,
	idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente) NULL,
	Titular NVARCHAR(100)
)
GO

CREATE TABLE Endereco (
	idEndereco INT PRIMARY KEY IDENTITY NOT NULL,
	cep VARCHAR(8) NULL,
	pais VARCHAR(20) NULL,
	estado VARCHAR(20) NULL,
	cidade VARCHAR(45) NULL,
	bairro VARCHAR(45) NULL,
	logradouro VARCHAR(100) NULL,
	tipoLogradouro VARCHAR(45) NULL,
	numero INT NULL,
	complementoEnd VARCHAR(100) NULL,
)
GO

CREATE TABLE Endereco_Cliente (
	idEndereco_Cliente INT PRIMARY KEY IDENTITY NOT NULL,
	idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente) NOT NULL,
	idEndereco INT FOREIGN KEY REFERENCES Endereco(idEndereco) NOT NULL
)
GO

CREATE TABLE CodigoResgate (
	idCodigoResgate CHAR(8) PRIMARY KEY,
	ativo INT NOT NULL
)
GO

CREATE TABLE Pedido (
	idPedido INT PRIMARY KEY IDENTITY NOT NULL,
	dataPedido DATETIME NULL,
	idEnvio INT FOREIGN KEY REFERENCES Envio(idEnvio) NULL,
	idTipoPgto INT FOREIGN KEY REFERENCES TipoPgto(idTipoPgto) NULL,
	idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente) NULL,
	idEndereco_Cliente INT FOREIGN KEY REFERENCES Endereco_Cliente(idEndereco_Cliente) NULL,
	idCartaoCredito INT FOREIGN KEY REFERENCES CartaoCredito(idCartao) NULL, --Em caso de pagamento em cartão
	idCodigoResgate CHAR(8) FOREIGN KEY REFERENCES CodigoResgate(idCodigoResgate) NULL, --Em caso de pagamento por código de resgate
	pagamentoAtivo TINYINT NULL, --Em caso de pagamento em boleto
	idStatusPedido INT FOREIGN KEY REFERENCES StatusPedido(idStatusPedido)
)
GO

CREATE TABLE NivelAcesso (
	idNivelAcesso INT PRIMARY KEY IDENTITY NOT NULL,
	nomeNivel VARCHAR(20) UNIQUE NULL,
	descricao VARCHAR(300) NULL	
)
GO

CREATE TABLE Funcionario (
	idFuncionario INT PRIMARY KEY IDENTITY NOT NULL,
	cpf VARCHAR(12) UNIQUE NULL,
	nome VARCHAR(45) NULL,
	sobrenome VARCHAR(45) NULL,
	sexo CHAR(1) NULL,
	email VARCHAR(100) UNIQUE NULL,
	senha VARCHAR(20) NULL,
	funcao VARCHAR(45) NULL,
	dataAdmissao DATE NULL,
	dataDemissao DATE NULL,
	valorHora MONEY NULL,
	regimento VARCHAR(15) NULL,
	obs VARCHAR(100) NULL,
	logradouro VARCHAR(100) NULL,
	bairro VARCHAR(20) NULL,
	cidade VARCHAR(45) NULL,
	estado VARCHAR(20) NULL,
	numeroCasa INT NULL,
	cep VARCHAR(8) NULL,
	complementoEnd VARCHAR(100) NULL,
	idNivelAcesso INT FOREIGN KEY REFERENCES NivelAcesso(idNivelAcesso) NULL,
	idFunCad INT FOREIGN KEY REFERENCES Funcionario(idFuncionario) NULL
)
GO

CREATE TABLE Logs (
	idLog INT PRIMARY KEY IDENTITY NOT NULL,
	detalhe VARCHAR(200) NULL,
	dataUltAlt DATETIME NULL,
	areaAlt VARCHAR(45) NULL,
	idFuncionario INT FOREIGN KEY REFERENCES Funcionario(idFuncionario) NULL
)
GO

CREATE TABLE Fornecedor (
	idFornecedor INT PRIMARY KEY IDENTITY NOT NULL,
	razaoSocial VARCHAR(90) NULL,
	nomeFantasia VARCHAR(70) NULL,
	email VARCHAR(100) NULL,
	cnpj VARCHAR(18) UNIQUE NULL,
	ie VARCHAR(12) NULL,
	telefone VARCHAR(20) NULL,
	telefone2 VARCHAR(20) NULL,
	representante VARCHAR(45) NULL,
	observacao VARCHAR(100) NULL,
	dataCad DATE NULL,
	idEndereco INT FOREIGN KEY REFERENCES Endereco(idEndereco) NULL,
	idFunCad INT FOREIGN KEY REFERENCES Funcionario(idFuncionario) NULL
)
GO

CREATE TABLE Grupo (
	idGrupo INT PRIMARY KEY IDENTITY NOT NULL,
	nomeGrupo VARCHAR(45) NULL,
	descricao VARCHAR(200) NULL,
	observacao VARCHAR(100) NULL
)
GO

CREATE TABLE Subgrupo (
	idSubgrupo INT PRIMARY KEY IDENTITY NOT NULL,
	nomeSubgrupo VARCHAR(45) NULL,
	descricao VARCHAR(200) NULL,
	observacao VARCHAR(100) NULL,
	idGrupo INT FOREIGN KEY REFERENCES Grupo(idGrupo) NULL,
)
GO

CREATE TABLE Produto (
	idProduto INT PRIMARY KEY IDENTITY NOT NULL,
	nome VARCHAR(45) NULL,
	imagem NVARCHAR(200),
	precoCusto MONEY NULL,
	precoVenda MONEY NULL,
	descricao VARCHAR(200) NULL,
	descricaoRed VARCHAR(100) NULL,
	modelo VARCHAR(100) NULL,
	marca VARCHAR(100) NULL,
	sexo CHAR(1) NULL,
	dataCad DATE NULL,
	idSubgrupo INT FOREIGN KEY REFERENCES Subgrupo(idSubgrupo) NULL,
	idFunCad INT FOREIGN KEY REFERENCES Funcionario(idFuncionario) NULL
)
GO

CREATE TABLE Fornecedor_Produto (
	idFornecedor_Produto INT PRIMARY KEY IDENTITY NOT NULL,
	dataPedido DATE NULL,
	idFornecedor INT FOREIGN KEY REFERENCES Fornecedor(idFornecedor) NULL,
	idProduto INT FOREIGN KEY REFERENCES Produto(idProduto) NULL,
	detalhe VARCHAR(100) NULL
)
GO


CREATE TABLE Tamanho (
	idTamanho INT PRIMARY KEY IDENTITY,
	tamanho VARCHAR(10) NOT NULL,
	descricao VARCHAR(200) NULL
)
GO

CREATE TABLE Detalhe_Tamanho (
	idDetalhe_Tamanho INT PRIMARY KEY IDENTITY,
	quantidade INT NOT NULL,
	quantidadeMin INT NOT NULL,
	idTamanho INT FOREIGN KEY REFERENCES Tamanho(idTamanho) NOT NULL,
	idProduto INT FOREIGN KEY REFERENCES Produto(idProduto) NOT NULL
)
GO

CREATE TABLE ProdutoPersonalizado (
	idProdutoPersonalizado INT PRIMARY KEY IDENTITY,
	nome VARCHAR(45) NOT NULL,
	imagem NVARCHAR(250) NULL,
	imagemModelo NVARCHAR(250) NULL,
	alturaCm DECIMAL(10,2) NULL,
	larguraCm DECIMAL(10,2) NULL,
	hexaCor CHAR(6) NULL,
	dataCad DATE NULL,
	sexo CHAR(1) NOT NULL,
	precoCusto MONEY NULL,
	precoVenda MONEY NULL,
	idSubgrupo INT FOREIGN KEY REFERENCES Subgrupo(idSubgrupo) NOT NULL,
	idTamanho INT FOREIGN KEY REFERENCES Tamanho(idTamanho) NOT NULL,
	idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente) NOT NULL
)
GO

CREATE TABLE Detalhe_Pedido (
	idDetalhe_Pedido INT PRIMARY KEY IDENTITY NOT NULL,
	quantidade INT NULL,
	idProduto INT FOREIGN KEY REFERENCES Produto(idProduto) NULL,
	idPedido INT FOREIGN KEY REFERENCES Pedido(idPedido) NULL,
	idProdutoPersonalizado INT FOREIGN KEY REFERENCES ProdutoPersonalizado(idProdutoPersonalizado) NULL
)
GO

CREATE TABLE Anunciante (
	idAnunciante INT PRIMARY KEY IDENTITY,
	email VARCHAR(100) UNIQUE NOT NULL,
	senha VARCHAR(45) NOT NULL,
	nome VARCHAR(45) NOT NULL,
	sobrenome VARCHAR(200) NULL,
	sexo CHAR(1) NULL,
	cpf VARCHAR(11) UNIQUE NOT NULL,
	dataNasc DATE NULL,
	dataInscricao DATE NULL,
	telefone1 VARCHAR(20) NOT NULL,
	telefone2 VARCHAR(20) NULL,
	idEndereco INT FOREIGN KEY REFERENCES Endereco(idEndereco) NOT NULL
)
GO

CREATE TABLE TipoAnuncio (
	idTipoAnuncio INT PRIMARY KEY IDENTITY,
	nome VARCHAR(45) NOT NULL,
	descricao VARCHAR(200) NULL,
	custoClique MONEY NOT NULL
)
GO

CREATE TABLE Anuncio (
	idAnuncio INT PRIMARY KEY IDENTITY,
	nomeAnuncio VARCHAR(45) NOT NULL,
	nomeMarca VARCHAR(100) NOT NULL,
	linkSite NVARCHAR(150) NOT NULL,
	imagem NVARCHAR(200) NULL,
	titulo VARCHAR(45) NULL,
	subTitulo VARCHAR(100) NULL,
	texto VARCHAR(600) NULL,
	idTipoAnuncio INT FOREIGN KEY REFERENCES TipoAnuncio(idTipoAnuncio) NOT NULL,
	idAnunciante INT FOREIGN KEY REFERENCES Anunciante(idAnunciante) NOT NULL,
)
GO

CREATE TABLE StatusAnuncio (
	idStatusAnuncio INT PRIMARY KEY IDENTITY,
	nomeStatus VARCHAR(45) NOT NULL,
	descricao VARCHAR(300) NULL
)
GO

CREATE TABLE Detalhe_Anuncio (
	idDetalhe_Anuncio INT PRIMARY KEY IDENTITY,
	idAnuncio INT FOREIGN KEY REFERENCES Anuncio(idAnuncio) NOT NULL,
	dataPedido DATE NULL,
	dataValid DATE NULL,
	cliquesUteis INT NOT NULL,
	cliquesContados INT NOT NULL,
	custoTotal MONEY NOT NULL,
	idTipoPgto INT FOREIGN KEY REFERENCES TipoPgto(idTipoPgto) NOT NULL,
	idCartao INT FOREIGN KEY REFERENCES CartaoCredito(idCartao) NULL,
	idStatusAnuncio INT FOREIGN KEY REFERENCES StatusAnuncio(idStatusAnuncio) NOT NULL
)
GO

CREATE TABLE CarPublico (
	idCarPublico INT PRIMARY KEY IDENTITY,
	cookieValue VARCHAR(100) NOT NULL,
	dataValidade DATETIME NULL
)
GO

CREATE TABLE Detalhe_CarPublico (
	idDetalhe_CarPublico INT PRIMARY KEY IDENTITY,
	quantidade INT NOT NULL,
	idCarPublico INT FOREIGN KEY REFERENCES CarPublico(idCarPublico) NOT NULL,
	idProduto INT FOREIGN KEY REFERENCES Produto(idProduto) NOT NULL
)
GO

CREATE TABLE CarCliente (
	idCarCliente INT IDENTITY,
	idProduto INT FOREIGN KEY REFERENCES Produto(idProduto) NOT NULL,
	quantidade INT NOT NULL,
	idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente) NOT NULL,
)
GO

ALTER TABLE Detalhe_Pedido ADD IDTAMANHO INT FOREIGN KEY REFERENCES TAMANHO(iDtamanho)
GO

ALTER TABLE CarCliente ADD idTamanho INT FOREIGN KEY REFERENCES Tamanho(idTamanho)
GO

ALTER TABLE Detalhe_CarPublico ADD idTamanho INT FOREIGN KEY REFERENCES Tamanho(idTamanho)
GO


-- Criando indexes das tabelas

CREATE INDEX ixNivelAcesso ON NivelAcesso(idNivelAcesso) 
GO

CREATE INDEX ixLogs ON Logs(idLog) 
GO

CREATE INDEX ixFuncionario ON Funcionario(idFuncionario)
GO

CREATE INDEX ixEndereco ON Endereco(idEndereco) 
GO

CREATE INDEX ixFornecedor ON Fornecedor(idFornecedor) 
GO

CREATE INDEX ixGrupo ON Grupo(idGrupo) 
GO

CREATE INDEX ixSubgrupo ON Subgrupo(idSubgrupo) 
GO

CREATE INDEX ixProduto ON Produto(idProduto) 
GO

CREATE INDEX ixFornecedor_Produto ON Fornecedor_Produto(idFornecedor_Produto)
GO

CREATE INDEX ixCliente ON Cliente(idCliente) 
GO

CREATE INDEX ixEndereco_Cliente ON Endereco_Cliente(idEndereco_Cliente)
GO

CREATE INDEX ixPedido ON Pedido(idPedido)
GO

CREATE INDEX ixDetalhe_Pedido ON Detalhe_Pedido(idDetalhe_Pedido) 
GO

CREATE INDEX ixEnvio ON Envio(idEnvio)
GO

CREATE INDEX ixStatusPedido ON StatusPedido(idStatusPedido) 
GO

CREATE INDEX ixTipoPgto ON TipoPgto(idTipoPgto) 
GO

CREATE INDEX ixCartaoCredito ON CartaoCredito(idCartao)
GO

CREATE INDEX ixAnuncio ON Anuncio(idAnuncio)
GO

CREATE INDEX ixDetalhe_Anuncio ON Detalhe_Anuncio(idDetalhe_Anuncio)
GO

CREATE INDEX ixTipoAnuncio ON TipoAnuncio(idTipoAnuncio)
GO

CREATE INDEX ixAnunciante ON Anunciante(idAnunciante)
GO

CREATE INDEX ixStatusAnuncio ON StatusAnuncio(idStatusAnuncio)
GO

CREATE INDEX ixCarPublico ON CarPublico(idCarPublico)
GO

CREATE INDEX ixCarCliente ON CarCliente(idCarCliente)
GO

CREATE INDEX ixTamanho ON Tamanho(idTamanho)
GO

CREATE INDEX ixDetalhe_CarPublico ON Detalhe_CarPublico(idDetalhe_CarPublico)
GO

CREATE INDEX ixDetalhe_Tamanho ON Detalhe_Tamanho(idDetalhe_Tamanho)
GO

CREATE INDEX ixProdutoPersonalizado ON ProdutoPersonalizado(idProdutoPersonalizado)
GO

CREATE INDEX ixCodigoResgate ON CodigoResgate(idCodigoResgate)
GO

-- Adicionando registros globais
INSERT INTO TipoPgto VALUES
	('Boleto', null),
	('Cartão de Crédito', null),
	('Cartão de Débito', null),
	('Código de Resgate', null),
	('PayPal', null),
	('PagSeguro', null)
GO

INSERT INTO StatusPedido VALUES
	('Aguardando Pagamento', null),
	('Cancelado', null),
	('Pendente', null),
	('Empacotado', null),
	('Enviado', null),
	('Entregue', null),
	('Retornado', null)
GO

INSERT INTO NivelAcesso VALUES
	('Sem Acesso', 'Funcionário sem acesso ao Software da loja'),
	('Básico', 'Pode visualizar as telas de Acompanhamento de Pedido e Estoque (e exigir encomendas de estoque para fornecedores) + Telas de Visualização de Cadastros (Produtos, Fornecedores e Clientes).'),
	('Administrador', 'Tem acesso as mesmas telas dos funcionários de nível básico + telas de cadastro de Produto e Fornecedor) + Alteração dos Cadastros de Produtos, Fornecedores e Clientes + Acesso ao Software de Cadastro de Anunciantes e à todas as suas funcionalidades'),
	('Gerente', 'Tem acesso as mesmas telas dos funcionários de nível Administrador + Telas de cadastro de Funcionários + Tela de visualização/alteração de funcionários cadastrados.')
GO

INSERT INTO Grupo VALUES 
	('Indefinido', null, null),
	('Camisetas', null, null),
	('Moletons', null, null),
	('Calças', null, null),
	('Acessórios', null, null)
GO

INSERT INTO Subgrupo VALUES 
	('Indefinido', null, null, 1),
	('Manga Longa', null, null, 2),
	('Manga Curta', null, null, 2),
	('Com touca', null, null, 3),
	('Sem touca', null, null, 3),
	('Jeans', null, null, 4),
	('De moletom', null, null, 4),
	('Bonés', null, null, 5),
	('Pulseiras', null, null, 5)
GO

INSERT INTO StatusAnuncio VALUES
	('Ativo', null),
	('Expirado/Inativo', null),
	('Reprovado', null),
	('Em Análise', null),
	('Aguardando Pagamento', null),
	('Desabilitado', null)
GO

INSERT INTO TipoAnuncio VALUES 
	('Anúncio de Texto', 'Tipo de Anúncio onde toda a informação é transmitida através de texto, exibidos em uma páginas estabelecida apenas para estes.', 2.00),
	('Banner', 'Tipo de Anúncio onde seu banner é exibido em qualquer lugar do aplicativo, contendo uma imagem estática e um link atribuído', 3.00),
	('Pop-Up Estático', 'Tipo de Anúncio onde uma imagem surge na tela contendo seu anúncio, é exibido de 30 em 30 minutos, ficando por 5 segundos na tela, contém link atribuído', 4.00),
	('Pop-Up Vídeo', 'Tipo de Anúncio onde um vídeo de sua marca é exibido de 30 em 30 minutos na tela, onde o usuário é obrigado a assistir pelo menos 15 segundos do mesmo, contém link atribuído', 5.00)
GO

INSERT INTO Tamanho VALUES
	('PP', null),
	('P', null),
	('M', null),
	('G', null),
	('GG', null),
	('36', null),
	('37', null),
	('38', null),
	('39', null),
	('40', null),
	('41', null),
	('42', null),
	('43', null)
GO

INSERT INTO Endereco VALUES (null, null, null, null, null, null, null, null, null)
GO

-- Adicionando 'Gerente Raiz' (Primeiro funcionário que irá cadastrar os outros funcionários)

INSERT INTO Funcionario VALUES('12345678999', 'Gustavo', 'de Oliveira Soares Silva', 'M', 'gustavolive22@gmail.com', 'Dd123456', 'Gerente Raiz', '25-10-2018', null, 1500, null, null, null, null, null, null, null, null, null, 4, null)
GO

-- Adicionando outros Funcionários

INSERT INTO Funcionario VALUES('11122233300', 'Gustavo', 'de Oliveira Soares Silva', 'M', 'gustavolive24@gmail.com', 'Dd123456', 'Repositor de Estoque', '25-10-2018', null, 1500, null, null, null, null, null, null, null, null, null, 2, null)
GO

-- Adicionando Anunciantes

INSERT INTO Anunciante VALUES('anunciante1@gmail.com', 'Dd123456', 'anunciante1', 'anunciante', null, '12345678999', null, null, '11922334455', null, 1)
GO

--Adicionando Produtos


INSERT INTO Produto VALUES('Camiseta vaporwave branca', '..\dbProdutoImagens\camisaexemplo1.jpg' , 30.00, 50.00, 'Camiseta manga longa branca e estampada com video-game no meio', 'Camiseta branca manga longa', 'Padrao', 'AttariClothes', 'M', '17-06-2019', 2, null)
GO
INSERT INTO Produto VALUES('Camiseta vaporwave PSP', '..\dbProdutoImagens\camisaexemplo2.jpg' , 30.00, 55.00, 'Camiseta manga longa branca e estampada com PSP', 'Camiseta branca manga longa', 'Padrao', 'AttariClothes', 'U', '17-06-2019', 2, null)
GO
INSERT INTO Produto VALUES('Camiseta vaporwave milk', '..\dbProdutoImagens\camisaexemplo3.jpg' , 10.00, 30.00, 'Camiseta manga curta com caixa de leite estampada', 'Camiseta branca manga longa', 'Padrao', 'Vaporwear', 'F', '17-06-2019', 3, null)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 1, 1)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 2, 1)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 3, 1)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 2, 2)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 3, 2)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 4, 2)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 1, 2)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 1, 3)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 2, 3)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 3, 3)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 4, 3)
GO

INSERT INTO Detalhe_Tamanho VALUES(100, 20, 5, 3)
GO

-- As Incríveis Procedures:

CREATE PROCEDURE autenticarCliente 
	@emailCliente VARCHAR(12),
	@senhaCliente VARCHAR(20) 
	AS
		SELECT * FROM Cliente
			WHERE email = @emailCliente AND senha = @senhaCliente
GO

CREATE PROCEDURE autenticarFuncionario
	@cpfFuncionario VARCHAR(100),
	@senhaFuncionario VARCHAR(20)
	AS
		SELECT * FROM Funcionario
			WHERE cpf = @cpfFuncionario AND senha = @senhaFuncionario
GO

CREATE PROCEDURE autenticarAnunciante
	@cpfAnunciante VARCHAR(12),
	@senhaAnunciante VARCHAR(20)
	AS
		SELECT * FROM Anunciante 
			WHERE cpf = @cpfAnunciante AND senha = @senhaAnunciante
GO

CREATE PROCEDURE cadastrarEndereco
	@cep VARCHAR(8),
	@pais VARCHAR(20),
	@estado VARCHAR(20),
	@cidade VARCHAR(45),
	@bairro VARCHAR(45),
	@logradouro VARCHAR(100),
	@tipoLogradouro VARCHAR(45),
	@numero INT,
	@complementoEnd VARCHAR(100)
AS
	INSERT INTO Endereco VALUES (@cep, @pais, @estado, @cidade, @bairro, @logradouro, @tipoLogradouro, @numero, @complementoEnd)
GO

CREATE PROCEDURE cadastrarAnunciante
	@email VARCHAR(100),
	@senha VARCHAR(45),
	@nome VARCHAR(45),
	@sobrenome VARCHAR(200),
	@cpf VARCHAR(11),
	@dataNasc DATE,
	@telefone1 VARCHAR(20),
	@telefone2 VARCHAR(20),
	@cepAnunc VARCHAR(8),
	@paisAnunc VARCHAR(20),
	@estadoAnunc VARCHAR(20),
	@cidadeAnunc VARCHAR(45),
	@bairroAnunc VARCHAR(45),
	@logradouroAnunc VARCHAR(100),
	@numeroAnunc INT
	AS
		EXECUTE cadastrarEndereco @cepAnunc, @paisAnunc, @estadoAnunc, @cidadeAnunc, @bairroAnunc, @logradouroAnunc, null, @numeroAnunc, null
		DECLARE @idEndereco INT
		DECLARE @dataInscricao DATETIME
		SET @idEndereco = @@IDENTITY
		SET @dataInscricao = SYSDATETIME()
		INSERT INTO Anunciante VALUES (@email, @senha, @nome, @sobrenome, null, @cpf, @dataNasc, @dataInscricao, @telefone1, @telefone2, @idEndereco)
GO

CREATE PROCEDURE getNumAnuncios
	@idAnunciante INT
	AS
		SELECT COUNT(*) FROM Anuncio 
			WHERE idAnunciante = @idAnunciante 
GO

CREATE PROCEDURE getEspecNumAnuncios
	@idAnunciante INT,
	@statusAnuncio INT
	AS
		SELECT COUNT(*) FROM Detalhe_Anuncio 
			WHERE idStatusAnuncio = @statusAnuncio AND @idAnunciante IN 
			(SELECT idAnunciante FROM Anuncio WHERE Anuncio.idAnuncio = Detalhe_Anuncio.idAnuncio)
GO

CREATE PROCEDURE cadastrarAnuncio 
	--Anuncio:
	@nomeAnuncio VARCHAR(45),
	@nomeMarca VARCHAR(100),
	@linkSite NVARCHAR(150),
	@imagem NVARCHAR(200),
	@titulo VARCHAR(45),
	@subTitulo VARCHAR(100),
	@texto VARCHAR(300),
	@idTipoAnuncio INT,
	@idAnunciante INT,
	--Detalhe Anuncio
	@cliquesUteis INT,
	@custoTotal MONEY,
	@idTipoPgto INT,
	@idCartao INT
	AS
		INSERT INTO Anuncio VALUES (@nomeAnuncio, @nomeMarca, @linkSite, @imagem, @titulo, @subtitulo, @texto, @idTipoAnuncio, @idAnunciante)
		DECLARE @idAnuncio INT
		DECLARE @cliquesContados INT
		DECLARE @dataPedido DATE
		DECLARE @idStatusAnuncio INT 
		SET @idAnuncio = @@IDENTITY
		SET @cliquesContados = 0
		SET @dataPedido = GETDATE()
		SET @idStatusAnuncio = 4
		INSERT INTO Detalhe_Anuncio VALUES (@idAnuncio, @dataPedido, null, @cliquesUteis, @cliquesContados, @custoTotal,
											@idTipoPgto, @idCartao, @idStatusAnuncio)
GO

CREATE PROCEDURE getSubgrupoSexo
	@sexo char(1),
	@idGrupo INT
	AS
		SELECT idSubgrupo, nomeSubgrupo from Subgrupo
			WHERE idSubgrupo IN (SELECT idSubgrupo FROM Produto
				WHERE sexo = @sexo) AND idGrupo = @idGrupo
GO

CREATE PROCEDURE getGrupoSexo
	@sexo char(1)
	AS
		SELECT idGrupo, nomeGrupo FROM Grupo
			WHERE idGrupo IN (SELECT idGrupo FROM Subgrupo
				WHERE idSubgrupo IN (SELECT idSubgrupo FROM Produto 
					WHERE sexo = @sexo))
GO

CREATE PROCEDURE cadastraProdutoPersonalizado
	@nome VARCHAR(45),
	@imagem NVARCHAR(250),
	@imagemModelo NVARCHAR(250),
	@hexaCor CHAR(6),
	@sexo CHAR(1),
	@idSubgrupo INTEGER,
	@idCliente INTEGER
AS
	DECLARE @precoCusto MONEY
	DECLARE @precoVenda MONEY
	IF @idSubgrupo = 3
		BEGIN
			SET @precoCusto = 40
			SET @precoVenda = 60
		END
	ELSE IF @idSubgrupo = 4
		BEGIN
			SET @precoCusto = 90
			SET @precoVenda = 120
		END
	INSERT INTO ProdutoPersonalizado OUTPUT INSERTED.idProdutoPersonalizado VALUES (@nome, @imagem, @imagemModelo, 50, 50, @hexaCor, GETDATE(), @sexo, @precoCusto, @precoVenda, @idSubgrupo, 1, @idCliente)
	RETURN @@IDENTITY
GO

--Jobs

CREATE PROCEDURE deleteOldPedido AS
			DELETE FROM Pedido WHERE dataPedido <= DATEADD(MINUTE,-5,getdate()) 
GO

CREATE PROCEDURE deleteOldAnuncio AS
			DELETE FROM Detalhe_Anuncio 
				WHERE (idStatusAnuncio = 2 OR idStatusAnuncio = 3) 
				AND dataValid <= DATEADD(MINUTE,-5,getdate()) 
GO