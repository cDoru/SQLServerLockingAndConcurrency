if schema_id('primaryKeyViolation') is null
begin

	exec('create schema [primaryKeyViolation]  authorization [dbo]')

end


if OBJECT_ID('[primaryKeyViolation].[usp_IncrementData_6]') IS NULL
begin
	exec('create procedure [primaryKeyViolation].[usp_IncrementData_6] as select 1/0 as [shell] ')
end
go
 
alter procedure [primaryKeyViolation].[usp_IncrementData_6]
(
	@id int
)
as
begin

	declare @name nchar(100)
	
	set @name = cast(@id as nchar(100))
 
	begin transaction

		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		
		MERGE [primaryKeyViolation].[repository] with (UPDLOCK) AS tblTarget
			USING (
					
					SELECT @id AS id
						
				  ) AS tblSource
				ON 
					(
						tblSource.[Id] = tblTarget.[id]
					)						
			WHEN MATCHED THEN UPDATE
			
				SET [counter] = tblTarget.[counter] + 1
				
			WHEN NOT MATCHED THEN 
			
				INSERT 
				(
					  id
					, name
					, [counter]
				) 
				VALUES 
				(
					  @id
					, @name
					, 1
				);

	commit
end
go
