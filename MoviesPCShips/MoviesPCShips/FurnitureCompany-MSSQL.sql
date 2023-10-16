USE master
GO
if exists (select * from sysdatabases where name='furniture_company')
	DROP DATABASE furniture_company
GO

CREATE DATABASE furniture_company
GO
USE furniture_company
GO

CREATE TABLE PRODUCT (
	PRODUCT_ID INT NOT NULL PRIMARY KEY,
	PRODUCT_DESCRIPTION VARCHAR(255) NOT NULL,
	PRODUCT_FINISH VARCHAR(100) DEFAULT NULL,
	STANDARD_PRICE FLOAT DEFAULT 0.0,
	PRODUCT_LINE_ID INT NOT NULL
);

CREATE TABLE CUSTOMER (
	CUSTOMER_ID INT IDENTITY(1,1) PRIMARY KEY,
	CUSTOMER_NAME VARCHAR(255) NOT NULL,
	CUSTOMER_ADDRESS VARCHAR(255),
	CUSTOMER_CITY VARCHAR(255),
	CITY_CODE INT
);


CREATE TABLE ORDER_T (
	ORDER_ID INT NOT NULL PRIMARY KEY,
	ORDER_DATE DATE NOT NULL,
	CUSTOMER_ID INT NOT NULL
	CONSTRAINT FK_ORDER_T_CUSTOMER
		FOREIGN KEY (CUSTOMER_ID)
		REFERENCES CUSTOMER(CUSTOMER_ID)
);

CREATE TABLE ORDER_LINE (
	ORDER_ID INT NOT NULL,
	PRODUCT_ID INT NOT NULL,
	ORDER_QUANTITY INT NOT NULL
	CONSTRAINT FK_ORDER_LINE_PRODUCT 
		FOREIGN KEY (PRODUCT_ID) 
		REFERENCES PRODUCT(PRODUCT_ID),
	CONSTRAINT FK_ORDER_LINE_ORDER_T
		FOREIGN KEY (ORDER_ID)
		REFERENCES ORDER_T(ORDER_ID)
);

ALTER TABLE PRODUCT ADD CONSTRAINT PRODUCT_FINISH CHECK (
	PRODUCT_FINISH IN ( 
		'cherry',
		'natural ash',
		'white ash',
		'red oak',
		'natural oak',
		'walnut'
	)
)

insert into CUSTOMER(CUSTOMER_NAME,CUSTOMER_ADDRESS,CUSTOMER_CITY,CITY_CODE)
values
('Ivan Petrov', '8 Lavele Street', 'Sofia', '1000'),
('Kameliya Yaneva', '3 Ivan Shishman Street', 'Burgas', '8000'),
('Vasil Dimitrov', 'Abadjiyska Street 87', 'Plovdiv', '4000'),
('Ani Mileva', 'Bul. Vladislav Varnenchik 56', 'Varna','9000');

insert into PRODUCT values
(1000, 'office desk', 'cherry', 195, 10),
(1001, 'director''s desk', 'red oak', 250, 10),
(2000, 'office chair', 'cherry', 75, 20),
(2001, 'director''s chair', 'natural oak', 129, 20),
(3000, 'bookshelf', 'natural ash', 85, 30),
(4000, 'table lamp', 'natural ash', 35, 40);

insert into ORDER_T values
(100, '2013-01-05', 1),
(101, '2013-12-07', 2),
(102, '2014-10-03', 3),
(103, '2014-10-08', 2),
(104, '2015-10-05', 1),
(105, '2015-10-05', 4),
(106, '2015-10-06', 2),
(107, '2016-01-06', 1);

insert into ORDER_LINE values
(100, 4000, 1),
(101, 1000, 2),
(101, 2000, 2),
(102, 3000, 1),
(102, 2000, 1),
(106, 4000, 1),
(103, 4000, 1),
(104, 4000, 1),
(105, 4000, 1),
(107, 4000, 1)


SELECT prod.PRODUCT_ID, 
	   prod.PRODUCT_DESCRIPTION, 
	   COUNT(ord_t.ORDER_ID) as 'Times Ordered'
FROM PRODUCT as prod
INNER JOIN ORDER_LINE as ord_l ON prod.PRODUCT_ID = ord_l.PRODUCT_ID
INNER JOIN ORDER_T as ord_t ON ord_l.ORDER_ID = ord_t.ORDER_ID
GROUP BY prod.PRODUCT_ID, prod.PRODUCT_DESCRIPTION;

SELECT prod.PRODUCT_ID, 
	   prod.PRODUCT_DESCRIPTION, 
	   ISNULL(SUM(ord_l.ORDER_QUANTITY), 0) as 'Total Quntity Ordered'
FROM PRODUCT as prod
LEFT JOIN ORDER_LINE as ord_l ON prod.PRODUCT_ID = ord_l.PRODUCT_ID
GROUP BY prod.PRODUCT_ID, prod.PRODUCT_DESCRIPTION;

SELECT custmr.CUSTOMER_NAME, SUM(prod.STANDARD_PRICE) as 'Order Amount'
FROM CUSTOMER as custmr
INNER JOIN ORDER_T as ord_t on ord_t.CUSTOMER_ID = custmr.CUSTOMER_ID
INNER JOIN ORDER_LINE as ord_l on ord_l.ORDER_ID = ord_t.ORDER_ID
INNER JOIN PRODUCT as prod on prod.PRODUCT_ID = ord_l.PRODUCT_ID
GROUP BY custmr.CUSTOMER_NAME

