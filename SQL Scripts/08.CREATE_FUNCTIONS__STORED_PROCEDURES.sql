USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.SP_Login
	(@Email		varchar(320),
	 @UserName	varchar(20),
	 @HashPassword	varchar(64))
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	

	SELECT COUNT(*) 
	FROM	 [dbo].[Dyn_User] 

	WHERE  ((@UserName	IS NOT NULL	 AND @Email		IS NOT NULL
					OR 
		 	(UserName	= @UserName	 AND @Email		IS NULL)
					OR
			(Email		= @Email	 AND @UserName	IS NULL))

	AND		UserName	= @UserName  AND  Email		= @Email)
	AND		HashPassword = @HashPassword;

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
CREATE OR ALTER PROCEDURE [dbo].[SP_GetUsersByRole]
	@UserRole	int
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	

	SELECT	UserId,
			UserName,						
			LastPasswordUpdatedTime,
			PasswordExpirationTime,
			UserRole,
			CreationTime,
			LastUpdatedTime,
			FirstName,
			LastName,
			Tel,
			Email,
			EmailConfirmed,
			IsActive

	FROM	[dbo].[Dyn_User] 
	WHERE   UserRole = @UserRole;

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
CREATE OR ALTER PROCEDURE [dbo].[SP_GetOrdersSum]
	@UserId		varchar(20) = NULL,
	@FromDate	datetime,
	@ToDate		datetime
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	

	SELECT	 SUM(TotalPrice)
	FROM	[dbo].[Dyn_Order]

	WHERE	(UserId		=	@UserId		OR @UserId		IS NULL)
	AND		(OrderDate	>=	@FromDate	OR @FromDate	IS NULL)
	AND		(OrderDate	<=	@ToDate		OR @ToDate		IS NULL);

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
CREATE OR ALTER PROCEDURE [dbo].[SP_GetOrders]
	@UserId			varchar(20)	= NULL,
	@FromDate		date		= NULL,
	@ToDate			date		= NULL,
	@IsCancelled	bit			= NULL
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';	

	SELECT		 OrderId 
				,OrderName 
				,UserId 
				,OrderDate 
				,TotalPrice
				,IsCancelled
	FROM		[dbo].[Dyn_Order]

	WHERE		 UserId			=	ISNULL(@UserId, UserId)
	AND			(OrderDate		>=	@FromDate	OR @FromDate		IS NULL)
	AND			(OrderDate		<	@ToDate		OR @ToDate			IS NULL)
	AND			(@IsCancelled		IS NULL		OR (@IsCancelled	IS NOT NULL AND IsCancelled = @IsCancelled));

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------
