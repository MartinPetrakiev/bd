USE master
GO
if exists (select * from sysdatabases where name='facebook')
	DROP DATABASE facebook
GO

CREATE DATABASE facebook
GO
USE facebook
GO

--- TABLES ---
CREATE TABLE USERS(
	ID INT NOT NULL UNIQUE,
	EMAIL VARCHAR(255) NOT NULL UNIQUE,
	PASSWORD VARCHAR(255) NOT NULL,
	CREATED DATETIME NOT NULL
	CONSTRAINT PK_USERS PRIMARY KEY (ID)
);
CREATE TABLE FRIENDS(
	USER_ID INT NOT NULL,
	FRIEND_ID INT NOT NULL
	CONSTRAINT FK_FRIEND_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS(ID),
	CONSTRAINT FK_FRIENDS_FRIEND_ID FOREIGN KEY (FRIEND_ID) REFERENCES USERS(ID)
);
CREATE TABLE WALLS(
	USER_ID INT NOT NULL,
	CONTENT NVARCHAR(MAX) NOT NULL,
	DATE DATETIME NOT NULL
);
CREATE TABLE GROUPS(
	ID INT NOT NULL UNIQUE,
	NAME VARCHAR(255) NOT NULL,
	DESCRIPTION VARCHAR(255) DEFAULT NULL
);
CREATE TABLE GROUP_MEMBERS(
	GROUP_ID INT NOT NULL,
	USER_ID INT NOT NULL
	CONSTRAINT PK_GROUP_MEMBERS_GROUP_ID FOREIGN KEY (GROUP_ID) REFERENCES GROUPS(ID),
	CONSTRAINT FK_GROUP_MEMBERS_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS(ID)
);

INSERT INTO USERS(ID, EMAIL,PASSWORD,CREATED)
	VALUES(1110001,'user1@email.com','123asd123',GETDATE()),
		  (1110002,'user2@email.com','asdASDafsdg',GETDATE()),
		  (1110003,'user3@email.com','KLasfNASF',GETDATE());
INSERT INTO FRIENDS(USER_ID, FRIEND_ID)
	VALUES(1110001,1110003),
		  (1110002,1110003),
		  (1110002,1110001);

INSERT INTO WALLS(USER_ID,CONTENT,DATE)
	VALUES(1110001,'A asf sgdgs ssdgsdg sdgs',GETDATE());

INSERT INTO GROUPS(ID, NAME)
	VALUES(1,'Group 1')

INSERT INTO GROUP_MEMBERS(GROUP_ID,USER_ID)
	VALUES(1,1110001),
		  (1,1110003)

SELECT * FROM USERS;
SELECT * FROM FRIENDS;
SELECT * FROM WALLS;
SELECT * FROM GROUPS;
SELECT * FROM GROUP_MEMBERS;

