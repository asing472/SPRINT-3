

/****** Object:  StoredProcedure [TeamE].[ChangeRegularAccountType]    Script Date: 21-11-2019 16:55:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [TeamE].[ChangeRegularAccountType](@AccountNo char(10),@AccountType varchar(10))

as 
begin
		
	
		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.RegularAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '1%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1


		---THROWING EXCEPTION IF THE ACCOUNT TYPE ENTERED IS NOT VALID
		if @AccountType NOT IN ('SAVINGS','CURRENT')
			throw 50001,'Account Type entered is invalid',1

		---CHANGING THE ACCOUNT TYPE IF ACCOUNT NO MATCHES
		update TeamE.RegularAccount
		set AccountType = @AccountType,LastModifiedDateTime = SYSDATETIME() where ((AccountNo = @AccountNo)AND(AccountType IN ('Savings','Current')))


		
end

GO





/****** Object:  StoredProcedure [TeamE].[ChangeRegularAccountBranch]    Script Date: 21-11-2019 16:54:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [TeamE].[ChangeRegularAccountBranch](@AccountNo char(10),@Branch varchar(30))

as 
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.RegularAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '1%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1


		---THROWING EXCEPTION IF THE HOME BRANCH ENTERED IS NOT VALID
		if @Branch NOT IN ('Mumbai','Delhi','Chennai','Bengaluru')
			throw 50001,'Home branch entered is invalid',1

		---CHANGING THE HOME BRANCH IF ACCOUNT NO MATCHES
		update TeamE.RegularAccount
		set Branch = @Branch, LastModifiedDateTime = SYSDATETIME() where ((AccountNo = @AccountNo)AND(Branch IN ('Mumbai','Delhi','Chennai','Bengaluru')))

		

end

GO


