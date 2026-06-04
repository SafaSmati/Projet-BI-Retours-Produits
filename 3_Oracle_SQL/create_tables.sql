-- CREATION DU DATA WAREHOUSE : SCHEMA EN ETOILE
-- DIM_TEMPS
CREATE TABLE DIM_TEMPS (
date_key NUMBER PRIMARY KEY,
full_date DATE,
year NUMBER,
quarter NUMBER,
month NUMBER,
month_name VARCHAR2(20),
week NUMBER,
day_of_week NUMBER,
is_weekend NUMBER(1)
);
-- DIM_PRODUIT
CREATE TABLE DIM_PRODUIT (
product_key NUMBER PRIMARY KEY,
category_name VARCHAR2(50),
supplier_id NUMBER,
unit_price NUMBER(10,2),
price_band VARCHAR2(10)
);
-- DIM_MAGASIN
CREATE TABLE DIM_MAGASIN (
store_key NUMBER PRIMARY KEY,
city VARCHAR2(50)
);
-- DIM_CLIENT
CREATE TABLE DIM_CLIENT (
customer_key NUMBER PRIMARY KEY,
city VARCHAR2(50),
signup_date DATE,
signup_year NUMBER
);
-- FACT_RETOURS
CREATE TABLE FACT_RETOURS (
return_id NUMBER,
order_item_id NUMBER, -- DD : traçabilité grain
product_key NUMBER,
store_key NUMBER,
customer_key NUMBER,
date_key NUMBER,
refund_amount NUMBER(10,2),
qty_returned NUMBER,
unit_price NUMBER(10,2),
total_lost NUMBER(10,2),
has_promotion NUMBER(1) DEFAULT 0,
CONSTRAINT pk_fact_retours PRIMARY KEY (return_id),
CONSTRAINT fk_date FOREIGN KEY (date_key)
REFERENCES DIM_TEMPS(date_key),
CONSTRAINT fk_product FOREIGN KEY (product_key)
REFERENCES DIM_PRODUIT(product_key),
CONSTRAINT fk_store FOREIGN KEY (store_key)
REFERENCES DIM_MAGASIN(store_key),
CONSTRAINT fk_customer FOREIGN KEY (customer_key)
REFERENCES DIM_CLIENT(customer_key)
);