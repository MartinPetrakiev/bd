USE master
GO
if exists (select * from sysdatabases where name='flights')
	DROP DATABASE flights
GO

CREATE DATABASE flights
GO
USE flights
GO

CREATE TABLE AIRLINE (
	CODE INT NOT NULL UNIQUE,
	NAME VARCHAR(150) NOT NULL,
	COUNTRY VARCHAR(100) NOT NULL
);
CREATE TABLE AIRPORT (
	CODE INT NOT NULL UNIQUE,
	NAME VARCHAR(150) NOT NULL,
	COUNTRY VARCHAR(100) NOT NULL,
	CITY VARCHAR(100) NOT NULL
);
CREATE TABLE AIRPLANE (
	CODE INT NOT NULL UNIQUE,
	TYPE VARCHAR(100) NOT NULL,
	SEATS INT,
	YEAR DATE
);
CREATE TABLE FLIGHT (
	CODE INT NOT NULL UNIQUE,
	AIRLINE_OPERATOR INT NOT NULL,
	DEP_AIRPORT INT NOT NULL,
	ARR_AIRPORT INT NOT NULL,
	FLIGHT_TIME FLOAT,
	FLIGHT_DURATION FLOAT,
	AIRPLANE INT NOT NULL
);
CREATE TABLE CUSTOMER (
	ID INT NOT NULL UNIQUE,
	FNAME VARCHAR(150) NOT NULL, 
	LNAME VARCHAR(150) NOT NULL, 
	EMAIL VARCHAR(150)
);
CREATE TABLE AGENCY (
	NAME VARCHAR(150) NOT NULL,
	COUNTRY VARCHAR(100),
	CITY VARCHAR(100),
	PHONE INT
);
CREATE TABLE BOOKING (
	CODE INT NOT NULL UNIQUE,
	AGENCY VARCHAR(150) NOT NULL,
	AIRLINE_CODE INT NOT NULL,
	FLIGHT_NUMBER INT NOT NULL,
	CUSTOMER_ID INT NOT NULL,
	BOOKING_DATE DATETIME,
	FLIGHT_DATE DATETIME,
	PRICE FLOAT,
	STATUS VARCHAR(8) CHECK (STATUS IN ('APPROVED', 'REJECTED', NULL))
);