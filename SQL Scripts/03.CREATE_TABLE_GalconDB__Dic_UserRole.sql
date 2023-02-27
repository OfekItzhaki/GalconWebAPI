USE [GalconDB]
GO
-------------------------------------------------------------------------
	IF OBJECT_ID('[dbo].[Dic_UserRole]','U') IS NOT NULL
		DROP TABLE [dbo].[Dic_UserRole];
	GO
CREATE TABLE [dbo].[Dic_UserRole] 
		(RoleId int IDENTITY(1,1) NOT NULL, UserRole varchar(40) NOT NULL

		,CONSTRAINT PK_Dic_UserRole_RoleId		PRIMARY KEY CLUSTERED (RoleId)
		,CONSTRAINT UK_Dyn_UserRole_UserRole	UNIQUE		NONCLUSTERED(UserRole)
	);
GO
------------------------------------------------------------------------- 
--DELETE FROM dbo.Dic_UserRole;
SET		IDENTITY_INSERT [dbo].[Dic_UserRole] ON;
INSERT	INTO			[dbo].[Dic_UserRole] (RoleId, UserRole)
			SELECT				1		,'User'
UNION ALL	SELECT				2		,'Admin'
SET		IDENTITY_INSERT [dbo].[Dic_UserRole] OFF;
-------------------------------------------------------------------------
	SELECT	RoleId, UserRole 
	FROM	[dbo].[Dic_UserRole] 
--	WHERE	...
	ORDER BY RoleId;
-------------------------------------------------------------------------
USE [GalconDB]
GO
/*
--Description: Users Get
--Created: Ofek Itzhaki, "2023-02-24"
--Execution Example:
	EXEC [dbo].[Dic_UserRole_Get]	 
				@RoleId	= NULL
*/
CREATE OR ALTER PROCEDURE [dbo].[Dic_UserRole_Get]
	@RoleId int = 1
AS
BEGIN
BEGIN TRY
	DECLARE	@ErrMsg varchar(1000) = '';

	SELECT		RoleId,
				UserRole
	FROM		[dbo].[Dic_UserRole] 
	WHERE		RoleId = ISNULL(@RoleId, RoleId)
	ORDER BY	RoleId;

END TRY
BEGIN CATCH
	SET @ErrMsg = ERROR_MESSAGE();
	RAISERROR(@ErrMsg,16,1);
END CATCH
END
GO
-------------------------------------------------------------------------