/*
	���SQL�ļ������ڽ���CMS���ݿ��,
	Ĭ���ǽ�����D:\data\studentCourse.mdf
*/

CREATE DATABASE CMS_db ON PRIMARY(
	NAME=CMS1,
	FILENAME='D:\data\studentCourse.mdf', 
	FILEGROWTH=10MB,MAXSIZE=UNLIMITED,SIZE=10MB
)
