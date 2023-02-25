USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('dbo.Dyn_OrderDetails','U') IS NOT NULL
		DROP TABLE dbo.Dyn_OrderDetails;
	GO
CREATE TABLE dbo.Dyn_OrderDetails 
		(OrderDetailsId int IDENTITY(1,1) NOT NULL, OrderId int NOT NULL, ProductId int NOT NULL, Quantity int NOT NULL
		,CONSTRAINT PK_Dyn_OrderDetails_OrderDetailsIdId PRIMARY KEY CLUSTERED (OrderDetailsId)
		,CONSTRAINT FK_Dyn_OrderDetails_OrderId FOREIGN KEY (OrderId) REFERENCES dbo.Dyn_Order(OrderId)
		,CONSTRAINT FK_Dyn_OrderDetails_ProductId FOREIGN KEY (ProductId) REFERENCES dbo.Dyn_Product(ProductId)
	);
GO
------------------------------------------------------------------------- 
	IF OBJECT_ID('dbo.Dyn_OrderDetails#OrderId#ProductId', 'UQ') IS NOT NULL
		ALTER TABLE dbo.Dyn_OrderDetails DROP CONSTRAINT UQ_dbo_Dyn_OrderDetails_#OrderId#ProductId;
	GO
ALTER TABLE dbo.Dyn_OrderDetails
ADD CONSTRAINT UQ_dbo_Dyn_OrderDetails_#OrderId#ProductId UNIQUE(OrderId, ProductId)
------------------------------------------------------------------------- 
DELETE FROM dbo.Dyn_OrderDetails;
--INSERT INTO dbo.Dyn_OrderDetails (OrderId, ProductId, Quantity) 
--			SELECT					'',		'',					
--UNION ALL SELECT					'',		'',					
--UNION ALL	SELECT					'',		'',					
--UNION ALL	SELECT					'',		'',					
--UNION ALL	SELECT					'',		'',					
--UNION ALL	SELECT					'',		'',					
--UNION ALL	SELECT					'',		'',					
--UNION ALL	SELECT					'',		'',					
-------------------------------------------------------------------------
	SELECT	* 
	FROM	dbo.Dyn_OrderDetails 
--	WHERE	...
	ORDER BY 2;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_OrderDetails_Get
	@OrderId int
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				SELECT	 *
				FROM	dbo.Dyn_OrderDetails
				WHERE	OrderId = ISNULL(@OrderId, OrderId)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "dbo.Dyn_OrderDetails" table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_OrderDetails_Insert
	(@OrderId			int
	,@CreateTime		dateTime
	,@LastUpdate		dateTime
	,@Quantity			int
	,@PlaceId			int
	,@ProductId			int)
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				INSERT INTO dbo.Dyn_OrderDetails
									(OrderId
									,Quantity
									,ProductId)
				VALUES				(@OrderId
									,@Quantity
									,@ProductId)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Insert a NULL Value into the "dbo.Dyn_OrderDetails" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_OrderDetails_Delete
	@OrderId int
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			DELETE FROM dbo.Dyn_OrderDetails
			WHERE  OrderId	=	@OrderId

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Delete a NULL Value from the "dbo.Dyn_OrderDetails" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO