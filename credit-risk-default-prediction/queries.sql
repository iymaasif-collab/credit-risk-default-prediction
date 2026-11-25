{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Credit Risk Analysis: SQL queries\
-- Database: SQLite | Table: loans (cleaned UCI Credit Card Default data)\
-- "default" is quoted because DEFAULT is a reserved word in SQL.\
\
\
-- 1. Portfolio summary\
SELECT COUNT(*) AS borrowers,\
       ROUND(AVG("default"), 3) AS default_rate,\
       ROUND(AVG(LIMIT_BAL), 0) AS avg_credit_limit,\
       ROUND(AVG(BILL_AMT1), 0) AS avg_outstanding_balance\
FROM loans;\
\
\
-- 2. Default rate by education\
SELECT EDUCATION, COUNT(*) AS borrowers, ROUND(AVG("default"), 3) AS default_rate\
FROM loans\
GROUP BY EDUCATION\
ORDER BY default_rate DESC;\
\
\
-- 3. Default rate by credit limit band\
SELECT CASE WHEN LIMIT_BAL < 50000 THEN 'Low'\
            WHEN LIMIT_BAL < 150000 THEN 'Medium'\
            ELSE 'High' END AS limit_band,\
       COUNT(*) AS borrowers,\
       ROUND(AVG("default"), 3) AS default_rate,\
       ROUND(AVG(BILL_AMT1), 0) AS avg_balance\
FROM loans\
GROUP BY limit_band;\
\
\
-- 4. High-risk segments: repayment statuses with above-average default rates (CTE)\
WITH overall AS (SELECT AVG("default") AS overall_rate FROM loans)\
SELECT PAY_1, COUNT(*) AS borrowers, ROUND(AVG("default"), 3) AS default_rate,\
       ROUND((SELECT overall_rate FROM overall), 3) AS overall_rate\
FROM loans\
GROUP BY PAY_1\
HAVING AVG("default") > (SELECT overall_rate FROM overall);\
\
\
-- 5. Default rate by age group\
SELECT CASE WHEN AGE < 30 THEN '20-29'\
            WHEN AGE < 40 THEN '30-39'\
            WHEN AGE < 50 THEN '40-49'\
            ELSE '50+' END AS age_group,\
       COUNT(*) AS borrowers,\
       ROUND(AVG("default"), 3) AS default_rate\
FROM loans\
GROUP BY age_group\
ORDER BY age_group;\
\
\
-- 6. Late payers then vs. now (the data has no dates, so this compares months)\
SELECT 'Late in latest month (PAY_1)' AS period,\
       COUNT(*) AS borrowers, ROUND(AVG("default"), 3) AS default_rate\
FROM loans WHERE PAY_1 >= 1\
UNION ALL\
SELECT 'Late six months ago (PAY_6)',\
       COUNT(*), ROUND(AVG("default"), 3)\
FROM loans WHERE PAY_6 >= 1;}