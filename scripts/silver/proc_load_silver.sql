CREATE OR ALTER PROCEDURE silver.load_silver as
Begin
	BEGIN TRY 
		print '-----------------------------------'
		print '>> truncating table silver.cut info'
		print '------------------------------------'
		Truncate table silver.crm_cust_info
		-- inseting silver.crm_cust_info
		INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_martial_status,
		cst_gndr,
		cst_create_date
		)
			select
				cst_id,
				cst_key, 
				trim(cst_firstname) as cst_firstname,
				trim(cst_lastname) as cst_lastname,
				(case when trim(cst_martial_status) =upper('S') THEN 'Single'
					 when trim(cst_martial_status) = upper('M') THEN 'Married'
					 ELSE 'n/a'
				end)as cst_martial_status,
				(case when trim(cst_gndr) =upper('F') THEN 'Female'
					 when trim(cst_gndr) = upper('M') THEN 'Male'
					 ELSE 'n/a'
				end) as cst_gndr, 
		
				cst_create_date
			from(
				select
					*,
					row_number() over(partition by cst_id order by cst_create_date) as flag_list
				from bronze.crm_cust_info
				where cst_id is NOT NuLL) t
			where flag_list = 1

   
		print '-----------------------------------------'
		print '>> truncating table silver.crm_prd_info'
		print '-----------------------------------------'
		Truncate table silver.crm_prd_info
		-- inseting silver.crm_prd_info

		INSERT INTO silver.crm_prd_info(
		  prd_id,
		  cat_id,
		  prd_key,
		  prd_nm,
		  prd_cst,
		  prd_line,
		  prd_start_dt,
		  prd_end_dt
		)
		select 
			prd_id,
			replace (substring(prd_key,1,5) ,'-' ,'_') as cat_id, -- extract category id
			substring(prd_key,7,len(prd_key)) as prd_key,
			prd_nm,
			Coalesce( prd_cst,0) as prd_cst,
			Case when prd_line =upper (Trim('M')) THEN 'Mountain'
				 when prd_line =upper (Trim('R')) THEN 'Road'
				 when prd_line =upper (Trim('S')) THEN 'Other Sales'
				 when prd_line =upper (Trim('T')) THEN 'Touring'
			ELSE 'n/a'
			END as prd_line,
			cast (prd_start_dt as date) as  prd_start_dt,
			cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt ) -1 AS date) as prd_end_dt
		from bronze.crm_prd_info

	

		print '-----------------------------------------'
		print '>> truncating table silver.crm_sales_details'
		print '-----------------------------------------'
		Truncate table silver.crm_sales_details
		-- inseting silver.crm_sales_details

		Insert into silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)
		select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case when sls_order_dt = 0  or len(sls_order_dt) != 8 then null
					 else CAST(CAST(sls_order_dt as varchar ) as date)
			end  as sls_order_dt,
			case when sls_ship_dt= 0  or len(sls_ship_dt) != 8 then null
					 else CAST(CAST(sls_ship_dt as varchar ) as date)
			end  as sls_ship_dt,
			case when sls_due_dt = 0  or len(sls_due_dt) != 8 then null
					 else CAST(CAST(sls_due_dt as varchar ) as date)
			end  as sls_due_dt,
			-- sales
			case when sls_Sales is null or sls_Sales <=0 or sls_Sales != sls_quantity* abs(Sls_price)
				  then sls_quantity * abs(Sls_price)
				  else sls_sales
			end as sls_sales,
			sls_quantity,
			case when sls_price is null or sls_price <=0
				 then sls_sales / NUllif(Sls_quantity ,0)
			else sls_price 
			end as sls_price 
		from bronze.crm_sales_details




		print '-----------------------------------------'
		print '>> truncating table silver.erp_LOC_A101'
		print '-----------------------------------------'
		Truncate table silver.erp_LOC_A101
		-- inseting silver.erp_LOC_A101

		INSERT INTO silver.erp_LOC_A101(
		cid,
		cntry
		)

		select 
		replace(cid,'-','') as cid2,
		case when trim(cntry) in ('us' , 'usa')  then 'United States'
			 when trim(cntry) = 'DE' then 'Germany'
			 when trim(cntry) = ' ' or CNTRY IS null  then 'n/a'
			 else trim(cntry)
		end as cntry
		from bronze.erp_LOC_A101

	

		print '-----------------------------------------'
		print '>> truncating table silver.erp_CUST_AZ12'
		print '-----------------------------------------'
		Truncate table silver.erp_CUST_AZ12
		-- inseting silver.erp_CUST_AZ12

		insert into silver.erp_CUST_AZ12(
		cid,
		bdate,
		gen
		)
		select 
			case when cid like 'NAS%'then substring(cid,4,len(cid))
				 else cid 
			end as cid,
			case when BDATE > GETDATE() then null 
				else bdate
			end as bdate,
			case when upper(trim(gen)) in ('F','Female') then 'Female'
				 when upper(trim(gen)) in ('M' ,'MALE' ) THEN 'Male'
				 ELSE 'n/a'
			end as gen
		from bronze.erp_cust_az12


	

		print '-----------------------------------------'
		print '>> truncating table silver.erp_PX_CAT_G1V2'
		print '-----------------------------------------'
		Truncate table silver.erp_PX_CAT_G1V2
		-- inseting silver.erp_PX_CAT_G1V2

		insert into silver.erp_PX_CAT_G1V2(
		id,
		cat,
		subcat,
		maintenance
		)
		select 
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_PX_CAT_G1V2
	END TRY 
	BEGIN CATCH
		PRINT'====================================='
		PRINT 'ERROR HAS OCCURED' + ERROR_MESSAGE()
		PRINT'====================================='
	END CATCH
END
GO
 EXEC silver.load_silver
