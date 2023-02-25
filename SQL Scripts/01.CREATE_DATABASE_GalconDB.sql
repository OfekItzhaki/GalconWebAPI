USE [master]
GO
WHILE EXISTS(SELECT * FROM sys.databases WHERE NAME='GalconDB')
	BEGIN
		PRINT 'Drop database [GalconDB]'
		DECLARE @SQL varchar(max)
		SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
		FROM MASTER..SysProcesses
		WHERE DBId = DB_ID(N'GalconDB') AND SPId <> @@SPId
		EXEC(@SQL)
		DROP DATABASE [GalconDB]
	END
	GO

PRINT 'Create database [GalconDB]'
CREATE DATABASE [GalconDB]
GO
USE [GalconDB];
GO
