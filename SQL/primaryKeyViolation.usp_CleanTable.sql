
use [DBLAB]
go


if schema_id('primaryKeyViolation') is null
begin

	exec('create schema [primaryKeyViolation]  authorization [dbo]')

end

/* First shot */

if OBJECT_ID('[primaryKeyViolation].[usp_IncrementData]') IS NOT NULL
begin

	drop proc [primaryKeyViolation].[usp_IncrementData]

end
go

if OBJECT_ID('[primaryKeyViolation].[usp_CleanTable]') IS NULL
begin
	exec('create procedure [primaryKeyViolation].[usp_CleanTable] as select 1/0 as [shell] ')
end
go
 
alter procedure [primaryKeyViolation].[usp_CleanTable]
as
begin

	truncate table [primaryKeyViolation].[repository];

end
go
