USE Hospital;
GO


-- /* ============================================================
--    Q1 — Count Patients per Ward
--    ============================================================ */

-- SELECT
--     WardId,
--     COUNT(*) AS PatientCount
-- FROM Patients
-- GROUP BY WardId;
-- GO


-- /* ============================================================
--    Q2 — Calculate the Average Consultant Salary
--    ============================================================ */

-- SELECT
--     AVG(Salary) AS AverageConsultantSalary
-- FROM Consultants;
-- GO


-- /* ============================================================
--    Q3 — Display Salary Statistics for Consultants
--    ============================================================ */

-- SELECT
--     MIN(Salary) AS MinimumSalary,
--     MAX(Salary) AS MaximumSalary,
--     AVG(Salary) AS AverageSalary,
--     SUM(Salary) AS TotalSalary
-- FROM Consultants;
-- GO


-- /* ============================================================
--    Q4 — Count Patients by Ward
--    Sorted from highest to lowest
--    ============================================================ */

-- SELECT
--     WardId,
--     COUNT(*) AS PatientCount
-- FROM Patients
-- GROUP BY WardId
-- ORDER BY PatientCount DESC;
-- GO


-- /* ============================================================
--    Q5 — Medication Quantity per Patient
--    Dosage examples: '2 tablets', '1 tablet'
--    ============================================================ */

-- SELECT
--     PatientId,
--     SUM(
--         TRY_CAST(
--             LEFT(Dosage, CHARINDEX(' ', Dosage + ' ') - 1)
--             AS INT
--         )
--     ) AS TotalMedicationQuantity
-- FROM DrugAdministrations
-- GROUP BY PatientId;
-- GO


-- /* ============================================================
--    Q6 — Medication Administrations per Patient
--    ============================================================ */

-- SELECT
--     PatientId,
--     COUNT(*) AS AdministrationCount
-- FROM DrugAdministrations
-- GROUP BY PatientId;
-- GO


-- /* ============================================================
--    Q7 — Patients per Ward with Ward Names
--    Include wards with no patients
--    ============================================================ */

-- SELECT
--     w.Id AS WardId,
--     w.Name AS WardName,
--     COUNT(p.Id) AS PatientCount
-- FROM Wards w
-- LEFT JOIN Patients p
--     ON w.Id = p.WardId
-- GROUP BY
--     w.Id,
--     w.Name;
-- GO


-- /* ============================================================
--    Q8 — Average Nurse Salary per Ward
--    ============================================================ */

-- SELECT
--     w.Id AS WardId,
--     w.Name AS WardName,
--     AVG(n.Salary) AS AverageNurseSalary
-- FROM Wards w
-- LEFT JOIN Nurses n
--     ON w.Id = n.ServesInWardId
-- GROUP BY
--     w.Id,
--     w.Name;
-- GO


-- /* ============================================================
--    Q9 — Wards with More Than 3 Patients
--    ============================================================ */

-- SELECT
--     w.Id AS WardId,
--     w.Name AS WardName,
--     COUNT(p.Id) AS PatientCount
-- FROM Wards w
-- LEFT JOIN Patients p
--     ON w.Id = p.WardId
-- GROUP BY
--     w.Id,
--     w.Name
-- HAVING COUNT(p.Id) > 3;
-- GO


-- /* ============================================================
--    Q10 — Patients with More Than 5 Medication Administrations
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     COUNT(*) AS AdministrationCount
-- FROM Patients p
-- INNER JOIN DrugAdministrations da
--     ON p.Id = da.PatientId
-- GROUP BY
--     p.Id,
--     p.Name
-- HAVING COUNT(*) > 5;
-- GO


-- /* ============================================================
--    Q11 — Consultants Above Average Salary
--    ============================================================ */

-- SELECT
--     Id,
--     Name,
--     Salary
-- FROM Consultants
-- WHERE Salary >
-- (
--     SELECT AVG(Salary)
--     FROM Consultants
-- );
-- GO


-- /* ============================================================
--    Q12 — Nurses Above Average Salary
--    ============================================================ */

-- SELECT
--     Number,
--     Name,
--     Salary
-- FROM Nurses
-- WHERE Salary >
-- (
--     SELECT AVG(Salary)
--     FROM Nurses
-- );
-- GO


-- /* ============================================================
--    Q13 — Patients in the Largest Ward
--    ============================================================ */

