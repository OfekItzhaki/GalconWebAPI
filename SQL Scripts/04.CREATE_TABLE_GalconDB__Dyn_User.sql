USE [GalconDB]
GO
-------------------------------------------------------------------------
IF OBJECT_ID('[dbo].[Dyn_User]','U') IS NOT NULL
	DROP TABLE [dbo].[Dyn_User];
GO
CREATE TABLE [dbo].[Dyn_User] 
		(UserId						int		IDENTITY(1,1)	NOT NULL
		,UserName					varchar(20)				NOT NULL 
		,HashPassWord				nvarchar(64)			NOT NULL
		,LastPasswordUpdatedTime	dateTime				NULL
		,PasswordExpirationTime		dateTime				NOT NULL
		,UserRole					int						NOT NULL 
		,CreationTime				dateTime				NOT NULL 
		,LastUpdatedTime			dateTime				NULL
		,FirstName					varchar(30)				NOT NULL 
		,LastName					varchar(30)				NOT NULL 
		,Tel						varchar(15)				NOT NULL 
		,Email						varchar(320)			NOT NULL 
		,EmailConfirmed				bit						NOT NULL
		,IsActive					bit						NOT NULL

		,CONSTRAINT PK_Dyn_User_Id			PRIMARY KEY CLUSTERED(UserId)
		,CONSTRAINT UK_Dyn_User_UserName	UNIQUE		NONCLUSTERED(UserName)
	);
GO
------------------------------------------------------------------------- 
DELETE FROM [dbo].[Dyn_User];
--INSERT INTO [dbo].[Dyn_User] (UserId, UserRole, CreationTime, LastUpdatedTime, UserId, FirstName, LastName, Tel, Email, EmailConfirmed) 
--			SELECT					
--UNION ALL SELECT					
-------------------------------------------------------------------------
	SELECT	* 
	FROM	[dbo].[Dyn_User] 
