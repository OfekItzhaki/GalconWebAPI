USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('dbo.Dyn_Product','U') IS NOT NULL
		DROP TABLE dbo.Dyn_Product;
	GO
CREATE TABLE dbo.Dyn_Product 
		(Id						int IDENTITY(1,1)	NOT NULL, 
		 ProductId				int UNIQUE			NOT NULL, 
		 ProductName			varchar(20) UNIQUE	NOT NULL, 
		 ProductDescription		varchar(50)			NOT NULL, 
		 ProductPrice			int					NOT NULL,

		 CONSTRAINT PK_Dyn_Product_Id PRIMARY KEY CLUSTERED(Id)
	);
GO
------------------------------------------------------------------------- 
DELETE FROM dbo.Dyn_Product;
INSERT INTO dbo.Dyn_Product (ProductId, ProductName, ProductDescription, ProductPrice) 
			SELECT				1,		'Soup',			'Cleaning products',	10
UNION ALL	SELECT				2,		'Toothbrush',	'Cleaning products',	10	
UNION ALL	SELECT				3,		'Towel',		'Cleaning products',	20			
-------------------------------------------------------------------------
	SELECT	* 
	FROM	dbo.Dyn_Product 
--	WHERE	...
	ORDER BY ProductId;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_Product_Get
	@ProductId int
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				SELECT	 ProductId,
						 ProductName,
						 ProductDescription,
						 ProductPrice

				FROM	 dbo.Dyn_Product
				WHERE	 ProductId = ISNULL(@ProductId, ProductId)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "dbo.Dyn_Product" table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_Product_Insert
	@ProductId				int,
	@ProductName			varchar(20),
	@ProductDescription		varchar(50),
	@ProductPrice			int
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				INSERT INTO dbo.Dyn_Product
							(ProductId,
							 ProductName,		
							 ProductDescription,
							 ProductPrice)
				VALUES		(@ProductId,			
							 @ProductName,		
							 @ProductDescription,
							 @ProductPrice)
									 
			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Insert a NULL Value into the "dbo.Dyn_Product" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_Product_Delete
	@ProductId int
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			DELETE FROM dbo.Dyn_Product
			WHERE		ProductId = @ProductId

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Delete a NULL Value from the "dbo.Dyn_Product" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO