# so-unanswered-dbt

This is a dbt project built on the [Stack Overflow BigQuery public dataset](https://cloud.google.com/bigquery-public-datasets/stackoverflow).  
It models the data into a **star schema** to analyze questions that are trending but unanswered.

## Deliverables

- **dbt project (this repo)**:  
  https://github.com/colinberrygithub/so-unanswered-dbt  

- **BigQuery dataset (public)**:  
  `clean-sylph-471418-n5:so_unanswered_us`  
  [View in BigQuery Console](https://console.cloud.google.com/bigquery?project=clean-sylph-471418-n5&d=so_unanswered_us)

- **Data Studio dashboard (to be added)**:  
  *(link once published)*

## How to run locally
1. Install dbt for BigQuery:
   ```bash
   pip install dbt-bigquery
