----------------------------------------------------------------------------------
-- Cria��o do banco de dados.
-----------------------------------------------------------------------------------

USE master;
GO
CREATE DATABASE [CandyShop_Edgard];
GO
USE [CandyShop_Edgard];
GO
SET LANGUAGE 'Brazilian';
GO
-----------------------------------------------------------------------------------
-- Cria��o dos esquemas.
-----------------------------------------------------------------------------------

CREATE SCHEMA [Comercial]
AUTHORIZATION dbo;
GO

CREATE SCHEMA RecursosHumanos
AUTHORIZATION dbo;
GO

CREATE SCHEMA [Auxiliar]
AUTHORIZATION dbo;
GO

-----------------------------------------------------------------------------------
-- Cria��o das tabelas.
-----------------------------------------------------------------------------------

CREATE TABLE [Comercial].[TipoProduto] (
	[Id_TipoProduto] INT PRIMARY KEY IDENTITY(1,1),
	[Nome_TipoProduto] VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE [Comercial].[Marca] (
	[Id_Marcas] INT PRIMARY KEY IDENTITY(1,1),
	[Nome_Marca] VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE [RecursosHumanos].[Cargos] (
	[Id_Cargo] INT PRIMARY KEY IDENTITY(1,1),
	[Nome_Cargo] VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE [Comercial].[Clientes] (
	[Id_Cliente] INT PRIMARY KEY IDENTITY(1,1),
	[Nome_Cliente] VARCHAR(50) NOT NULL,
	[Ind_Sexo] INT NOT NULL, -- 1 = Masculino / 2 = Feminino
	[Data_Nascimento] VARCHAR(MAX),
	[Ind_Ativo] INT NOT NULL -- 0 = Inativo / 1 = Ativo
);
GO

CREATE TABLE [Comercial].[Produto] (
	[Id_Produto] INT PRIMARY KEY IDENTITY(1,1),
	[Id_TipoProduto] INT FOREIGN KEY REFERENCES [Comercial].[TipoProduto](Id_TipoProduto),
	[Id_Marca] INT FOREIGN KEY REFERENCES [Comercial].[Marca](Id_Marcas),
	[Nome_Produto] VARCHAR(MAX) NOT NULL,
	[Vlr_Compra] DECIMAL(4,2),
	[Vlr_Venda] DECIMAL(4,2),
	[Qtde_Estoque] INT,
	[Vlr_MaxDesconto] INT
);
GO

CREATE TABLE [RecursosHumanos].[Funcionarios] (
	[Id_Funcionario] INT PRIMARY KEY IDENTITY(1,1),
	[Nome_Funcionario] VARCHAR(50) NOT NULL,
	[Data_Nascimento] VARCHAR(MAX),
	[Id_Cargo] INT FOREIGN KEY REFERENCES [RecursosHumanos].[Cargos](Id_Cargo) NOT NULL,
	[Vlr_Salario] DECIMAL(7,2) NOT NULL,
	[Vlr_Comissao] INT,
	[Data_Admissao] VARCHAR(MAX),
	[Data_Demissao] VARCHAR(MAX),
	[Ind_Ativo] INT CHECK(Ind_Ativo = 1 OR Ind_Ativo = 0) NOT NULL --0 = Inativo / 1 = Ativo
);
GO

CREATE TABLE [Comercial].[Venda] (
	[Id_Venda] INT PRIMARY KEY IDENTITY(1,1),
	[Id_Cliente] INT FOREIGN KEY REFERENCES [Comercial].[Clientes](Id_Cliente),
	[Id_Vendedor] INT FOREIGN KEY REFERENCES [RecursosHumanos].[Funcionarios](Id_Funcionario),
	[Data_Venda] VARCHAR(MAX),
	[Data_Pagamento] VARCHAR(MAX)
);
GO

CREATE TABLE [Comercial].[VendaItem] (
	[Id_VendaItem] INT PRIMARY KEY IDENTITY(1,1),
	[Id_Venda] INT FOREIGN KEY REFERENCES [Comercial].[Venda](Id_Venda),
	[Id_Produto] INT FOREIGN KEY REFERENCES [Comercial].[Produto](Id_Produto),
	[Qtd_Vendida] INT NOT NULL,
	[Vlr_DescontoConcedido] INT --O valor m�ximo vai ser o valor que estiver na coluna Vlr_MaxDesconto da tabela Produto
);
GO

CREATE TABLE [Auxiliar].[Nomes] (
	[Id_Nome] INT PRIMARY KEY IDENTITY(1,1),
	[Nome] VARCHAR(30)
);
GO

----------------------------------------------------------------------------------------------------------
-- Inser��o manual de dados nas tabelas Comercial.TipoProduto, Comercial.Marca e RecursosHumanos.Cargos.
----------------------------------------------------------------------------------------------------------
SET NOCOUNT ON;
INSERT INTO [Comercial].[TipoProduto]
VALUES
('Goma de mascar'),
('Chocolate'),
('Marshmallow'),
('Paçoca'),
('Doce de leite'),
('Pipoca'),
('Sorvete'),
('Pirulito'),
('Bala'),
('Geléia'),
('Cupcake'),
('Bem casado'),
('Macaron'),
('Pão de mel'),
('Gelatina'),
('Bala de coco'),
('Cookie'),
('Refrigerante'),
('Picolé'),
('Pé-de-moleque')
SET NOCOUNT ON;
GO

SET NOCOUNT ON;

INSERT INTO [Comercial].[Marca]
VALUES
('Bubbaloo'),
('Trident'),
('Mentos'),
('Chiclets'),
('Hershey''s'),
('M&M''s'),
('Milka'),
('Ferrero Rocher'),
('Cacau Show'),
('Nestlé'),
('Garoto'),
('Fini'),
('MaxMallows'),
('Paçoquita'),
('Reserva de Minas'),
('Aviação'),
('Rocca'),
('Sabores do Grama'),
('Magnum'),
('Cornetto')
GO

SET NOCOUNT ON;

INSERT INTO [RecursosHumanos].[Cargos]
VALUES
('Gerente de contabilidade'),
('Agente de vendas assistente'),
('Assistente de representante de vendas'),
('Assistente de marketing'),
('Administrador de pedidos'),
('Proprietário'),
('Proprietário/Assistente de marketing'),
('Agente de vendas'),
('Assistente de vendas'),
('Gerente de vendas'),
('Representante de vendas')

GO

------------------------------------------------------------------------------------------------------------
-- Retornar "Masculino" para Ind_Sexo 1 e "Feminino" para Ind_Sexo 2. Ambos status se referem aos clientes.
------------------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[FNC_RetornaSexo] (@Ind_Sexo INT)
RETURNS VARCHAR(9)
AS
BEGIN
	DECLARE @sexoCliente AS VARCHAR(9)
	IF @Ind_Sexo = 1
		BEGIN
			SET @sexoCliente = 'Masculino'
		END
	ELSE
		BEGIN
			SET @sexoCliente = 'Feminino'
		END
	RETURN @sexoCliente
END
GO

------------------------------------------------------------------------------------------------------------
--  Retornar "Ativo" para Ind_Status 1 e "Inativo" para Ind_Status 0. Ambos status se referem aos clientes.
------------------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[FNC_RetornaStatus] (@Ind_Ativo INT)
RETURNS VARCHAR(7)
AS
BEGIN
	DECLARE @statusCliente AS VARCHAR(7)
	IF @Ind_Ativo = 0
		BEGIN
			SET @statusCliente = 'Inativo'
		END
	ELSE
		BEGIN
			SET @statusCliente = 'Ativo'
		END
	RETURN @statusCliente
END
GO

--------------------------------------------------------------------------------------------------------------------------
--  Retornar valor m�ximo de desconto permitido para determinado produto. Essa fun��o deve ser usada na tabela VendaItem.
--------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].[FNC_PermissaoDesconto] (@idProduto INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT [Vlr_MaxDesconto] FROM [Comercial].[Produto] WHERE [Id_Produto] = @idProduto);
END;
GO

-----------------------------------------------------------
-- Inserir dinamicamente produtos ao executar a procedure.
-----------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InserirProdutos](@num INT)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @randIdTipoProduto INT,
			@nmTipoProduto VARCHAR(20),
			@randIdMarca INT,
			@nmMarca VARCHAR(15),
			@nmProduto VARCHAR(30),
			@randVlrCompra DECIMAL(4,2),
			@randVlrVenda DECIMAL(4,2),
			@randQtdeEstoque INT,
			@randVlrMaxDesconto INT,
			@i INT = 1;

	WHILE @i <= @num
		BEGIN
			SET @randIdTipoProduto = FLOOR(RAND()*((SELECT MAX([Id_TipoProduto]) FROM [Comercial].[TipoProduto])-(SELECT MIN([Id_TipoProduto]) FROM [Comercial].[TipoProduto])+1)+1);
			SET @randIdMarca = FLOOR(RAND()*((SELECT MAX([Id_Marcas]) FROM [Comercial].[Marca])-(SELECT MIN([Id_Marcas]) FROM [Comercial].[Marca])+1)+1);
			SET @nmTipoProduto = (SELECT Nome_TipoProduto FROM [Comercial].[TipoProduto] WHERE Id_TipoProduto = @randIdTipoProduto);
			SET @nmMarca = (SELECT Nome_Marca FROM [Comercial].[Marca] WHERE Id_Marcas = @randIdMarca);
			SET @nmProduto = CONCAT(@nmTipoProduto, ' ', @nmMarca);
			SET @randVlrCompra = RAND()*(10-1+1)+1;
			SET @randVlrVenda = RAND()*(10-@randVlrCompra+1)+@randVlrCompra;
			SET @randQtdeEstoque = FLOOR(RAND()*(100-0+1)+0);
			SET @randVlrMaxDesconto = FLOOR(RAND()*(50-0+1)+0);

			INSERT INTO [Comercial].[Produto]
			(Id_TipoProduto, Id_Marca, Nome_Produto, Vlr_Compra, Vlr_Venda, Qtde_Estoque, Vlr_MaxDesconto)
			VALUES
			(@randIdTipoProduto, @randIdMarca, @nmProduto, @randVlrCompra, @randVlrVenda, @randQtdeEstoque, @randVlrMaxDesconto);

			SET @i = @i + 1;
		END;
END;
GO

-------------------------------------------------------------------------------------------------
-- Separarar os nomes de seus sobrenomes da tabela [Sales].[Customers] ao executar a procedure
-------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[listNomes]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @string VARCHAR(30),
			@sobrenome VARCHAR(14),
			@nome VARCHAR(14),
			@maxLinhas INT = (SELECT COUNT(*) FROM [TSQLV4].[Sales].[Customers]),
			@i INT = 1;

	WHILE @i <= @maxLinhas
		BEGIN
			SET @string = (SELECT contactname FROM [TSQLV4].[Sales].[Customers] WHERE custid = @i);
			SET @sobrenome = (SELECT REPLACE((SELECT SUBSTRING(@string, 1, CHARINDEX(',', @string))), ',', ''));
			SET @nome = (SELECT REPLACE((SELECT SUBSTRING(@string, CHARINDEX(',', @string), LEN(@string))), ', ', ''));

			INSERT INTO [CandyShop_Edgard].[Auxiliar].[Nomes]
			VALUES (@nome), (@sobrenome);

			SET @i = @i + 1;
		END;
END;
GO

EXEC [dbo].[listNomes];
GO

----------------------------------------------------------
-- Inserir dinamicamente clientes ao executar a procedure.
-- Par�metro: Quantidade de Clientes (a serem inseridos)
----------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InserirClientes] (@num INT)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @i INT = 1;
	WHILE @i <= @num
		BEGIN
		/* Random de nomes de clientes. */
		DECLARE @idNome INT,
				@nmNome VARCHAR(20),
				@idSobrenome INT,
				@nmSobrenome VARCHAR(20),
				@nmCliente VARCHAR(20);

		SET @idNome = FLOOR(RAND()*((SELECT MAX([Id_Nome]) FROM [Auxiliar].[Nomes])-(SELECT MIN(Id_Nome) FROM [Auxiliar].[Nomes])+1)+1);
		SET @nmNome = (SELECT [Nome] FROM [Auxiliar].[Nomes] WHERE [Id_Nome] = @idNome);
		SET @idSobrenome = FLOOR(RAND()*((SELECT MAX([Id_Nome]) FROM [Auxiliar].[Nomes])-(SELECT MIN(Id_Nome) FROM [Auxiliar].[Nomes])+1)+1);
		SET @nmSobrenome = (SELECT [Nome] FROM [Auxiliar].[Nomes] WHERE [Id_Nome] = @idSobrenome);
		SET @nmCliente = CONCAT(@nmNome, ' ', @nmSobrenome);

		/* Random de sexo de clientes. */
		DECLARE @idRandSexo CHAR(1) = FLOOR(RAND()*(2-1+1)+1); -- Fun��o random entre 1 (masculino) ou 2 (feminino).

		/* Random de datas de nascimento com idade m�nima de 18 e m�xima de 100. */
		DECLARE @dataInicio DATE,
				@dataFinal DATE,
				@nascimentoCliente VARCHAR(MAX);
	
		SET @dataInicio = DATEADD(YEAR, -100, GETDATE()); -- Idade m�xima de 100 anos.
		SET @dataFinal = DATEADD(YEAR, -18, GETDATE()); -- Idade m�nima de 18 anos.
		SET @nascimentoCliente = CONVERT(VARCHAR(MAX), (DATEADD(DAY, RAND()*DATEDIFF(DAY, @dataInicio, @dataFinal), @dataInicio)),  103); -- Random e convers�o de formato de data.

		/* Random do status do cliente (ativo/inativo) */
		DECLARE @idRandStatus CHAR(1) = FLOOR(RAND()*(1-0+1)+0); -- Fun��o random entre 1 (ativo) ou 0 (inativo).

		/* Inser��o dos dados. */
		INSERT INTO [Comercial].[Clientes]
		([Nome_Cliente], [Ind_Sexo], [Data_Nascimento], [Ind_Ativo])
		VALUES
		(@nmCliente, @idRandSexo, @nascimentoCliente, @idRandStatus);

		SET @i = @i + 1;
		END;
