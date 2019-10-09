


---CREATED BY AKASH KUMAR SINGH
---MODULE ACCOUNTS
---CREATED ON 
use PecuniaBanking
GO


---CREATED SCHEMA CustomerService
CREATE SCHEMA CustomerService

---CREATED DUMMY TABLE CUSTOMER
CREATE TABLE CustomerService.Customer
(CustomerID uniqueidentifier NOT NULL primary key,
	CustomerNumber char(6) NOT NULL check(CustomerNumber like '______') unique,
	CustomerName varchar(50) NOT NULL)



---CREATED TABLE REGULAR ACCOUNT
CREATE TABLE CustomerService.RegularAccount
(AccountID uniqueidentifier constraint PK_RegularAccount_AccountID primary key,
	CustomerID uniqueidentifier NOT NULL constraint FK_RegularAccount_CustomerID foreign key references CustomerService.Customer(CustomerID),
	CustomerNo char(6) NOT NULL constraint FK_RegularAccount_CustomerNo foreign key references CustomerService.Customer(CustomerNumber),
	AccountNo char(10) NOT NULL check(AccountNo like '_________'),
	CurrentBalance money NOT NULL default 0 check(CurrentBalance >= 0),
	AccountType varchar(10) NOT NULL check(AccountType = 'Savings' OR AccountType = 'Current'),
	Branch varchar(30) NOT NULL check(Branch = 'Delhi' OR Branch = 'Mumbai'OR Branch = 'Chennai'OR Branch = 'Bengaluru' ),
	Status char(10) NOT NULL default 'Active' check(Status ='Active' OR Status = 'Closed'),
	MinimumBalance money NOT NULL default 500 check(MinimumBalance > 0),
	InterestRate decimal NOT NULL default 3.5 check(InterestRate > 0),
	CreationDateTime datetime NOT NULL default SysDateTime(),
	LastModifiedTime datetime NOT NULL default SysDateTime())

GO


---CREATED TABLE FIXED ACCOUNT
CREATE TABLE CustomerService.FixedAccount
(AccountID uniqueidentifier constraint PK_FixedAccount_AccountID primary key,
	CustomerID uniqueidentifier NOT NULL constraint FK_FixedAccount_CustomerID foreign key references CustomerService.Customer(CustomerID),
	CustomerNo char(6) NOT NULL constraint FK_RegularAccount_CustomerNo foreign key references CustomerService.Customer(CustomerNumber),
	AccountNo char(10) NOT NULL check(AccountNo like '_________'),
	CurrentBalance money default 0 check(CurrentBalance >= 0) ,
	AccountType varchar(10) NOT NULL check(AccountType = 'Fixed'),
	Branch varchar(30) NOT NULL check(Branch = 'Delhi' OR Branch = 'Mumbai'OR Branch = 'Chennai'OR Branch = 'Bengaluru' ),
	Tenure decimal NOT NULL check(tenure > 0),
	FDDeposit money NOT NULL check(FDDeposit > 0),
	Status char(10) NOT NULL default 'Active' check(Status ='Active' OR Status = 'Closed'),
	MinimumBalance money NOT NULL default 500 check(MinimumBalance > 0),
	InterestRate decimal NOT NULL default 3.5 check(InterestRate > 0),
	CreationDateTime datetime NOT NULL default SysDateTime(),
	LastModifiedTime datetime NOT NULL default SysDateTime())
GO


---CREATED PROCEDURE FOR ADDING ITEMS IN REGULAR ACCOUNT TABLE

create procedure CreateRegularAccount
(@AccountID uniqueIdentifier,@CustomerID uniqueIdentifier, @CustomerNo char(6), @AccountNo char(10), @CurrentBalance money,
	@AccountType varchar(10),@Branch varchar(30),@Status char(10),@MinimumBalance money,@InterestRate decimal,@CreationDateTime datetime,@LastModifiedTime datetime)
