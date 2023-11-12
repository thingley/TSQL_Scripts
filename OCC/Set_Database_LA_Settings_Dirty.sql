--select * from dbo.TrefSys_LASetting order by LADescriptionShort

UPDATE dbo.TSys_Setting SET
	ONSCode = las.ONSCode
	, LADescriptionShort = las.LADescriptionShort
	, LADescriptionLong = las.LADescriptionLong
	, StoredProcedureSuffix = las.StoredProcedureSuffix
	, LADescriptionExternal = las.LADescriptionExternal
	--, HasProtocol = las.HasProtocol
	--, HasGenericWebService = las.HasGenericWebService
	--, IsChildren = las.IsChildren
	--, GWSMastersCPLISAndClients = las.GWSMastersCPLIsAndClients 

	-- , PaymentsSlack = las.PaymentsSlack
	--, HasProtocol = las.HasProtocol
	--, HasProviderPortal = las.HasProviderPortal
FROM dbo.TRefSys_LASetting las
WHERE las.ONSCode = '00AH-A';

EXEC dbo.SYS_Deploy;
EXEC dbo.SYS_IgnoreDifferenceFromLASetting;

select
	s.ONSCode
	, s.HasFinancialProtection
	, s.DatabaseVersion
	, s.DatabasePatchNumber
	, s.HasApplicationServiceUserEmails
	, s.LADescriptionShort
from dbo.tsys_setting s

