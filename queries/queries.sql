-- Analyzing NHANES Data 
-- note 1: when analyzing, we do NOT want to treat all records equally. All analyses must factor in the population weights in order to represent the total population.
-- note 2: given that the total_population for this data is ~279M, and the US pop is nearly ~350 (common knowledge), using actual population sums may may seem smaller than they are (by about 20%) so use %s! 

-- SELECT
--     *
-- FROM
--     nhanes_data
    
-- Total population (testing, validating calculations)
-- SELECT
--     SUM(normalized_weight),
--     ROUND(SUM(normalized_weight)),
--     AVG(total_pop),
--     ROUND(AVG(total_pop))
-- FROM 
--     nhanes_data

-- Population by A1C 
-- SELECT
--     a1c_threshold AS "A1C Blood Glucose",
--     (SUM(normalized_weight) / AVG(total_pop)) AS "Population (%)"
-- FROM nhanes_data
-- GROUP BY 1
-- ORDER BY 2 DESC

-- Population by HOMA-IR
-- SELECT
--     insulin_sensitivity AS "HOMA-IR Insulin Sensitivity",
--     (SUM(normalized_weight) / AVG(total_pop)) AS "Population (%)"
-- FROM nhanes_data
-- GROUP BY 1
-- ORDER BY 2 DESC


-- Population distribution by Age Group  
-- SELECT
--     age_cohort AS "Age Group",
--     (SUM(normalized_weight) / AVG(total_pop)) AS "Population (%)"
-- FROM nhanes_data
-- GROUP BY 1
-- ORDER BY 1 ASC


-- Population by BMI 
-- SELECT
--     bmi_threshold AS "BMI",
--     (SUM(normalized_weight) / AVG(total_pop)) AS "Population (%)"
-- FROM nhanes_data
-- GROUP BY 1
-- ORDER BY 1 ASC



-- Pop Dist of Beta Cell Health and Dysfunction
-- SELECT
--         CASE
--         WHEN a1c_threshold IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity IN ('Early resistance', 'Significant resistance') 
--             THEN 'Elevated A1C and HOMA-IR' 
--         WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity IN ('Early resistance', 'Significant resistance') 
--             THEN 'Elevated HOMA-IR Only'
--         WHEN a1c_threshold IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
--             THEN 'Elevated A1C Only'
--         WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
--             THEN 'Normal A1C and HOMA-IR'
--         ELSE 'unknown'
--         END AS "Beta Cell Health and Dysfunction",
--     (SUM(normalized_weight) / AVG(total_pop)) AS "Population (%)"
-- FROM nhanes_data
-- GROUP BY 1
-- ORDER BY 2 DESC


-- Pop Dist of Beta Cell Health and Dysfunction by Age Group / BMI (two significant risk factors for diabetes) (substitute out age/bmi as needed)
-- SELECT
--     age_cohort AS "Age Group",
--     -- bmi_threshold AS "BMI",
--     CASE
--         WHEN a1c_threshold IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity IN ('Early resistance', 'Significant resistance') 
--             THEN 'Elevated A1C and HOMA-IR' 
--         WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity IN ('Early resistance', 'Significant resistance') 
--             THEN 'Elevated HOMA-IR Only'
--         WHEN a1c_threshold IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
--             THEN 'Elevated A1C Only'
--         WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
--             THEN 'Normal A1C and HOMA-IR'
--         ELSE 'unknown'
--         END AS "Beta Cell Health and Dysfunction",
--     (SUM(normalized_weight) / AVG(total_pop)) AS "Population (%)"
-- FROM nhanes_data
-- GROUP BY 1, 2
-- ORDER BY 1 ASC, 3 DESC 


-- Normalized/Likelihood of Beta Cell Health and Dysfunction by Age / BMI (Can also substitute in alternate case statement for overall health)  
WITH group_totals AS (
    SELECT
        age_cohort AS age_group,
        -- bmi_threshold AS bmi_group,
        SUM(normalized_weight) AS group_weight
    FROM nhanes_data
    GROUP BY 1
)
SELECT
    age_group AS "Age Group",
    -- bmi_group AS "BMI",
    -- CASE
    --     WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
    --         THEN 'Normal A1C and HOMA-IR'
    --     ELSE 'Beta Cell Dysfunction'
    -- END AS "Healthy vs Beta-Cell Dysfunction",
    CASE
        WHEN a1c_threshold IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity IN ('Early resistance', 'Significant resistance') 
            THEN 'Elevated A1C and HOMA-IR' 
        WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity IN ('Early resistance', 'Significant resistance') 
            THEN 'Elevated HOMA-IR Only'
        WHEN a1c_threshold IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
            THEN 'Elevated A1C Only'
        WHEN a1c_threshold NOT IN ('Diabetes', 'Prediabetes') AND insulin_sensitivity NOT IN ('Early resistance', 'Significant resistance') 
            THEN 'Normal A1C and HOMA-IR'
        ELSE 'unknown'
        END AS "Beta Cell Health and Dysfunction",
    SUM(normalized_weight) / MAX(group_weight) AS "Likelihood (%)"
FROM nhanes_data
JOIN group_totals
    ON nhanes_data.age_cohort = group_totals.age_group
    -- ON nhanes_data.bmi_threshold = group_totals.bmi_group
GROUP BY 1, 2
ORDER BY 1 ASC, 3 DESC 