set "SQLInstance=LABDB"
set "database=DBLAB"

@REM Create Table
sqlcmd -E -S %SQLInstance% -d %database% -i primaryKeyViolation.repository.sql

@REM Clean Table
sqlcmd -E -S %SQLInstance% -d %database% -i primaryKeyViolation.usp_CleanTable.sql

@REM Get Number of Records successfully processed
sqlcmd -E -S %SQLInstance% -d %database% -i primaryKeyViolation.ufn_getCounterSum.sql

for /f %%f in ('dir /b primaryKeyViolation.usp_IncrementData*.sql /ON') do (
 
    echo Processing file : %%f
    sqlcmd -E -S%SQLInstance% -d %database% -b -i %%f
 
)   