END;
GO

-----------------------------------------------------------------------------------
-- Inserir dinamicamente funcion�rios ao executar a procedure.
-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InserirFuncionarios] (@num INT)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idNome INT,
			@nmNome VARCHAR(20),
			@idSobrenome INT, 
			@nmSobrenome VARCHAR(20),
			@nmFuncionario VARCHAR(20),
			@nascimentoFuncionario VARCHAR(MAX),
			@dataInicio DATE,
			@dataFinal DATE,
			@comissao INT,
			@i INT = 1;

	WHILE @i <= @num
	BEGIN	
			/* Random de nome(s) de funcion�rio(s) */
			SET @idNome = FLOOR(RAND()*((SELECT MAX([Id_Nome]) FROM [Auxiliar].[Nomes]) - (SELECT MIN(Id_Nome) FROM [Auxiliar].[Nomes]) +1) +1);
			SET @nmNome = (SELECT [Nome] FROM [Auxiliar].[Nomes] WHERE [Id_Nome] = @idNome);
			SET @idSobrenome = FLOOR(RAND()*((SELECT MAX([Id_Nome]) FROM [Auxiliar].[Nomes]) - (SELECT MIN(Id_Nome) FROM [Auxiliar].[Nomes]) +1) +1);
			SET @nmSobrenome = (SELECT [Nome] FROM [Auxiliar].[Nomes] WHERE [Id_Nome] = @idSobrenome);
			SET @nmFuncionario = CONCAT(@nmNome, ' ', @nmSobrenome);


			/* Random de data(s) de nascimento de funcion�rio(s). */
			SET @dataInicio = DATEADD(YEAR, -100, GETDATE()); -- Idade m�xima de 100 anos.
			SET @dataFinal = DATEADD(YEAR, -18, GETDATE()); -- Idade m�nima de 18 anos.
			SET @nascimentoFuncionario = CONVERT(VARCHAR(MAX), (DATEADD(DAY, RAND()*DATEDIFF(DAY, @dataInicio, @dataFinal), @dataInicio)),  103); -- Random e convers�o de formato de data.

			/* Random Cargo */
			DECLARE @idCargo INT;
			SET @idCargo = FLOOR(RAND()*((SELECT MAX([Id_Cargo]) FROM [RecursosHumanos].[Cargos]) - (SELECT MIN([Id_Cargo]) FROM [RecursosHumanos].[Cargos])+1)+1);

			/* Random valor sal�rio */
			DECLARE @salario DECIMAL(7,2);

			SET @salario = RAND()*(10000 - 1000 + 1) + 1;

			/* Valor da comissão */
			SET @comissao = FLOOR(RAND()*(15 - 1  + 1) + 1);

			/* Random Ind_Ativo */
			DECLARE @idRandStatus INT;
			SET @idRandStatus = FLOOR(RAND()*(1-0+1)+0); -- Fun��o random entre 1 (ativo) ou 0 (inativo).

			/* Random de data de admiss�o/demiss�o */
			DECLARE @dataAdmissao VARCHAR(MAX),
					@dataDemissao VARCHAR (MAX),
					@indStatus INT;

			
			SET @dataInicio = DATEADD(YEAR, 18, @nascimentoFuncionario); --Garantir que @dataAdmiss�o >= @DataNascimento + 18.
			SET @dataFinal = GETDATE(); -- At� data atual.
			SET @dataAdmissao = CONVERT(VARCHAR(MAX), (DATEADD(DAY, RAND()*DATEDIFF(DAY, @nascimentoFuncionario, @dataFinal), @nascimentoFuncionario)),  103);

			SET @indStatus = FLOOR(RAND()*(1 - 0 + 1 ) + 0);

			IF @indStatus = 1
			BEGIN
				SET @dataDemissao = CONVERT(VARCHAR(MAX), (DATEADD(DAY, RAND()*DATEDIFF(DAY, @dataAdmissao, @dataFinal), @dataAdmissao)),  103);
			END;
			ELSE
			BEGIN
				SET @dataDemissao = NULL;
			END;

			INSERT INTO [RecursosHumanos].[Funcionarios]
			VALUES
			(@nmFuncionario, @nascimentoFuncionario, @idCargo, @salario, @comissao, @dataAdmissao, @dataDemissao, @idRandStatus);

			SET @i = @i + 1;
		END;
