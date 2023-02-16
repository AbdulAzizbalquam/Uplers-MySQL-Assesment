/*
You are part of a team creating an IAM (Identity & Access Management) solution. You have
defined a table UserRole with the following structure:
*/

CREATE TABLE `UserRole`( 
Id bigint NOT NULL AUTO INCREMENT,
Name varchar(108) NOT NULL,
Description varchar(200) MULL,
IsEnabled bit NOT NULL, 1 if a role is enabled, 0 otherwise 
Created date NOT NULL, When a role was created Createdly varchar(200) NOT MULL, Who created a role
Updated date NULL, When a role was updated (if at all)
Updated By varchar(200) NULL, Who updated a role (if at all)
CONSTRAINT PK,UserRole PRIMARY KEY (Id ASC)
)

/*
Your task is to write a SQL query (a report) that, for each user that has ever created a role, will return four values:
• User name in the User column 
• Number of created roles in the NoOfcreatedRoles Column Number of created roles that are enabled in the NoOfCreatedAndEnabledRoles column; 
• Number of updated roles in the NoorUpdatedRoles column.

I
Rows in the report should be sorted by user name in descending order. Additionally, user names should contain no leading or trailing white spaces and should be uppercase.
Your query should return no NULL values for numerical columns. Instead, NULL should be replaced with -1. For example, it is possible that there are no roles updated by a given user, or that there are no roles created by a given user that are enabled.


Test Output

You should also take into account that values in createdly and updatedly columns are not consistent:
. They can contain additional white spaces at the beginning or the end; They can be written using a mixture of small and capital letters, e.g. JOHN SMITH, John smith Here is an example. 
*/


#SOLUTION


SELECT TC.UserName, COALESCE(TC.NoOfCreatedRoles,-1) AS NoOfCreatedRoles ,COALESCE(TC.NoOfCreatedAndEnabledRoles,-1) AS NoOfCreatedAndEnabledRoles , COALESCE(TU.NoOfUpdatedRoles,-1) AS NoOfUpdatedRoles
FROM
(
SELECT UPPER(TRIM(T1.CreatedBy)) AS UserName,COUNT(DISTINCT T1.Id) AS NoOfCreatedRoles,SUM(CASE WHEN T1.IsEnabled = 1 THEN 1 ELSE NULL END) AS NoOfCreatedAndEnabledRoles
FROM UserRole T1
GROUP BY UPPER(TRIM(T1.CreatedBy))
) AS TC
LEFT JOIN 
(
SELECT UPPER(TRIM(T2.UpdatedBy)) AS UserName,SUM(CASE WHEN T2.updated IS NOT NULL THEN 1 ELSE NULL END)  AS NoOfUpdatedRoles
FROM UserRole T2
GROUP BY UPPER(TRIM(T2.UpdatedBy))
)AS TU
ON TC.UserName=TU.UserName

ORDER BY TC.UserName DESC