--	WHERE	...
	ORDER BY UserId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Get Users
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dyn_User_Get]	 
				    @UserId		= NULL
				   ,@UserName	= NULL
				   ,@Tel		= NULL
				   ,@Email		= NULL;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Get]
		 @UserId	int			 = NULL
		,@UserName	varchar(20)  = NULL
		,@Tel		varchar(15)  = NULL
		,@Email		varchar(320) = NULL
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg		varchar(1000)	= '';
	DECLARE @EmptyPass	varchar(64)		= '';

	SELECT	 UserId
			,UserName
			,@EmptyPass AS 'HashPassword'
			,LastPasswordUpdatedTime
			,PasswordExpirationTime	
			,UserRole
			,CreationTime
			,LastUpdatedTime
			,FirstName
			,LastName
			,Tel
			,Email
			,EmailConfirmed
			,IsActive

	FROM		[dbo].[Dyn_User] 
	WHERE	(	(	(UserId		= @UserId		OR @UserId		IS NULL)
				AND	(UserName	= @UserName		OR @UserName	IS NULL)
				AND	(Tel		= @Tel			OR @Tel			IS NULL)
				AND	(Email		= @Email		OR @Email		IS NULL)	)
			OR	(	@UserId		IS NULL
				AND	@UserName	IS NULL
				AND	@Tel		IS NULL
				AND	@Email		IS NULL	)	)
	ORDER BY	UserId;

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
--Description: Insert User
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	 @UserId int;
	EXEC [dbo].[Dyn_User_Insert] 
		 @UserId					= @UserId	OUTPUT
		,@UserName					= 'User02'
		,@HashPassWord				= 'Password'
		,@UserRole					= 1
		,@FirstName					= 'First'
		,@LastName					= 'Last'
		,@Tel						= '0548473849'
		,@Email						= 'this@gmail.com';
	SELECT * FROM [dbo].[Dyn_User] WITH(nolock) WHERE UserId = @UserId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Insert]
	 @UserId					int			OUTPUT
	,@UserName					varchar(20)
	,@HashPassWord				nvarchar(64)
	,@UserRole					int
    ,@FirstName					varchar(30)
	,@LastName					varchar(30)
    ,@Tel						varchar(15)
	,@Email						varchar(320)
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';
	DECLARE @FutureExpirationTime datetime = GetDate() + 120;

	INSERT INTO [dbo].[Dyn_User]
				(UserName
				,HashPassWord
				,LastPasswordUpdatedTime
				,PasswordExpirationTime
				,UserRole
				,CreationTime
				,LastUpdatedTime
				,FirstName
				,LastName
				,Tel
				,Email
				,EmailConfirmed
				,IsActive)

	VALUES	    (@UserName
			    ,@HashPassWord
			    ,GetDate()
			    ,@FutureExpirationTime
			    ,@UserRole
			    ,GetDate()
			    ,GetDate()
			    ,@FirstName
			    ,@LastName
			    ,@Tel
			    ,@Email
			    ,0
			    ,1);
	SET	@UserId	= SCOPE_IDENTITY();

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
--Description: Update User
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@UserId						int				= 4;
	DECLARE	@HashPassWord				nvarchar(64)	= HASHBYTES('SHA2_256', 'Password');
	DECLARE	@OldPassword				nvarchar(64)	= HASHBYTES('SHA2_256', 'Old');
	DECLARE	@PasswordExpirationTime		datetime		= GetDate()
	DECLARE	@LastUpdatedTime			datetime		= GetDate()
	DECLARE	@IsActive					bit				= 0;
	EXEC [dbo].[Dyn_User_Update]
				@UserId						= @UserId
			   ,@UserName					= 'User02'
			   ,@HashPassWord				= @HashPassWord
			   ,@OldPassword				= @OldPassword
			   ,@PasswordExpirationTime		= @PasswordExpirationTime	
			   ,@UserRole					= 1
			   ,@FirstName					= 'First'
			   ,@LastName					= 'Last'
			   ,@Tel						= '0548473849'
			   ,@Email						= 'this@gmail.com'
			   ,@EmailConfirmed				= 0
			   ,@IsActive					= @IsActive;
	SELECT * FROM [dbo].[Dyn_User] WITH(nolock) WHERE UserId = @UserId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Update]
	 @UserId					int
	,@UserName					varchar(20)		= NULL
	,@HashPassWord				nvarchar(64)	= NULL
	,@OldPassword				nvarchar(64)	= NULL
	,@PasswordExpirationTime	dateTime		= NULL
	,@UserRole					int				= NULL
    ,@FirstName					varchar(30)		= NULL
	,@LastName					varchar(30)		= NULL
    ,@Tel						varchar(15)		= NULL
	,@Email						varchar(320)	= NULL
	,@EmailConfirmed			bit				= NULL
	,@IsActive					bit				= NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';
	DECLARE @TempPasswordUpdatedTime AS datetime

	IF EXISTS (SELECT TOP 1 1 FROM [dbo].[Dyn_User] WHERE HashPassWord = @HashPassWord)
		RAISERROR('New Password must not be the same as previous password',16,1);

	SET @TempPasswordUpdatedTime =  CASE	WHEN @OldPassword IS NOT NULL
											THEN GetDate() ELSE @PasswordExpirationTime
									END
	
	UPDATE	[dbo].[Dyn_User]
	SET		 UserName					= ISNULL(@UserName,					UserName)
			,HashPassWord				= ISNULL(@HashPassWord,				HashPassWord)
			,LastPasswordUpdatedTime	= @TempPasswordUpdatedTime
			,PasswordExpirationTime		= ISNULL(@PasswordExpirationTime,	PasswordExpirationTime)
			,UserRole					= ISNULL(@UserRole,					UserRole)
			,LastUpdatedTime			= GetDate()
			,FirstName					= ISNULL(@FirstName,				FirstName)
			,LastName					= ISNULL(@LastName,					LastName)
			,Tel						= ISNULL(@Tel,						Tel)
			,Email						= ISNULL(@Email,					Email)
			,EmailConfirmed				= ISNULL(@EmailConfirmed,			EmailConfirmed)
			,IsActive					= ISNULL(@IsActive,					IsActive)
	WHERE	 UserId = @UserId;

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
--Description: Delete User
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	DECLARE	@UserId int = 4;
	EXEC [dbo].[Dyn_User_Delete] @UserId = @UserId;
	SELECT * FROM [dbo].[Dyn_User] WITH(nolock)	WHERE UserId = @UserId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Delete]
	@UserId int
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';
	IF NOT EXISTS(	SELECT	TOP 1 1 
					FROM	[dbo].[Dyn_Order]
					WHERE	UserId = @UserId)
		DELETE FROM [dbo].[Dyn_User]
		WHERE		UserId		= @UserId
		AND			IsActive	= 0;

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------