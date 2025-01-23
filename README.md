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
1. How are each of our four core data fields (Diabetes, Insulin Sensitivity, Age, and BMI) distributed across the population?
2. What is the relationship between Diabetes and Insulin Resistance across the entire population?
3. What is the relationship between Diabetes and Insulin Resistance within the context of Age and BMI, two major risk factors for Diabetes?
4. To identify our cohort of the population to target for early intervention with increased insulin testing, what is the subset of the population experiencing Insulin Resistance but does not yet have elevated A1C? 

### **Reviewing the distribution of data across the population**
### Figure 1.1: Population Distribution of Diabetes
![Figure 1.1: Population Distribution of Diabetes](./analysis/Figure%201.1%20Population%20Distribution%20of%20Diabetes.jpg)
- Approximately 70% of the population have a normal blood sugar level, 20% have slightly elevated blood sugar (Prediabetes), and 9% have significantly elevated blood sugar (Diabetes).

#### Figure 1.2: Population Distribution of Insulin Resistance
![Figure 1.2: Population Distribution of Insulin Resistance](./analysis/Figure%201.2%20Population%20Distribution%20of%20Insulin%20Resistance.jpg)
- Approximately 41% of the population experiences normal insulin sensitivity, 20% is experiencing early insulin resistance, and 39% have significant insulin resistance.

#### Figure 1.3: Population Distribution by Age Group
![Figure 1.3: Population Distribution by Age Group](./analysis/Figure%201.3%20Population%20Distribution%20by%20Age%20Group.jpg)
- The population is distributed across age groups as expected, and likely aligns closely with changing demographics over time.
- The data is limited to the ages 12-80 because age 12 was the minimum age set by NHANES to participate in lab work, and NHANES denotes everyone over age 80 as just 80.

#### Figure 1.4: Population Distribution by BMI
![Figure 1.4: Population Distribution by BMI](./analysis/Figure%201.4%20Population%20Distribution%20by%20BMI.jpg)
- Approximately 30% of the population is a normal weight, 29.5% are overweight, and 38% experience some degree of obesity. Less than 3% are underweight.

### Evalulating beta-cell health and dysfunction
Figure 2.1 will evaluate the entire population. Given that Age and BMI are both significant risk factors for Type 2 Diabetes, Figures 2.2-2.4 will evaluate health and dysfunction by Age Group, and Figures 2.5-2.7 will evaluate by BMI instead of Age Group.

#### Figure 2.1: Population Distribution of Factors in Beta Cell Health and Dysfunction
![Figure 2.1: Population Distribution of Factors in Beta Cell Health and Dysfunction](./analysis/Figure%202.1%20Population%20Distribution%20of%20Factors%20in%20Beta%20Cell%20Health%20and%20Dysfunction.jpg)
- Approximately 35% of the population is in a healthy state, another 35% are experiencing insulin resistance without elevated blood sugar, 24% are experiencing both elevated insulin and blood sugar, and 6.5% are experiencing elevated A1C only. In other words, while just over a third of the population has a healthy blood sugar and insulin response, just as many are experiencing early insulin resistance, and the remaining 30% experiencing some degree of elevated blood sugar and beta-cell dysfunction.

### Figure 2.2 Population Distribution of Factors in Beta Cell Health and Dysfunction by Age Group
![Figure 2.2 Population Distribution of Factors in Beta Cell Health and Dysfunction by Age Group](./analysis/Figure%202.2%20Population%20Distribution%20of%20Factors%20in%20Beta%20Cell%20Health%20and%20Dysfunction%20by%20Age%20Group.jpg)
- This chart not only shows how diabetes and insulin resistance change as age increases, but it also shows which category is the most predominant for a given age group.
- In order to further evaluate our data effectively, we will want to "normalize" population across our age groups to understand proportionate likelihood of health or dysfunction within a given age group, rather than being subjected to skew where population is higher or lower for an age group (e.g. since population decreases in older age, all factors within that age group look relatively smaller compared to more populous age groups).

