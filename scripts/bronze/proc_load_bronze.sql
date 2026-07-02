 --1---inserting data into table created
--1--- FULL LOAD 
--2---- TRUNCATING THE TABLE AND THEN DOING THE FULL LOAD
-- 3----create stored procedure to have eazy run 
/*  
CREATE PROCEDURE load_bronze_customers
AS
BEGIN

TRUNCATE TABLE bronze.customers;

INSERT INTO bronze.customers
SELECT *
FROM source.customers;

END  


-- 4---now whenever you wnat this to run just run 

EXEC load_bronze_customers;

*/ 


-- 5---also use try and catch block in order to handle error if any 
---6-- ALSO calculate time of loading and executing time 
-- 7-- How long it takes to load whole bronze layer
/*Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;*/
create or alter  procedure bronze.load_bronze AS
begin 
    DECLARE @start_timing Datetime,@end_timing datetime,@batch_start datetime ,@batch_end datetime 
	BEGIN TRY
		print '============================';
		print 'loading the bronze layer';
		print '============================';


		print '----------------------------';
		print 'loading the crm table';
		print '----------------------------';
		print '>> truncating data ';

		set @batch_start = getdate()

		set @start_timing = getdate()
		TRUNCATE TABLE bronze.crm_cust_info; 
		print '<>> inseritng the data'-- TREUNCATE EVERY TABLE BECAUSE EVERY TIME WE RUN THE QUERY OUR DATA GETS DUPLICATED AND FILLED SO BETTER TO DELETE OLD TABLE
		BULK INSERT bronze.crm_cust_info
		from 'C:\Users\RITIK\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			 FIRSTROW = 2, -- ASKING TO TAKE second row as starting row
			 FIELDTERMINATOR =',',  -- FIELD SEPERATOR CHECK IT INTO ACTUAL TABLE(IN CSV) HOW COLUKN DATA IS SEPERATED
			 TABLOCK  -- TO LOOK BEAUTIFUL
		 );
		set @end_timing = getdate()
		print '>> duration ' +cast ((datediff(second,@start_timing,@end_timing)) as NVARCHAR);
		PRINT'---------------------------------------------------'

		set @start_timing = getdate()
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		from 'C:\Users\RITIK\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- LOCK THE TABLE FOR FASTER WORK AND OTHER USERS CANT USE IT
		);
		set @end_timing = getdate()
		print '>> duration ' +cast ((datediff(second,@start_timing,@end_timing)) as NVARCHAR);

		PRINT'---------------------------------------------------'
        set @start_timing = getdate()
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\RITIK\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_timing = getdate()
		print '>> duration ' +cast ((datediff(second,@start_timing,@end_timing)) as NVARCHAR);

		PRINT'---------------------------------------------------'

		print '----------------------------';
		print 'loading the erp table';
		print '----------------------------';


		set @start_timing = getdate()
		TRUNCATE TABLE bronze.erp_CUST_AZ12;
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\RITIK\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_timing = getdate()
		print '>> duration ' +cast ((datediff(second,@start_timing,@end_timing)) as NVARCHAR);

		PRINT'---------------------------------------------------'
		
		set @start_timing = getdate()
		TRUNCATE TABLE bronze.erp_LOC_A101;
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\RITIK\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_timing = getdate()
		print '>> duration ' +cast ((datediff(second,@start_timing,@end_timing)) as NVARCHAR);

		PRINT'---------------------------------------------------'

		set @start_timing = getdate()
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\RITIK\Downloads\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		set @end_timing = getdate()
		print '>> duration ' +cast ((datediff(second,@start_timing,@end_timing)) as NVARCHAR) + ' SECONDS';

		PRINT'---------------------------------------------------'
	END TRY 
	BEGIN CATCH
	PRINT'================================='
	PRINT 'ERROR OCCURED'+ ERROR_MESSAGE();
	PRINT '================================'
	END CATCH 
end
set @batch_end = getdate()
print '>> total load duration ' +cast ((datediff(second,@batch_start,@batch_end)) as NVARCHAR);

GO -- is must to ensure thid exec is occuring out of stored procedure


EXEC bronze.load_bronze  --- to run all uper code just run this to load bronze layer 