END;
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inserir dinamicamente vendas ao executar a procedure. A quantidade de itens da venda deve ser randomizada, podendo variar de 1 a 10 itens por venda.
-----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InserirVendas] (@num INT)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idVenda INT,
		@idProduto INT,
		@qtdVendida INT,
		@vlrDesconto INT,
		@idCliente INT,
		@dataVenda VARCHAR(MAX),
		@idVendedor INT,
		@dataPagamento VARCHAR(MAX),
		@dataInicio DATE,
		@dataFinal DATE,
        @i INT = 1;

	WHILE @i <= @num
	BEGIN
		SET @idCliente = FLOOR(RAND()*((SELECT MAX([Id_Cliente]) FROM [Comercial].[Clientes]) - (SELECT MIN([Id_Cliente]) FROM [Comercial].[Clientes]) - 1) + 1) + 1;
		SET @idVendedor = FLOOR(RAND()*((SELECT MAX([Id_Funcionario]) FROM [RecursosHumanos].[Funcionarios] WHERE [Ind_Ativo] = 1 AND [Id_Cargo] IN (2, 8, 9)) - (SELECT MIN([Id_Funcionario]) FROM [RecursosHumanos].[Funcionarios] WHERE [Ind_Ativo] = 1 AND [Id_Cargo] IN (2, 8, 9)) - 1) + 1) + 1;

		SET @dataInicio = DATEADD(YEAR, -50, GETDATE());
		SET @dataFinal = GETDATE();
		SET @dataVenda = CONVERT(VARCHAR, (DATEADD(DAY, RAND()*DATEDIFF(DAY, @dataInicio, @dataFinal), @dataInicio)),  103); -- Random e convers�o de formato de data.

		SET @dataPagamento = CONVERT(VARCHAR, (DATEADD(DAY, RAND()*DATEDIFF(DAY, @dataVenda, @dataFinal), @dataVenda)),  103);

        INSERT INTO [Comercial].[Venda]
		VALUES
		(@idCliente, @idVendedor, @dataVenda, @dataPagamento);

        SET @i = @i + 1;
	END;

	SET @i = 1;

	WHILE @i <= @num
	BEGIN
        SET @idVenda = FLOOR(RAND()*((SELECT MAX([Id_Venda]) FROM [Comercial].[Venda]) - (SELECT MIN([Id_Venda]) FROM [Comercial].[Venda]) +1) +1);
		SET @idProduto = FLOOR(RAND()*((SELECT MAX([Id_Produto]) FROM [Comercial].[Produto]) - (SELECT MIN([Id_Produto]) FROM [Comercial].[Produto])+1)+1);
		SET @qtdVendida = FLOOR(RAND()*(10 - 0 + 1) + 0);
		SET @vlrDesconto = FLOOR(RAND()*((SELECT MAX([Vlr_MaxDesconto]) FROM [Comercial].[Produto] WHERE Id_Produto = @idProduto) - 1) + 1) + 1;

		INSERT INTO [Comercial].[VendaItem]
		VALUES
		(@idVenda, @idProduto, @qtdVendida, @vlrDesconto);

		SET @i = @i + 1;
	END;
