# Measuring Insulin Sensitivity to Predict Type 2 Diabetes
The current method of measuring and diagnosing Type 2 Diabetes is primarily based on the standard A1C blood glucose test. However, this method alone can result in missing the 
long window of early detection for the disease by up to decades, as blood glucose will typically only rise once a person is already resistant to their insulin response, meaning that their 
body's mechanism of keeping blood sugar within a normal range has already become compromised. Early detection and treatment are essential for the improvement of individual health outcomes 
as well as reducing the population burden of the disease. By increasing the prevalence of insulin sensitivity testing, at-risk individuals could recieve earlier interventions and 
ultimately achieve significantly better health outcomes.
 

## Objectives and Goals 
The primary goals:
 1. To demonstrate with a data-driven approach that insulin resistance, when tested, does indeed precede diabetes
 2. Identify a subset of the US population that could benefit from, and be targeted for, an earlier intervention
 3. Demonstrate data analysis skills by using Python to extract, transform, and load the data and then using SQL and visualization to provide a meaningful assessment of the data 
 
The secondary goals:
1) Gain a deeper understanding of diabetes, how it progresses, and how to measure it
2) Learn more about the NHANES survey and methodology, including working with complex documentation and population weights
3) Consider the impact of the analysis and other potential areas of exploration


## An Overview of Diabetes
Type 2 Diabetes is a chronic disease that impacts how the body processes sugar, characterized by a decreasingly effective insulin response over time. Insulin is produced by beta-cells in the pancreas in order to regulate blood sugar. As a person's insulin becomes less effective at regulating blood sugar, the body has to produce progressively more insulin to keep blood sugar within a normal range. Eventually, as the disease develops and progresses, the beta-cells in the pancreas begin to fail, where either they cannot produce enough insulin or the insulin is simply ineffective, and blood sugar will then begin to rise. In advanced stages of the disease, after insulin has stopped being produced, insulin deficiency will occur, requiring injections to maintain blood sugar. As the disease progresses, it becomes much harder to reverse the damage, so early detection and a lifestyle changes (in particular, diet and physical activity) are often essential for improvement. [[1]](https://diabetes.org/living-with-diabetes/type-2/how-type-2-diabetes-progresses)

