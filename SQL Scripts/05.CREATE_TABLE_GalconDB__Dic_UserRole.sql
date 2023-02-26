USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('dbo.Dic_UserRole','U') IS NOT NULL
		DROP TABLE dbo.Dic_UserRole;
	GO
CREATE TABLE dbo.Dic_UserRole 
		(RoleId int IDENTITY(1,1) NOT NULL, UserRole varchar(40) UNIQUE NOT NULL
		,CONSTRAINT PK_Dic_UserRole_RoleId PRIMARY KEY CLUSTERED (RoleId)
	);
GO
------------------------------------------------------------------------- 
--DELETE FROM dbo.Dic_UserRole;
INSERT INTO dbo.Dic_UserRole (UserRole) 
			SELECT				'User'
UNION ALL	SELECT				'Admin'
-------------------------------------------------------------------------
	SELECT	* 
	FROM	dbo.Dic_UserRole 
--	WHERE	...
	ORDER BY RoleId;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
USE [GalconDB]
GO
CREATE OR ALTER PROCEDURE dbo.Dic_UserRole_Get
	@RoleId int = 0
AS
	PRINT 'BEFORE TRY'
	BEGIN TRY
		BEGIN TRAN
			PRINT 'First Statement in the TRY block'

			SELECT		RoleId,
						UserRole

			FROM		dbo.Dic_UserRole 
			WHERE		RoleId = ISNULL(@RoleId, RoleId)
			ORDER BY	RoleId;

			PRINT 'Last Statement in the TRY block'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		PRINT('Error! Select "Dic_UserRole" table')
			IF(@@TRANCOUNT > 0)
				ROLLBACK TRAN;

			THROW; -- raise error to the client
	END CATCH
	PRINT 'After END CATCH'
GO
-------------------------------------------------------------------------
-------------------------------------------------------------------------