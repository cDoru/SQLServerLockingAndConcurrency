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

if OBJECT_ID('[primaryKeyViolation].[usp_IncrementData_Base]') IS NULL
begin
	exec('create procedure [primaryKeyViolation].[usp_IncrementData_Base] as select 1/0 as [shell] ')
end
go
 
alter procedure [primaryKeyViolation].[usp_IncrementData_Base]
(
	  @method tinyint = 4
	, @id int
)
as
begin

	if (@method =1)
	begin

		exec [primaryKeyViolation].[usp_IncrementData_1] @id

	end
	else if (@method =2)
	begin

		exec [primaryKeyViolation].[usp_IncrementData_2] @id

	end

	else if (@method =3)
	begin

		exec [primaryKeyViolation].[usp_IncrementData_3] @id

	end
	else if (@method =4)
	begin

		exec [primaryKeyViolation].[usp_IncrementData_4] @id

	end

	else if (@method =5)
	begin

		exec [primaryKeyViolation].[usp_IncrementData_5] @id

	end

	else if (@method =6)
	begin

		exec [primaryKeyViolation].[usp_IncrementData_6] @id

	end

end
go

