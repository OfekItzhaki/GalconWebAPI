USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('dbo.Dyn_User','U') IS NOT NULL
		DROP TABLE dbo.Dyn_User;
	GO
CREATE TABLE dbo.Dyn_User 
		(Id							int IDENTITY(1,1)	NOT NULL,
		 UserId						varchar(20) UNIQUE	NOT NULL, 
		 UserName					varchar(20) UNIQUE	NOT NULL, 
		 HashPassWord				varchar(64)			NOT NULL,
		 LastPasswordUpdatedTime	dateTime			NOT NULL,
		 PasswordExpirationTime		dateTime			NOT NULL,
		 UserRole					int					NOT NULL, 
		 CreatedTime				dateTime			NOT NULL, 
		 LastUpdatedTime			dateTime			NULL,
		 FirstName					varchar(30)			NOT NULL, 
		 LastName					varchar(30)			NOT NULL, 
		 Tel						varchar(15)			NOT NULL, 
		 Email						varchar(320)		NOT NULL, 
		 EmailConfirmed				bit					NOT NULL,
		 IsActive					bit					NOT NULL,

		 CONSTRAINT PK_Dyn_User_Id PRIMARY KEY CLUSTERED(Id)
	);
GO
------------------------------------------------------------------------- 
DELETE FROM dbo.Dyn_User;
--INSERT INTO dbo.Dyn_User (UserId, UserRole, CreatedTime, LastUpdatedTime, UserId, FirstName, LastName, Tel, Email, EmailConfirmed) 
--			SELECT					
--UNION ALL SELECT					
-------------------------------------------------------------------------
	SELECT	* 
	FROM	dbo.Dyn_User 
--	WHERE	...
	ORDER BY UserId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_User_Get
		@UserId		varchar(20)	 = NULL,
		@UserName	varchar(20)  = NULL,
		@Tel		varchar(15)  = NULL,
		@Email		varchar(320) = NULL
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
			PRINT 'First Statement in the TRY block'

			SELECT	UserId,
					UserName,				
					HashPassWord,			
					LastPasswordUpdatedTime,
					PasswordExpirationTime,	
					UserRole,
					CreatedTime,
					LastUpdatedTime,
					FirstName,
					LastName,
					Tel,
					Email,
					EmailConfirmed,
					IsActive

			FROM	dbo.Dyn_User 
			WHERE   UserId	= @UserId
			OR		UserName = @UserName
			OR		Tel		= @Tel
			OR		Email	= @Email;

			PRINT 'Last Statement in the TRY block'
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "UserData" table')
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_User_Insert
	@UserId						varchar(20),
	@UserName					varchar(20),
	@HashPassWord				varchar(64),
	@LastPasswordUpdatedTime	datetime,
	@PasswordExpirationTime		datetime,
	@UserRole					int,
	@CreatedTime				dateTime,
    @LastUpdatedTime			dateTime,
    @FirstName					varchar(30),
	@LastName					varchar(30),
    @Tel						varchar(15),
	@Email						varchar(320),
	@EmailConfirmed				bit,
	@IsActive					bit
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			INSERT INTO dbo.Dyn_User
					   (UserId,
					    UserName,
						HashPassWord,
						LastPasswordUpdatedTime,
						PasswordExpirationTime,
						UserRole,
						CreatedTime,
						LastUpdatedTime,
						FirstName,
						LastName,
						Tel,
						Email,
						EmailConfirmed,
						IsActive)

			VALUES	   (@UserId,
						@UserName,
						@HashPassWord,
						@LastPasswordUpdatedTime,
						@PasswordExpirationTime,
						@UserRole,
						@CreatedTime,
						@LastUpdatedTime,
						@FirstName,
						@LastName,
						@Tel,
						@Email,
						@EmailConfirmed,
						@IsActive)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Insert a NULL Value into the "UserData" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_User_Update
	@UserId						varchar(20),
	@UserName					varchar(20),
	@HashPassWord				varchar(64),
	@OldPassword				varchar(64) = NULL,
	@LastPasswordUpdatedTime	dateTime,
	@PasswordExpirationTime		dateTime,
	@UserRole					int,
    @LastUpdatedTime			dateTime,
    @FirstName					varchar(30),
	@LastName					varchar(30),
    @Tel						varchar(15),
	@Email						varchar(320),
	@EmailConfirmed				bit,
	@IsActive					bit
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
			PRINT 'First Statement in the TRY block'

			UPDATE	dbo.Dyn_User
			SET		UserName				= @UserName,
					HashPassWord			= @HashPassWord,
					LastPasswordUpdatedTime = @LastPasswordUpdatedTime,
					PasswordExpirationTime	=  @PasswordExpirationTime,
					UserRole				= @UserRole,
					LastUpdatedTime			= @LastUpdatedTime,
					FirstName				= @FirstName,
					LastName				= @LastName,
					Tel						= @Tel,
					Email					= @Email,
					EmailConfirmed			= @EmailConfirmed,
					IsActive				= @IsActive

			WHERE	UserId = @UserId
			AND		(@OldPassword IS NULL OR (@OldPassword IS NOT NULL AND HashPassWord = @OldPassword))

			PRINT 'Last Statement in the TRY block'
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Update a NULL Value into the "UserData" table')
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_User_Delete
	@UserId varchar(20)
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			DELETE FROM dbo.Dyn_User
			WHERE  UserId = @UserId

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Delete a NULL Value from the "UserData" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
-------------------------------------------------------------------------