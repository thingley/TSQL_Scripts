-- ====================================================================================================
-- SCRIPT INITIALISATION AND VALIDATION
-- ====================================================================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Constants
DECLARE
	@SQL_SERVER_COMP_LEVEL__2005	INT	= 90
	, @SQL_SERVER_COMP_LEVEL__2008	INT	= 100
	, @SQL_SERVER_COMP_LEVEL__2012	INT	= 110
	, @SEVERITY						INT	= 15
	, @STATE						INT	= 1;

-- Variables
DECLARE
	@CompatabilityLevel	INT				= NULL
	, @Database			NVARCHAR(MAX)	= NULL
	, @ErrorMessage		NVARCHAR(MAX)	= NULL;

SELECT @CompatabilityLevel = d.[compatibility_level]
FROM sys.databases d
WHERE d.database_id = DB_ID();

SET @database = DB_NAME();

-- Safety checks
IF (@Database IN ('master', 'tempdb', 'model', 'msdb'))
    GOTO SPError_SystemDatabase;

IF (@Database LIKE ('ReportServer$%'))
    GOTO SPError_ReportingDatabase;

IF (@CompatabilityLevel NOT IN (@SQL_SERVER_COMP_LEVEL__2005, @SQL_SERVER_COMP_LEVEL__2008, @SQL_SERVER_COMP_LEVEL__2012))
	GOTO SPError_DatabaseCompatabilityLevel;

-- ====================================================================================================
-- SCRIPT EXECUTION
-- ====================================================================================================

BEGIN TRY
	DECLARE @DatabaseID int;

	SET @DatabaseID = DB_ID();

	-- A) CLEAR DATA CACHE

	-- This forces all dirty pages for the current database to be written to disk and cleans the buffers.
	CHECKPOINT;

	-- This removes all clean buffers from the buffer pool.
	DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS;

	-- B) CLEAR THE PLAN CACHE

	-- This flushes the plan cache for the database.
	DBCC FLUSHPROCINDB (@DatabaseID) WITH NO_INFOMSGS;
END TRY
BEGIN CATCH
	SET @ErrorMessage = N'ERROR ' + CONVERT(NVARCHAR(100), ERROR_NUMBER()) + ': ' + ERROR_MESSAGE();
	
	GOTO SPError_CatchBlock;
END CATCH

-- ====================================================================================================
-- SCRIPT TERMINATION
-- ====================================================================================================

SPEnd:
    PRINT 'Script has completed!';
	RETURN;

SPError_SystemDatabase:
    RAISERROR('Script should not be run on a system database!', @SEVERITY , @STATE);
    RETURN;

SPError_ReportingDatabase:
    RAISERROR('Script should not be run on a report server database!', @SEVERITY , @STATE);
    RETURN;

SPError_DatabaseCompatabilityLevel:
	RAISERROR('The database compatalibity level (version) is not compatible with this script!', @SEVERITY , @STATE);
	RETURN;

SPError_CatchBlock:
	RAISERROR(@ErrorMessage, @SEVERITY , @STATE);
	RETURN;
