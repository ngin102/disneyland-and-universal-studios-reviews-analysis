# Disneyland & Universal Studios Reviews Data Science Analysis
Émilie Brazeau, Nicholas Gin, Gordon Tang

## Description
For this project, we enrich the "Disneyland Reviews" dataset with the "Reviews of Universal Studios" dataset. The goal of this project is to apply many data science principles to find trends in reviews across different Disneyland and Universal Studios branches. We also use machine learning models to see if we can predict the rating of a review at a specific Disneyland or Universal Studios branch, given a set of existing reviews with ratings; note that the models used in this project are not NLP models - this had an impact on our their performance. 

Our analysis will reveal trends in the reviews. The dataset contains information that can assist this analysis, such as the park branch (Disneyland Paris, Disneyland California, Disneyland Hong Kong, Universal Studios Japan, Universal Studios Florida, or Universal Studios Singapore) and the date the review was written. We can also keep track of the number of attendees per year for each branch (we were unable to locate a freely accessible pre-compiled dataset with attendance information for each park; however, we did find this information for the years 2006-2021 and can manually compile this data - please note, that data can only be found for Universal Studios Singapore beginning in 2010 because that was the year that park opened). Our Disneyland dataset includes reviews from 2010 to 2019, and our Universal Studios dataset includes reviews from 2002 to 2021. We can measure the monthly percentage of positive (4-5 star rated reviews), mixed (3 star rated reviews), and negative (1 star rated reviews) reviews at each branch.

Our work is split between 4 phases and presentation, which includes our data staging and ETL processes.

## Table of Contents
* **[Phase 1: Initial Planning and Dimensional Model](phase1)**: Files for Phase 1.
  * **[Initial Planning and Dimensional Model (.pdf)](phase1/phase_1.pdf)**: Initial planning and dimensional model for the data mart (note that this plan was adjusted in later phases).
  
* **[Phase 2: Data Staging, ETL, and Building the Data Mart](phase2)**: Files for Phase 2.
  * **[Dimensional Model (.pdf)](phase2/dimensional_model.pdf)**: Updated dimensional model from the previous phase.
  * **[High level planning schematic (.pdf)](phase2/high_level_planning.pdf)**: A one-page schematic with our high-level data staging plan.
  * **[Report on data quality and handling (.pdf)](phase2/report.pdf)**: Our report containing a list of data quality issues we encountered and how we handled them. We also describe our ETL process.
  * **[Data staging (.ipynb)](phase2/data_staging.ipynb)**: Our data staging using Jupyter Notebook – part of the ETL process.
  * **[Script to load data mart (.sh)](phase2/setup_datamart.sh)**: **Replace staged_data.csv filepath in the .sh file before using it.** A script to setup the data mart (assumes that PostgreSQL has already been installed on your machine) – part of the ETL process.
  * **[PostgreSQL queries to load data mart for pgAdmin 4 (.txt)](phase2/load_datamart.txt)**: **Replace staged_data.csv filepath in the .txt file before using it**. A .txt file with PostgreSQL queries to load the data mart (meant to be used with pgAdmin 4, and we assume that the database has already been setup). 
  * **[Staged data (.csv)](phase2/staged_data.csv)**: Our data (after extracting and transforming) in a state where it can be loaded into the data mart.
  * **[Exported dimension tables (.csv)](phase2/exported_dimension_tables)**: Exported dimension tables from pgAdmin 4 after building the data mart using the provided queries.
  
* **[Phase 3 Part A: Queries for the DataM art](phase3_partA)**: Files for Phase 3 Part A.
   * **[Queries and Explanations (.pdf)](phase3_partA/queries_and_explanations.pdf)**: 11 queries that can be run on the data mart and explanations for each query (we also show example outputs for each query).
  * **[Script to run queries (.sh)](phase3_partA/run_queries.sh)**: **Replace staged_data.csv filepath in the .sh file before using it.** A script to run the queries; it assumes you have not setup the data mart yet and that PostgreSQL has already been installed on your machine.
      * **[Staged data for queries (.csv)](phase4_partA/updated_phase2/staged_data.csv)**: The staged data needed to setup the data mart and run the queries.

* **[Phase 3 Part B: Power BI Visualizations and Dashboard](phase3_partB)**: Files for Phase 3 Part B.
  * **[Power BI Visualizations and Dashboard (.pbix)](phase3_partB/Part3B_PowerBI_Visualization.pbix)**: Our Power BI dashboard and visualizations.
  * **[Visualization Report (.pdf)](phase3_partB/visualization_report.pdf)**: Our report on how to use the PowerBI dashboard and some conclusions we drew from it. 

* **[Phase 4 Part A: Data Summarization and Pre-processing for Machine Learning Models](phase4_partA)**: Files for Phase 4 Part A.
  * **[Updated Phase 2 files](phase4_partA/updated_phase2)**: Updated Phase 2 files to switch from stemming to lemmatization.
  * **[Data Summarization and Pre-processing (.ipynb)](phase4_partA/phase4_partA.ipynb)**: Our data summarization and pre-processing of the data in our data mart for the models.
      * **[Pre-processed data (.csv)](phase4_partA/preprocessed_data.csv)**: The pre-processed data we use in Phase 4 Part B.   
  * **[Summary (.pdf)](phase4_partA/summary.pdf)**: A summary of the work we did on this part. 
   
* **[Phase 4 Part B: Machine Learning Models](phase4_partB)**: Files for Phase 4 Part B.
  * **[Data for the Models (.csv)](phase4_partB/data_for_model.csv)**: The data provided to the models.
  * **[Training and Testing the Models – without Sampling (.ipynb)](phase4_partB/phase4_partB_no_sampling.ipynb)**: Our results after training and testing the models (without sampling).
  * **[Training and Testing the Models – with Sampling (.ipynb)](phase4_partB/phase4_partB_sampling.ipynb)**: Our results after training and testing the models (with sampling).
  * **[Summary (.pdf)](phase4_partB/summary.pdf)**: A summary of the work we did on this part. 
  * **[Next Steps (Outside the Scope of the Project)](phase4_partB/next_steps)**: OUTSIDE THE SCOPE OF THE PROJECT - Additional, interesting experiments to improve and expand upon the results of Phase 4 Part B (many are unfinished)
      * **[downsampled.ipynb](phase4_partB/next_steps/downsampled.ipynb)**: A text-to-rating-average-counting model approach.
      * **[neuralnetwork.ipynb](phase4_partB/next_steps/neuralnetwork.ipynb)**: A CNN model approach.
      * **[sentiment_analysis.ipynb](phase4_partB/next_steps/sentiment_analysis.ipynb)**: A sentiment analysis on a portion of the dataset.
      
* **[Phase 4 Part C: Outlier Detection](phase4_partC)**: Files for Phase 4 Part C.
  * **[Outlier Detection (.ipynb)](phase4_partC/phase4_partC.ipynb)**: Our outlier detection.
  * **[Summary (.pdf)](phase4_partC/summary.pdf)**: A summary of the work we did on this part. 
  
* **[Presentation](presentation.pdf)**: A presentation (.pdf) describing all the phases and our work.
      

