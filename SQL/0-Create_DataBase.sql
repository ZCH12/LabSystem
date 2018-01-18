/*
	这个SQL文件是用于建立CMS数据库的,
	默认是建立在D:\data\studentCourse.mdf
*/

CREATE DATABASE CMS_db ON PRIMARY(
	NAME=CMS1,
	FILENAME='D:\data\studentCourse.mdf', 
	FILEGROWTH=10MB,MAXSIZE=UNLIMITED,SIZE=10MB
)