-- SELECT
--     p.Id,
--     p.Name,
--     p.DOB,
--     p.WardId
-- FROM Patients p
-- WHERE p.WardId IN
-- (
--     SELECT WardId
--     FROM Patients
--     WHERE WardId IS NOT NULL
--     GROUP BY WardId
--     HAVING COUNT(*) =
--     (
--         SELECT MAX(PatientCount)
--         FROM
--         (
--             SELECT COUNT(*) AS PatientCount
--             FROM Patients
--             WHERE WardId IS NOT NULL
--             GROUP BY WardId
--         ) AS WardCounts
--     )
-- );
-- GO


-- /* ============================================================
--    Q14 — Consultants with the Maximum Salary
--    ============================================================ */

-- SELECT
--     Id,
--     Name,
--     Salary
-- FROM Consultants
-- WHERE Salary =
-- (
--     SELECT MAX(Salary)
--     FROM Consultants
-- );
-- GO


-- /* ============================================================
--    Q15 — Patients Who Received Medication
--    ============================================================ */

-- SELECT
--     p.Id,
--     p.Name,
--     p.DOB,
--     p.WardId
-- FROM Patients p
-- WHERE EXISTS
-- (
--     SELECT 1
--     FROM DrugAdministrations da
--     WHERE da.PatientId = p.Id
-- );
-- GO


-- /* ============================================================
--    Q16 — Patients Who Never Received Medication
--    ============================================================ */

-- SELECT
--     p.Id,
--     p.Name,
--     p.DOB,
--     p.WardId
-- FROM Patients p
-- WHERE NOT EXISTS
-- (
--     SELECT 1
--     FROM DrugAdministrations da
--     WHERE da.PatientId = p.Id
-- );
-- GO


-- /* ============================================================
--    Q17 — Count Medication Administrations per Patient
--    Include every patient
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     COUNT(da.PatientId) AS AdministrationCount
-- FROM Patients p
-- LEFT JOIN DrugAdministrations da
--     ON p.Id = da.PatientId
-- GROUP BY
--     p.Id,
--     p.Name;
-- GO


-- /* ============================================================
--    Q18 — Total Medication Quantity per Patient
--    Include patients with no medication
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     COALESCE(
--         SUM(
--             TRY_CAST(
--                 LEFT(da.Dosage, CHARINDEX(' ', da.Dosage + ' ') - 1)
--                 AS INT
--             )
--         ),
--         0
--     ) AS TotalMedicationQuantity
-- FROM Patients p
-- LEFT JOIN DrugAdministrations da
--     ON p.Id = da.PatientId
-- GROUP BY
--     p.Id,
--     p.Name;
-- GO


-- /* ============================================================
--    Q19 — Derived Table for Consultant Salaries
--    ============================================================ */

-- SELECT
--     c.Id,
--     c.Name,
--     c.Salary
-- FROM Consultants c
-- CROSS JOIN
-- (
--     SELECT AVG(Salary) AS AverageSalary
--     FROM Consultants
-- ) AS SalaryAverage
-- WHERE c.Salary > SalaryAverage.AverageSalary;
-- GO


-- /* ============================================================
--    Q20 — Patients with Above-Average Medication Quantity
--    ============================================================ */

-- WITH PatientMedicationTotals AS
-- (
--     SELECT
--         PatientId,
--         SUM(
--             TRY_CAST(
--                 LEFT(Dosage, CHARINDEX(' ', Dosage + ' ') - 1)
--                 AS INT
--             )
--         ) AS TotalQuantity
--     FROM DrugAdministrations
--     GROUP BY PatientId
-- )
-- SELECT
--     p.Id,
--     p.Name,
--     pmt.TotalQuantity
-- FROM PatientMedicationTotals pmt
-- INNER JOIN Patients p
--     ON p.Id = pmt.PatientId
-- WHERE pmt.TotalQuantity >
-- (
--     SELECT AVG(CAST(TotalQuantity AS DECIMAL(18,2)))
--     FROM PatientMedicationTotals
-- );
-- GO


-- /* ============================================================
--    Q21 — Create a Patient Backup
--    ============================================================ */

-- SELECT *
-- INTO PatientBackup
-- FROM Patients;
-- GO


-- /* ============================================================
--    Q22 — Create a Basic Patient Information Table
--    ============================================================ */

-- SELECT
--     Id,
--     Name,
--     DOB
-- INTO BasicPatientInformation
-- FROM Patients;
-- GO


-- /* ============================================================
--    Q23 — Create a Consultant Salary Report
--    ============================================================ */

