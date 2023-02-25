USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('dbo.Dyn_UserAccount','U') IS NOT NULL
		DROP TABLE dbo.Dyn_UserAccount;
	GO
CREATE TABLE dbo.Dyn_UserAccount 
		(Id							int IDENTITY(1,1)	NOT NULL, 
		 UserId						varchar(20) UNIQUE	NOT NULL, 
		 UserName					varchar(20) UNIQUE	NOT NULL, 
		 HashPassWord				varchar(64)			NOT NULL,
		 LastPasswordUpdatedTime	dateTime			NOT NULL,
		 PasswordExpirationTime		dateTime			NOT NULL,
		 CONSTRAINT PK_Dyn_UserAccount_Id		PRIMARY KEY			CLUSTERED(Id),
		 CONSTRAINT FK_Dyn_UserAccount_UserId	FOREIGN KEY(UserId) REFERENCES dbo.Dyn_UserData(UserId)
	);
GO
------------------------------------------------------------------------- 
DELETE FROM dbo.Dyn_UserAccount;
--INSERT INTO dbo.Dyn_UserAccount (UserId, UserName, HashPassword, CreatedTime, LastPasswordUpdatedTime, PasswordExpirationTime) 
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
	FROM	dbo.Dyn_UserAccount 
--	WHERE	...
	ORDER BY Id;
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_UserAccount_Get
		@UserId		varchar(20)	= NULL,
		@UserName	varchar(20) = NULL
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		SELECT		UserId,
					UserName,
					HashPassword,
					LastPasswordUpdatedTime,
					PasswordExpirationTime

			FROM	dbo.Dyn_UserAccount 
			WHERE   UserId = @UserId
			OR		UserName = @UserName;
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "UserAccount" table')
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_UserAccount_Insert
	@UserId						varchar(20),
	@UserName					varchar(20),
	@HashPassWord				varchar(64),
	@LastPasswordUpdatedTime	datetime,
	@PasswordExpirationTime		datetime
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			INSERT INTO dbo.Dyn_UserAccount
								(UserId,
								 UserName,
								 HashPassWord,
								 LastPasswordUpdatedTime,
								 PasswordExpirationTime)
			VALUES				(@UserId,
								 @UserName,
								 @HashPassWord,
								 @LastPasswordUpdatedTime,
								 @PasswordExpirationTime)

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Insert a NULL Value into the "UserAccount" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_UserAccount_Update
	@UserId						varchar(20),
	@OldPassword				varchar(64),
	@NewPassword				varchar(64),
	@LastPasswordUpdatedTime	datetime,
	@PasswordExpirationTime		datetime
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			BEGIN
				UPDATE dbo.Dyn_UserAccount
				SET		UserId					=	@UserId,
						HashPassWord			=	@NewPassword,
						LastPasswordUpdatedTime	=	@LastPasswordUpdatedTime,
						PasswordExpirationTime	=	@PasswordExpirationTime

				WHERE	UserId					=	@UserId
			END

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Update a NULL Value into the "UserAccount" table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;
			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dyn_UserAccount_Delete
	@UserId varchar(20)
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			DELETE FROM dbo.Dyn_UserAccount
			WHERE		UserId = UserId

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Cannot Delete a NULL Value from the "UserAccount" Table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
-------------------------------------------------------------------------