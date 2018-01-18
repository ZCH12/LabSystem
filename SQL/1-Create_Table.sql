USE CMS_db
GO
/*��ѧ¥�İ���*/
IF OBJECT_ID('dbo.Building_TBL') IS NULL
	CREATE TABLE dbo.Building_TBL(
		[ID]			INT IDENTITY(1,1) NOT NULL PRIMARY KEY,	--��ѧ¥���ڲ����,�������ݿ��ڲ���ʶ��
		BuildingName	NVARCHAR(10)							--��ѧ¥������
	)
GO
/*���ҵ����õĴ洢��*/
IF OBJECT_ID('dbo.ClassRoom_TBL') IS NULL
	CREATE TABLE dbo.ClassRoom_TBL(
		[ID]			INT IDENTITY(1,1),		--���ҵ��ڲ����,�������ݿ��ڲ�ʶ��
		[Classroom]		NVARCHAR(5) NOT NULL,	--���ҵı��,����λ��д��ĸ��3λСд��ĸ���,��:MA309
		[BuildingID]	INT,					--�˿��������Ľ�ѧ¥��ID,���õ�Building_TBL��
		[SeatCount]		INT NOT NULL,			--�˿���ӵ�е������λ��
		[UseFor]		NVARCHAR(20),			--�˿��ҵ���;,���ڶ�����ʾ
		CONSTRAINT PK_CR PRIMARY KEY([Classroom]),
		CHECK(Classroom LIKE '[A-Z][A-Z][0-9][0-9][0-9]')
	)
GO

/*ѧ�ڵ����õĴ洢��*/
IF OBJECT_ID('dbo.Term_TBL') IS NULL
	CREATE TABLE dbo.Term_TBL(
		[ID]	INT IDENTITY(1,1),				--ѧ�ڵ�ID
		[RealName]	NVARCHAR(50) PRIMARY KEY,	--ѧ�ڵ���ʵ����,��:2017-2017-1
		[StartDate] NVARCHAR(50) NOT NULL		--��¼ѧ�ڵĿ�ѧ�ĵ�һ��(Ӧ��Ϊ����һ)������,��ֵ���ڼ�������ڵ�ǰѧ��,��ǰ������,��ֵʮ����Ҫ,���ڱ���
	)
GO

/*רҵ��Ϣ�洢��*/
IF OBJECT_ID('dbo.Major_TBL') IS NULL
	CREATE TABLE dbo.Major_TBL(
		[ID]			INT IDENTITY(1,1),			--רҵ��ID,�����ڲ�ʶ��
		[RealName]		NVARCHAR(50) PRIMARY KEY	--רҵ������
	)
GO

/*רҵ��Ϣ�ĸ����洢��,���ڴ洢רҵ��Ϣ���Զ�ʶ��ؼ���,�����Զ���������רҵ*/
/*�˸��������ڴӰ༶�����л�ȡ��Ӧ��רҵ*/
IF OBJECT_ID('dbo.Major2_TBL') IS NULL
	CREATE TABLE dbo.Major2_TBL(
		MajorID			INT,						--������רҵ��ID
		[KeyWord]		NVARCHAR(20) PRIMARY KEY(MajorID,KeyWord)	--������רҵ�Ĺؼ���
	)
GO

/*ʵ���ҿγ���Ϣ�Ĵ洢��*/
IF  OBJECT_ID('dbo.CRCourse_TBL')  IS NULL
	CREATE TABLE dbo.CRCourse_TBL(
		[ID]			INT IDENTITY(1,1) PRIMARY KEY,					--�γ̼�¼���ڲ�ID
		[CourseName]	NVARCHAR(50) NOT NULL,							--�γ̵�����
		[Week]			INT NOT NULL CHECK ([Week] BETWEEN 1 and 7),	--�γ̵�����
		[HasClassWeek]  INT NOT NULL CHECK ([HasClassWeek] <> 0),		--�γ��пε��ܴεı�־λ
		[HasClassTime]	INT NOT NULL CHECK ([HasClassTime] <> 0),		--�γ��ο͵Ľڴεı�־λ
		[ClassroomID]	INT NOT NULL,									--�ÿγ��ϿεĿ��ҵ�ID
		[TermID]		INT NOT NULL,									--�ÿγ�������ѧ�ڵ�ID
		[MajorID]		INT NOT NULL,									--�ÿγ�������רҵ��ID(��)
		[TeacherName]	NVARCHAR(50),									--�ÿγ̵��ο���ʦ
		[StudentCount]	INT CHECK ([StudentCount] >0),					--�ÿγ̵��Ͽ�ѧ����
		[ClassName]		NVARCHAR(200)									--�Ͽΰ༶
	)
GO

/*����ͳ����Ϣ�Ĵ洢��,�����ڱ��治����Ϣ,�������ձ�����±����ʱ��,Ӧ��ע��˱�*/
IF OBJECT_ID('dbo.ChangeCourse_TBL')  IS NULL
	CREATE TABLE dbo.ChangeCourse_TBL(
		TermID			INT,
		FromWeek		INT,			--������Դ������(ֵ�ķ�Χ��1~7)
		FromClassWeek	INT,			--������Դ���ܴ�
		ToWeek			INT ,			--����Ŀ�������
		ToClassWeek		INT				--����Ŀ����ܴ�
	)
GO

