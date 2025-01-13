# Measuring Insulin Sensitivity to Predict Type 2 Diabetes
The current method of measuring and diagnosing Type 2 Diabetes is primarily based on the standard A1C blood glucose test. However, this method alone can result in missing the 
long window of early detection for the disease by up to decades, as blood glucose will typically only rise once a person is already resistant to their insulin response, meaning that their 
body's mechanism of keeping blood sugar within a normal range has already become compromised. Early detection and treatment are essential for the improvement of individual health outcomes 
as well as reducing the population burden of the disease. By increasing the prevalence of insulin sensitivity testing, at-risk individuals could recieve earlier interventions and 
ultimately achieve significantly better health outcomes.
 

## Objectives and Goals
My primary goals for this analysis:
 1. To demonstrate with a data-driven approach that insulin resistance, when tested, does indeed precede diabetes
 2. Identify a subset of the US population that could benefit from, and be targeted for, an earlier intervention
 3. Demonstrate data analysis skills by using Python to extract, transform, and load the data and then using SQL and visualization to provide a meaningful assessment of the data 
 
My secondary goals:
1) Gain a deeper understanding of diabetes, how it progresses, and how to measure it
2) Learn more about the NHANES survey and methodology, including working with complex documentation and population weights
3) Consider the impact of the analysis and other potential areas of exploration


## An Overview of Diabetes
Type 2 Diabetes is a chronic disease that impacts how the body processes sugar, characterized by a decreasingly effective insulin response over time. Insulin is produced by beta-cells in the pancreas in order to regulate blood sugar. As a person's insulin becomes less effective at regulating blood sugar, the body has to produce progressively more insulin to keep blood sugar within a normal range. Eventually, as the disease develops and progresses, the beta-cells in the pancreas begin to fail, where either they cannot produce enough insulin or the insulin is simply ineffective, and blood sugar will then begin to rise. In advanced stages of the disease, after insulin has stopped being produced, insulin deficiency will occur, requiring injections to maintain blood sugar. As the disease progresses, it becomes much harder to reverse the damage, so early detection and a lifestyle changes (in particular, diet and physical activity) are often essential for improvement. [[1]](https://diabetes.org/living-with-diabetes/type-2/how-type-2-diabetes-progresses)

