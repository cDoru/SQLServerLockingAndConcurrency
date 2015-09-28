if schema_id('primaryKeyViolation') is null
begin

	exec('create schema [primaryKeyViolation]  authorization [dbo]')

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