/*�û���Ϣ�Ĵ洢��*/
IF OBJECT_ID('dbo.User_TBL') IS NULL 
	CREATE TABLE dbo.User_TBL(
		[ID]			INT IDENTITY(1,1),			--�û������
		[WechatID]		NVARCHAR(30) NULL,			--������˺Ű󶨵�΢�ŵ�΢��ID
		[WechatUnionID]	NVARCHAR(30) NULL,
		[UserName]		NVARCHAR(20) PRIMARY KEY,	--�û���
		[Pwd]			NVARCHAR(32),				--����
		[Authority]		INT,						--��¼�˺���ӵ�е�Ȩ��
		[Name]			NVARCHAR(10) NOT NULL,		--���������
		[PhoneNumber]	NVARCHAR(13),				--������ֻ�����
		[ClassName]		NVARCHAR(100),				--����İ༶רҵ��Ϣ
		[Sex]			NVARCHAR(1) NULL CHECK([Sex]=N'��' OR [Sex]=N'Ů'),
		[Email]			NVARCHAR(100) NULL			--������������������ʱ�������һ�
	)
GO
	
/*����ֵ�ల�ŵļ�¼(User_TBL����ϵ��)*/
IF OBJECT_ID('dbo.User2_TBL') IS NULL
	CREATE TABLE dbo.User2_TBL(
		[UserID]		INT NOT NULL,				--ֵ����Ա��ID
		[DutyWeek]		INT	NOT NULL ,				--ֵ����ܴ�,λ���
		[DutyTime]		INT NOT NULL,				--ֵ���ʱ��,λ���
		[Week]			INT NOT NULL,				--ֵ�������,��Χ��1-7
		[TableID]		INT NOT NULL				--������¼�������߼���(���ڽ�����ֵ�ల�ű����ֿ�)
	)
GO

/*�˱����ڼ�¼ѧ���Ŀγ���Ϣ,�˱��е�������������ֵ���ȱ��*/
IF OBJECT_ID('dbo.STCourse_TBL') IS NULL
	CREATE TABLE dbo.STCourse_TBL(
		[ID]			INT	IDENTITY(1,1),			--ѧ���Ŀγ̵��ڲ����
		[Week]			INT NOT NULL,				--ָ���γ̵�����
		[HasClassWeek]	INT NOT NULL,				--�пε�����
		[HasClassTime]	INT NOT NULL,				--�ο͵Ľڴ�
		[Classroom]		NVARCHAR(5) NOT NULL,
		[TermID]		INT NOT NULL
	)
GO

/*����ֵ���ı�ͷ*/
IF OBJECT_ID('dbo.StuArrangeChartHead_TBL') IS NULL
	CREATE TABLE dbo.StuArrangeChartHead_TBL(
		[ID]			INT IDENTITY(1,1) NOT NULL,	--ֵ�����ڲ�ID,����ʶ��ͬ�ı�
		[Name]			NVARCHAR(20) NOT NULL,		--ֵ��������
		[BuildingID]	INT NOT NULL,				--ֵ��ص�,������Building_TBL
		[TermID]		INT NOT NULL,				--��ֵ�ల��������ѧ��
	)
GO

/*����ֵ��������*/
IF OBJECT_ID('dbo.StuArrangeChartHead_TBL') IS NULL
	CREATE TABLE dbo.StuArrangeChart_TBL(
		[ChartID]		INT,						--��ʾֵ����ID,��Դ:StuArrangeChartHead_TBL.ID
		[Name]			NVARCHAR(10) NOT NULL,		--ֵ����Ա������
		[Week]			INT	NOT NULL,				--ֵ����Ա������
		[DutyClassWeek]	INT NOT NULL,				--ֵ����ܴ�
		[DutyClassTime]	INT NOT NULL,				--ֵ��Ľڴ�
	)
GO

/*ǩ����ͳ�Ʊ�*/
IF OBJECT_ID('dbo.CheckInOut_TBL') IS NULL
	CREATE TABLE dbo.CheckInOut_TBL(
		UserID			INT NOT NULL,--ǩ�����û���ID,��Դ:User_TBL.ID
		SignDate		DATE,	--ǩ��������
		SignTime_ON		TIME,	--�ϰ�ʱ��
		SignTime_OFF	TIME,	--�°�ʱ��
		SignWeek		INT,	--����
		SignClassWeek	INT,	--ֵ���ܴ�
		SignTimePeriod	INT		--ֵ����(��ֵΪ1-3,�ֱ��ʾ������������)
	)
GO

/*ȫ��ͳ����Ϣ�Ĵ洢��*/
IF OBJECT_ID('dbo.Global_TBL') IS NULL
BEGIN
	CREATE TABLE dbo.Global_TBL(
		KeyName NVARChar(50)	PRIMARY KEY,
		ValStr NVARCHAR(50)		NULL,
		ValInt INT				NULL,
		CHECK(ValStr IS NOT NULL OR ValInt IS NOT NULL)
		/*ÿһ�����ļ�ֵ����ʹ��һ��(ValStr��ValInt),�ڳ��������й涨Ӧ����ȡ��һ��ֵ*/
	)
	/*����Ĭ������*/
	INSERT INTO dbo.Global_TBL(KeyName,ValInt) VALUES (N'CurTermID',N'1')
End
GO

/*����һ��ͨ�õ���֤��洢��,���ڴ洢������ʱ����֤��*/
/*
�˶�Ӧ����Ӧ��֤�������
Type		��֤������
1			ǩ����֤��(4λ)
2			����������֤��(8λ)
*/
IF OBJECT_ID('CommonVerifyCode_TBL') IS NULL
	CREATE TABLE dbo.CommonVerifyCode_TBL(
	    [UserName]		NVARCHAR(20)	NULL,
	    [GenerateTime]	DATETIME		NULL,
	    [VerifyCode]	NVARCHAR(20)	NULL,
		[Type]			INT				NOT NULL
	)