END;
GO

--------------------------------------------------------------------------------------------------------------------------------
-- Criar uma trigger que, ao se preencher uma data na coluna Data_Demissão, o valor da coluna Ind_Ativo será alterado para 0
-----------------------------------------------------------------------------------------------------------------------------

CREATE TRIGGER [RecursosHumanos].[TRG_AlteraStatusFuncionario]
ON [RecursosHumanos].[Funcionarios]
FOR INSERT
AS
BEGIN
	UPDATE [RecursosHumanos].[Funcionarios]
	SET [Ind_Ativo] = 0
	WHERE [Data_Demissao] IS NULL;
END;
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Criar uma view que retorne o Id_Produto, Nome_TipoProduto, Nome_Marca, Nome_Produto, Vlr_Compra, Vlr_Venda, Vlr_MargemLucro, Qtd_Estoque, Vlr_VendaEstoque, Vlr_MaxDesconto.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW [dbo].[VW_CaracteristicasGeraisProdutos]
AS
SELECT Id_Produto AS [Id (Produto)],
       Nome_TipoProduto AS [Tipo de produto],
	   Nome_Marca AS [Marca],
	   Nome_Produto AS [Nome do produto],
	   Vlr_Compra AS [Valor da compra],
       Vlr_Venda AS [Valor da venda],
	   Vlr_Venda - Vlr_Compra AS [Margem de lucro],
       Qtde_Estoque AS [Em estoque],
	   Qtde_Estoque * Qtde_Estoque AS [Valor (estoque)],
	   Vlr_MaxDesconto
FROM [Comercial].[Produto]
INNER JOIN [Comercial].[TipoProduto] ON [Comercial].[Produto].[Id_TipoProduto] = [Comercial].[TipoProduto].[Id_TipoProduto]
INNER JOIN [Comercial].[Marca] ON [Comercial].[Produto].[Id_Marca] = [Comercial].[Marca].[Id_Marcas];
GO