-- SELECT
--     Id AS ConsultantId,
--     Name,
--     Salary
-- INTO ConsultantSalaryReport
-- FROM Consultants;
-- GO


-- /* ============================================================
--    Q24 — Create a Patient-Ward Report
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     w.Id AS WardId,
--     w.Name AS WardName
-- INTO PatientWardReport
-- FROM Patients p
-- LEFT JOIN Wards w
--     ON p.WardId = w.Id;
-- GO


-- /* ============================================================
--    Q25 — Create a Patient-Consultant Report
--    Uses ASSIGNED consultants, not examinations
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     c.Id AS ConsultantId,
--     c.Name AS ConsultantName
-- INTO PatientConsultantReport
-- FROM Patients p
-- INNER JOIN PatientConsultantAssignments pca
--     ON p.Id = pca.PatientId
-- INNER JOIN Consultants c
--     ON pca.ConsultantId = c.Id;
-- GO


-- /* ============================================================
--    Q26 — Create a High-Salary Consultant Table
--    ============================================================ */

-- SELECT
--     Id,
--     Name,
--     Salary
-- INTO HighSalaryConsultants
-- FROM Consultants
-- WHERE Salary > 50000;
-- GO


-- /* ============================================================
--    Q27 — Create a Young Patients Table
--    ============================================================ */

-- SELECT
--     Id,
--     Name,
--     DOB,
--     WardId
-- INTO YoungPatients
-- FROM Patients
-- WHERE DOB > '2000-01-01';
-- GO


-- /* ============================================================
--    Q28 — Create a High-Salary Nurse Report
--    ============================================================ */

-- SELECT
--     n.Number AS NurseId,
--     n.Name AS NurseName,
--     n.Salary,
--     w.Id AS WardId,
--     w.Name AS WardName
-- INTO HighSalaryNurseReport
-- FROM Nurses n
-- LEFT JOIN Wards w
--     ON n.ServesInWardId = w.Id
-- WHERE n.Salary > 30000;
-- GO


-- /* ============================================================
--    Q29 — Create a Ward Patient Summary
--    ============================================================ */

-- SELECT
--     w.Id AS WardId,
--     w.Name AS WardName,
--     COUNT(p.Id) AS PatientCount
-- INTO WardPatientSummary
-- FROM Wards w
-- LEFT JOIN Patients p
--     ON w.Id = p.WardId
-- GROUP BY
--     w.Id,
--     w.Name;
-- GO


