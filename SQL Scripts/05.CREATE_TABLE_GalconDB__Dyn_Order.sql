USE [GalconDB]
GO
-------------------------------------------------------------------------
IF OBJECT_ID('dbo.Dyn_Order','U') IS NOT NULL
	DROP TABLE dbo.Dyn_Order;
GO
CREATE TABLE dbo.Dyn_Order
		(OrderId		int IDENTITY(1,1)	NOT NULL,
		 OrderName		varchar(30)			NOT NULL, 
		 UserId			varchar(20)			NOT NULL, 
		 OrderDate		date				NOT NULL, 
		 TotalPrice		decimal(10,2)		NOT NULL,
		 IsActive		bit					NOT NULL,
		 
		 CONSTRAINT PK_Dyn_Order_Id			PRIMARY KEY				CLUSTERED(OrderId),
		 CONSTRAINT UK_Dyn_Order_OrderName	UNIQUE					NONCLUSTERED(OrderName),
		 CONSTRAINT FK_Dyn_Order_OrderName	FOREIGN KEY(OrderId)	REFERENCES dbo.Dyn_Order(OrderId)
	);
GO
------------------------------------------------------------------------- 
IF OBJECT_ID('dbo.Dyn_Order#OrderId#UserId', 'UQ') IS NOT NULL
	ALTER TABLE dbo.Dyn_Order DROP CONSTRAINT UQ_dbo_Dyn_Order_#OrderId#UserId;
GO
ALTER TABLE dbo.Dyn_Order ADD CONSTRAINT UQ_dbo_Dyn_Order_#OrderId#UserId UNIQUE(OrderId, UserId);
GO
------------------------------------------------------------------------- 
--	DELETE FROM dbo.Dyn_Order;
	--DBCC CHECKIDENT('dbo.Dyn_Order','RESEED',0);

--	INSERT INTO dbo.Dyn_Order (OrderName, UserId, OrderDate, TotalPrice, IsActive)
--				SELECT			'a100'		,1		,GETDATE()		, 10.00		,0
--	UNION ALL	SELECT			'a101'		,1		,GETDATE()		, 23.00		,0
--	UNION ALL	SELECT			'a102'		,2		,GETDATE()		,300.00		,0
-------------------------------------------------------------------------
	SELECT	* 
	FROM	dbo.Dyn_Order 
--	WHERE	...
	ORDER BY OrderId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Orders Get
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC dbo.Dyn_Order_Get @OrderId = NULL;
*/
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Get
	@OrderId		int			= NULL,
	@OrderName		varchar(30) = NULL
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';
	SELECT	 OrderId
			,OrderName 
			,UserId 
			,OrderDate 
			,TotalPrice
	FROM	 dbo.Dyn_Order
	WHERE	 (OrderId	= @OrderId		OR @OrderId		IS NULL)
	AND		 (OrderName	= @OrderName	OR @OrderName	IS NULL);
END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH;
END;
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Insert Orders
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@OrderId int;
	EXEC dbo.Dyn_Order_Insert 
		 @OrderName		= 'Ord10002'
		,@UserId		= 1
		,@OrderId		= @OrderId OUTPUT;
	SELECT @OrderId AS "@OrderId";
*/
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Insert
	 @OrderName			varchar(30)
	,@UserId			varchar(20)
	,@OrderId			int		OUTPUT
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg		varchar(1000) = '';
	INSERT INTO dbo.Dyn_Order
					(OrderName
					,UserId
					,OrderDate
					,TotalPrice
					,IsActive)
	VALUES			(@OrderName
					,@UserId	
					,GetDate()
					,0
					,1);
	SET @OrderId = SCOPE_IDENTITY();
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
--Description: Update Orders
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@OrderId int = 1;
	EXEC dbo.Dyn_Order_Update
			 @OrderId		= @OrderId
			,@PriceDelta	= 100.02
			,@IsActive		= 1
	SELECT * FROM dbo.Dyn_Order WITH(nolock) WHERE OrderId = @OrderId;
*/
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Update
	  @OrderId			int
	 ,@PriceDelta		decimal(10,2)	= NULL
	 ,@IsActive			bit				= 1
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';
	UPDATE	dbo.Dyn_Order
		SET		 TotalPrice	= TotalPrice + ISNULL(@PriceDelta,0.00)
				,IsActive	= @IsActive
		WHERE	OrderId		= @OrderId;
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
--Description: Delete Orders
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC dbo.Dyn_Order_Delete @OrderId = 1;
*/
CREATE OR ALTER PROCEDURE dbo.Dyn_Order_Delete
	@OrderId int
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';

	BEGIN TRAN;

		EXEC dbo.Dyn_OrderDetails_Delete
			 @OrderId = @OrderId;

		DELETE 
		FROM	dbo.Dyn_Order
		WHERE	OrderId = @OrderId;

	COMMIT TRAN;

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK;
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH;
END;
GO
-------------------------------------------------------------------------