----------------------------------------------------------------------------------------------------------------------
-- Criar uma view que irá listar o Nome_Produto, Nome_Marca, Vlr_Venda, Nome_TipoProduto, Vlr_Compra e Qtd_Estoque.
----------------------------------------------------------------------------------------------------------------------

CREATE VIEW [dbo].[VW_CaracteristicasEspecificasProdutos]
AS
SELECT Nome_Produto AS [Nome (Produto)],
       Nome_Marca AS [Nome (Marca)],
	   Vlr_Venda AS [Valor (Venda)],
	   Nome_TipoProduto AS [Tipo de produto],
	   Vlr_Compra AS [Valor (Compra)],
	   Qtde_Estoque AS [Em estoque]
FROM [Comercial].[Produto]
INNER JOIN [Comercial].[Marca] ON [Comercial].[Produto].[Id_Marca] = [Comercial].[Marca].[Id_Marcas]
INNER JOIN [Comercial].[TipoProduto] ON [Comercial].[Produto].[Id_TipoProduto] = [Comercial].[TipoProduto].[Id_TipoProduto];
GO
------------------------------------------------------------------------------------------------------
-- Listar o Nome_Produto, Nome_Marca e Qtd_Estoque de todos os produtos do Id_TipoProduto informado.
----------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarQuantidadeEstoquePorProduto] (@id INT)
AS
BEGIN
	SELECT Nome_Produto,
	       Nome_Marca,
		   Qtde_Estoque
	FROM [Comercial].[Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Produto].[Id_Marca] = [Comercial].[Marca].[Id_Marcas]
	WHERE Id_Produto = @id;
END;
GO

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente e Ind_Sexo (Utilizar função) de todos os clientes que fazem aniversário no mês indicado. Retornar apenas clientes com status ativo.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ListarAniversarioClientesPorMes]
AS
BEGIN
	DECLARE @num VARCHAR(MAX) = '02';
	SELECT Nome_Cliente,
	       Ind_Sexo,
		   Data_Nascimento
	FROM [Comercial].[Clientes]
	WHERE Data_Nascimento LIKE CONCAT('___', @num, '%');
END;
GO

-----------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente, Ind_Sexo (Utilizar função) e Data_Nascimento de todos os clientes ativos.
-----------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarClientesAtivos]
AS
BEGIN
	SELECT Nome_Cliente AS [Nome],
	       [dbo].FNC_RetornaSexo (Ind_Sexo) AS [Sexo],
		   Data_Nascimento AS [Data de nascimento]
	FROM [Comercial].[Clientes]
	WHERE Ind_Ativo = 1;
END;
GO

---------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Marca, Qtd_Estoque, Qtd_Vendida, Data_UltimaVenda dos produtos da Id_Marca informada no parâmetro.
----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ListarEstoqueVendaPorMarca] (@id INT)
AS
BEGIN
	SELECT [Nome_Marca], SUM(Qtde_Estoque), SUM(Qtd_Vendida), CONVERT(VARCHAR, MAX(Data_Venda), 103)
	FROM [Comercial].[Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Produto].[Id_Marca] = [Comercial].[Marca].[Id_Marcas]
	INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[VendaItem].[Id_Venda] = [Comercial].[Venda].[Id_Venda]
	WHERE [Id_Marcas] = @id
    GROUP BY [Nome_Marca]
END;
GO

------------------------------------------
-- Listar o Nome_Produto e Qtd_Vendida.
-----------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarVendasProdutosPorMesPorAno] (@mes VARCHAR(2), @ano VARCHAR (4))
AS
BEGIN
	SELECT Nome_Produto AS [Nome], SUM([Qtd_Vendida]) AS [Quantidade vendida]
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[VendaItem].[Id_Produto] = [Comercial].[Produto].[Id_Produto]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[VendaItem].[Id_VendaItem] = [Comercial].[Venda].[Id_Venda]
	WHERE [Data_Venda] LIKE CONCAT('___', @mes, '_', @ano)
	GROUP BY Nome_Produto;
END;
GO

----------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente, Ind_Sexo (Utilizar função) e Ind_Status (Utilizar função) de todos os clientes que não compraram.
----------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[USP_ListarClientesSemCompra]
AS
BEGIN
	SELECT [Comercial].[Clientes].[Nome_Cliente] AS [Nome],
		   [dbo].[FNC_RetornaSexo]([Ind_Sexo]) AS [Sexo],
           [dbo].[FNC_RetornaStatus]([Ind_Ativo]) AS [Status]
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[VendaItem].[Id_Venda] = [Comercial].[Venda].[Id_Venda]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Venda].[Id_Cliente] = [Comercial].[Clientes].[Id_Cliente]
	WHERE [Qtd_Vendida] = 0
END;
GO

-----------------------------------------------------------------------------
-- Listar o Id_Venda, Nome_Cliente, Data_Venda, Data_Pagamento e Vlr_Venda.
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarVendasPorMesPorAno] (@mes VARCHAR(2), @ano VARCHAR (4))
AS
BEGIN
	SELECT [Comercial].[Venda].[Id_Venda],
	       [Nome_Cliente],
		   [Data_Venda],
           [Data_Pagamento],
		   [Comercial].[Produto].[Vlr_Venda] * [Qtd_Vendida] AS [Valor da venda]
	FROM [Comercial].[Venda]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Venda].[Id_Cliente] = [Comercial].[Clientes].[Id_Cliente]
	INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Cliente] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[VendaItem].[Id_Produto] = [Comercial].[Produto].[Id_Produto]
	WHERE Data_Venda LIKE CONCAT('___', @mes, '_', @ano);
END;
GO

