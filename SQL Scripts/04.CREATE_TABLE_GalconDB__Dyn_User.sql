USE [GalconDB]
GO
-------------------------------------------------------------------------
IF OBJECT_ID('[dbo].[Dyn_User]','U') IS NOT NULL
	DROP TABLE [dbo].[Dyn_User];
GO
CREATE TABLE [dbo].[Dyn_User] 
		(UserId						int IDENTITY(1,1)	NOT NULL
		,UserName					varchar(20)			NOT NULL 
		,HashPassWord				varchar(64)			NOT NULL
		,LastPasswordUpdatedTime	dateTime			NULL
		,PasswordExpirationTime		dateTime			NOT NULL
		,UserRole					int					NOT NULL 
		,CreationTime				dateTime			NOT NULL 
		,LastUpdatedTime			dateTime			NULL
		,FirstName					varchar(30)			NOT NULL 
		,LastName					varchar(30)			NOT NULL 
		,Tel						varchar(15)			NOT NULL 
		,Email						varchar(320)		NOT NULL 
		,EmailConfirmed				bit					NOT NULL
		,IsActive					bit					NOT NULL

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
/*
--Description: Get Users
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dyn_User_Get]	 
				   (@UserId		= NULL
				   ,@UserName	= NULL
				   ,@Tel		= NULL
				   ,@Email		= NULL);
*/
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Get]
		(@UserId	int			 = NULL
		,@UserName	varchar(20)  = NULL
		,@Tel		varchar(15)  = NULL
		,@Email		varchar(320) = NULL)
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
	WHERE		UserId	= @UserId
	OR			UserName = @UserName
	OR			Tel		= @Tel
	OR			Email	= @Email
	ORDER BY	UserId;

	IF (@@ROWCOUNT = 0)
	BEGIN
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
		ORDER BY	UserId;

	END

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
	DECLARE	@OrderId int;
	EXEC [dbo].[Dyn_User_Insert] 
		(@UserName					= 'User'
		,@HashPassWord				= 'Password'
		,@LastPasswordUpdatedTime	= GetDate()
		,@PasswordExpirationTime	= GetDate()
		,@UserRole					= 1
		,@CreationTime				= GetDate()
		,@LastUpdatedTime			= GetDate()
		,@FirstName					= 'First'
		,@LastName					= 'Last'
		,@Tel						= '0548473849'
		,@Email						= 'this@gmail.com'
		,@EmailConfirmed			= 0
		,@IsActive					= 1;				
	SELECT * FROM [dbo].[Dyn_User] WITH(nolock) WHERE UserId = @UserId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Insert]
	(@UserName					varchar(20)
	,@HashPassWord				varchar(64)
	,@UserRole					int
    ,@FirstName					varchar(30)
	,@LastName					varchar(30)
    ,@Tel						varchar(15)
	,@Email						varchar(320))
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
			    ,NULL
			    ,@FirstName
			    ,@LastName
			    ,@Tel
			    ,@Email
			    ,0
			    ,1);

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
	EXEC [dbo].[Dyn_User_Update]
			   (@UserName					= 'User'
			   ,@HashPassWord				= 'Password'
			   ,@OldPassword				= 'Old'
			   ,@LastPasswordUpdatedTime	= GetDate()
			   ,@PasswordExpirationTime		= GetDAte()
			   ,@UserRole					= 1
			   ,@LastUpdatedTime			= GetDate()
			   ,@FirstName					= 'First'
			   ,@LastName					= 'Last'
			   ,@Tel						= '0548473849'
			   ,@Email						= 'this@gmail.com'
			   ,@EmailConfirmed				= 0
			   ,@IsActive					= 1);					
	SELECT * FROM [dbo].[Dyn_User] WITH(nolock) WHERE UserId = @UserId;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Update]
	(@UserId					int
	,@UserName					varchar(20)		= NULL
	,@HashPassWord				varchar(64)		= NULL			
	,@OldPassword				varchar(64)		= NULL
	,@PasswordExpirationTime	dateTime		= NULL			
	,@UserRole					int				= NULL	
    ,@FirstName					varchar(30)		= NULL			
	,@LastName					varchar(30)		= NULL			
    ,@Tel						varchar(15)		= NULL			
	,@Email						varchar(320)	= NULL				
	,@EmailConfirmed			bit				= NULL	
	,@IsActive					bit				= NULL)
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';
	Declare @TempPasswordUpdatedTime AS datetime

	SET @TempPasswordUpdatedTime =  CASE WHEN @OldPassword IS NOT NULL
										THEN GetDate() ELSE @PasswordExpirationTime
									END

	UPDATE	[dbo].[Dyn_User]
	SET		 UserName					= ISNULL(@UserName,					UserName)
			,HashPassWord				= ISNULL(@HashPassWord,				UserName)
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

	WHERE	 UserId = @UserId
	AND		(@OldPassword IS NULL OR (@OldPassword IS NOT NULL AND HashPassWord = @OldPassword));

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
	EXEC [dbo].[Dyn_User_Delete] @UserId = 1;
*/
CREATE OR ALTER PROCEDURE [dbo].[Dyn_User_Delete]
	@UserId int
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE	@ErrMsg varchar(1000) = '';

	DELETE FROM [dbo].[Dyn_User]
	WHERE		UserId = @UserId;

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------