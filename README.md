# Measuring Insulin Resistance to Predict Type 2 Diabetes & Improve Population health 💉

Diabetes is one of the most common diseases impacting public health. Many of us know someone affected by it, yet few are aware of insulin resistance, the underlying driver of the disease. Despite being a measurable prerequisite to Type 2 Diabetes, insulin resistance is often neglected in routine screenings and early intervention. Furthermore, even though elevated blood sugar is the hallmark trait of Type 2 Diabetes, common medications for the disease (such as Metformin or Semaglutide) primarily work (in different ways) to improve insulin function, not simply directly lower blood sugar. The current approach to treating Diabetes is like ignoring smoke in the distance until the fire is clearly visible. This project aims to demonstrate that insulin resistance can be measured and used to improve public health. 

## Overview 

The standard method for diagnosing and measuring Type 2 Diabetes is primarily based on the popular Hemoglobin A1C test, which measures average blood glucose (blood sugar) over approximately the past 3 months. However, this method alone can result in missing the long window of early detection for the disease by up to decades, as blood glucose will typically only rise once a person is already resistant to their insulin response, which happens progressively over time as beta cells in the pancreas begin to experience dysfunction, and only results in an elevated A1C test once their body's ability to keep blood sugar within a normal range has already become compromised. 

Despite growing awareness of diabetes risk factors such as obesity, aging, and a sedentary lifestyle, routine screenings essentially never include direct assessment of beta cell function or insulin resistance. This gap in early detection means that a significant portion of the population may be unaware that they are already on the path to developing diabetes. Given that the current diagnostic criteria focuses solely on blood glucose levels, early beta cell dysfunction often goes unrecognized, delaying intervention until the disease has already fully developed - at which point the disease becomes significantly harder to reverse.

This analysis leverages publicly available NHANES data from the CDC to investigate insulin resistance at a population level. The findings below ultimately suggest that a substantial proportion of individuals, roughly 35% of the entire US population, exhibits what could be called "covert insulin resistance" - a state in which beta cell function has begun to decline, yet blood glucose remains within normal levels. 

By identifying patterns in insulin resistance before overt hyperglycemia (elevated blood sugar) develops, this project highlights the need for a more proactive approach to metabolic health. A shift in screening strategies could allow for earlier interventions that preserve beta cell function and potentially prevent the onset of Type 2 Diabetes altogether.
  

## Objectives 
 1. To demonstrate with a data-driven approach that insulin resistance, when tested, does indeed precede diabetes
 2. Identify a subset of the US population that could benefit from, and be targeted for, an earlier intervention
 3. Consider the role that risk factors such as Age and BMI play in the development of the disease

## Understanding Diabetes & Insulin Resistance 
Type 2 Diabetes is a chronic disease that impacts how the body processes sugar, characterized by a decreasingly effective insulin response over time. Insulin is produced by beta cells in the pancreas in order to regulate blood sugar. As a person's insulin becomes less effective at regulating blood sugar, the body has to produce progressively more insulin to keep blood sugar within a normal range. Eventually, as the disease develops and progresses, the beta cells in the pancreas begin to fail, where either they cannot produce enough insulin or the insulin is simply ineffective, and blood sugar will then begin to rise. In advanced stages of the disease, after insulin has stopped being produced, insulin deficiency will occur, requiring injections to maintain blood sugar. As the disease progresses, it becomes much harder to reverse the damage, so early detection and a lifestyle changes (in particular, diet and physical activity) are often essential for improvement. [[1]](https://diabetes.org/living-with-diabetes/type-2/how-type-2-diabetes-progresses)

