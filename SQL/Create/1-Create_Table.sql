USE CMS_db
GO
/*教学楼的安排*/
IF OBJECT_ID('dbo.Building_TBL') IS NULL
	CREATE TABLE dbo.Building_TBL(
		[ID]			INT IDENTITY(1,1) NOT NULL PRIMARY KEY,	--教学楼的内部编号,用于数据库内部的识别
		BuildingName	NVARCHAR(10)							--教学楼的名称
	)
GO
/*教室的设置的存储表*/
IF OBJECT_ID('dbo.ClassRoom_TBL') IS NULL
	CREATE TABLE dbo.ClassRoom_TBL(
		[ID]			INT IDENTITY(1,1),		--教室的内部编号,用于数据库内部识别
		[Classroom]		NVARCHAR(5) NOT NULL,	--课室的编号,由两位大写字母和3位小写字母组成,如:MA309
		[BuildingID]	INT,					--此课室所属的教学楼的ID,引用到Building_TBL表
		[SeatCount]		INT NOT NULL,			--此课室拥有的最大座位数
		[UseFor]		NVARCHAR(20),			--此课室的用途,用于对外显示
		CONSTRAINT PK_CR PRIMARY KEY([Classroom]),
		CHECK(Classroom LIKE '[A-Z][A-Z][0-9][0-9][0-9]')
	)
GO

/*学期的设置的存储表*/
IF OBJECT_ID('dbo.Term_TBL') IS NULL
	CREATE TABLE dbo.Term_TBL(
		[ID]	INT IDENTITY(1,1),				--学期的ID
		[RealName]	NVARCHAR(50) PRIMARY KEY,	--学期的真实名字,如:2017-2017-1
		[StartDate] NVARCHAR(50) NOT NULL		--记录学期的开学的第一天(应当为星期一)的日期,此值用于计算相对于当前学期,当前的周数,此值十分重要,属于必填
	)
GO

/*专业信息存储表*/
IF OBJECT_ID('dbo.Major_TBL') IS NULL
	CREATE TABLE dbo.Major_TBL(
		[ID]			INT IDENTITY(1,1),			--专业的ID,用于内部识别
		[RealName]		NVARCHAR(50) PRIMARY KEY	--专业的名称
	)
GO

/*专业信息的附属存储表,用于存储专业信息的自动识别关键字,用于自动设置所属专业*/
/*此附属表用于从班级名称中获取对应的专业*/
IF OBJECT_ID('dbo.Major2_TBL') IS NULL
	CREATE TABLE dbo.Major2_TBL(
		MajorID			INT,						--关联的专业的ID
		[KeyWord]		NVARCHAR(20) PRIMARY KEY(MajorID,KeyWord)	--关联的专业的关键字
	)
GO

/*实验室课程信息的存储表*/
IF  OBJECT_ID('dbo.CRCourse_TBL')  IS NULL
	CREATE TABLE dbo.CRCourse_TBL(
		[ID]			INT IDENTITY(1,1) PRIMARY KEY,					--课程记录的内部ID
		[CourseName]	NVARCHAR(50) NOT NULL,							--课程的名称
		[Week]			INT NOT NULL CHECK ([Week] BETWEEN 1 and 7),	--课程的星期
		[HasClassWeek]  INT NOT NULL CHECK ([HasClassWeek] <> 0),		--课程有课的周次的标志位
		[HasClassTime]	INT NOT NULL CHECK ([HasClassTime] <> 0),		--课程游客的节次的标志位
		[ClassroomID]	INT NOT NULL,									--该课程上课的课室的ID
		[TermID]		INT NOT NULL,									--该课程所属的学期的ID
		[MajorID]		INT NOT NULL,									--该课程所属的专业的ID(此)
		[TeacherName]	NVARCHAR(50),									--该课程的任课老师
		[StudentCount]	INT CHECK ([StudentCount] >0),					--该课程的上课学生数
		[ClassName]		NVARCHAR(200)									--上课班级
	)
GO

/*补课统计信息的存储表,此用于保存不可信息,当生成日报表和月报表的时候,应当注意此表*/
IF OBJECT_ID('dbo.ChangeCourse_TBL')  IS NULL
	CREATE TABLE dbo.ChangeCourse_TBL(
		TermID			INT,
		FromWeek		INT,			--补课来源的星期(值的范围从1~7)
		FromClassWeek	INT,			--补课来源的周次
		ToWeek			INT ,			--补课目标的星期
		ToClassWeek		INT				--补课目标的周次
	)
GO

