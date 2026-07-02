-- create table
if object_id('silver.crm_cust_info', 'u') is not null 
  drop table silver.crm_cust_info
go
create table silver.crm_cust_info(
	cst_id INT,
	cst_key Nvarchar(50),
	cst_firstname Nvarchar(50),
	cst_lastname Nvarchar(50),
	cst_martial_status Nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
	dwh_create_date datetime2 default getdate() -- metadata being added in silver column in order to keep track of actual data 
);
if object_id('silver.crm_prd_info', 'u') is not null 
  drop table silver.crm_prd_info
go
--drop table silver.crm_prd_info
create table silver.crm_prd_info(
	prd_id INT,
	cat_id Nvarchar(50), -- since we have created a cat_id in this 
	prd_key Nvarchar(50),
	prd_nm NVARCHAR(50),
	prd_cst int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate() -- metadata being added in silver column in order to keep track of actual data 
);
if object_id('silver.crm_sales_details', 'u') is not null 
  drop table silver.crm_sales_details
go
--drop table silver.crm_sales_details
create table silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id int,
	sls_order_dt date, -- from number to date data type being changed
	sls_ship_dt date,-- from number to date data type being changed
	sls_due_dt date,-- from number to date data type being changed
	sls_sales int,
	sls_quantity int ,
	sls_price int,
	dwh_create_date datetime2 default getdate() -- metadata being added in silver column in order to keep track of actual data 
);
if object_id('silver.erp_CUST_AZ12', 'u') is not null 
  drop table silver.erp_CUST_AZ12
go

create table silver.erp_CUST_AZ12(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN nvarchar(50),
dwh_create_date datetime2 default getdate() -- metadata being added in silver column in order to keep track of actual data 
);
if object_id('silver.erp_LOC_A101', 'u') is not null 
  drop table silver.erp_LOC_A101
go

create table silver.erp_LOC_A101(
	CID nvarchar(50),
	cntry varchar(50),
	dwh_create_date datetime2 default getdate() -- metadata being added in silver column in order to keep track of actual data 

);
if object_id('silver.erp_PX_CAT_G1V2', 'u') is not null 
  drop table silver.erp_PX_CAT_G1V2
go

create table silver.erp_PX_CAT_G1V2(
	ID nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50),
	dwh_create_date datetime2 default getdate() -- metadata being added in silver column in order to keep track of actual data 

);
go