-- /* ============================================================
--    Q30 — Create a Patient Medication Summary
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     COALESCE(
--         SUM(
--             TRY_CAST(
--                 LEFT(da.Dosage, CHARINDEX(' ', da.Dosage + ' ') - 1)
--                 AS INT
--             )
--         ),
--         0
--     ) AS TotalMedicationQuantity
-- INTO PatientMedicationSummary
-- FROM Patients p
-- LEFT JOIN DrugAdministrations da
--     ON p.Id = da.PatientId
-- GROUP BY
--     p.Id,
--     p.Name;
-- GO


-- /* ============================================================
--    Q31 — Calculate Patient Age
--    Scalar Function
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.CalculatePatientAge
-- (
--     @DOB DATE
-- )
-- RETURNS INT
-- AS
-- BEGIN
--     DECLARE @Age INT;

--     SET @Age = DATEDIFF(YEAR, @DOB, GETDATE());

--     IF DATEADD(YEAR, @Age, @DOB) > CAST(GETDATE() AS DATE)
--         SET @Age = @Age - 1;

--     RETURN @Age;
-- END;
-- GO


-- -- Example
-- SELECT
--     Id,
--     Name,
--     dbo.CalculatePatientAge(DOB) AS Age
-- FROM Patients;
-- GO


-- /* ============================================================
--    Q32 — Calculate Annual Salary
--    Scalar Function
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.CalculateAnnualSalary
-- (
--     @MonthlySalary DECIMAL(18,2)
-- )
-- RETURNS DECIMAL(18,2)
-- AS
-- BEGIN
--     RETURN @MonthlySalary * 12;
-- END;
-- GO


-- /* ============================================================
--    Q33 — Calculate Medication Cost
--    Scalar Function
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.CalculateMedicationCost
-- (
--     @Quantity INT,
--     @UnitPrice DECIMAL(18,2)
-- )
-- RETURNS DECIMAL(18,2)
-- AS
-- BEGIN
--     RETURN @Quantity * @UnitPrice;
-- END;
-- GO


-- /* ============================================================
--    Q34 — Get Patients by Ward
--    Inline Table-Valued Function
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.GetPatientsByWard
-- (
--     @WardId INT
-- )
-- RETURNS TABLE
-- AS
-- RETURN
-- (
--     SELECT
--         Id,
--         Name,
--         DOB,
--         WardId
--     FROM Patients
--     WHERE WardId = @WardId
-- );
-- GO


-- -- Example
-- SELECT *
-- FROM dbo.GetPatientsByWard(1);
-- GO


-- /* ============================================================
--    Q35 — Get Consultants by Minimum Salary
--    Inline TVF
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.GetConsultantsByMinimumSalary
-- (
--     @MinimumSalary DECIMAL(18,2)
-- )
-- RETURNS TABLE
-- AS
-- RETURN
-- (
--     SELECT
--         Id,
--         Name,
--         Salary
--     FROM Consultants
--     WHERE Salary >= @MinimumSalary
-- );
-- GO


-- /* ============================================================
--    Q36 — Get Patients with Their Ward
--    Inline TVF
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.GetPatientsWithWard
-- (
--     @WardId INT
-- )
-- RETURNS TABLE
-- AS
-- RETURN
-- (
--     SELECT
--         p.Id AS PatientId,
--         p.Name AS PatientName,
--         p.DOB,
--         w.Id AS WardId,
--         w.Name AS WardName
--     FROM Patients p
--     INNER JOIN Wards w
--         ON p.WardId = w.Id
--     WHERE p.WardId = @WardId
-- );
-- GO


-- /* ============================================================
--    Q37 — Get Patients Above a Specific Age
--    Multi-Statement Table-Valued Function

--    Name GetPatientsWithAge is used because Q45 explicitly
--    refers to GetPatientsWithAge.
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.GetPatientsWithAge
-- (
--     @MinimumAge INT
-- )
-- RETURNS @Result TABLE
-- (
--     PatientId INT,
--     PatientName NVARCHAR(255),
--     DOB DATE,
--     Age INT
-- )
-- AS
-- BEGIN

--     INSERT INTO @Result
--         (PatientId, PatientName, DOB, Age)
--     SELECT
--         Id,
--         Name,
--         DOB,
--         dbo.CalculatePatientAge(DOB)
--     FROM Patients
--     WHERE dbo.CalculatePatientAge(DOB) >= @MinimumAge;

--     RETURN;
-- END;
-- GO


-- /* ============================================================
--    Q38 — Get Patient Medication Summary
--    Multi-Statement TVF
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.GetPatientMedicationSummary
-- (
--     @PatientId INT
-- )
-- RETURNS @Result TABLE
-- (
--     PatientId INT,
--     TotalMedicationQuantity INT,
--     AdministrationCount INT
-- )
-- AS
-- BEGIN

--     INSERT INTO @Result
--         (PatientId, TotalMedicationQuantity, AdministrationCount)
--     SELECT
--         p.Id,
--         COALESCE(
--             SUM(
--                 TRY_CAST(
--                     LEFT(da.Dosage, CHARINDEX(' ', da.Dosage + ' ') - 1)
--                     AS INT
--                 )
--             ),
--             0
--         ),
--         COUNT(da.PatientId)
--     FROM Patients p
--     LEFT JOIN DrugAdministrations da
--         ON p.Id = da.PatientId
--     WHERE p.Id = @PatientId
--     GROUP BY p.Id;

--     RETURN;
-- END;
-- GO


-- /* ============================================================
--    Q39 — Classify Consultant Salaries
--    Multi-Statement TVF

--    Classification:
--    >= 75000 : High
--    >= 50000 : Medium
--    otherwise: Low

--    Only consultants >= @MinimumSalary are returned.
--    ============================================================ */

-- CREATE OR ALTER FUNCTION dbo.GetConsultantsWithSalaryClassification
-- (
--     @MinimumSalary DECIMAL(18,2)
-- )
-- RETURNS @Result TABLE
-- (
--     ConsultantId INT,
--     ConsultantName NVARCHAR(255),
--     Salary DECIMAL(18,2),
--     SalaryClassification NVARCHAR(20)
-- )
-- AS
-- BEGIN

