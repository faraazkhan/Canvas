SET @row = 0;
select @row := @row + 1 as 'S.No', 
table_name As 'Table Name', 
column_name As 'Actual Field Name in the DB', 
TITLEIZE(REPLACE(column_name, '_', ' ')) As 'Field Name as shown in the Reporting Tool', 
CASE
	WHEN column_name = 'id' THEN ' Unique Identifier for each record in the table'
	WHEN column_name = 'created_at' THEN ' Date & Time of Record Creation'
	WHEN column_name = 'updated_at' THEN ' Date & Time the record was last updated'
	WHEN column_name = 'created_by_id' THEN 'ID of the User that created the record'
	WHEN column_name = 'updated_by_id' THEN 'ID of the User that last updated the record'
	WHEN column_name LIKE '%_id' and column_name != 'id' THEN concat('ID of the ', TITLEIZE(left(column_name, char_length(column_name)-2)), 'associated with the given ', TITLEIZE(left(table_name, char_length(table_name) - 1)))
	WHEN table_name like '%type%' OR table_name like '%group%' OR table_name like '%group%' or table_name = 'delivery_methods' or table_name = 'school_sub_regions' or table_name = 'hearing_officers' and column_name NOT IN ('id', 'created_at', 'updated_at', 'created_by_id', 'updated_by_id') THEN concat('Allowed ' , TITLEIZE(column_name), 's', ' for ', TITLEIZE(table_name))
END  AS 'Description',
CASE
	WHEN table_name = 'rosters' THEN 'Active Student Roster File from SLEDS'
	WHEN table_name = 'inactive_rosters' THEN 'Students Inactive File from SLEDS'
	WHEN table_name LIKE '%_timelinesses' THEN concat('Weekly ',TITLEIZE(left(table_name, char_length(table_name)-2)), ' Import')
	WHEN table_name = 'enrollments' THEN 'Daily Student Enrollment History Import from STARS'
	WHEN table_name = 'iep_documentations' THEN 'Weekly IEP Documentations Import'
	WHEN table_name = 'non_eligibilities' THEN 'Weekly Student Non Eligibility Import'
	WHEN table_name = 'non_public_placements' THEN 'Weekly NPP Import'
	WHEN table_name = 'sho_reconciliations' THEN 'Daily SHO Reconciliation Import'
	WHEN table_name = 'student_disabilities' THEN 'Weekly Student Disability Import'
	WHEN table_name = 'student_merges' THEN 'Student Merge Import from STARS'	
	WHEN table_name like '%type%' OR table_name like '%group%' OR table_name like '%group%' or table_name = 'delivery_methods' or table_name = 'school_sub_regions'  or table_name = 'hearing_officers' THEN 'Look Up Table'
	ELSE 'Information Created/Captured in Blackman Jones'
END as 'Source',
is_nullable As 'Can be NULL', 
data_type as 'Field Data Type', 
column_key As  'Key/Index Type'
from information_schema.columns where table_schema = 'bjv3_local'
and table_name not in ('bdrb_job_queues', 'access_requests', 'features', 'migration_logs', 'schema_migrations', 'email_templates' , 'groups', 'information_requests', 'school_dashboard_assignments')
-- Uncomment lines below to see how many rows you have to fill out manually
-- group by table_name, column_name
-- having `Description` is null

/*
For the query above to work add this UDF
DELIMITER $$
CREATE FUNCTION TITLEIZE (input VARCHAR(255))
 
RETURNS VARCHAR(255)
 
DETERMINISTIC
 
BEGIN
	DECLARE len INT;
	DECLARE i INT;
 
	SET len   = CHAR_LENGTH(input);
	SET input = REPLACE(LOWER(input), '_',' ');
	SET i = 0;
 
	WHILE (i < len) DO
		IF (MID(input,i,1) = ' ' OR i = 0) THEN
			IF (i < len) THEN
				SET input = CONCAT(
					LEFT(input,i),
					UPPER(MID(input,i + 1,1)),
					RIGHT(input,len - i - 1)
				);
			END IF;
		END IF;
		SET i = i + 1;
	END WHILE;
 
	RETURN input;
END $$
DELIMITER ;

*/

