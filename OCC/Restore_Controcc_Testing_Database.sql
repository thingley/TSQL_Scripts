USE [master];
GO

ALTER DATABASE [Controcc_Testing_] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE [Controcc_Testing_]
	FROM  DISK = N'D:\TEMP\patchedEmptyDatabase.v131to140.20231106-122359.2014.bak' WITH  FILE = 1
	,  MOVE N'ContrOCC_Install_Empty' TO N'D:\SQL_SERVER\2014\Data\Controcc_Testing_.mdf'
	,  MOVE N'ContrOCC_Install_Empty_log' TO N'D:\SQL_SERVER\2014\Logs\Controcc_Testing_.ldf'
	,  NOUNLOAD
	,  REPLACE
	,  STATS = 5;
GO

ALTER DATABASE [Controcc_Testing_] SET MULTI_USER;
GO

EXEC [Controcc_Testing_].dbo.SYS_CreateOCCAdmin;
EXEC [Controcc_Testing_].dbo.SYS_Deploy;
EXEC [Controcc_Testing_].dbo.SYS_IgnoreDifferenceFromLASetting;
GO

--UPDATE [Controcc_Testing_].dbo.TRef_ContractType SET CPLIAuthorisationRequiredIfNotProtocol = 0;
--UPDATE [Controcc_Testing_].dbo.TSys_Setting SET HasProtocol = 1;
--UPDATE [Controcc_Testing_].dbo.TSys_Global_ReadOnly_ExternalEntityType SET [Disabled] = 0;

--UPDATE [Controcc_Testing_].dbo.T_Client SET OtherExternalReference = ClientID;
--UPDATE [Controcc_Testing_].dbo.T_CarePackageLineItem SET ExternalReference = CarePackageLineItemID;
GO

select * from [Controcc_Testing_].dbo.TSys_Setting;