as
begin

		---THROWING EXCEPTION IF ACCOUNT ID IS NULL OR INVALID
		if @AccountID is null OR @AccountID = ' '
			throw 5001,'Invalid Account ID',1

		---THROWING EXCEPTION IF CUSTOMER ID IS NULL OR INVALID
		if @CustomerID is null OR @CustomerID = ' '
			throw 5001,'Invalid Customer ID',2

		---THROWING EXCEPTION IF ACCOUNT ID IS NULL OR INVALID
		if @CustomerNo is null OR @CustomerNo = ' 'OR @CustomerNo NOT like '1_____'
			throw 5001, 'Invalid Customer No',3

		---THROWING EXCEPTION IF ACCOUNT NO IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = '' OR @AccountNo NOT like '1________'
			throw 5001,'Invalid Account No',4

		---THROWING EXCEPTION IF CURRENT BALANCE IS NULL OR LESS THAN 0
		if @CurrentBalance < 0 OR @CurrentBalance = '' OR @CurrentBalance = null
			throw 5001, 'Invalid Current Balance',5

		---THROWING EXCEPTION IF ACCOUNT TYPE IS NOT SAVINGS OR CURRENT
		if @AccountType = null OR @AccountType = ''OR @AccountType NOT IN('Fixed')
			throw 5001,'Invalid Account Type',6

		---THROWING EXCEPTION IF HOME BRANCH IS INVALID OR NULL
		if @Branch = null OR @Branch = ''OR @Branch NOT IN('Mumbai','Delhi','Chennai','Bengaluru')
			throw 5001,'Invalid Branch',7

			INSERT INTO CustomerService.RegularAccount(AccountID, CustomerID, CustomerNo, AccountNo, CurrentBalance,
	AccountType ,Branch,Status,MinimumBalance,InterestRate,CreationDateTime,LastModifiedTime)VALUES(@AccountID, @CustomerID, @CustomerNo, @AccountNo, @CurrentBalance,
	@AccountType ,@Branch,@Status,@MinimumBalance,@InterestRate,@CreationDateTime,@LastModifiedTime)

end

GO



---CREATED PROCEDURE FOR ADDING ITEMS IN FIXED ACCOUNT TABLE

create procedure CreateFixedAccount
(@AccountID uniqueIdentifier,@CustomerID uniqueIdentifier, @CustomerNo char(6), @AccountNo char(10), @CurrentBalance money,
	@AccountType varchar(10),@Branch varchar(30),@Tenure decimal,@FDDeposit money,@Status char(10),@MinimumBalance money,@InterestRate decimal,@CreationDateTime datetime,@LastModifiedTime datetime)
as
begin

		---THROWING EXCEPTION IF ACCOUNT ID IS NULL OR INVALID
		if @AccountID is null OR @AccountID = ' '
			throw 5001,'Invalid Account ID',1

		---THROWING EXCEPTION IF CUSTOMER ID IS NULL OR INVALID
		if @CustomerID is null OR @CustomerID = ' '
			throw 5001,'Invalid Customer ID',2

		---THROWING EXCEPTION IF ACCOUNT ID IS NULL OR INVALID
		if @CustomerNo is null OR @CustomerNo = ' 'OR @CustomerNo NOT like '1_____'
			throw 5001, 'Invalid Customer No',3

		---THROWING EXCEPTION IF ACCOUNT NO IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = '' OR @AccountNo NOT like '1________'
			throw 5001,'Invalid Account No',4

		---THROWING EXCEPTION IF CURRENT BALANCE IS NULL OR LESS THAN 0
		if @CurrentBalance < 0 OR @CurrentBalance = '' OR @CurrentBalance = null
			throw 5001, 'Invalid Current Balance',5

		---THROWING EXCEPTION IF ACCOUNT TYPE IS NOT SAVINGS OR CURRENT
		if @AccountType = null OR @AccountType = ''OR @AccountType NOT IN('Savings','Current')
			throw 5001,'Invalid Account Type',6

		---THROWING EXCEPTION IF HOME BRANCH IS INVALID OR NULL
		if @Branch = null OR @Branch = ''OR @Branch NOT IN('Mumbai','Delhi','Chennai','Bengaluru')
			throw 5001,'Invalid Branch',7

		---THROWING EXCEPTION IF TENURE IS INVALID 
		if @Tenure <= 0 OR @Tenure = '' OR @Tenure = null
			throw 5001, 'Invalid Tenure',5

		---THROWING EXCEPTION IF FDDEPOSIT AMOUNT IS INVALID 
		if @FDDeposit <= 0 OR @FDDeposit = '' OR @FDDeposit = null
			throw 5001, 'Invalid FDDeposit Amount',5

			INSERT INTO CustomerService.FixedAccount(AccountID, CustomerID, CustomerNo, AccountNo, CurrentBalance,
	AccountType ,Branch,Tenure,FDDeposit,Status,MinimumBalance,InterestRate,CreationDateTime,LastModifiedTime)VALUES(@AccountID, @CustomerID, @CustomerNo, @AccountNo, @CurrentBalance,
	@AccountType ,@Branch,@Tenure,@FDDeposit,@Status,@MinimumBalance,@InterestRate,@CreationDateTime,@LastModifiedTime)


end


GO

insert into CustomerService.Customer values(NEWID(),'100001','Asmita')

select * from CustomerService.Customer

GO


---INSERTING VALUES INTO REGULARACCOUNT TABLE

