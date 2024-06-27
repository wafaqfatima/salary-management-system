---create database
  create database salary_management_system;

  ---add tables

  ---department table
  
  CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(255) NOT NULL
);

---employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    DepartmentID INT,
    HireDate DATE,
    CurrentPosition VARCHAR(255),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

---salary table
CREATE TABLE Salary (
    SalaryID INT PRIMARY KEY,
    EmployeeID INT,
    BaseSalary DECIMAL(10, 2) NOT NULL,
    Bonus DECIMAL(10, 2) NOT NULL,
    Deductions DECIMAL(10, 2) NOT NULL,
    NetSalary AS (BaseSalary + Bonus - Deductions) PERSISTED,
    PayDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

---promotion table
CREATE TABLE Promotion (
    PromotionID INT PRIMARY KEY,
    EmployeeID INT,
    OldPosition VARCHAR(255),
    NewPosition VARCHAR(255),
    PromotionDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

---salaryhistory table
CREATE TABLE SalaryHistory (
    HistoryID INT PRIMARY KEY,
    EmployeeID INT,
    OldBaseSalary DECIMAL(10, 2),
    NewBaseSalary DECIMAL(10, 2),
    OldBonus DECIMAL(10, 2),
    NewBonus DECIMAL(10, 2),
    EffectiveDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

---add values to department table
INSERT INTO Department (DepartmentID, DepartmentName)
VALUES
(1, 'Human Resources'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Marketing');

---add values to employee table

INSERT INTO Employee (EmployeeID, FirstName, LastName, DepartmentID, HireDate, CurrentPosition)
VALUES
(1, 'John', 'Doe', 3, '2015-06-01', 'Software Engineer'),
(2, 'Jane', 'Smith', 1, '2018-03-15', 'HR Manager'),
(3, 'Alice', 'Johnson', 2, '2017-11-01', 'Financial Analyst'),
(4, 'Bob', 'Williams', 4, '2019-08-21', 'Marketing Specialist');

---add values to salary table

INSERT INTO Salary (SalaryID, EmployeeID, BaseSalary, Bonus, Deductions, PayDate)
VALUES
(1, 1, 80000.00, 5000.00, 2000.00, '2023-01-31'),
(2, 2, 60000.00, 3000.00, 1500.00, '2023-01-31'),
(3, 3, 70000.00, 4000.00, 1000.00, '2023-01-31'),
(4, 4, 50000.00, 2000.00, 500.00, '2023-01-31');

---add values to promotion table

INSERT INTO Promotion (PromotionID, EmployeeID, OldPosition, NewPosition, PromotionDate)
VALUES
(1, 1, 'Junior Software Engineer', 'Software Engineer', '2018-06-01'),
(2, 2, 'HR Assistant', 'HR Manager', '2020-03-15'),
(3, 3, 'Junior Financial Analyst', 'Financial Analyst', '2019-11-01'),
(4, 4, 'Marketing Intern', 'Marketing Specialist', '2021-08-21');

---add values to salaryhistory table

INSERT INTO SalaryHistory (HistoryID, EmployeeID, OldBaseSalary, NewBaseSalary, OldBonus, NewBonus, EffectiveDate)
VALUES
(1, 1, 70000.00, 80000.00, 4000.00, 5000.00, '2022-12-31'),
(2, 2, 50000.00, 60000.00, 2000.00, 3000.00, '2022-12-31'),
(3, 3, 60000.00, 70000.00, 3000.00, 4000.00, '2022-12-31'),
(4, 4, 40000.00, 50000.00, 1000.00, 2000.00, '2022-12-31');

------------------------------------------------------------------------------------------------------
CREATE PROCEDURE  AddDepartment (
    @DepartmentName VARCHAR(255)
)
AS
BEGIN
    INSERT INTO Department (DepartmentName)
    VALUES (@DepartmentName);
END;
------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddEmployee(
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @DepartmentID INT,
    @HireDate DATE,
    @CurrentPosition VARCHAR(255)
)
AS
BEGIN
    INSERT INTO Employee (FirstName, LastName, DepartmentID, HireDate, CurrentPosition)
    VALUES (@FirstName, @LastName, @DepartmentID, @HireDate, @CurrentPosition);
END;
-----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddSalary(
    @EmployeeID INT,
    @BaseSalary DECIMAL(10, 2),
    @Bonus DECIMAL(10, 2),
    @Deductions DECIMAL(10, 2),
    @PayDate DATE
)
AS
BEGIN
    INSERT INTO Salary (EmployeeID, BaseSalary, Bonus, Deductions, PayDate)
    VALUES (@EmployeeID, @BaseSalary, @Bonus, @Deductions, @PayDate);
END;
------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddPromotion(
    @EmployeeID INT,
    @OldPosition VARCHAR(255),
    @NewPosition VARCHAR(255),
    @PromotionDate DATE
)
AS
BEGIN
    INSERT INTO Promotion (EmployeeID, OldPosition, NewPosition, PromotionDate)
    VALUES (@EmployeeID, @OldPosition, @NewPosition, @PromotionDate);
    
    UPDATE Employee
    SET CurrentPosition = @NewPosition
    WHERE EmployeeID = @EmployeeID;
END;
-----------------------------------------------------------------------------------------------------
CREATE PROCEDURE AddSalaryHistory(
    @EmployeeID INT,
    @OldBaseSalary DECIMAL(10, 2),
    @NewBaseSalary DECIMAL(10, 2),
    @OldBonus DECIMAL(10, 2),
    @NewBonus DECIMAL(10, 2),
    @EffectiveDate DATE
)
AS
BEGIN
    INSERT INTO SalaryHistory (EmployeeID, OldBaseSalary, NewBaseSalary, OldBonus, NewBonus, EffectiveDate)
    VALUES (@EmployeeID, @OldBaseSalary, @NewBaseSalary, @OldBonus, @NewBonus, @EffectiveDate);
END;
--------------------------------------------------------------------------------------------------------
CREATE PROCEDURE UpdateSalary(
    @SalaryID INT,
    @BaseSalary DECIMAL(10, 2),
    @Bonus DECIMAL(10, 2),
    @Deductions DECIMAL(10, 2)
)
AS
BEGIN
    DECLARE @EmployeeID INT, @OldBaseSalary DECIMAL(10, 2), @OldBonus DECIMAL(10, 2);

    SELECT @EmployeeID = EmployeeID, @OldBaseSalary = BaseSalary, @OldBonus = Bonus
    FROM Salary
    WHERE SalaryID = @SalaryID;

    INSERT INTO SalaryHistory (EmployeeID, OldBaseSalary, NewBaseSalary, OldBonus, NewBonus, EffectiveDate)
    VALUES (@EmployeeID, @OldBaseSalary, @BaseSalary, @OldBonus, @Bonus, GETDATE());

    UPDATE Salary
    SET BaseSalary = @BaseSalary, Bonus = @Bonus, Deductions = @Deductions
    WHERE SalaryID = @SalaryID;
END;
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE GetEmployeeDetails(
    @EmployeeID INT
)
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName, e.CurrentPosition, s.BaseSalary, s.Bonus, s.Deductions, s.NetSalary, s.PayDate
    FROM Employee e
    JOIN Department d ON e.DepartmentID = d.DepartmentID
    JOIN Salary s ON e.EmployeeID = s.EmployeeID
    WHERE e.EmployeeID = @EmployeeID;

    SELECT p.PromotionID, p.OldPosition, p.NewPosition, p.PromotionDate
    FROM Promotion p
    WHERE p.EmployeeID = @EmployeeID;

    SELECT h.HistoryID, h.OldBaseSalary, h.NewBaseSalary, h.OldBonus, h.NewBonus, h.EffectiveDate
    FROM SalaryHistory h
    WHERE h.EmployeeID = @EmployeeID;
END;
----------------------------------------------------------------------------------------------------------------------------------------

-- View Department Data
SELECT * FROM Department;

-- View Employee Data
SELECT * FROM Employee;

-- View Salary Data
SELECT * FROM salary;


-- View Promotion Data
SELECT * FROM Promotion;

-- View SalaryHistory Data
SELECT * FROM SalaryHistory;
