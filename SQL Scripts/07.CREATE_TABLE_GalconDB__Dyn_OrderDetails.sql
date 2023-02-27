USE [GalconDB]
GO
-------------------------------------------------------------------------
IF OBJECT_ID('[dbo].[Dyn_OrderDetails]','U') IS NOT NULL
	DROP TABLE [dbo].[Dyn_OrderDetails];
GO
CREATE TABLE [dbo].[Dyn_OrderDetails] 
		(OrderDetailsId int IDENTITY(1,1) NOT NULL
		,OrderId		int				NOT NULL
		,ProductId		int				NOT NULL
		,Quantity		int				NOT NULL
		,SalePrice		decimal(10,2)	NOT NULL
		,CreationTime	datetime		NOT NULL
		,LastUpdatedTime	datetime		NULL
		,CONSTRAINT PK_Dyn_OrderDetails_OrderDetailsIdId	PRIMARY KEY CLUSTERED (OrderDetailsId)
		,CONSTRAINT FK_Dyn_OrderDetails_OrderId				FOREIGN KEY (OrderId)	REFERENCES dbo.Dyn_Order(OrderId)
		,CONSTRAINT FK_Dyn_OrderDetails_ProductId			FOREIGN KEY (ProductId) REFERENCES dbo.Dyn_Product(ProductId)
	);
GO
------------------------------------------------------------------------- 
IF OBJECT_ID('[dbo].[Dyn_OrderDetails]#OrderId#ProductId', 'UQ') IS NOT NULL
	ALTER TABLE [dbo].[Dyn_OrderDetails] DROP CONSTRAINT UQ_dbo_Dyn_OrderDetails_#OrderId#ProductId;
GO
	ALTER TABLE [dbo].[Dyn_OrderDetails] ADD CONSTRAINT  UQ_dbo_Dyn_OrderDetails_#OrderId#ProductId UNIQUE(OrderId, ProductId);
GO
------------------------------------------------------------------------- 
--	DELETE FROM [dbo].[Dyn_OrderDetails];
	--DBCC CHECKIDENT('[dbo].[Dyn_OrderDetails]','RESEED',0);

--	INSERT INTO [dbo].[Dyn_OrderDetails] (OrderId, ProductId, Quantity) 
--				SELECT					'',		'',					
--	UNION ALL SELECT					'',		'',					
--	UNION ALL	SELECT					'',		'',					
--	UNION ALL	SELECT					'',		'',								
-------------------------------------------------------------------------
	SELECT	* 
	FROM	[dbo].[Dyn_OrderDetails] 
