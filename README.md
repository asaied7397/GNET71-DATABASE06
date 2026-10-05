# Hospital Database — SQL Server Assignment

A SQL Server practice project completed as part of an **ASP.NET Backend Development Course**.

This assignment uses an existing Hospital database to practice SQL aggregation, grouping, subqueries, derived tables, `SELECT INTO`, scalar functions, and table-valued functions.

---

## Database

The project uses the `Hospital` database with the following main tables:

- `Patients`
- `Wards`
- `Consultants`
- `Nurses`
- `DrugAdministrations`
- `Drugs`
- `DrugBrands`
- `PatientExaminations`
- `PatientConsultantAssignments`

The database runs locally using **Microsoft SQL Server in Docker**.

```text
Server: localhost,1433
Database: Hospital
```

---

## Assignment Overview

The assignment contains **46 SQL questions** covering several SQL Server concepts.

### 1. Aggregate Functions

The first section uses aggregate functions to summarize hospital data.

Functions used:

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

Examples include:

- Counting patients per ward
- Calculating average consultant salary
- Finding minimum and maximum salaries
- Counting medication administrations
- Calculating total medication quantities

---

### 2. GROUP BY and HAVING

`GROUP BY` is used to create summaries for groups of records.

Examples:

```sql
SELECT WardId, COUNT(*) AS PatientCount
FROM Patients
GROUP BY WardId;
```

`HAVING` is used when filtering aggregated results.

Example:

```sql
HAVING COUNT(p.Id) > 3
```

This is used to find wards containing more than three patients.

---

### 3. Subqueries

Subqueries are used to compare records against calculated values.

Examples include:

- Consultants earning above the average salary
- Nurses earning above the average salary
- Consultants with the maximum salary
- Patients belonging to the largest ward

Example:

```sql
SELECT Id, Name, Salary
FROM Consultants
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Consultants
);
```

---

### 4. EXISTS and NOT EXISTS

The assignment uses `EXISTS` to determine whether related records exist.

Examples:

- Patients who received medication
- Patients who never received medication

```sql
WHERE EXISTS (...)
```

and:

```sql
WHERE NOT EXISTS (...)
```

---

### 5. Derived Tables and CTEs

Derived tables and Common Table Expressions (`CTE`) are used when an intermediate result is needed before the final query.

They are used for tasks such as:

- Comparing consultant salaries with the average salary
- Calculating medication totals per patient
- Finding wards with above-average patient counts

Example structure:

```sql
WITH WardCounts AS
(
    SELECT ...
)
SELECT ...
FROM WardCounts;
```

---

## Creating Tables from Queries

Several questions use:

```sql
SELECT ... INTO ...
```

to create new tables directly from query results.

Tables created during the assignment include:

```text
PatientBackup
BasicPatientInformation
ConsultantSalaryReport
PatientWardReport
PatientConsultantReport
HighSalaryConsultants
YoungPatients
HighSalaryNurseReport
WardPatientSummary
PatientMedicationSummary
HighActivityPatientReport
ConsultantAnnualSalaryReport
```

For example:

```sql
SELECT *
INTO PatientBackup
FROM Patients;
```

These statements should normally be executed only once because the destination table is created during execution.

---

# SQL Server Functions

The second part of the assignment introduces reusable SQL Server functions.

Three types are practiced:

1. Scalar Functions
2. Inline Table-Valued Functions
3. Multi-Statement Table-Valued Functions

---

## Scalar Functions

Scalar functions return a single value.

Functions created include:

### `CalculatePatientAge`

Calculates a patient's age from their date of birth.

```sql
dbo.CalculatePatientAge(DOB)
```

### `CalculateAnnualSalary`

Converts a monthly salary into an annual salary.

```sql
dbo.CalculateAnnualSalary(Salary)
```

### `CalculateMedicationCost`

Calculates:

```text
Quantity × Unit Price
```

---

## Inline Table-Valued Functions

Inline TVFs return a table using a single query.

Functions created include:

```text
GetPatientsByWard
GetConsultantsByMinimumSalary
GetPatientsWithWard
```

Example usage:

```sql
SELECT *
FROM dbo.GetPatientsByWard(1);
```

They can also be filtered like normal tables:

```sql
SELECT *
FROM dbo.GetConsultantsByMinimumSalary(50000)
WHERE Name LIKE 'A%';
```

---

## Multi-Statement Table-Valued Functions

Multi-statement TVFs create and populate a table variable before returning it.

Functions created include:

```text
GetPatientsWithAge
GetPatientMedicationSummary
GetConsultantsWithSalaryClassification
```

These functions are used for more complex reusable operations.

Example:

```sql
SELECT *
FROM dbo.GetPatientsWithAge(30)
ORDER BY Age DESC;
```

---

## Medication Quantity Handling

In the provided database, medication dosage is stored as text.

Examples:

```text
2 tablets
1 tablet
```

Because the assignment requires numerical medication quantities, the numeric portion is extracted before performing calculations.

```sql
TRY_CAST(
    LEFT(Dosage, CHARINDEX(' ', Dosage + ' ') - 1)
    AS INT
)
```

This converts values such as:

```text
"2 tablets" → 2
"1 tablet"  → 1
```

The extracted value can then be used with:

```sql
SUM()
AVG()
```

---

## Final Queries

The final section combines multiple concepts from the assignment.

These include:

- Patient medication statistics
- Above-average ward activity
- High-activity patients
- Annual consultant salary reports
- Filtering results returned by TVFs
- Patient age calculations
- Patient, ward, and medication summaries

The final hospital patient summary combines:

```text
Patient
   │
   ├── Ward
   │
   ├── Calculated Age
   │
   └── Drug Administrations
          │
          ├── Administration Count
          └── Total Medication Quantity
```

---

## Concepts Covered

| Questions | Main Topic                             |
| --------- | -------------------------------------- |
| Q1–Q10    | Aggregate Functions, GROUP BY, HAVING  |
| Q11–Q18   | Subqueries, EXISTS, JOINs              |
| Q19–Q20   | Derived Tables and CTEs                |
| Q21–Q30   | SELECT INTO                            |
| Q31–Q33   | Scalar Functions                       |
| Q34–Q36   | Inline Table-Valued Functions          |
| Q37–Q39   | Multi-Statement Table-Valued Functions |
| Q40–Q46   | Combined SQL Queries                   |

---

## Technologies

- Microsoft SQL Server
- T-SQL
- Docker
- Visual Studio Code
- MSSQL Extension for VS Code
- Git
- GitHub

---

## Project Structure

```text
Hospital-Database-Assignment/
│
├── README.md
└── Hospital_Aggregates_Functions.sql
```

---

## Running the Project

Start the SQL Server Docker container:

```bash
docker start sqlserver
```

Open the project in VS Code and connect using the MSSQL extension.

Select:

```text
Database: Hospital
```

The SQL file begins with:

```sql
USE Hospital;
GO
```

Queries can then be executed individually.

> **Note:** Queries using `SELECT INTO` create new tables. Running the same `SELECT INTO` statement again without dropping the existing table will produce an error.

---

## Key Learning Outcomes

This assignment demonstrates how to:

- Summarize data using aggregate functions
- Group and filter aggregated results
- Use subqueries and derived tables
- Use `EXISTS` and `NOT EXISTS`
- Combine aggregation with joins
- Create tables from query results
- Build reusable scalar functions
- Build inline table-valued functions
- Build multi-statement table-valued functions
- Use CTEs for more complex calculations
- Combine multiple SQL techniques into reporting queries

---

## Course

**ASP.NET Backend Development Course — SQL Server Module**