### Figure 2.3: Likelihood of Factors in Beta Cell Health and Dysfunction by Age Group
![Figure 2.3: Likelihood of Factors in Beta Cell Health and Dysfunction by Age Group](./analysis/Figure%202.3%20Likelihood%20of%20Factors%20in%20Beta%20Cell%20Health%20and%20Dysfunction%20by%20Age%20Group.jpg)
- In contrast with the previous chart, this one shows the likelihood of status within a given age group, rather than the percent of total population. In other words, it is not skewed when certain age groups have higher or lower populations.
- The predominant states for those up to around age 30 are a *healthy response* and *insulin resistance only*. It is very uncommon to experience *elevated blood sugar only* at an early age, but one potential factor could be Type 1 Diabetes, which is present from birth, where the body does not produce insulin at all, thus causing a naturally elevated blood sugar that requires supplemental insulin.
- In general, it appears that those in the population between ages 20-40 are most likely to experience healthiness (*neither elevated blood sugar nor insulin resistance*) as well as *insulin resistance only*. The prevalence of both experience a slow decline in favor of the other two states, with untreated Diabetes (*elevated blood sugar and insulin resistance together*) in particular increasing in prevalence. For those around age 50, *elevated blood sugar and insulin* becomes the most prominent category and remains in the top spot for all subsequent age groups.
- For those around 80 years old, there is a sharp increase in the number of folks who experience *elevated blood sugar only, and not insulin resistance*, and aligns with a small decline in the incidence of people with *both elevated blood sugar and insulin resistance*). Although it is the state with the smallest incidence by far, the sharp spike upwards at the end of life to no longer be the least common category, may support the idea that medications like Metformin which increase insulin sensitivity but don't necessarily increase blood sugar are taken at higher rates, as well as that people who are treating their Diabetes are more likely to live longer. 
- In the very beginning of life (at least, from our 12 year old minimum), there is already a significant degree of insulin resistance. This is curious, and it may be related to significant increases in childhood obesity in recent years and decades, indicating that people are experiencing earlier onset and/or faster disease progression, likely due to societal factors. Since our data was captured within a brief moment of time (in the grand scheme of things), it cannot give us the answer - we would need to look back at historical data to understand.

### Figure 2.4: Likelihood of Overall Beta-Cell Health or Dysfunction by Age Group
![Figure 2.4: Likelihood of Overall Beta-Cell Health or Dysfunction by Age Group](./analysis/Figure%202.4%20Likelihood%20of%20Overall%20Beta-Cell%20Health%20or%20Dysfunction%20by%20Age%20Group.jpg)
- This chart is similar to the previous, but it is simpler - it only shows those who are healthy (*normal blood sugar and insulin sensitivity*) compared to those who have some form and degree of beta-cell dysfunction (*any combination of elevated blood sugar OR insulin*). The previous insights and hypotheses are also visible here. 
- Aside from the alarming spike in the 12-20 age group, the prevalence of dysfunction increases slowly and consistently with age, with a notably sharp increase around age 50. There is likely research using historical data that can align the sharp increases we see here with sigificant changes that happened at these respective periods in time (in particular, after the years 1970 and then 2000). 
- With all forms of dysfunction grouped together, it is clear that beta-cell dysfunction as a whole remains the most likely state for all age groups.

### Figure 2.5: Population Distribution of Factors in Beta Cell Health and Dysfunction by BMI
![Figure 2.5: Population Distribution of Factors in Beta Cell Health and Dysfunction by BMI](./analysis/Figure%202.5%20Population%20Distribution%20of%20Factors%20in%20Beta%20Cell%20Health%20and%20Dysfunction%20by%20BMI.jpg)
- This chart shows how diabetes and insulin resistance change over time as BMI increases. In contrast with the previous chart, this does not factor in age group.
- Similar to age, we will want to view this data with a normalized population to understand proportionate likelihood for health or dysfunction for a given BMI.
- Most notably, this chart indicates that approximately 20% of the US population is both a normal weight and has healthy beta-cell function. Given the valid critiques of the BMI system, it may not be appropriate to say that "only 20% of the population is healthy", but it is still a valuable insight that confirms that a significant degree of the population is already being impacted by some form of beta-cell dysfunction. 