--------------------------------------------------------
-- Listar o Nome_Cliente, Qtd_Compras e o Vlr_Compras.
--------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarComprasPorCliente] (@mes VARCHAR(2), @ano VARCHAR(4))
AS
BEGIN
	SELECT [Nome_Cliente],
	       COUNT([Comercial].[Venda].[Id_Venda]) AS [Compras],
		   SUM([Comercial].[Produto].[Vlr_Venda] * [Qtd_Vendida]) AS [Valor]
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[VendaItem].[Id_Venda] = [Comercial].[Venda].[Id_Venda]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Venda].[Id_Cliente] = [Comercial].[Clientes].[Id_Cliente]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[VendaItem].[Id_Produto] = [Comercial].[Produto].[Id_Produto]
	WHERE Data_Venda LIKE CONCAT('___', @mes, '_', @ano)
	GROUP BY [Nome_Cliente];
END;
GO

-----------------------------------------------------------------------------------------
-- Listar o Nome_Produto que contenham uma parte ou toda a palavra passada no parâmetro.
-----------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarNomeProdutos] (@texto VARCHAR(MAX))
AS
BEGIN
	SELECT [Nome_Produto]
	FROM [Comercial].[Produto]
	WHERE [Nome_Produto] LIKE CONCAT('%', @texto, '%');
END;
GO

-------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Produto, Nome_Marca, Vlr_Compra, Vlr_Venda, Qtd_Estoque, Qtd_Vendida e Vlr_TotalVendido dos produtos mais vendidos.
-------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ListarProdutosMaisVendidos] (@num INT)
AS
BEGIN
	SELECT TOP(@num) [Comercial].[Produto].[Nome_Produto],
		   [Comercial].[Marca].[Nome_Marca],
		   [Comercial].[Produto].[Vlr_Compra],
		   [Comercial].[Produto].[Vlr_Venda],
		   [Comercial].[Produto].[Qtde_Estoque],
		   [Comercial].[VendaItem].[Qtd_Vendida],
		   [Comercial].[Produto].[Vlr_Venda] * [Comercial].[VendaItem].[Qtd_Vendida]
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	ORDER BY [Comercial].[VendaItem].[Qtd_Vendida] DESC;
END;
GO

-------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente, Ind_Sexo (Utilizar função), Data_Nascimento e Qtd_Comprada e Vlr_TotalComprado (somente paga).
-------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarMaioresCompradores] (@num INT)
AS
BEGIN
	SELECT TOP (@num) [Comercial].[Clientes].[Nome_Cliente] AS [Nome],
	       [dbo].[FNC_RetornaSexo]([Ind_Sexo]) AS [Sexo],
           [Comercial].[Clientes].[Data_Nascimento] AS [Data de nascimento],
		   SUM([Qtd_Vendida]) AS [Quantidade vendida],
		   SUM([Vlr_Venda]) AS [Valor total de vendas]
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	GROUP BY [Comercial].[Clientes].[Nome_Cliente], [Ind_Sexo], [Data_Nascimento]
	ORDER BY [Valor total de vendas] DESC;
END;
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente, Ind_Sexo (Utilizar função) e Media_Tempo (minutos, horas ou dias que ele demora para pagar). Retornar clientes que pagam mais rápido.
----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ListarMelhoresPagadores] (@num INT)
AS
BEGIN
	 SELECT TOP (@num) [Nome_Cliente] AS [Nome],
	            [dbo].[FNC_RetornaSexo](Ind_Sexo) AS [Sexo],
				[Data_Venda] AS [Data de venda],
				[Data_Pagamento] AS [Data de pagamento],
				ABS(DATEDIFF(DAY, Data_Pagamento, Data_Venda)) AS [Dias até pagamento]
	 FROM [Comercial].[Venda]
	 INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	 ORDER BY [Dias até pagamento];
 END;
 GO

---------------------------------------------------------------------------------------------------------
-- Listar o nome do produto, marca e porcentagem dos clientes ativos que compraram o produto em questão.
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_PorcentagemComprasPorProdutos]
AS
BEGIN
	DECLARE @clientesAtivos INT;
	SET @clientesAtivos= (SELECT COUNT(*) FROM [Comercial].[Clientes] WHERE [Ind_Ativo] = 1);

	SELECT [Nome_Produto],
		   [Comercial].[Marca].[Nome_Marca],
		   CAST(((CAST(COUNT([Comercial].[Venda].[Id_Cliente]) AS DECIMAL) / 100) * @clientesAtivos) AS DECIMAL(4,2)) AS [Porcentagem de clientes]
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	WHERE [Comercial].[Clientes].[Ind_Ativo] = 1 --Clientes ativos
	GROUP BY [Nome_Produto], [Comercial].[Marca].[Nome_Marca]
END;
GO

-----------------------------------------------------------------------------------------------------
-- Listar o Nome_Produto, Nome_Marca, Vlr_Venda, Vlr_Compra, Nome_UltimoComprador e Data_UltimaVenda
-----------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarProdutosVendas]
AS
BEGIN

	SELECT [Comercial].[Produto].[Nome_Produto],
           [Comercial].[Marca].[Nome_Marca],
           [Comercial].[Produto].[Vlr_Venda],
           [Comercial].[Produto].[Vlr_Compra],
           MAX([Comercial].[Clientes].[Nome_Cliente]),
           MAX((CONVERT(DATE, ([Comercial].[Venda].[Data_Venda]))))
	FROM [Comercial].[Venda]

	INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
    INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
    INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]

	GROUP BY [Nome_Produto], [Nome_Marca], [Vlr_Venda], [Vlr_Compra],Comercial.Produto.Id_Produto
	ORDER BY Nome_Produto
END;
GO

