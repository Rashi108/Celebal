-- Create the table
CREATE TABLE HZL_Table (
    Date DATE,
    BU VARCHAR(10),
    Value INT
);

-- Insert the exact data
INSERT INTO HZL_Table (Date, BU, Value) VALUES 
('2024-01-01', 'hzl', 3456),
('2024-02-01', 'hzl', NULL),
('2024-03-01', 'hzl', NULL),
('2024-04-01', 'hzl', NULL),
('2024-01-01', 'SC', 32456),
('2024-02-01', 'SC', NULL),
('2024-03-01', 'SC', NULL),
('2024-04-01', 'SC', NULL),
('2024-05-01', 'SC', 345),
('2024-06-01', 'SC', NULL);

-- Query to replace NULL values with the previous non-NULL value within the same BU
WITH CTE AS (
    SELECT 
        Date,
        BU,
        Value,
        ROW_NUMBER() OVER (PARTITION BY BU ORDER BY Date) AS RowNum
    FROM 
        HZL_Table
),
CTE_Filled AS (
    SELECT 
        Date,
        BU,
        COALESCE(Value, LAG(Value) OVER (PARTITION BY BU ORDER BY RowNum)) AS Value,
        RowNum
    FROM 
        CTE
)
SELECT 
    Date,
    BU,
    Value
FROM 
    CTE_Filled;