declare @cid uniqueidentifier,@aid uniqueidentifier,@crdate date,@modate date
set @cid = NEWID()
set @aid = NEWID()
set @crdate = SysDateTime()
set @modate = SysDateTime() 
exec createRegularAccount @aid,@cid,'100001','1000000001',0,'Savings','Mumbai','Active',500,3.5,@crdate,@modate

GO

select * from CustomerService.RegularAccount

GO
---INSERTING VALUES INTO FIXEDACCOUNT TABLE

declare @cid uniqueidentifier,@aid uniqueidentifier,@crdate date,@modate date
set @cid = NEWID()
set @aid = NEWID()
set @crdate = SysDateTime()
set @modate = SysDateTime() 
exec CreateFixedAccount @aid,@cid,'100001','2000000001',0,'Fixed','Bengaluru',10,100000,'Active',500,3.5,@crdate,@modate

select * from CustomerService.RegularAccount


GO

------CREATED PROCEDURE FOR DELETING ITEMS FROM REGULAR ACCOUNT TABLE

create procedure DeleteRegularAccount(@AccountNo char(10))

as 
begin

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = ' '
			throw 5001,'Invalid Account No',1

		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from CustomerService.RegularAccount WHERE AccountNo = @AccountNo)
			throw 5001,'Account does not exists',1

		---SETTING THE VALUE OF STATUS FROM "ACTIVE" TO "CLOSED"
		update CustomerService.RegularAccount
		set Status = 'Closed' where AccountNo = @AccountNo;

end

GO

declare @accountno char(10), @cid uniqueIdentifier
set @cid = '1000000000'

EXEC DeleteRegularAccount @accountno

GO



------CREATED PROCEDURE FOR DELETING ITEMS FROM FIXED ACCOUNT TABLE

create procedure DeleteFixedAccount(@AccountNo char(10))

as 
begin

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = ' '
			throw 5001,'Invalid Account No',1

		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from CustomerService.FixedAccount WHERE AccountNo = @AccountNo)
			throw 5001,'Account does not exists',1

		---SETTING THE VALUE OF STATUS FROM "ACTIVE" TO "CLOSED"
		update CustomerService.FixedAccount
		set Status = "Closed" where AccountNo = @AccountNo;

end

GO

declare @accountno char(10)
set @accountno = '2000000001'

EXEC DeleteFixedAccount @accountno

GO

---CREATING A VIEW TO GET ACTIVE REGULAR ACCOUNTS BY ACCOUNT NO

create view [GetAccountByAccountNo]
as
SELECT * from CustomerService.RegularAccount WHERE Status = 'Active'

GO


---CREATED PROCEDURE FOR CHANGING HOME BRANCH OF REGULAR ACCOUNT

create procedure ChangeRegularAccountBranch(@AccountNo char(10),@Branch varchar(30))

as 
begin

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = ' '
			throw 5001,'Invalid Account No',1

		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from CustomerService.RegularAccount WHERE AccountNo = @AccountNo)
			throw 5001,'Account does not exists',1

		---THROWING EXCEPTION IF THE HOME BRANCH ENTERED IS NOT VALID
		if @Branch NOT IN ('Mumbai','Delhi','Chennai','Bengaluru')
			throw 5001,'Home branch entered is invalid',1

		---CHANGING THE HOME BRANCH IF ACCOUNT NO MATCHES
		update CustomerService.RegularAccount
		set Branch = @Branch where ((AccountNo = @AccountNo)AND(Branch IN ('Mumbai','Delhi','Chennai','Bengaluru')))

end

GO

declare @accountno char(10), @branch varchar(30)
set @accountno = '1000000005'
set @branch = 'Shimla'

EXEC ChangeRegularAccountBranch @accountno,@branch

GO



---CREATED PROCEDURE FOR CHANGING HOME BRANCH OF FIXED ACCOUNT

create procedure ChangeFixedAccountBranch(@AccountNo char(10),@Branch varchar(30))

as 
begin

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = ' '
			throw 5001,'Invalid Account No',1

		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from CustomerService.FixedAccount WHERE AccountNo = @AccountNo)
			throw 5001,'Account does not exists',1

		---THROWING EXCEPTION IF THE HOME BRANCH ENTERED IS NOT VALID
		if @Branch NOT IN ('Mumbai','Delhi','Chennai','Bengaluru')
			throw 5001,'Home branch entered is invalid',1

		---CHANGING THE HOME BRANCH IF ACCOUNT NO MATCHES
		update CustomerService.FixedAccount
		set Branch = @Branch where ((AccountNo = @AccountNo)AND(Branch IN ('Mumbai','Delhi','Chennai','Bengaluru')))



end

GO