The disease impacts a significant portion of the US (and global) population, and has continued to rise over time [[2]](https://archive.cdc.gov/www_cdc_gov/diabetes/library/reports/reportcard/national-state-diabetes-trends.html?). It is associated with a variety of health challenges; from obesity and deterioration of health and wellness at the individual level, to population level impacts such as loss of productivity [[3]](https://diabetesjournals.org/care/article/45/11/2553/147546/Productivity-Loss-and-Medical-Costs-Associated?) and significant healthcare costs [[4]](https://diabetes.org/newsroom/press-releases/new-american-diabetes-association-report-finds-annual-costs-diabetes-be) (and given that CMS (Centers for Medicare & Medicaid) is the single largest healthcare payer in the United States [[5]](https://www.cms.gov/cms-guide-medical-technology-companies-and-other-interested-parties/payment), that means the government often absorbs this burden).

Although not in the scope of this analysis, Type 1 Diabetes is an autoimmune condition that occurs at birth, impacts a smaller percentage of the population, and represents less population burden.

## An Overview of the NHANES Survey
The NHANES (National Health and Nutrition Examination Survey) is a long-running effort from the CDC to release health data for public use in multi-year cycles. The data is used by government agencies, organizations, and businesses as well as for academic use by instutitions and students. The various surveys administered (broken into "components") are meant to be able to represent the majority of the US population (US citizens, non-institutionalized).

The data is available in "components", which include a number of data fields and a population weight that can be used to show how representative a given survey participant is of the entire US population (which is determined by the statisticians behind the effort to abstract out complex demographic and response factors). By joining data across different components and normalizing the population weight to one's filtered data, one can craft a targeted analyis within the scope of anything that the NHANES survey measures.

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

![The Python Notebook for this ETL is available for review and use.](./python/nhanes_data_etl_public.ipynb) 

![The raw NHANES datasets are available here.](./data/raw/) 

![The final, cleaned dataset is available here.](./data/clean/nhanes_data.csv)

## Analyzing the Data
With the data ready for analysis, the following questions are under consideration:
1. How are each of our 4 core data fields (Diabetes, Insulin Sensitivity, Age, and BMI) distributed across the population?
2. What is the relationship between Diabetes and Insulin Resistance across the entire population?
3. What is the relationship between Diabetes and Insulin Resistance within the context of Age and BMI, two major risk factors for Diabetes?
4. What is the subset of the population experiencing Insulin Resistance but does not yet have elevated A1C? 

### Population Distribution of Diabetes
![Population Distribution of Diabetes](./analysis/Population%20Distribution%20of%20Diabetes.jpg)
- Approximately 70% of the population has a normal blood sugar level, 20% have Prediabetes, and 9% have Diabetes.

### Population Distribution of Insulin Resistance
![Population Distribution of Insulin Resistance](./analysis/Population%20Distribution%20of%20Insulin%20Resistance.jpg)
- Approximately 41% of the population has a normal insulin sensitivity, 20% is experiencing early resistance, and 39% have significant resistance. 

### Population Distribution by Age Group
![Population Distribution by Age Group](./analysis/Population%20Distribution%20of%20Age%20Groups.jpg)
- The population is distributed relatively evenly across age groups.
- The data is limited to the age range of 12-80 because age 12 was the minimum age to participate in lab work, and NHANES denotes everyone over age 80 as just 80.

### Population Distribution by BMI
![Population Distribution by BMI](./analysis/Population%20Distribution%20of%20BMI.jpg)
- Approximately 30% of the population is a normal weight, 29.5% are overweight, and 38% experience some degree of obesity. Less than 3% are underweight.

### Diabetes vs Insulin Resistance
![Diabetes vs Insulin Resistance](./analysis/Diabetes%20vs%20Insulin%20Resistance.jpg)
- Approximately 35% of the population is healthy, another 35% are experiencing insulin resistance without elevated blood sugar, 24% are experiencing both elevated insulin and blood sugar, and 6.5% are experiencing elevated A1C only.
- The small percentage of folks with elevated blood sugar but not elevated insulin likely could have two potential explanations. First, it could represent Type 1 Diabetics, whose bodies do not effectively produce insulin, which would explain elevated blood sugar and low insulin resistance. Second, it is possible that folks who are treating their Type 2 Diabetes with a medication like Metformin that increases insulin sensitivity (making it more effective at lowering blood sugar) but does not necessarily directly lower it.
- This suggests that, while just over a third of the population has a healthy blood sugar and insulin response, just as many are experiencing early insulin resistance, with the remaining 30% experiencing some degree of elevated blood sugar and beta-cell dysfunction.

### Diabetes vs Insulin Resistance by Age Group
![Diabetes vs Insulin Resistance by Age Group](./analysis/Diabetes%20vs%20Insulin%20Resistance%20by%20Age%20Group.jpg)

- This chart not only shows how diabetes and insulin resistance change as age increases, but it also shows which category is the most predominant for a given age group.
- The predominant groups for the first 3 decades of life are a healthy response and insulin sensitivity. It is very unlikely to experience elevated blood sugar at an early age, and could potentially be explained entirely by Type 1 Diabetes (which is present from birth).
- It appears that, in general, healthiness peaks between age 30-40, and insulin resistance only begins to decline in favor of elevated blood sugar & insulin together, with a reversal between the prominence of health and diabetes at age 50. Elevated blood sugar & insulin resistance remains the most prominent category for all older age groups after age 50, with the total population across all categories experiencing a sharp drop off with respect to increasing age. 

### Diabetes vs Insulin Resistance by BMI
![Diabetes vs Insulin Resistance by BMI](./analysis/Diabetes%20vs%20Insulin%20Resistance%20by%20BMI.jpg)

- The final chart shows how Diabetes and Insulin Resistance change over time as BMI increases. In contrast with the previous chart, this does not factor in age group.
- There seems to be a clear relationship between healthy weight and healthy blood sugar & insulin response. However, even at a normal weight, there is a non-insignificant degree of insulin resistance. In the progression to overweight or obese (1), there is a reversal in the prominence of healthy and unhealthy.
- Although the lines seem to decrease towards the end, this is more representative of a smaller population of extremely overweight folks, but we can still see that elevated resistance & blood sugar has an inverse relationship with healthy resistance and blood sugar (with the population difference being multiple times larger than in lower BMI groups). 

This analysis provides an extremely insightful view of diabetes and its factors across the US population.

## Conclusion 

In Summary:
- We can confirm that insulin resistance does indeed precede the onset of diabetes by a measurable degree, with about 35% of the population experiencing insulin resistance but not yet having elevated blood sugar, often from a young age. If these folks were given an A1C blood sugar test, they would test in the normal range. This is a significant amount of the US population that could benefit from knowing that they are on the path to developing diabetes.
- This analysis fully succeeds at demonstrating the scale and depth of the public health problem, but unfortunately it may not be able to be fixed by increased lab testing alone. It likely requires a massive societal shift to address the many contributing factors involved that encourage the development of diabetes and obesity, which is an infinitely more complex public health problem to address, and would take time for change to materialize.
- Despite public health challenges, insulin sensitivity testing could still be a valuable tool for a healthcare practitioner or a health-conscious person who is at-risk to get an early start on the lifestyle changes they may need to implement. Although is not clear how many actually make quantifiable lifestyle changes after recieving a diagnosis, the earlier we can tell anyone in the 35% of the population experiencing insulin resistance that they're at-risk the better.

A few obstacles to improving public health include:
- Educating the medical community that insulin sensitivity precedes diabetes and that it can be tested
- Encouraging insurers to actually cover the fasting glucose and insulin tests instead of just the A1C test, which is often a barrier
- Educating the general public on Type 2 Diabetes in a way that contextualizes the severity of present unhealthy behaviors as major contributors to a decline in health with age 
- The affordability, accessibility, and prevalence of high-carb diets (which have agricultural and economic implications, given that heavily subsidized crops like corn and grain are in many of our foods, and may also explain why we see high insulin resistance even from a young age, suggesting that many people are not suited for high-carb diets and end up unknowingly facing the consequences)
- Other factors contributing to the obesity epidemic, such as a rise in sedentary lifestyle (caused by an increase in desk jobs, widely accessible mass entertainment, and more)


## Various Resources  
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

### Calculations
- [A1C Blood Glucose Thresholds (Diabetes.org)](https://diabetes.org/about-diabetes/a1c)
- [HOMA-IR Insulin Sensitivity Information & Calculation](https://en.wikipedia.org/wiki/Homeostatic_model_assessment) [(2)](https://www.omnicalculator.com/health/homa-ir#what-is-homa-ir-homa-formula-calculation)
- [HOMA-IR Insulin Sensitivity Thresholds](https://thebloodcode.com/homa-ir-know/) [(2)](https://drlogy.com/calculator/homa-ir)
- [BMI Thresholds (CDC)](https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html)