--     INSERT INTO @Result
--         (ConsultantId, ConsultantName, Salary, SalaryClassification)
--     SELECT
--         Id,
--         Name,
--         Salary,
--         CASE
--             WHEN Salary >= 75000 THEN 'High'
--             WHEN Salary >= 50000 THEN 'Medium'
--             ELSE 'Low'
--         END
--     FROM Consultants
--     WHERE Salary >= @MinimumSalary;

--     RETURN;
-- END;
-- GO


-- /* ============================================================
--    Q40 — Patient Medication Statistics
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,

--     COUNT(da.PatientId) AS AdministrationCount,

--     COALESCE(
--         SUM(
--             TRY_CAST(
--                 LEFT(da.Dosage, CHARINDEX(' ', da.Dosage + ' ') - 1)
--                 AS INT
--             )
--         ),
--         0
--     ) AS TotalMedicationQuantity,

--     COALESCE(
--         AVG(
--             CAST(
--                 TRY_CAST(
--                     LEFT(da.Dosage, CHARINDEX(' ', da.Dosage + ' ') - 1)
--                     AS INT
--                 )
--                 AS DECIMAL(18,2)
--             )
--         ),
--         0
--     ) AS AverageMedicationQuantity

-- FROM Patients p
-- LEFT JOIN DrugAdministrations da
--     ON p.Id = da.PatientId

-- GROUP BY
--     p.Id,
--     p.Name;
-- GO


-- /* ============================================================
--    Q41 — Above-Average Wards
--    ============================================================ */

-- WITH WardCounts AS
-- (
--     SELECT
--         w.Id AS WardId,
--         w.Name AS WardName,
--         COUNT(p.Id) AS PatientCount
--     FROM Wards w
--     LEFT JOIN Patients p
--         ON w.Id = p.WardId
--     GROUP BY
--         w.Id,
--         w.Name
-- )
-- SELECT
--     WardId,
--     WardName,
--     PatientCount
-- FROM WardCounts
-- WHERE PatientCount >
-- (
--     SELECT AVG(CAST(PatientCount AS DECIMAL(18,2)))
--     FROM WardCounts
-- );
-- GO


-- /* ============================================================
--    Q42 — Create a High-Activity Patient Report
--    More than 5 medication administrations
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     COUNT(da.PatientId) AS AdministrationCount
-- INTO HighActivityPatientReport
-- FROM Patients p
-- INNER JOIN DrugAdministrations da
--     ON p.Id = da.PatientId
-- GROUP BY
--     p.Id,
--     p.Name
-- HAVING COUNT(da.PatientId) > 5;
-- GO


-- /* ============================================================
--    Q43 — Consultant Salary Report Using Scalar Function
--    ============================================================ */

-- SELECT
--     Name AS ConsultantName,
--     Salary AS MonthlySalary,
--     dbo.CalculateAnnualSalary(Salary) AS AnnualSalary
-- INTO ConsultantAnnualSalaryReport
-- FROM Consultants;
-- GO


-- /* ============================================================
--    Q44 — Use Inline TVF with a Filter
--    Salary >= 50000 AND name starts with A
--    ============================================================ */

-- SELECT
--     Id,
--     Name,
--     Salary
-- FROM dbo.GetConsultantsByMinimumSalary(50000)
-- WHERE Name LIKE 'A%';
-- GO


-- /* ============================================================
--    Q45 — Use Multi-Statement TVF
--    Patients at least 30, oldest first
--    ============================================================ */

-- SELECT
--     PatientId,
--     PatientName,
--     DOB,
--     Age
-- FROM dbo.GetPatientsWithAge(30)
-- ORDER BY Age DESC;
-- GO


-- /* ============================================================
--    Q46 — Final Hospital Patient Summary
--    ============================================================ */

-- SELECT
--     p.Id AS PatientId,
--     p.Name AS PatientName,
--     w.Name AS WardName,

--     dbo.CalculatePatientAge(p.DOB) AS PatientAge,

--     COUNT(da.PatientId) AS AdministrationCount,

--     COALESCE(
--         SUM(
--             TRY_CAST(
--                 LEFT(da.Dosage, CHARINDEX(' ', da.Dosage + ' ') - 1)
--                 AS INT
--             )
--         ),
--         0
--     ) AS TotalMedicationQuantity

-- FROM Patients p

-- LEFT JOIN Wards w
--     ON p.WardId = w.Id

-- LEFT JOIN DrugAdministrations da
--     ON p.Id = da.PatientId

-- GROUP BY
--     p.Id,
--     p.Name,
--     p.DOB,
--     w.Name;
-- GO