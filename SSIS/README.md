# SSIS Solution for AdwentureWorksDW2016

## Task Overview

This SSIS solution consists of three Master Packages: one main package and two child packages. The solution extracts data from the source database **AdwentureWorksDW2016** and processes it according to the following instructions:

### Child Package 1: DB - DB and DB - Excel

#### 1.1 DB – DB
- **Source Table**: Choose any table from the source database (e.g., [dbo].[DimAccount], [dbo].[DimCurrency], etc.).
- **Destination Table**: Create your own table with the same structure as the source table. Add two additional columns to store:
  - `UserName` (data type: string)
  - `ExecutionDate` (data type: datetime)
- **Column Transformation**:
  - Concatenate two columns with different data types (e.g., **Char & Date**, **Char & Numeric**). For example: `[dbo].[DimAccount].[AccountDescription] = [AccountDescription] + [AccountKey]`.
  - For one of the columns, if the value is **NULL**, replace it with ‘Unknown’ (ensure the datatype compatibility).
- **Insert**: Insert the transformed data into your destination table.

#### 1.2 DB – Excel File
- **Source Table**: Use any table from the source database (e.g., [dbo].[DimAccount], [dbo].[DimCurrency], etc.).
- **Add Columns**: Add new columns to the table to store SSIS system variables:
  - `ExecutionID` 
  - `ExecutionDate`
- **Destination**: Insert the data into an Excel file.

---

### Child Package 2: DB – Flat File and Flat File – DB

#### 2.1 DB – Flat File
- **Source Table**: Choose any table from the source database (e.g., [dbo].[DimProduct], [dbo].[DimProductSubcategory], etc.).
- **Use Lookup DFT Component**: Perform a lookup to retrieve additional information (e.g., for **Product**, lookup **ProductSubCategory**).
- **File Output**: Insert the data into a **Flat File**. Choose appropriate file properties:
  - Delimited file
  - Specify the delimiter and include a header.
  - The file name should be dynamically generated and should contain the date of execution.
- **Check**: Verify that the file is created correctly after the package is executed.

#### 2.2 Flat File – DB
- **Source**: Use the flat files generated in the previous step.
- **Create Tables**: Create two tables with the same structure as the source file:
  - One table for matched rows (e.g., `[dbo].[DimProduct_Destination]`).
  - One table for unmatched rows (e.g., `[dbo].[DimProduct_NotMatched]`).
- **Parallel Data Flows**: Set up two parallel data flows in one Data Flow Task to process the data from each file.
- **Add Derived Column**: Use the derived column component to perform additional calculations.
- **Conditional Split**: Add a conditional split component to redirect rows based on certain conditions:
  - Redirected rows should be inserted into a new flat file.
  - Other rows should be inserted into the tables created in the previous step.

---

## Notes

- Ensure that all data types in the transformations are compatible.
- Double-check the table and file structures to ensure the data integrity after processing.
- Monitor the SSIS packages for execution errors and validate that the dynamic file names are created correctly with the execution date.
