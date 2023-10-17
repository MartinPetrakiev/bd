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
	CODE INT NOT NULL PRIMARY KEY,
	NAME VARCHAR(150) NOT NULL UNIQUE,
	COUNTRY VARCHAR(100) NOT NULL
);
CREATE TABLE AIRPORT (
	CODE INT NOT NULL PRIMARY KEY,
	NAME VARCHAR(150) NOT NULL,
	COUNTRY VARCHAR(100) NOT NULL,
	CITY VARCHAR(100) NOT NULL
	UNIQUE (NAME, COUNTRY)
);
CREATE TABLE AIRPLANE (
	CODE INT NOT NULL PRIMARY KEY,
	TYPE VARCHAR(100) NOT NULL,
	SEATS INT CHECK (SEATS > 0),
	YEAR DATE
);
CREATE TABLE FLIGHT (
	CODE INT NOT NULL PRIMARY KEY,
	AIRLINE_OPERATOR INT NOT NULL,
	DEP_AIRPORT INT NOT NULL,
	ARR_AIRPORT INT NOT NULL,
	FLIGHT_TIME FLOAT,
	FLIGHT_DURATION FLOAT,
	AIRPLANE INT NOT NULL
);
CREATE TABLE CUSTOMER (
	ID INT NOT NULL PRIMARY KEY,
	FNAME VARCHAR(150) NOT NULL, 
	LNAME VARCHAR(150) NOT NULL, 
	EMAIL VARCHAR(150) CHECK (EMAIL LIKE '%_@_%.__%' AND LEN(EMAIL) > 6)
);
CREATE TABLE AGENCY (
	NAME VARCHAR(150) NOT NULL PRIMARY KEY,
	COUNTRY VARCHAR(100),
	CITY VARCHAR(100),
	PHONE VARCHAR(100)
);
CREATE TABLE BOOKING (
	CODE INT NOT NULL UNIQUE,
	AGENCY VARCHAR(150) NOT NULL,
	AIRLINE_CODE INT NOT NULL,
	FLIGHT_NUMBER INT NOT NULL,
	CUSTOMER_ID INT NOT NULL,
	BOOKING_DATE DATETIME NOT NULL,
	FLIGHT_DATE DATETIME NOT NULL,
	PRICE FLOAT,
	STATUS VARCHAR(8) NOT NULL CHECK (STATUS IN ('0', '1')),
	CONSTRAINT PK_BOOKING PRIMARY KEY (CODE),
	CONSTRAINT FLIGHT_DATE CHECK (FLIGHT_DATE >= BOOKING_DATE)
);

ALTER TABLE FLIGHT ADD CONSTRAINT FK_FLIGHTS_AIRLINE 
	FOREIGN KEY  (AIRLINE_OPERATOR) REFERENCES AIRLINE(CODE);
ALTER TABLE FLIGHT ADD CONSTRAINT FK_FLIGHTS_DEP_AIRPORT 
	FOREIGN KEY (DEP_AIRPORT) REFERENCES AIRPORT(CODE);
ALTER TABLE FLIGHT ADD CONSTRAINT FK_FLIGHTS_ARR_AIRPORT 
	FOREIGN KEY (ARR_AIRPORT) REFERENCES AIRPORT(CODE);
ALTER TABLE FLIGHT ADD CONSTRAINT FK_FLIGHTS_AIRPLANE 
	FOREIGN KEY (AIRPLANE) REFERENCES AIRPLANE(CODE);
ALTER TABLE BOOKING ADD CONSTRAINT FK_BOOKING_AGENCY 
	FOREIGN KEY (AGENCY) REFERENCES AGENCY(NAME);
ALTER TABLE BOOKING ADD CONSTRAINT FK_BOOKING_AIRLINE_CODE 
	FOREIGN KEY (AIRLINE_CODE) REFERENCES AIRLINE(CODE);
ALTER TABLE BOOKING ADD CONSTRAINT FK_BOOKING_FLIGHT_NUMBER 
	FOREIGN KEY (FLIGHT_NUMBER) REFERENCES FLIGHT(CODE);
ALTER TABLE BOOKING ADD CONSTRAINT FK_BOOKING_CUSTOMER_ID 
	FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(ID);

ALTER TABLE FLIGHT ADD NUM_PASS INT DEFAULT 0;
ALTER TABLE AGENCY ADD NUM_BOOK INT DEFAULT 0;

INSERT INTO AIRLINE (CODE, NAME, COUNTRY)
VALUES
    (1, 'Delta Air Lines', 'United States'),
    (2, 'Emirates', 'United Arab Emirates'),
    (3, 'Lufthansa', 'Germany');

INSERT INTO AIRPORT (CODE, NAME, COUNTRY, CITY)
VALUES
    (101, 'John F. Kennedy International Airport', 'United States', 'New York'),
    (102, 'Dubai International Airport', 'United Arab Emirates', 'Dubai'),
    (103, 'Frankfurt Airport', 'Germany', 'Frankfurt');

INSERT INTO AIRPLANE (CODE, TYPE, SEATS, YEAR)
VALUES
    (201, 'Boeing 737', 150, '2015-01-01'),
    (202, 'Airbus A380', 853, '2010-01-01'),
    (203, 'Boeing 777', 317, '2018-01-01');

INSERT INTO FLIGHT (CODE, AIRLINE_OPERATOR, DEP_AIRPORT, ARR_AIRPORT, FLIGHT_TIME, FLIGHT_DURATION, AIRPLANE)
VALUES
    (301, 1, 101, 102, 14.5, 16, 201),
    (302, 2, 102, 101, 16, 15.5, 202),
    (303, 3, 103, 102, 11, 12, 203);

INSERT INTO CUSTOMER (ID, FNAME, LNAME, EMAIL)
VALUES
    (401, 'John', 'Smith', 'john.smith@email.com'),
    (402, 'Emma', 'Johnson', 'emma.johnson@email.com'),
    (403, 'Michael', 'Williams', 'michael.williams@email.com');

INSERT INTO AGENCY (NAME, COUNTRY, CITY, PHONE)
VALUES
    ('TravelWorld', 'United States', 'New York', '1234567890'),
    ('SkyTravel', 'United Arab Emirates', 'Dubai', '9876543210'),
    ('EuropeTravel', 'Germany', 'Berlin', '5555555555');


INSERT INTO BOOKING (CODE, AGENCY, AIRLINE_CODE, FLIGHT_NUMBER, CUSTOMER_ID, BOOKING_DATE, FLIGHT_DATE, PRICE, STATUS)
VALUES
    (501, 'TravelWorld', 1, 301, 401, '2023-10-10 08:00:00', '2023-11-10 12:00:00', 500.00, '1'),
    (502, 'SkyTravel', 2, 302, 402, '2023-10-12 09:30:00', '2023-11-12 14:30:00', 650.00, '1'),
    (503, 'EuropeTravel', 3, 303, 403, '2023-10-15 07:45:00', '2023-11-15 11:45:00', 450.00, '1');



select * from FLIGHT;
select * from AGENCY;
select * from BOOKING;
