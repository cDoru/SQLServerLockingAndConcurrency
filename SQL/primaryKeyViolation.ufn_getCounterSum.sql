IF OBJECT_ID (N'[primaryKeyViolation].[ufn_getCounterSum]', N'FN') IS NOT NULL
begin

    DROP FUNCTION [primaryKeyViolation].[ufn_getCounterSum]

end
GO

CREATE FUNCTION [primaryKeyViolation].[ufn_getCounterSum]
()
RETURNS bigint 
AS 
begin

	return
		(

			select
					[NumberOfCounters]
						= sum([counter])
					
			from    [primaryKeyViolation].[repository]
						with (nolock)
			
		) 
end
go