--------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Produto, Tipo_Produto, Nome_Marca, Vlr_Compra, Vlr_Venda e Margem_Lucro. Somente de produtos que não foram vendidos.
--------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarProdutosSemVendas]
AS
BEGIN
	SELECT [Comercial].[Produto].[Nome_Produto],
	       [Comercial].[TipoProduto].[Nome_TipoProduto],
	       [Comercial].[Marca].[Nome_Marca],
           [Comercial].[Produto].[Vlr_Compra],
           [Comercial].[Produto].[Vlr_Venda],
           [Vlr_Venda]-[Vlr_Compra] AS [Margem de lucro],
           SUM([Comercial].[VendaItem].[Qtd_Vendida]) AS [Vendas totais]
	INTO #temp_prod
	FROM [Comercial].[VendaItem]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	INNER JOIN [Comercial].[Venda] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	INNER JOIN [Comercial].[TipoProduto] ON [Comercial].[TipoProduto].[Id_TipoProduto] = [Comercial].[Produto].[Id_TipoProduto]
	GROUP BY [Nome_Produto], [Nome_TipoProduto], [Nome_Marca], [Vlr_Compra], [Vlr_Venda]

	SELECT * FROM  #temp_prod WHERE [Vendas totais]= 0

	DROP TABLE #temp_prod
END;
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente, Ind_Sexo (Utilizar função), Qtd_ItensVenda e Qtd_UnidadesVendidas, Data_PrimeiraCompraNaoPaga, Qtd_ComprasNaoPagas. Somente de clientes inadimplentes.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ListarPrimeiroCalotePorCliente]
AS
SELECT [Nome_Cliente] AS [Nome],
       [dbo].[FNC_RetornaSexo]([Ind_Sexo]) AS [Sexo],
	   COUNT([Comercial].[Produto].[Nome_Produto]) AS [Produtos vendidos],
	   SUM([Qtd_Vendida]) AS [Unidade vendidas], [Data_Pagamento] AS [Data de pagamento]
INTO #temp_inad
FROM [Comercial].[Venda]
INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
WHERE [Data_Pagamento] IS NULL
GROUP BY [Ind_Sexo], [Data_Pagamento], [Nome_Cliente];
SELECT * FROM #temp_inad;
DROP TABLE #temp_inad;
GO

--------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Produto, Nome_Marca, Vlr_TotalCusto, Vlr_TotalVendido e Vlr_Lucro (somente produtos pagos) ordenados por Vlr_Lucro.
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[USP_ListarProdutosMaisLucrativos]
AS
BEGIN
	SELECT [Nome_Produto],
		   [Nome_Marca],
		   SUM([Qtd_Vendida]*[Vlr_Venda]) AS [Vlr_TotalVendido],
		   [Vlr_Venda]-[Vlr_Compra] AS [Vlr_Lucro]
		   --MAX([Data_Pagamento]) AS [Data_Pagamento]
	INTO #temp_prod
	FROM [Comercial].[Venda]

	INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	WHERE [Data_Pagamento] IS NOT NULL
	GROUP BY [Nome_Produto], [Nome_Marca], [Vlr_Venda], [Vlr_Compra],[Qtd_Vendida],[Comercial].[Produto].[Id_Produto] --, [Data_Pagamento]
	ORDER BY [Vlr_Lucro] DESC
	SELECT * FROM #temp_prod -- WHERE [Data_Pagamento] IS NOT NULL;

	DROP TABLE #temp_prod;
END;
GO

---------------------------------------------------------------------------------------
-- Listar o Nome_Marca, o Vlr_TotalLucro, Qtd_ProdutosVendidos e Qtd_UnidadesVendidas
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarVendasLucroPorMarca] (@id INT)
AS
BEGIN
	SELECT [Nome_Marca],
		   SUM(([Vlr_Venda]-[Vlr_Compra]) * [Qtd_Vendida]) AS [Vlr_TotalLucro],
		   COUNT([Comercial].[VendaItem].[Id_Produto]) AS [Qtd_ProdutosVendidos],
		   SUM([Qtd_Vendida]) AS [Qtd_Unidades Vendidas]
	FROM  [Comercial].[Venda]
	INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	WHERE [Comercial].[Marca].[Id_Marcas] = @id
	GROUP BY [Nome_Marca]
END;
GO

------------------------------------------------------------------------------------------------------------------------------
-- Listar Nome_Cliente e Nome_ProdutosComprados (por ele em ordem alfabética separados por virgula e todos em apenas 1 coluna
------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarClienteProdutosComprados] (@id INT)
AS
BEGIN
	SELECT (SELECT [Nome_Cliente] FROM [Comercial].[Clientes] WHERE [Id_Cliente] = @id) AS [Nome (cliente)],
		   STUFF((SELECT DISTINCT ', ' + [Nome_Produto]
				         FROM  [Comercial].[Venda]
						 INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
						 INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
						 INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
						 INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
						 WHERE [Comercial].[Venda].[Id_Cliente] = @id
						 FOR XML PATH ('')), 1, 1, '') AS [Produtos comprados]
END;
GO

------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Marca e Nome_TodosProdutosMarca (da marca em questão, separados por virgula e todos em apenas 1 coluna)
------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarProdutosDeMarcas] (@texto VARCHAR(MAX))
AS
BEGIN

	DECLARE @produtos VARCHAR(MAX), @marca VARCHAR(MAX);
	SET @produtos = STUFF((SELECT DISTINCT ', ' + [Nome_Produto]
					 FROM [Comercial].[Produto]
					 INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
					 WHERE Nome_Marca LIKE CONCAT('%', @texto, '%')
					 FOR XML PATH('')), 1, 1, '');

	SET @marca = (SELECT [Nome_Marca]
	              FROM [Comercial].[Marca] WHERE [Nome_Marca] LIKE CONCAT('%', @texto, '%'));
	SELECT @marca, @produtos
END;
GO

-------------------------------------------------------
-- Função para converter data DD/MM/YYYY para Mês/YYYY
-------------------------------------------------------

