USE [GalconDB]
GO
-------------------------------------------------------------------------
IF OBJECT_ID('[dbo].[Dyn_Product]','U') IS NOT NULL
	DROP TABLE [dbo].[Dyn_Product];
GO
CREATE TABLE [dbo].[Dyn_Product] 
		(ProductId				int IDENTITY(1,1)	NOT NULL, 
		 ProductBarcode			varchar(20) 		NOT NULL, 
		 ProductName			varchar(20) 		NOT NULL, 
		 ProductDescription		varchar(50)			NOT NULL, 
		 ProductPrice			int					NOT NULL,
		 IsActive				bit					NOT NULL CONSTRAINT DF_Dyn_Product_IsActive DEFAULT(1)

		,CONSTRAINT PK_Dyn_Product_ProductId		PRIMARY KEY CLUSTERED(ProductId)
		,CONSTRAINT UK_Dyn_Product_ProductBarcode	UNIQUE		NONCLUSTERED(ProductBarcode)
		,CONSTRAINT UK_Dyn_Product_ProductName		UNIQUE		NONCLUSTERED(ProductName)
	);
GO
------------------------------------------------------------------------- 
DELETE FROM [dbo].[Dyn_Product];
INSERT INTO [dbo].[Dyn_Product] (ProductBarcode, ProductName, ProductDescription, ProductPrice) 
			SELECT				'1',	'Soup',			'Cleaning products',	10
UNION ALL	SELECT				'2',	'Toothbrush',	'Cleaning products',	10	
UNION ALL	SELECT				'3',	'Towel',		'Cleaning products',	20			
-------------------------------------------------------------------------
	SELECT	ProductID, ProductBarcode, ProductName, ProductDescription, ProductPrice 
	FROM	[dbo].[Dyn_Product] 
--	WHERE	...
	ORDER BY ProductBarcode;
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Get Products
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dyn_Product_Get]
				@ProductId = NULL;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Product_Get]
	@ProductId	int = NULL
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	

	SELECT		ProductBarcode, ProductName, ProductDescription, ProductPrice
	FROM		[dbo].[Dyn_Product]
	WHERE		ProductId = ISNULL(@ProductId, ProductId)
	ORDER BY	ProductId;

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Insert Products
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dyn_Product_Insert] 
		 @ProductBarcode		= 'Prod10002'
		,@ProductName			= 'Product 1'
		,@ProductDescription	= 'Test Product 1'
		,@ProductPrice			= 20;
	SELECT * FROM [dbo].[Dyn_Product] WITH(nolock) WHERE ProductId = @ProductId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Product_Insert]
	@ProductBarcode			varchar(20),
	@ProductName			varchar(20),
	@ProductDescription		varchar(50),
	@ProductPrice			int
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	

	INSERT INTO [dbo].[Dyn_Product]
			(ProductBarcode		,ProductName	,ProductDescription		,ProductPrice	,IsActive)
	VALUES	(@ProductBarcode	,@ProductName	,@ProductDescription	,@ProductPrice	,1);
						
END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Update Product
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dyn_Product_Update]
			 @ProductId				= 1
			,@ProductBarcode		= 'Prod10003'
			,@ProductName			= 'Product 4'
			,@ProductDescription	= 'Test Product 1'
			,@ProductPrice			= 20;
	SELECT * FROM [dbo].[Dyn_Product] WITH(nolock) WHERE ProductId = @ProductId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Product_Update]
	 (@ProductId			int 	
	 ,@ProductBarcode		varchar(20) 	= NULL
	 ,@ProductName			varchar(20)		= NULL
	 ,@ProductDescription	varchar(50)		= NULL	
	 ,@ProductPrice			int				= NULL
	 ,@IsActive				bit				= NULL)
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';

	UPDATE	[dbo].[Dyn_Product]
		SET		 ProductBarcode		= ISNULL(@ProductBarcode, ProductBarcode)
				,ProductName		= ISNULL(@ProductName, ProductName)
				,ProductDescription	= ISNULL(@ProductDescription, ProductDescription)
				,ProductPrice		= ISNULL(@ProductPrice, ProductPrice)
				,IsActive			= ISNULL(@IsActive, IsActive)
		WHERE	 ProductId			= @ProductId;

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END;
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Delete Product
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE @ProductId int = 1;
	EXEC [dbo].[Dyn_Product_Delete] @ProductId = @ProductId;
	SELECT * FROM [dbo].[Dyn_Product] WITH(nolock) WHERE ProductId = @ProductId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Product_Delete]
	@ProductId	int
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	
	IF NOT EXISTS(	SELECT TOP 1 1 
					FROM	[dbo].[Dyn_OrderDetails] 
					WHERE	ProductId = @ProductId)
	DELETE FROM [dbo].[Dyn_Product]
	WHERE		ProductId	= @ProductId
	AND			IsActive	= 0;

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------