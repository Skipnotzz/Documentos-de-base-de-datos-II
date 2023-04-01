MERGE RegionPrueba AS TARGET
USING Region AS SOURCE 
ON (TARGET.RegionID = SOURCE.RegionID) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.RegionDescription <> SOURCE.RegionDescription  
THEN UPDATE SET TARGET.RegionDescription = SOURCE.RegionDescription
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (RegionID, RegionDescription) VALUES (SOURCE.RegionID, SOURCE.RegionDescription);
--When there is a row that exists in target and same record does not exist in source then delete this record target
--WHEN NOT MATCHED BY SOURCE 
--THEN DELETE 
--
Select *  from Region
Delete from RegionPrueba