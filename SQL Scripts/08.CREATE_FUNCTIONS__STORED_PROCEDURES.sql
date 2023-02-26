USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.SP_CheckExists
	(@UserId	varchar(20),
	 @UserName	varchar(20),
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
	 @UserName	varchar(20),
	 @HashPassword	varchar(64))
AS	  			
	PRINT 'BEFORE TRY'
	BEGIN TRY
			PRINT 'First Statement in the TRY block'
			BEGIN
				SELECT COUNT(*) 
				FROM  [dbo].[Dyn_User] 
				WHERE (
					(Email = @Email			 AND @UserName IS NULL) 
					OR 
		 			(UserName = @UserName	 AND @Email IS NULL)
					OR
					(@UserName IS NOT NULL	 AND @Email IS NOT NULL
					AND 
					UserName = @UserName AND Email = @Email))
				AND	HashPassword = @HashPassword
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
				EmailConfirmed,
				IsActive

		FROM	dbo.Dyn_User 
		WHERE   UserRole = @UserRole;


		--AS U INNER JOIN [dbo].[Dic_UserRole] AS UR 
		--		ON U.UserRole = UR.UserRole
		--(@RoleId IS NOT NULL AND @RoleName IS NULL AND U.UserRole = @RoleId)
		--OR		(@RoleId IS NULL AND @RoleName IS NOT NULL AND UR.UserRole = @RoleName)
		--OR		(@RoleId IS NOT NULL AND @RoleName IS NOT NULL AND U.UserRole = @RoleId AND UR.UserRole = @RoleName);

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

		SELECT	 SUM(TotalPrice)

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
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.SP_GetOrders
	@UserId		varchar(20)	= NULL,
	@FromDate	date		= NULL,
	@ToDate		date		= NULL,
	@IsActive	bit			= NULL
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'
				SELECT	 OrderId, 
						 OrderName, 
						 UserId, 
						 OrderDate, 
						 TotalPrice,
						 IsActive

				FROM	 dbo.Dyn_Order
				WHERE	 UserId		=	ISNULL(@UserId, UserId)
				AND		(OrderDate	>=	@FromDate	OR @FromDate	IS NULL)
				AND		(OrderDate	<	@ToDate		OR @ToDate		IS NULL)
				AND		(@IsActive		IS NULL		OR (@IsActive	IS NOT NULL AND IsActive = @IsActive));

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
