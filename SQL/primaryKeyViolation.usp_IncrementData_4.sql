if OBJECT_ID('[primaryKeyViolation].[usp_IncrementData_4]') IS NULL
begin
	exec('create procedure [primaryKeyViolation].[usp_IncrementData_4] as select 1/0 as [shell] ')
end
go
 
alter procedure [primaryKeyViolation].[usp_IncrementData_4]
(
	@id int
)
as
begin

	declare @name nchar(100)
	
	set @name = cast(@id as nchar(100))
 
    set transaction isolation level serializable;

	begin transaction

		if exists (
					select 1 
					from   [primaryKeyViolation].[repository] with (updlock)
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