The disease impacts a significant portion of the US (and global) population, and has continued to rise over time [[2]](https://archive.cdc.gov/www_cdc_gov/diabetes/library/reports/reportcard/national-state-diabetes-trends.html?). It is associated with a variety of health challenges; from obesity and deterioration of health and wellness at the individual level, to population level impacts such as loss of productivity [[3]](https://diabetesjournals.org/care/article/45/11/2553/147546/Productivity-Loss-and-Medical-Costs-Associated?) and significant healthcare costs [[4]](https://diabetes.org/newsroom/press-releases/new-american-diabetes-association-report-finds-annual-costs-diabetes-be) (and given that CMS (Centers for Medicare & Medicaid) is the single largest healthcare payer in the United States [[5]](https://www.cms.gov/cms-guide-medical-technology-companies-and-other-interested-parties/payment), that means the government often absorbs the cost and would also benefit from investing in public health).

In order to diagnose Type 2 Diabetes, the standard Hemoglobin A1C (blood glucose) test is administered. To be precise, the test measures the total percentage of hemoglobin (a protein in red blood cells) that have glucose attached (they bind to the hemoglobin). Since red blood cells have a lifespan of roughly 90 days, the test is considered to be an average of blood glucose over the last ~3 months. The A1C threshold levels are listed below.

<!-- ![A1C Thresholds](./charts/A1C%20Thresholds.jpg)   -->
<img src="./charts/Figure 1.1 A1C Thresholds.jpg" alt="Figure 1.1: A1C Thresholds" width="300"/> 

[A1C Explanation from Diabetes.org](https://diabetes.org/about-diabetes/a1c) 

In order to measure Insulin Resistance (or Insulin Sensitivity, with regard to healthiness), we can use a test called the HOMA-IR (Homeostatic Model Assessment of Insulin Resistance), which is a mathematical calculation interpreting the values of two blood tests: fasting glucose and fasting insulin. Although interpretation can vary slightly based for different populations, it has been used in both clinical and research settings. The thresholds used in this analysis, as well as a link to an online calculator, are listed below.

<!-- ![HOMA-IR Thresholds](./charts/HOMA-IR%20Thresholds.jpg) -->
<img src="./charts/Figure 1.2 HOMA-IR Thresholds.jpg" alt="Figure 1.2: HOMA-IR Thresholds" width="360"/>

[A great HOMA-IR calculator is available here.](https://www.omnicalculator.com/health/homa-ir) 

*In parts of the analysis, for the sake of simplicity, both of the elevated A1C thresholds can be combined to just "elevated blood sugar" and both of the elevated insulin resistance thresholds can be combined into "insulin resistance". The degree to which they are experiencing dysfunction for either area is not as important as simply the binary nature that they *are* experiencing it to some degree, making it likely that it will continue to develop over time.*

Although not in the scope of this analysis, Type 1 Diabetes is an autoimmune condition that occurs at birth, where the body does not produce insulin sufficiently or at all, which causes blood sugar to spike after consumption without supplemental insulin to manage the reaction. It is helpful to know this because Type 1 Diabetics also experience beta cell dysfunction and will be represented to some extent in this data, though it impacts a much smaller percentage of the total population.

Here is a flow chart to help visualize how blood sugar and insulin resistance change as Diabetes develops and progresses:
<!-- ![The Progression of Diabetes](./charts/The%20Progression%20of%20Diabetes.jpg)  -->
<img src="./charts/Figure 1.3 The Progression of Diabetes.jpg" alt="Figure 1.3: The Progression of Diabetes" width="1500"/>

## The National Health and Nutrition Examination Survey
The National Health and Nutrition Examination Survey ("NHANES") is a long-running effort from the CDC to release free and accessible population health data in multi-year cycles to help assess and improve public health. The data is used by government agencies, organizations, and businesses as well as for academic use by instutitions and students. The various surveys administered (broken into "components") are meant to be able to represent the majority of the US population (US citizens, non-institutionalized).

The data is available in "components", which include a number of data fields and a population weight that can be used to show how representative a given survey participant is of the entire US population (which is determined by the survey statisticians to abstract out complex demographic and response factors). By joining data across different components and normalizing the population weight to one's filtered data, one can craft a targeted analysis within the scope of anything that the NHANES survey measures.

For this effort, we will be looking at the following components: [Glycohemoglobin](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GHB_L.htm#WTPH2YR) (A1C), [Plasma Fasting Glucose](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GLU_L.htm) and [Fasting Insulin](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/INS_L.htm) (both needed to calculate Insulin Sensitivity), [Demographics](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm#RIDAGEYR) (specifically for Age), and [Examination](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BMX_L.htm#BMXBMI) (specifically for BMI). 

## Extracting, Transforming, and Loading the Data
After downloading the datasets from the respective components, the following steps are taken in Python:
1. Reading the XPT files using pyreadstat and turning them into pandas dataframes
    - This is performed for all 5 components; Glycohemoglobin, Fasting Glucose, Fasting Insulin, Age, & BMI *(the images only show the first two as examples)*

<img src="./charts/ETL-1.1 Reading XPT Files.jpg" alt="ETL 1.1" width="850"/> 

<img src="./charts/ETL-1.2 Printing XPT Files.jpg" alt="ETL 1.2" width="400"/> 

2. Merging all of the dataframes into one and cleaning the new dataframe to only see the core fields that we need

3. Dropping all null values from our core data so that we only see records where participants had all information measured (specifically, Glycohemoglobin, Fasting Glucose, Fasting Insulin, Age, and BMI).
    - We would also drop any '0' values (that denote missing data), if there were any that existed.

<img src="./charts/ETL-2.1 Merging and Cleaning.jpg" alt="ETL 2.1" width="800"/> 

4. Identify and calculate a new population weight for the filtered data.
    - After filtering to only see participants with core data, none of the original 4 population weights (Glycohemoglobin labs, Fasting labs, Demographics, and Physical Examinations) are able to be used as-is (as some degree of data was dropped from each). Thus, we must calculate a new one, where the population weights for each participant in our filtered data sum up to the original total population.
    - The NHANES documentation recommends utilizing the most restrictive of the weights involved in any analysis, so after calculating the percent of data that would be lost by selecting each of the weights, we can see that the smallest percentage loss by far, with only ~6% of records from the original dataset lost, was the weight for the fasting labs (which is logical as it had the smallest number of original participants).
    - Given that the total population from the original fasting labs was ~280 million, and the sum of the remaining fasting lab weights for our filtered data is ~264 million, we simply scale up our remaining weights by a factor of ~6% to match the original population. We can verify this with simple calculations. Additionally, since the "Total Population" for this data is notably lower than the actual US population of ~350 million due to excluded groups, we will want to use *percentages* of the total population to keep the analysis simple and avoid confusion.

<img src="./charts/ETL-3.1 Identifying Population Weight.jpg" alt="ETL 3.1" width="850"/>

<img src="./charts/ETL-3.2 Calculating Population Weight.jpg" alt="ETL 3.2" width="850"/> 

<img src="./charts/ETL-3.3 Printing Population Weight Values.jpg" alt="ETL 3.3" width="750"/>  


5. Using our new set of data, interpret the following (our core data fields for analysis):
    - Diabetes (Interpreted via A1C Threshold *(Normal, Prediabetic, & Diabetic)*)
    - Insulin Sensitivity (Interpreted via HOMA-IR *(Normal, Early, & Significant Insulin Resistance)*)
    - Age Cohort by Decade (With 12 years being the minimum age for lab data, and all participants over 80 being set == 80 by NHANES)
    - BMI (From underweight to the increasing levels of obesity, as defined in the Official CDC Guidelines)

<img src="./charts/ETL-4.1 Interpreting A1C and HOMA-IR.jpg" alt="ETL 4.1" width="800"/>

<img src="./charts/ETL-4.2 Interpreting Age Cohorts.jpg" alt="ETL 4.2" width="600"/> 

<img src="./charts/ETL-4.3 Interpreting BMI.jpg" alt="ETL 4.3" width="600"/> 

6. Final cleaning and review (before loading into database for further analysis)
    - The printed dataframe shows all fields
    - The described dataframe shows stats for all numerical fields 

<img src="./charts/ETL-5.1 Final Print.jpg" alt="ETL 5.1" width="600"/> 

<img src="./charts/ETL-5.2 Final Describe.jpg" alt="ETL 5.2" width="600"/> 
 
<div style="height:25px;"></div>
 
Final code and data for review:
- ![The Python Notebook for this ETL is available here.](./python/nhanes_data_etl_public.ipynb)

- ![The raw NHANES datasets are available here.](./data/raw/)

- ![The final, cleaned dataset is available here.](./data/clean/nhanes_data.csv)

## Analysis
With the data ready for analysis, we are evaluating the following questions:
1. How are each of our four core data fields Diabetes (A1C threshold), Insulin Sensitivity (HOMA-IR thresold), Age Group (decade), and BMI (CDC threshold) distributed across the population?
    - This will help us understand the data
2. What is the subset of the population experiencing Insulin Resistance but does not yet have elevated A1C? 
    - This is our subset of the population that would benefit from early insulin testing
3. What is the relationship between Diabetes and Insulin Resistance (i.e. Beta Cell Health and Dysfunction) across the entire population?
4. What is the relationship between Diabetes and Insulin Resistance within the context of Age and BMI, two major risk factors for Diabetes?

### **Exploring and reviewing the distribution of data across the population**
### Figure 2.1: Population Distribution of Diabetes
<img src="./charts/Figure 2.1 Population Distribution of Diabetes.jpg" alt="Figure 2.1: Population Distribution of Diabetes" width="1500"/>

- Approximately 70% of the population experiences a normal blood sugar level, 20% experience slightly elevated blood sugar (Prediabetes), and 9% have significantly elevated blood sugar (Diabetes).

### Figure 2.2: Population Distribution of Insulin Resistance
<img src="./charts/Figure 2.2 Population Distribution of Insulin Resistance.jpg" alt="Figure 2.2: Population Distribution of Insulin Resistance" width="1500"/>

- Approximately 41% of the population experiences normal insulin sensitivity, 20% early insulin resistance, and 39% significant insulin resistance.

### Figure 2.3: Population Distribution of Beta Cell Health and Dysfunction
<img src="./charts/Figure 2.3 Population Distribution of Beta Cell Health and Dysfunction.jpg" alt="Figure 2.3: Population Distribution of Beta Cell Health and Dysfunction" width="1500"/>

- Approximately 35% of the population is in a healthy state, another 35% are experiencing insulin resistance without elevated blood sugar, 24% are experiencing both elevated insulin and blood sugar, and 6.5% are experiencing elevated A1C only.
    - In other words, while just over a third of the population has a healthy blood sugar and insulin response, just as many are experiencing early insulin resistance, and the remaining 30% experiencing some form of elevated blood sugar and beta cell dysfunction.

### Figure 2.4: Population Distribution by Age Group
<img src="./charts/Figure 2.4 Population Distribution by Age Group.jpg" alt="Figure 2.4: Population Distribution by Age Group" width="1500"/>

- The population is distributed across age groups as expected, and likely aligns closely with changing demographics over time.
- The data is limited to the ages 12-80 because age 12 is the minimum age set by NHANES to participate in lab work, and NHANES denotes everyone over age 80 as just 80.

### Figure 2.5 Population Distribution of Beta Cell Health and Dysfunction by Age Group
<img src="./charts/Figure 2.5 Population Distribution of Beta Cell Health and Dysfunction by Age Group.jpg" alt="Figure 2.5 Population Distribution of Beta Cell Health and Dysfunction by Age Group" width="1500"/>

- This chart not only shows how diabetes and insulin resistance change as age increases, but it also shows which category is the most predominant for a given age group. Each data point represents a percentage of the total US population.

### Figure 2.6: Population Distribution by BMI
<img src="./charts/Figure 2.6 Population Distribution by BMI.jpg" alt="Figure 2.6: Population Distribution by BMI" width="1500"/>

- Approximately 30% of the population is a normal weight, 29.5% are overweight, and 38% experience some degree of obesity. Less than 3% are underweight.

### Figure 2.7: Population Distribution of Beta Cell Health and Dysfunction by BMI
<img src="./charts/Figure 2.7 Population Distribution of Beta Cell Health and Dysfunction by BMI.jpg" alt="Figure 2.7: Population Distribution of Beta Cell Health and Dysfunction by BMI" width="1500"/>

- This chart shows how diabetes and insulin resistance change over time as BMI increases. Each data point represents a percentage of the total US population.

### Standardizing the population
In order to evaluate our data more effectively, we want to standardize the population across our age groups to understand the proportionate likelihood of health or dysfunction for a given age group or BMI level, rather than being subjected to skew where population is higher or lower for an age group or BMI (e.g. since population decreases in older age, all data points within that age group look relatively smaller compared to more populous age groups, which makes it harder to spot the overall trends if not standardized).

### Figure 3.1: Likelihood of Beta Cell Health and Dysfunction by Age Group
<img src="./charts/Figure 3.1 Likelihood of Beta Cell Health and Dysfunction by Age Group.jpg" alt="Figure 3.1: Likelihood of Beta Cell Health and Dysfunction by Age Group" width="1500"/>

- Across the entire US population, people between ages 20-40 are most likely to experience healthiness (*neither elevated blood sugar nor insulin resistance*) as well as *insulin resistance only*. As age goes up, the prevalence of both states decline slowly in favor of the other two states, with early or developed Type 2 Diabetes (*elevated blood sugar and insulin resistance together*) in particular rising. For those around age 50, Type 2 Diabetes (*elevated blood sugar and insulin*) becomes the most prominent category and remains in the top spot for all subsequent older age groups. 
- Around 80 years old (or older), there is a sharp increase in the number of folks who experience *elevated blood sugar only, and not insulin resistance*, and aligns with a small decline in the incidence of people with *both elevated blood sugar and insulin resistance*. Although it is the state with the smallest incidence by far, the sharp spike upwards (to no longer be the least common category), may represent those who are treating their diabetes, as they are more likely to live longer (thus they begin to represent a larger percentage of the age group). 
- In the youngest age group of 12-20 years old, there is already a significant degree of insulin resistance, which is more likely to be experienced than healthy beta cell function. This may be related to significant increases in childhood obesity in recent years and decades, indicating that children are experiencing earlier onset and/or faster disease progression.

### Figure 3.2: Likelihood of Overall Health or Dysfunction by Age Group 
<img src="./charts/Figure 3.2 Likelihood of Overall Health or Dysfunction by Age Group.jpg" alt="Figure 3.3: Likelihood of Overall Health or Dysfunction by Age Group" width="1500"/>

- This chart only shows those who are healthy (*normal blood sugar and insulin sensitivity*) compared to those who have any form or degree of beta cell dysfunction (*any combination of elevated blood sugar OR insulin*).
- Although we can greater divergence as age increases, there is a large divergence in the youngest age group. This is an anomaly and seems more likely to represent worsening childhood obesity than typical disease progression. Without societal change or public health intervention to improve outcomes, this trend may continue.
- Aside from the divergence in the youngest age group of 12-20 years, adults in the 20-40 age range have relatively consistent likelihood of health or dysfunction. Around 45-55 years, there is a sharp spike in the likelihood of dysfunction, which increases slowly and consistently with continued age.
- With all forms of dysfunction grouped together, we can see that every age group is more likely to experience some form of beta cell dysfunction than healthiness. 

### Figure 3.3: Likelihood of Beta Cell Health and Dysfunction by BMI
<img src="./charts/Figure 3.3 Likelihood of Beta Cell Health and Dysfunction by BMI.jpg" alt="Figure 3.2: Likelihood of Beta Cell Health and Dysfunction by BMI" width="1500"/>

- After standardization of the population across BMI thresholds, we can see a clear inverse relationship between weight and beta cell function. As weight increases, it becomes steadily more likely to experience beta cell dysfunction, or progression towards Type 2 Diabetes.
- It is worth noting that, even at a "normal" or "healthy" weight, there is still a non-insignificant degree of insulin-resistance, which may indicate that beta cell dysfunction or diabetes will still progress or develop with age. 


### Figure 3.4: Likelihood of Overall Health and Dysfunction by BMI 
<img src="./charts/Figure 3.4 Likelihood of Overall Health and Dysfunction by BMI.jpg" alt="Figure 3.4: Likelihood of Overall Health and Dysfunction by BMI" width="1500"/>

- This final chart confirms the inverse relationship between weight and beta cell function, with the inversion between health and dysfunction at approximately the transition from normal weight to overweight. 


#### This analysis provides an extremely insightful view of diabetes and its factors across the US population.
[The queries behind these charts are available for review here.](./queries/queries.sql)

## Conclusion 

In summary:
- We can confirm that insulin resistance does indeed precede the onset of diabetes by a measurable degree, with about 35% of the population experiencing insulin resistance but not yet having elevated blood sugar, including (and becoming more common for) younger age groups. If these folks were given an A1C blood glucose test, they would test in the normal range. This is a significant portion of the US population that could benefit from knowing that they are on the path to developing Type 2 Diabetes.
- This analysis fully succeeds at demonstrating the scale and depth of the public health problem, but unfortunately it may not be able to be fixed by increased lab testing alone. It likely requires a massive societal shift to address the many contributing factors involved that encourage the development of diabetes and obesity, which is an infinitely more complex public health problem to address, and would take much time for change to materialize. On the contrary, the sharp increase in insulin resistance in younger age groups (which aligns with increases in childhood obesity) indicates that the problem may be continuing to get worse.
- Despite public health challenges, insulin sensitivity testing could still be a valuable tool for a healthcare practitioner or a health-conscious person who is at-risk to get an early start on the lifestyle changes they may need to implement, and to set a clinical baseline for improvement. Although is not clear how many actually make quantifiable lifestyle changes after recieving a diagnosis, the earlier we can tell any individual in the 35% of the population experiencing covert insulin resistance that they're at-risk, the greater the impact that can be made.


## Resources  
### [The CDC's National Health and Nutrition Examination Survey (NHANES) 2021 to 2023 Cycle](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2021-2023)
- [Brief Overview of Sample Design and Analytics Guidelines](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/overviewbrief.aspx?Cycle=2021-2023)
- [Full Survey Methods and Analytics Guidelines](https://wwwn.cdc.gov/nchs/nhanes/analyticguidelines.aspx#analytic-guidelines)
- [Tutorials for Analysts](https://wwwn.cdc.gov/nchs/nhanes/tutorials/default.aspx)
- [Glycohemoglobin Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GHB_L.htm#WTPH2YR)
- [Fasting Glucose Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/GLU_L.htm)
- [Insulin Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/INS_L.htm)
- [Demographics Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm#RIDAGEYR)
- [Physical Examination Documentation](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BMX_L.htm#BMXBMI)

### Information on Diabetes
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