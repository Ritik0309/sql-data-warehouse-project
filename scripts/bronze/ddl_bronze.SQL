-- create table
/*
creates bronze schema tabel 
*/
if object_id('bronze.crm_cust_info', 'u') is not null 
  drop table bronze.crm_cust_info
go
create table bronze.crm_cust_info(
	cst_id INT,
	cst_key Nvarchar(50),
	cst_firstname Nvarchar(50),
	cst_lastname Nvarchar(50),
	cst_martial_status Nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
);
if object_id('bronze.crm_prd_info', 'u') is not null 
  drop table bronze.crm_prd_info
go
--drop table bronze.crm_prd_info
create table bronze.crm_prd_info(
	prd_id INT,
	prd_key Nvarchar(50),
	prd_nm NVARCHAR(50),
	prd_cst int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);
if object_id('bronze.crm_sales_details', 'u') is not null 
  drop table bronze.crm_sales_details
go
--drop table bronze.crm_sales_details
create table bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int ,
	sls_price int 
);
if object_id('bronze.erp_CUST_AZ12', 'u') is not null 
  drop table bronze.erp_CUST_AZ12
go

create table bronze.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN nvarchar(50)
);
if object_id('bronze.erp_LOC_A101', 'u') is not null 
  drop table bronze.erp_LOC_A101
go

create table bronze.erp_LOC_A101(
	CID nvarchar(50),
	cntry varchar(50)

);
if object_id('bronze.erp_PX_CAT_G1V2', 'u') is not null 
  drop table bronze.erp_PX_CAT_G1V2
go

create table bronze.erp_PX_CAT_G1V2(
	ID nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)

);
