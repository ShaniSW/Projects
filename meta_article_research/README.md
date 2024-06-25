# Neurocognitive Methodology in Learning Mathematics - Bibliographic Project

## Overview

This project is part of a comprehensive survey aimed at performing a systematic literature review on the application of neurocognitive methodologies in learning mathematics. The focus is on analyzing selected literature through bibliometric analysis. The project is conducted in collaboration with one of the universities in Israel, as part of an international initiative involving multiple universities around the world.

## Innovation and Importance

This project represents an innovative approach that higher education institutions are increasingly adopting. Traditionally, research focused on individual subjects through various sources. Today, the research scope has expanded to analyze the sources themselves using big data methodologies. The project utilizes a dataset of approximately 600 articles, showcasing the significance and breadth of the research.

## Steps Involved

### 1. Data Retrieval

- Use the provided scripts to fetch data from Scopus and Web of Science using your API keys.
- **Sources:** Scopus, Web of Science
- **Method:** API key retrieval
- **Documentation:** [Elsevier API Documentation] (https://dev.elsevier.com/)

### 2. Data Preparation

- **Cleaning data:** Accent removal, country name extraction, record filtering
- Data cleaning includes normalizing author keywords for consistency and filtering based on relevant search terms in neurocognitive and mathematical domains.
-**Key Steps:**
    -**Convert to Lowercase:** Standardize the 'Author Keywords' column to lowercase to ensure uniformity.
    -**Replace Terms:** Standardize terminology for consistency
    -**Filter Keywords:** Focus on relevant neurocognitive methodologies and mathematical terms to ensure data relevance.

### 3. Data Analysis

- **Tools:** Python scripts for detailed analysis
- Use the analysis scripts to perform bibliometric analysis.

### 4. Data Visualization

- **Outputs:** Graphs, Excel tables
- Generate visualizations using the provided plotting scripts.