CREATE FUNCTION [dbo].[FNC_ConverterDataMesAno] (@Data_Pagamento VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @mes VARCHAR(MAX), @ano VARCHAR(4);
	SET @mes = SUBSTRING(@Data_Pagamento, 4, 2)
	SET @ano = SUBSTRING(@Data_Pagamento, 7, 4)
	
	IF @mes = '01'
	SET @mes = 'Janeiro'
	ELSE IF @mes = '02'
	SET @mes = 'Fevereiro'
	ELSE IF @mes = '03'
	SET @mes = 'Março'
	ELSE IF @mes = '04'
	SET @mes = 'Abril'
	ELSE IF @mes = '05'
	SET @mes = 'Maio'	
	ELSE IF @mes = '06'
	SET @mes = 'Junho'	
	ELSE IF @mes = '07'
	SET @mes = 'Julho'
	ELSE IF @mes = '08'
	SET @mes = 'Agosto'
	ELSE IF @mes = '09'
	SET @mes = 'Setembro'
	ELSE IF @mes = '10'
	SET @mes = 'Outubro'
	ELSE IF @mes = '11'
	SET @mes = 'Novembro'
	ELSE
	SET @mes = 'Dezembro'

    SET @Data_Pagamento = CONCAT(@mes, '/', @ano)
	
	RETURN @Data_Pagamento
END;
GO

CREATE FUNCTION [dbo].[FCN_NomeMes] (@mes VARCHAR(MAX))
RETURNS VARCHAR(MAX)
BEGIN
	IF @mes = '01'
	SET @mes = 'Janeiro'
	ELSE IF @mes = '02'
	SET @mes = 'Fevereiro'
	ELSE IF @mes = '03'
	SET @mes = 'Março'
	ELSE IF @mes = '04'
	SET @mes = 'Abril'
	ELSE IF @mes = '05'
	SET @mes = 'Maio'	
	ELSE IF @mes = '06'
	SET @mes = 'Junho'	
	ELSE IF @mes = '07'
	SET @mes = 'Julho'
	ELSE IF @mes = '08'
	SET @mes = 'Agosto'
	ELSE IF @mes = '09'
	SET @mes = 'Setembro'
	ELSE IF @mes = '10'
	SET @mes = 'Outubro'
	ELSE IF @mes = '11'
	SET @mes = 'Novembro'
	ELSE
	SET @mes = 'Dezembro'

	RETURN @mes;
END;
GO

---------------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Mes/Ano, Qtd_TotalVendidosPagos (somente pagos) e a Qtd_TotalVendidosNaoPagos (somente não pagos) no Mês/Ano de referência
---------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ListarTotalVendasPagasCalotes] (@mes VARCHAR(MAX), @ano VARCHAR(MAX))
AS
BEGIN
	IF @mes = '01'
	SET @mes = 'Janeiro'
	ELSE IF @mes = '02'
	SET @mes = 'Fevereiro'
	ELSE IF @mes = '03'
	SET @mes = 'Março'
	ELSE IF @mes = '04'
	SET @mes = 'Abril'
	ELSE IF @mes = '05'
	SET @mes = 'Maio'	
	ELSE IF @mes = '06'
	SET @mes = 'Junho'	
	ELSE IF @mes = '07'
	SET @mes = 'Julho'
	ELSE IF @mes = '08'
	SET @mes = 'Agosto'
	ELSE IF @mes = '09'
	SET @mes = 'Setembro'
	ELSE IF @mes = '10'
	SET @mes = 'Outubro'
	ELSE IF @mes = '11'
	SET @mes = 'Novembro'
	ELSE
	SET @mes = 'Dezembro'

	SELECT  [dbo].[FNC_ConverterDataMesAno]([Comercial].[Venda].[Data_Pagamento]) AS [Data de pagamento],
	        SUM(Qtd_Vendida) AS [Quantidade vendida],
			(SELECT COUNT(*) FROM [Comercial].[Venda] WHERE [Data_Pagamento] IS NULL) AS [Quantidade (produtos não pagos)]
    INTO #temp_total
	FROM [Comercial].[Venda]
	INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
	INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
	INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
	INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
	WHERE Data_Pagamento IS NOT NULL
	GROUP BY Data_Pagamento;

	SELECT [Data de pagamento], SUM([Quantidade vendida]) AS [Quantidade (produtos pagos)], COUNT([Quantidade (produtos não pagos)]) AS [Quantidade (produtos não pagos)] FROM #temp_total WHERE [Data de pagamento] = CONCAT(@mes, '/', @ano)
	GROUP BY [Data de pagamento]
	DROP TABLE #temp_total;
END;
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Listar o Nome_Cliente, Ind_Sexo (Utilizar função), Num_Idade e Nome_Produto (mais comprado pelo cliente), caso não possua deixar em branco, caso exista 2 ou mais produtos com o mesmo valor, utilizar o produto
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ListarClienteProdutosFavoritos]
AS
BEGIN
	SELECT Nome_Cliente,
		   [dbo].[FNC_RetornaSexo](Ind_Sexo) AS [Sexo],
		   ABS(DATEDIFF(YEAR, GETDATE(), (CONVERT(DATE, [Data_Nascimento], 103)))) AS [Idade],
		   MAX(Nome_Produto) AS [Produto],
		   MAX(Qtd_Vendida) AS [Quantidade vendida]

		FROM [Comercial].[Venda]
		INNER JOIN [Comercial].[VendaItem] ON [Comercial].[Venda].[Id_Venda] = [Comercial].[VendaItem].[Id_Venda]
		INNER JOIN [Comercial].[Produto] ON [Comercial].[Produto].[Id_Produto] = [Comercial].[VendaItem].[Id_Produto]
		INNER JOIN [Comercial].[Marca] ON [Comercial].[Marca].[Id_Marcas] = [Comercial].[Produto].[Id_Marca]
		INNER JOIN [Comercial].[Clientes] ON [Comercial].[Clientes].[Id_Cliente] = [Comercial].[Venda].[Id_Cliente]
		GROUP BY Nome_Cliente, Ind_Sexo,  Data_Nascimento
		ORDER BY Nome_Cliente
END;
GO