--	WHERE	...
	ORDER BY OrderDetailsId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Get OrderDetails
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	 @OrderDetailsId	int = NULL
			,@OrderId			int = NULL
	EXEC [dbo].[Dyn_OrderDetails_Get]
			 @OrderDetailsId	= @OrderDetailsId
			,@OrderId			= @OrderId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_OrderDetails_Get]
	 @OrderDetailsId	int
	,@OrderId			int
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';
	SELECT	 OrderDetailsId
			,OrderId
			,ProductId
			,Quantity
			,SalePrice
			,CreationTime
			,LastUpdatedTime
	FROM	[dbo].[Dyn_OrderDetails]
	WHERE	(OrderDetailsId	= @OrderDetailsId	OR @OrderDetailsId	IS NULL)
	OR		(OrderId		= @OrderId			OR @OrderId			IS NULL)
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
--Description: Update & Insert OrderDetails
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	------------------------------------------------------------------------
	--Insert:
	------------------------------------------------------------------------
		DECLARE	 @OrderDetailsId	int				= NULL
				,@OrderId			int				= 2
				,@ProductId			int				= 3
				,@Quantity			int				= 3
				,@SalePrice			decimal(10,2)	= 10.00
		EXEC	[dbo].[Dyn_OrderDetails_Upsert]
				 @OrderDetailsId	= @OrderDetailsId	OUTPUT
				,@OrderId			= @OrderId		
				,@ProductId			= @ProductId	
				,@Quantity			= @Quantity	
				,@SalePrice			= @SalePrice;

		SELECT		* 
		FROM		[dbo].[Dyn_Order]			O	WITH(nolock)
		INNER JOIN	[dbo].[Dyn_OrderDetails]	OD	WITH(nolock) ON OD.OrderId = O.OrderId
		WHERE		OD.OrderDetailsId = @OrderDetailsId;
	------------------------------------------------------------------------
	--Update:
	------------------------------------------------------------------------
		DECLARE	 @OrderDetailsId	int				= 8
				,@OrderId			int				= NULL
				,@ProductId			int				= 7
				,@Quantity			int				= 3
				,@SalePrice			decimal(10,2)
				SELECT	@SalePrice = ProductPrice 
				FROM	[dbo].[Dyn_Product] 
				WHERE	ProductId	= @ProductId;
		EXEC	[dbo].[Dyn_OrderDetails_Upsert]
				 @OrderDetailsId	= @OrderDetailsId	OUTPUT
				,@OrderId			= @OrderId
				,@ProductId			= @ProductId	
				,@Quantity			= @Quantity	
				,@SalePrice			= @SalePrice;

		SELECT		* 
		FROM		[dbo].[Dyn_Order]			O	WITH(nolock)
		INNER JOIN	[dbo].[Dyn_OrderDetails]	OD	WITH(nolock) ON OD.OrderId = O.OrderId
		WHERE	OrderDetailsId = @OrderDetailsId;
	------------------------------------------------------------------------
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_OrderDetails_Upsert]
	(@OrderDetailsId	int				= NULL	OUTPUT
	,@OrderId			int				
	,@ProductId			int
	,@Quantity			int				
	,@SalePrice			decimal(10,2)
	)
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';
	DECLARE	@PriceDelta		decimal(10,2);
	DECLARE	@T_PriceDelta	AS TABLE (	 DELETED_OrderId	int
										,DELETED_SalesPrice	decimal(10,2)	,INSERTED_SalesPrice	decimal(10,2)	
										,DELETED_Quantity	int				,INSERTED_Quantity		int		);
	BEGIN TRAN;

		UPDATE [dbo].[Dyn_OrderDetails]
		SET						 ProductId		= @ProductId
								,Quantity		= ISNULL(@Quantity, Quantity)
								,SalePrice		= ISNULL(@SalePrice, SalePrice)
								,LastUpdatedTime	= GetDate()

		OUTPUT					 DELETED.OrderId
								,DELETED.SalePrice	,INSERTED.SalePrice
								,DELETED.Quantity	,INSERTED.Quantity

		INTO @T_PriceDelta		(DELETED_OrderId
								,DELETED_SalesPrice	,INSERTED_SalesPrice
								,DELETED_Quantity	,INSERTED_Quantity)

		WHERE					 OrderDetailsId	= @OrderDetailsId;


		IF (@@ROWCOUNT = 0)
		BEGIN
			INSERT INTO [dbo].[Dyn_OrderDetails]
						(OrderId, ProductId, Quantity ,SalePrice, CreationTime, LastUpdatedTime)
			VALUES		(@OrderId ,@ProductId ,@Quantity ,@SalePrice ,GetDate() ,NULL);
			SET			 @OrderDetailsId = SCOPE_IDENTITY();
		END;


		SELECT		@OrderId		= DELETED_OrderId
				   ,@PriceDelta		= ((INSERTED_SalesPrice * INSERTED_Quantity	) 
									-  (DELETED_SalesPrice	* DELETED_Quantity	))
		FROM		@T_PriceDelta;
		SET			@PriceDelta		= ISNULL(@PriceDelta, (@SalePrice * @Quantity));
		EXEC		dbo.Dyn_Order_Update @OrderId = @OrderId ,@PriceDelta = @PriceDelta;

	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF(@@TRANCOUNT > 0)
		ROLLBACK TRAN;
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH;
END;
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Delete OrderDetails
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
		DECLARE	 @OrderDetailsId	int = 8		--(@OrderDetailsId	= NULL will Delete All OrderDetails Rows of Specified @OrderId)
				,@OrderId			int = NULL	--(@OrderId is to Delete All OrderDetails of an @OrderId. And @OrderId = NULL to be sent when Delete of specific @OrderDetailsId)
		EXEC [dbo].[Dyn_OrderDetails_Delete]
				 @OrderDetailsId	= @OrderDetailsId
				,@OrderId			= @OrderId;

		SELECT		* 
		FROM		[dbo].[Dyn_Order]			O	WITH(nolock)
		INNER JOIN	[dbo].[Dyn_OrderDetails]	OD	WITH(nolock) ON OD.OrderId = O.OrderId
		WHERE		OrderDetailsId = @OrderDetailsId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_OrderDetails_Delete]
	  @OrderDetailsId	int	= NULL
	 ,@OrderId			int = NULL
AS
BEGIN
BEGIN TRY
	IF @OrderDetailsId IS NULL AND @OrderId IS NULL
		RAISERROR('Must Provide OrderDetailsId or OrderId', 16, 1);
	DECLARE	@ErrMsg			varchar(1000) = '';
	DECLARE	@PriceDelta		decimal(10,2);
	DECLARE	@T_PriceDelta	AS TABLE (DELETED_OrderId int, DELETED_SalesPrice decimal(10,2), DELETED_Quantity int);

	BEGIN TRAN;
	
		DELETE	
		FROM	[dbo].[Dyn_OrderDetails]
		OUTPUT						 DELETED.OrderId		,DELETED.Quantity	,DELETED.SalePrice
		INTO	@T_PriceDelta		(DELETED_OrderId		,DELETED_SalesPrice	,DELETED_Quantity)

		WHERE						((OrderDetailsId	= @OrderDetailsId	OR @OrderDetailsId	IS NULL)
		AND							 (OrderId			= @OrderId			OR @OrderId			IS NULL));


		SELECT	 @OrderId		= MAX(DELETED_OrderId)
				,@PriceDelta	= SUM((-1 * (DELETED_SalesPrice * DELETED_Quantity)))
		FROM	@T_PriceDelta;
		EXEC dbo.Dyn_Order_Update
				 @OrderId		= @OrderId
				,@PriceDelta	= @PriceDelta;

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
---------------------------------------------------------------------------
--	SELECT			* 
--	FROM			dbo.Dyn_Order			O	WITH(nolock)
--	LEFT OUTER JOIN	[dbo].[Dyn_OrderDetails]	OD	WITH(nolock) ON OD.OrderId = O.OrderId;
---------------------------------------------------------------------------