The disease impacts a significant portion of the US (and global) population, and has continued to rise over time [[2]](https://archive.cdc.gov/www_cdc_gov/diabetes/library/reports/reportcard/national-state-diabetes-trends.html?). It is associated with a variety of health challenges; from obesity and deterioration of health and wellness at the individual level, to population level impacts such as loss of productivity [[3]](https://diabetesjournals.org/care/article/45/11/2553/147546/Productivity-Loss-and-Medical-Costs-Associated?) and significant healthcare costs [[4]](https://diabetes.org/newsroom/press-releases/new-american-diabetes-association-report-finds-annual-costs-diabetes-be) (and given that CMS (Centers for Medicare & Medicaid) is the single largest healthcare payer in the United States [[5]](https://www.cms.gov/cms-guide-medical-technology-companies-and-other-interested-parties/payment), that means the government often absorbs this burden).

Although not in the scope of this analysis, Type 1 Diabetes is an autoimmune condition that occurs at birth, impacts a much smaller percentage of the population, and represents significantly less population burden.

## An Overview of the NHANES Survey
The NHANES (National Health and Nutrition Examination Survey) is a long-running effort from the CDC to release health data for public use in multi-year cycles. The data is used by government agencies, organizations, and businesses as well as for academic use by instutitions and students. The various surveys administered (broken into "components") are meant to be able to represent the majority of the US population. It excludes people that...

The data is available in "components", which include a number of data fields and a population weight that can be used to show how representative a given survey participant is of the entire US population (which is determined by the awesome statisticians behind the effort to abstract out complex demographic and response information). By joining data across different components and normalizing the population weight across one's filtered data, one can craft a targeted analyis within the scope of anything that the NHANES survey measures.

For this effort, we will be looking at the following components: [Glycohemoglobin](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GHB_L.htm#WTPH2YR) (A1C), [Plasma Fasting Glucose](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GLU_L.htm) and [Insulin](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/INS_L.htm) (both needed to calculate Insulin Sensitivity), [Demographics](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm#RIDAGEYR) (specifically for Age), and [Examination](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BMX_L.htm#BMXBMI) (specifically for BMI). 

## Extracting, Transforming, and Loading the Data
After downloading the datasets from the respective components, the following steps are taken in Python:
1. Reading the XPT files using pyreadstat and turning them into pandas dataframes
2. Merging all of the dataframes into one and cleaning the new dataframe to only see the core fields that we need
3. Dropping all null values from our core data so that we only see records where participants had all information measured (namely, glycohemoglobin, fasting glucose, insulin, age, and bmi). This would also include '0' values that denote missing data, if there were any that existed.
4. Identify and calculate a new population weight for the filtered data. After filtering to only see participants with core data, none of the original 4 population weights (glycohemoglobin labs, fasting labs, demographics, and physical examinations) are able to be used as-is (as some degree of data was dropped from each). Thus, we must calculate a new one, where the population weights for each participant in our filtered data sum up to the original total population. The NHANES documentation recommends utilizing the most restrictive of the weights involved in your analysis, so after calculating the percent of data that would be lost by selecting each of the weights, we can see that the smallest percentage loss by far, with only ~6% of records from the original dataset lost, was the weight for the fasting labs (which is logical as it had the smallest number of original participants). Given that the total population from the original fasting labs was ~280 million, and the sum of the remaining fasting lab weights for our filtered data is ~264 million, we simply scale up our remaining weights by a factor of ~6% to match the original population.
5. Using our new set of data, interpret the following:
    - A1C Threshold (Normal, Prediabetic, Diabetic)
    - Insulin Sensitivity (Normal, Early, and Significant Insulin Resistance)
    - Age Cohort by Decade (with 12 years being the minimum age for lab data, and all participants over 80 being set == 80 by NHANES)
    - BMI (From underweight to the increasing levels of obesity, as defined by the CDC)
6. Final cleaning, review, and load into database

## Analyzing the Data
With the data ready for analysis, the following questions are under consideration:
1. How are each of our 4 core data fields (Diabetes, Insulin Sensitivity, Age, and BMI) distributed across the population?
2. What is the relationship between Diabetes and Insulin Resistance across the entire population?
3. What is the relationship between Diabetes and Insulin Resistance within the context of Age and BMI, two major risk factors for Diabetes?
4. What is the subset of the population experiencing Insulin Resistance but does not yet have elevated A1C? 



## Conclusion 




## Additional Resources  
### [The CDC's National Health and Nutrition Examination Survey (NHANES) 2021 to 2023 Cycle](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2021-2023)
- [Brief Overview of Sample Design and Analytics Guidelines](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/overviewbrief.aspx?Cycle=2021-2023)
- [Full Survey Methods and Analytics Guidelines](https://wwwn.cdc.gov/nchs/nhanes/analyticguidelines.aspx#analytic-guidelines)
- [Tutorials for Analysts](https://wwwn.cdc.gov/nchs/nhanes/tutorials/default.aspx)
- [Glycohemoglobin Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GHB_L.htm#WTPH2YR)
- [Fasting Glucose Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GLU_L.htm)
- [Insulin Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/INS_L.htm)
- [Demographics Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm#RIDAGEYR)
- [Physical Examination Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BMX_L.htm#BMXBMI)

### Great Information
- [How Type 2 Diabetes Progresses](https://diabetes.org/living-with-diabetes/type-2/how-type-2-diabetes-progresses)
- [National and State Diabetes Trends](https://archive.cdc.gov/www_cdc_gov/diabetes/library/reports/reportcard/national-state-diabetes-trends.html?)
- [Diabetes and Loss of Productivity](https://diabetesjournals.org/care/article/45/11/2553/147546/Productivity-Loss-and-Medical-Costs-Associated?)
- [Diabetes and Healthcare Costs](https://diabetes.org/newsroom/press-releases/new-american-diabetes-association-report-finds-annual-costs-diabetes-be)
- [Insulin Resistance and Prediabetes (NIH)](https://www.niddk.nih.gov/health-information/diabetes/overview/what-is-diabetes/prediabetes-insulin-resistance)

### Various Calculations
- [A1C Blood Glucose Thresholds (Diabetes.org)](https://diabetes.org/about-diabetes/a1c)
- [HOMA-IR Insulin Sensitivity Information & Calculation](https://en.wikipedia.org/wiki/Homeostatic_model_assessment) [(2)](https://www.omnicalculator.com/health/homa-ir#what-is-homa-ir-homa-formula-calculation)
- [HOMA-IR Insulin Sensitivity Thresholds](https://thebloodcode.com/homa-ir-know/) [(2)](https://drlogy.com/calculator/homa-ir)
- [BMI Thresholds (CDC)](https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html)