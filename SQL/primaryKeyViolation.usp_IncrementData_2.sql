if schema_id('primaryKeyViolation') is null
begin

	exec('create schema [primaryKeyViolation]  authorization [dbo]')

end


if OBJECT_ID('[primaryKeyViolation].[usp_IncrementData_2]') IS NULL
begin

	exec('create procedure [primaryKeyViolation].[usp_IncrementData_2] as select 1/0 as [shell] ')

end
go
 
alter procedure [primaryKeyViolation].[usp_IncrementData_2]
(
	@id int
)
as
begin

	declare @name nchar(100)
	
	set @name = cast(@id as nchar(100))
	
	/*
		Set transaction mode to read uncommitted
			"Dirty Read"
	*/ 
	set transaction isolation level read uncommitted		
	
	begin transaction
		
		
		if exists (
					select 1 
					from   [primaryKeyViolation].[repository] 
					where  id = @id
				)
		begin
		
			update [primaryKeyViolation].[repository]
			set    [counter] = [counter] + 1 
			where  [id] = @id;

		end
		else
		begin
		
			insert [primaryKeyViolation].[repository]
			 (
				[id], [name], [counter]
			 ) 
			 values
			  (
				  @id
				, @name
				, 1
			);
		end



	commit
	
end

go
 