/*用户信息的存储表*/
IF OBJECT_ID('dbo.User_TBL') IS NULL 
	CREATE TABLE dbo.User_TBL(
		[ID]			INT IDENTITY(1,1),			--用户的序号
		[WechatID]		NVARCHAR(30) NULL,			--助理的账号绑定的微信的微信ID
		[WechatUnionID]	NVARCHAR(30) NULL,
		[UserName]		NVARCHAR(20) PRIMARY KEY,	--用户名
		[Pwd]			NVARCHAR(32),				--密码
		[Authority]		INT,						--记录账号所拥有的权限
		[Name]			NVARCHAR(10) NOT NULL,		--助理的姓名
		[PhoneNumber]	NVARCHAR(13),				--助理的手机号码
		[ClassName]		NVARCHAR(100),				--助理的班级专业信息
		[Sex]			NVARCHAR(1) NULL CHECK([Sex]=N'男' OR [Sex]=N'女'),
		[Email]			NVARCHAR(100) NULL			--此邮箱用于忘记密码时的密码找回
	)
GO
	
/*助理值班安排的记录(User_TBL的联系集)*/
IF OBJECT_ID('dbo.User2_TBL') IS NULL
	CREATE TABLE dbo.User2_TBL(
		[UserID]		INT NOT NULL,				--值班人员的ID
		[DutyWeek]		INT	NOT NULL ,				--值班的周次,位标记
		[DutyTime]		INT NOT NULL,				--值班的时间,位标记
		[Week]			INT NOT NULL,				--值班的星期,范围从1-7
		[TableID]		INT NOT NULL				--本条记录所属的逻辑表(用于将多张值班安排表区分开)
	)
GO

/*此表用于记录学生的课程信息,此表中的数据用于生成值班表等表格*/
IF OBJECT_ID('dbo.STCourse_TBL') IS NULL
	CREATE TABLE dbo.STCourse_TBL(
		[ID]			INT	IDENTITY(1,1),			--学生的课程的内部编号
		[Week]			INT NOT NULL,				--指定课程的星期
		[HasClassWeek]	INT NOT NULL,				--有课的星期
		[HasClassTime]	INT NOT NULL,				--游客的节次
		[Classroom]		NVARCHAR(5) NOT NULL,
		[TermID]		INT NOT NULL
	)
GO

/*助理值班表的表头*/
IF OBJECT_ID('dbo.StuArrangeChartHead_TBL') IS NULL
	CREATE TABLE dbo.StuArrangeChartHead_TBL(
		[ID]			INT IDENTITY(1,1) NOT NULL,	--值班表的内部ID,用于识别不同的表
		[Name]			NVARCHAR(20) NOT NULL,		--值班表的名称
		[BuildingID]	INT NOT NULL,				--值班地点,关联到Building_TBL
		[TermID]		INT NOT NULL,				--本值班安排所属的学期
	)
GO

/*助理值班表的主体*/
IF OBJECT_ID('dbo.StuArrangeChartHead_TBL') IS NULL
	CREATE TABLE dbo.StuArrangeChart_TBL(
		[ChartID]		INT,						--表示值班表的ID,来源:StuArrangeChartHead_TBL.ID
		[Name]			NVARCHAR(10) NOT NULL,		--值班人员的姓名
		[Week]			INT	NOT NULL,				--值班人员的星期
		[DutyClassWeek]	INT NOT NULL,				--值班的周次
		[DutyClassTime]	INT NOT NULL,				--值班的节次
	)
GO

/*签到的统计表*/
IF OBJECT_ID('dbo.CheckInOut_TBL') IS NULL
	CREATE TABLE dbo.CheckInOut_TBL(
		UserID			INT NOT NULL,--签到的用户的ID,来源:User_TBL.ID
		SignDate		DATE,	--签到的日期
		SignTime_ON		TIME,	--上班时间
		SignTime_OFF	TIME,	--下班时间
		SignWeek		INT,	--星期
		SignClassWeek	INT,	--值班周次
		SignTimePeriod	INT		--值班班次(数值为1-3,分别表示上午下午晚上)
	)
GO

/*全局统计信息的存储表*/
IF OBJECT_ID('dbo.Global_TBL') IS NULL
BEGIN
	CREATE TABLE dbo.Global_TBL(
		KeyName NVARChar(50)	PRIMARY KEY,
		ValStr NVARCHAR(50)		NULL,
		ValInt INT				NULL,
		CHECK(ValStr IS NOT NULL OR ValInt IS NOT NULL)
		/*每一个键的键值可以使用一种(ValStr或ValInt),在程序中自行规定应当读取哪一个值*/
	)
	/*插入默认数据*/
	INSERT INTO dbo.Global_TBL(KeyName,ValInt) VALUES (N'CurTermID',N'1')
End
GO

/*这是一个通用的验证码存储地,用于存储各类临时的验证码*/
/*
此对应表将对应验证码的类型
Type		验证码类型
1			签到验证码(4位)
2			重置密码验证码(8位)
*/
IF OBJECT_ID('CommonVerifyCode_TBL') IS NULL
	CREATE TABLE dbo.CommonVerifyCode_TBL(
	    [UserName]		NVARCHAR(20)	NULL,
	    [GenerateTime]	DATETIME		NULL,
	    [VerifyCode]	NVARCHAR(20)	NULL,
		[Type]			INT				NOT NULL
	)

