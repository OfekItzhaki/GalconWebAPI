USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.SP_CheckExists
	(@UserId	varchar(20),
	 @UserName	varchar(30),
	 @Tel		varchar(15),	
	 @Email		varchar(320))
AS	  			
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
			BEGIN
				EXEC dbo.Dyn_User_Get	@UserId		= @UserId,
										@UserName	= @UserName,
										@Tel		= @Tel, 
										@Email		= @Email;
			END

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! SP_CheckExists')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;
			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
--------------------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.SP_Login
	(@Email		varchar(320),
	 @UserName	varchar(30),
	 @HashPassword	varchar(30))
AS	  			
	PRINT 'BEFORE TRY'
	BEGIN TRY
			PRINT 'First Statement in the TRY block'
			BEGIN
				SELECT COUNT(*) 
				FROM [dbo].[Dyn_User] 
				WHERE (Email		= @Email
				OR	   UserName		= @UserName)
				AND	   HashPassword = @HashPassword
			END

			PRINT 'Last Statement in the TRY block'
	END TRY
	BEGIN CATCH
		PRINT('Error! SP_Login')
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.SP_GetUsersByRole
	@UserRole	int
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
				EmailConfirmed

		FROM	dbo.Dyn_User 
		WHERE   UserRole = @UserRole;

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
CREATE OR ALTER PROCEDURE dbo.SP_GetOrdersSum
	@UserId		varchar(20),
	@FromDate	datetime,
	@ToDate		datetime
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		PRINT 'First Statement in the TRY block'

		SELECT	 TotalPrice

		FROM	 dbo.Dyn_Order
		WHERE	 UserId		=	ISNULL(@UserId, UserId)
		AND		(OrderDate	>=	@FromDate	OR @FromDate	IS NULL)
		AND		(OrderDate	<=	@ToDate		OR @ToDate		IS NULL);

		PRINT 'Last Statement in the TRY block'
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "UserData" table')
	END CATCH
	PRINT 'After END CATCH'
GO