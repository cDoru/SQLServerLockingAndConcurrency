set noexec off
go

use [DBLAB]
go


if schema_id('primaryKeyViolation') is null
begin

	exec('create schema [primaryKeyViolation]  authorization [dbo]')

end


/*

	drop table [primaryKeyViolation].[repository];

*/

if OBJECT_ID('[primaryKeyViolation].[repository]') IS NOT NULL
begin

	set noexec on

end
    
go
 
create table [primaryKeyViolation].[repository]
(
      id bigint
    , [name] nchar(100)
    , counter int

    , constraint PK_primaryKeyViolation_REPOSITORY
		   primary key 
			 (
			  	[id]
			 )
    
	, constraint uniqueprimaryKeyViolationName unique 
		(
		  [name]
		)
);
go

set noexec off
go
