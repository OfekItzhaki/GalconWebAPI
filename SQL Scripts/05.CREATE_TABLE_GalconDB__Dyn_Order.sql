USE [GalconDB]
GO
-------------------------------------------------------------------------
IF OBJECT_ID('[dbo].[FK_Dyn_OrderDetails_OrderId]','F') IS NOT NULL
	ALTER TABLE [dbo].[Dyn_OrderDetails] DROP CONSTRAINT FK_Dyn_OrderDetails_OrderId;
GO
IF OBJECT_ID('[dbo].[Dyn_Order]','U') IS NOT NULL
	DROP TABLE [dbo].[Dyn_Order];
GO
CREATE TABLE [dbo].[Dyn_Order]
		(OrderId		int IDENTITY(1,1)	NOT NULL
		,OrderName		varchar(30)			NOT NULL
		,UserId			int					NOT NULL
		,OrderDate		date				NOT NULL
		,TotalPrice		decimal(10,2)		NOT NULL
		,IsCancelled 	bit					NOT NULL CONSTRAINT DF_Dyn_Order_IsCancelled  DEFAULT(1)
		
		,CONSTRAINT PK_Dyn_Order_Id			PRIMARY KEY				CLUSTERED(OrderId)
		,CONSTRAINT FK_Dyn_User_UserId		FOREIGN KEY(UserId)		REFERENCES [dbo].[Dyn_User](UserId)
		,CONSTRAINT UK_Dyn_Order_OrderName	UNIQUE					NONCLUSTERED(OrderName)
	);
GO
IF		OBJECT_ID('[dbo].[FK_Dyn_OrderDetails_OrderId]','F')	IS NULL 
	AND OBJECT_ID('[dbo].[Dyn_OrderDetails]','U')				IS NOT NULL
	ALTER TABLE [dbo].[Dyn_OrderDetails] 
		ADD CONSTRAINT FK_Dyn_OrderDetails_OrderId FOREIGN KEY (OrderId) REFERENCES dbo.Dyn_Order(OrderId);
GO
------------------------------------------------------------------------- 
--	DELETE FROM [dbo].[Dyn_Order];
	--DBCC CHECKIDENT('[dbo].[Dyn_Order]','RESEED',0);

--	INSERT INTO [dbo].[Dyn_Order] (OrderName, UserId, OrderDate, TotalPrice, IsCancelled )
--				SELECT			'a100'		,1		,GETDATE()		, 10.00		,0
--	UNION ALL	SELECT			'a101'		,1		,GETDATE()		, 23.00		,0
--	UNION ALL	SELECT			'a102'		,2		,GETDATE()		,300.00		,0
-------------------------------------------------------------------------
	SELECT	* 
	FROM	[dbo].[Dyn_Order] 
--	WHERE	...
	ORDER BY OrderId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Get Orders
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dyn_Order_Get]	@OrderId = NULL;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Order_Get]
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
			,IsCancelled

	FROM		[dbo].[Dyn_Order]
	WHERE		(OrderId	= @OrderId		OR @OrderId		IS NULL)
	AND			(OrderName	= @OrderName	OR @OrderName	IS NULL)
	ORDER BY	 OrderId;

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
--Description: Insert Order
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@OrderId int;
	DECLARE @OrderName		varchar(30) = 'Ord10002'
	DECLARE	@UserId			int			= 1
	EXEC [dbo].[Dyn_Order_Insert] 
		 @OrderName		= @OrderName	
		,@UserId		= @UserId		
		,@OrderId		= @OrderId	OUTPUT;
	SELECT @OrderId AS "@OrderId";
	SELECT * FROM [dbo].[Dyn_Order] WITH(nolock) WHERE OrderId = @OrderId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Order_Insert]
	 @OrderName			varchar(30)
	,@UserId			int
	,@OrderId			int		OUTPUT
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';

	INSERT INTO [dbo].[Dyn_Order]
			(OrderName	,UserId		,OrderDate ,TotalPrice	,IsCancelled)
	VALUES	(@OrderName ,@UserId	,GetDate() ,0			,0);
	SET		 @OrderId = SCOPE_IDENTITY();

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
--Description: Update Order
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@OrderId		int					= 1;
	DECLARE @PriceDelta		decimal(10,2)		= 100.02
	DECLARE @IsCancelled	bit					= 1;
	EXEC [dbo].[Dyn_Order_Update]
			 @OrderId		= @OrderId
			,@PriceDelta	= @PriceDelta	
			,@IsCancelled 	= @IsCancelled
	SELECT * FROM [dbo].[Dyn_Order] WITH(nolock) WHERE OrderId = @OrderId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Order_Update]
	 (@OrderId			int
	 ,@PriceDelta		decimal(10,2)	= NULL
	 ,@IsCancelled 		bit				= NULL)
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';

	UPDATE	[dbo].[Dyn_Order]
	SET		TotalPrice	= TotalPrice + ISNULL(@PriceDelta, 0.00)
		   ,IsCancelled = ISNULL(@IsCancelled, IsCancelled) 
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
--Description: Delete Order
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@OrderId int = 1;
	EXEC [dbo].[Dyn_Order_Delete] @OrderId = @OrderId;
	SELECT * FROM [dbo].[Dyn_Order] WITH(nolock) WHERE OrderId = @OrderId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_Order_Delete]
	@OrderId int
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';

	BEGIN TRAN;

		EXEC Dyn_OrderDetails_Delete @OrderId = @OrderId;

		DELETE 
		FROM	[dbo].[Dyn_Order]
		WHERE	OrderId		= @OrderId
		AND		IsCancelled	= 1;

	COMMIT TRAN;

END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
		ROLLBACK;
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH;
END;
GO
-------------------------------------------------------------------------