declare @accountno char(10), @branch varchar(30)
set @accountno = '2000000005'
set @branch = 'Bengaluru'

EXEC CustomerService.ChangeFixedAccountBranch @accountno,@branch

GO

---CREATED PROCEDURE FOR CHANGING THE ACCOUNT TYPE OF REGULAR ACCOUNTS

create procedure ChangeRegularAccountType(@AccountNo char(10),@AccountType varchar(10))

as 
begin

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR @AccountNo = ' '
			throw 5001,'Invalid Account No',1

		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from CustomerService.RegularAccount WHERE AccountNo = @AccountNo)
			throw 5001,'Regular Account does not exists',1
		
		---THROWING EXCEPTION IF THE ACCOUNT NO ENTERED BELONGS TO FIXED ACCOUNT TABLE
		if EXISTS(SELECT * from CustomerService.FixedAccount WHERE AccountNo = @AccountNo) 
			throw 5001,'Fixed accounts cannot be modified into other account types',1

		---THROWING EXCEPTION IF THE ACCOUNT TYPE ENTERED IS NOT VALID
		if @AccountType NOT IN ('SAVINGS','CURRENT')
			throw 5001,'Account Type entered is invalid',1

		---CHANGING THE ACCOUNT TYPE IF ACCOUNT NO MATCHES
		update CustomerService.RegularAccount
		set AccountType = @AccountType where ((AccountNo = @AccountNo)AND(AccountType IN ('Savings','Current')))


end

GO

EXEC ChangeRegularAccountType @1000000002,@Savings

GO

---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNT BY ACCOUNT NO

Create procedure GetRegularAccountByAccountNo(@AccountNo char(10))
as
begin

		
		SELECT c.CustomerName,a.* from CustomerService.RegularAccount a, CustomerService.Customer c WHERE (AccountNo = @AccountNo) 
		AND (c.CustomerID = a.CustomerID )

end


GO

---CREATED PROCEDURE FOR LISTING FIXED ACCOUNT BY ACCOUNT NO

Create procedure GetFixedAccountByAccountNo(@AccountNo char(10)) 
as
begin

		SELECT c.CustomerName,a.* from CustomerService.FixedAccount a, CustomerService.Customer c WHERE (AccountNo = @AccountNo) 
		AND (c.CustomerID = a.CustomerID )

end


GO

---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNTS BY CUSTOMER NO

Create procedure GetRegularAccountByCustomerNo(@CustomerNo char(6))
as
begin

		SELECT c.CustomerName,a.* from CustomerService.RegularAccount a, CustomerService.Customer c WHERE (CustomerNo = @CustomerNo) 
		AND (c.CustomerID = a.CustomerID )

end


GO


---CREATED PROCEDURE FOR LISTING FIXED ACCOUNTS BY CUSTOMER NO

Create procedure GetFixedAccountByCustomerNo(@CustomerNo char(6))
as
begin

		SELECT c.CustomerName,a.* from CustomerService.FixedAccount a, CustomerService.Customer c WHERE (CustomerNo = @CustomerNo) 
		AND (c.CustomerID = a.CustomerID )

end

GO

---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNTS BY ACCOUNT TYPE

Create procedure GetRegularAccountsByAccountType(@AccountType varchar(10))
as
begin

		SELECT c.CustomerName,a.* from CustomerService.RegularAccount a, CustomerService.Customer c WHERE (AccountType = @AccountType) 
		AND (c.CustomerID = a.CustomerID )

end

GO


---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNTS BY ACCOUNT OPENING DATE

Create procedure GetRegularAccountsByAccountOpeningDate(@StartDate datetime,@EndDate datetime)
as
begin
		
		---THROWING EXCEPTION IF END DATE IS LATER THAN TODAY
		if (@EndDate > = CreationDateTime)
			throw 5001,'End date cannot be later than today',1

		SELECT c.CustomerName,a.* from CustomerService.RegularAccount a, CustomerService.Customer c WHERE ((CreationDateTime >= @StartDate) 
		AND (CreationDateTime <= @EndDate))

end

GO


---CREATED PROCEDURE FOR LISTING FIXED ACCOUNTS BY ACCOUNT OPENING DATE

Create procedure GetFixedAccountsByAccountOpeningDate(@StartDate datetime,@EndDate datetime)
as
begin
		
		---THROWING EXCEPTION IF END DATE IS LATER THAN TODAY
		if (@EndDate > = CreationDateTime)
			throw 5001,'End date cannot be later than today',1

		SELECT c.CustomerName,a.* from CustomerService.FixedAccount a, CustomerService.Customer c WHERE ((CreationDateTime >= @StartDate) 
		AND (CreationDateTime <= @EndDate))

end

GO

