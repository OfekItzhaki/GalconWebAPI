USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('dbo.Dyn_OrderDetails','U') IS NOT NULL
		DROP TABLE dbo.Dyn_OrderDetails;
	GO
	IF OBJECT_ID('dbo.Dyn_Order','U') IS NOT NULL
		DROP TABLE dbo.Dyn_Order;
	GO
CREATE TABLE dbo.Dyn_Order
		(OrderId		int IDENTITY(1,1)	NOT NULL,
		 OrderName		varchar(30) UNIQUE	NOT NULL, 
		 UserId			varchar(20)			NOT NULL, 
		 OrderDate		date				NOT NULL, 
		 TotalPrice		int					NOT NULL,
		 IsActive		bit					NOT NULL,
		 
		 CONSTRAINT PK_Dyn_Order_Id			PRIMARY KEY				CLUSTERED(OrderId),
		 CONSTRAINT FK_Dyn_Order_OrderName	FOREIGN KEY(OrderId)	REFERENCES dbo.Dyn_Order(OrderId)
	);
GO
------------------------------------------------------------------------- 
	IF OBJECT_ID('dbo.Dyn_Order#OrderId#UserId', 'UQ') IS NOT NULL
		ALTER TABLE dbo.Dyn_Order DROP CONSTRAINT UQ_dbo_Dyn_Order_#OrderId#UserId;
	GO
ALTER TABLE dbo.Dyn_Order
ADD CONSTRAINT UQ_dbo_Dyn_Order_#OrderId#UserId UNIQUE(OrderId, UserId)
------------------------------------------------------------------------- 
DELETE FROM dbo.Dyn_Order;
INSERT INTO dbo.Dyn_Order (OrderName, UserId, OrderDate, TotalPrice, IsActive) 
			SELECT			'a100',		1,		GETDATE(),		10,		0	
UNION ALL	SELECT			'a101',		1,		GETDATE(),		23,		0		
UNION ALL	SELECT			'a102',		2,		GETDATE(),		300,	0						
-------------------------------------------------------------------------
	SELECT	* 
	FROM	dbo.Dyn_Order 
--	WHERE	...
	ORDER BY OrderId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Get
	@OrderId		int			= NULL,
	@OrderName		varchar(30) = NULL
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				SELECT	 OrderId, 
						 OrderName, 
						 UserId, 
						 OrderDate, 
						 TotalPrice

				FROM	 dbo.Dyn_Order
				WHERE	 OrderId	= ISNULL(@OrderId, OrderId) 
				AND		 OrderName	= ISNULL(@OrderName, @OrderName)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "dbo.Dyn_Order" table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Insert
	@OrderId			int,
	@OrderName			varchar(30),
	@UserId				varchar(20),
	@OrderDate			date,
	@TotalPrice			int,
	@IsActive			bit
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				INSERT INTO dbo.Dyn_Order
								(OrderId,
								 OrderName,
								 UserId,
								 OrderDate,
								 TotalPrice,
								 IsActive)
				VALUES			(@OrderId,
								 @OrderName,
								 @UserId,	
								 @OrderDate,
								 @TotalPrice,
								 @IsActive)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Insert a NULL Value into the "dbo.Dyn_Order" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Delete
	@OrderId int
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			DELETE FROM dbo.Dyn_Order
			WHERE		OrderId = @OrderId

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Delete a NULL Value from the "dbo.Dyn_Order" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO