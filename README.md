### Zomato Data Analysis

#### Project Overview
Zomato is an Indian multinational restaurant aggregator and food delivery company. Its platform connects customers, restaurant partners, and delivery partners, serving their multiple needs. 

This project aims to thoroughly analyze and synthesize a self-created dataset containing 10,000 rows of orders to uncover critical insights that will improve Zomato’s commercial success.

 **Insights and recommendations are provided on the following key areas:**

- **Top Dishes Revenue Contribution:** Percentage of total revenue generated by top-performing dishes.
- **Top Dishes Ordered by Different Customer Segments:** Top 5 dishes ordered by each customer segment, such as frequent vs. infrequent buyers.
- **Monthly Trend Analysis for Popular Dishes:** Insights into which dishes are popular during specific times of the year.
- **High-Value Customer Identification:** Proportion of high-value vs. regular customers based on their order frequency and total revenue, using the 75th percentile to distinguish regular customers.
- **Dish Popularity by Time:** Highlights top 3 dishes in each time slot (Breakfast, Lunch, Dinner, Midnight Snack).
- **Percentage of Restaurants Open Late:** Identifies the proportion of restaurants open past 10 PM, segmented by city, to analyze areas with more late-night dining options.
- **Rider Efficiency:** Measures the average star rating of each rider, focusing on those with ratings above 4.3 to identify high-performing riders.

#### Data Structure Overview

Zomato’s database, as seen below, consists of five tables—customers, restaurants, orders, riders, and deliveries—with a total of 10,000 records.

![zomato_analysis_schema](https://github.com/user-attachments/assets/eef4aa87-92c8-4d51-bad6-1149d9188959)

#### Executive Summary 

#### Insights 
##### 1. Revenue and Sales Performance:
  - The top five dishes account for **37%** of the **total revenue** over the analysis period. This significant contribution indicates that a **small selection of popular 
    items** drives a **large share of Zomato's income**.
  - It turns out that the top dishes ordered by both **frequent** and **infrequent** customers are strikingly similar. Dishes like **Chicken Biryani, Pasta Alfredo, Paneer 
    Butter Masala, Masala Dosa,** and **Mutton Rogan** Josh dominate both segments. This overlap suggests that these dishes have a universal appeal, resonating with a wide 
    range of customer types.
  - These top 5 dishes aren't just popular in terms of order frequency — they are also the **top revenue generators**, collectively contributing to **37% of total revenue**. 
    This highlights the importance of these dishes in Zomato’s revenue stream.
  - **High-value customers**, making up **25%** of the customer base, were found to have a substantial impact on Zomato's performance. These top-tier customers placed an 
    average of **757 orders** and generated **$253,134** in revenue each, significantly outperforming the "Regular" customer group.
  - In contrast, the remaining **75% of customers** were categorized as **Regular**, each generating below the threshold of **$243,223** in revenue and **733 orders**, indicating lower engagement and revenue.

  ##### 2. Customer Behavior and Preferences
- Chicken Biryani is consistently among the top 3 in all time slots (Breakfast, Dinner, and Midnight Snack), indicating it has broad appeal throughout the day.
- Paneer Butter Masala ranks highly in Breakfast and Lunch, while Masala Dosa is also popular during Breakfast and Dinner. This suggests that vegetarian options like Paneer Butter Masala and Masala Dosa attract customers during peak dining times.
- The Midnight Snack category has low demand (with orders generally under 50) , with Masala Dosa being the most ordered at 43 orders, indicating a smaller but loyal customer base for late-night meals.