### Figure 2.6: Likelihood of Factors in Beta Cell Health and Dysfunction by BMI
![Figure 2.6: Likelihood of Factors in Beta Cell Health and Dysfunction by BMI](./analysis/Figure%202.6%20Likelihood%20of%20Factors%20in%20Beta%20Cell%20Health%20and%20Dysfunction%20by%20BMI.jpg)
- After normalizing population to only see likelihood of a state for a given BMI threshold, we can see a clear relationship between weight and beta-cell function. As weight increases, it becomes steadily more likely to experience *elevated blood sugar* or *elevated blood sugar and insulin resistance*.  
- It is worth noting that, even at a "normal" or "healthy" weight, there is still a non-insignificant degree of insulin-resistance, which may indicate that diabetes can still develop with age. 
- The incidence of *elevated blood sugar only* being highest at low and normal weights may be another indication of Type 1 Diabetes. At higher weights, it may indicate treatment of Type 2 Diabetes with medication that increases insulin-sensitivity. 

### Figure 2.7: Likelihood of Overall Beta Cell Health and Dysfunction by BMI
![Figure 2.7: Likelihood of Overall Beta Cell Health and Dysfunction by BMI](./analysis/Figure%202.7%20Likelihood%20of%20Overall%20Beta%20Cell%20Health%20and%20Dysfunction%20by%20BMI.jpg)
- This final chart confirms the inverse relationship between weight and beta-cell function, with the inversion between health and dysfunction at approximately the transition from normal weight to overweight. 

#### This analysis provides an extremely insightful view of diabetes and its factors across the US population.

## Conclusion 

In Summary:
- We can confirm that insulin resistance does indeed precede the onset of diabetes by a measurable degree, with about 35% of the population experiencing insulin resistance but not yet having elevated blood sugar, often from a young age. If these folks were given an A1C blood sugar test, they would test in the normal range. This is a significant amount of the US population that could benefit from knowing that they are on the path to developing diabetes.
- This analysis fully succeeds at demonstrating the scale and depth of the public health problem, but unfortunately it may not be able to be fixed by increased lab testing alone. It likely requires a massive societal shift to address the many contributing factors involved that encourage the development of diabetes and obesity, which is an infinitely more complex public health problem to address, and would take time for change to materialize. On the contrary, there are many indications that the problem is getting worse.
- Despite public health challenges, insulin sensitivity testing could still be a valuable tool for a healthcare practitioner or a health-conscious person who is at-risk to get an early start on the lifestyle changes they may need to implement. Although is not clear how many actually make quantifiable lifestyle changes after recieving a diagnosis, the earlier we can tell any individual in the 35% of the population experiencing covert insulin resistance that they're at-risk the better.

A few obstacles to improving public health include:
- Educating the medical community that insulin sensitivity precedes diabetes and that it can be tested
- Encouraging insurers to actually cover the fasting glucose and insulin tests instead of just the A1C test, which is often a barrier
- Educating the general public on Type 2 Diabetes in a way that contextualizes the severity of present unhealthy behaviors as major contributors to a decline in health with age 
- The rise in sedentary lifestyle caused by things such as an increase in desk-jobs and highly accessible entertainment which contribute to inactivity
- The affordability, accessibility, and prevalence of high-carb diets (which have agricultural and economic implications, given that heavily subsidized crops like corn and grain are in many of our foods, whose increasing presence in our foods may align with sharp increases in obesity rates, and may explain why we see such high insulin resistance even from a young age, suggesting that many people are not suited for high-carb diets and end up unknowingly facing the consequences).


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