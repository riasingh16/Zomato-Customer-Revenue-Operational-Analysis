## Zomato Case Study: Actionable Insights from Simulated Restaurant Data

### Project Overview
Zomato is an Indian multinational restaurant aggregator and food delivery company. Its platform connects customers, restaurant partners, and delivery partners, serving their multiple needs. 

This project aims to thoroughly analyze and synthesize a self-created dataset containing 10,000 rows of orders to uncover critical insights that will improve Zomato’s commercial success.

 **Project Goals:**

- **Top Dishes Revenue Contribution:** Percentage of total revenue generated by top-performing dishes.
- **Top Dishes Ordered by Different Customer Segments:** Top 5 dishes ordered by each customer segment, such as frequent vs. infrequent buyers.
- **Monthly Trend Analysis for Popular Dishes:** Insights into which dishes are popular during specific times of the year.
- **High-Value Customer Identification:** Proportion of high-value vs. regular customers based on their order frequency and total revenue, using the 75th percentile to distinguish regular customers.
- **Dish Popularity by Time:** Highlights top 3 dishes in each time slot (Breakfast, Lunch, Dinner, Midnight Snack).
- **Percentage of Restaurants Open Late:** Identifies the proportion of restaurants open past 10 PM, segmented by city, to analyze areas with more late-night dining options.
- **Rider Efficiency:** Measures the average star rating of each rider, focusing on those with ratings above 4.3 to identify high-performing riders.

### Data Structure Overview

Zomato’s database, as seen below, consists of five tables—customers, restaurants, orders, riders, and deliveries—with a total of 10,000 records.

![zomato_analysis_schema](https://github.com/user-attachments/assets/eef4aa87-92c8-4d51-bad6-1149d9188959)

### Executive Summary 

Zomato's performance is driven by a few key factors: **top dishes** like **Chicken Biryani** and **Paneer Butter Masala** contribute **37% of total revenue**, with strong appeal across both **frequent** and **infrequent** customers. **High-value customers**, making up **25%** of the base, generate significantly higher revenue than **regular customers**. Operationally, **73% of riders** maintain strong performance with ratings of **4.2 or higher**, but lower-rated riders may benefit from targeted support. The **late-night dining scene** is dominated by **Bengaluru** and **Delhi**, accounting for **51.41%** of late-night restaurants, indicating potential for growth in other cities. These insights suggest areas to optimize revenue, customer engagement, and operational efficiency.

### Insights 
#### 1. Revenue and Sales Performance:
  - The top five dishes account for **37%** of the **total revenue** over the analysis period. This significant contribution indicates that a **small selection of popular 
    items** drives a **large share of Zomato's income**.

    
<img align="center" width="440" alt="revenue_contribution" src="https://github.com/user-attachments/assets/d05e243d-2ab6-40b9-9c20-fd6136970229">

  - It turns out that the top dishes ordered by both **frequent** and **infrequent** customers are strikingly similar. Dishes like **Chicken Biryani, Pasta Alfredo, Paneer 
    Butter Masala, Masala Dosa,** and **Mutton Rogan Josh** dominate both segments. This overlap suggests that these dishes have a universal appeal, resonating with a wide 
    range of customer types.

    
<img align="center" style="margin-right: 300px" width="328" alt="data_distribution" src="https://github.com/user-attachments/assets/3fbf254a-8763-4f27-8879-d0562c34f291">


<img width="530" align="center" alt="freq_infreq" src="https://github.com/user-attachments/assets/2ee94784-bf53-400a-ace9-65695f646cfe">

  - **High-value customers**, making up **25%** of the customer base, were found to have a substantial impact on Zomato's performance. These top-tier customers placed an 
    average of **757 orders** and generated **$253,134** in revenue each, significantly outperforming the "Regular" customer group.


    <img width="478" align="center" alt="cust_segment" src="https://github.com/user-attachments/assets/fb1441a7-b321-457e-b065-0b925d9cbd3a">
    
  - In contrast, the remaining **75% of customers** were categorized as **Regular**, each generating below the threshold of **$243,223** in revenue and **733 orders**, indicating lower engagement and revenue.

    
  <img width="589" align="center" alt="revenue_vs_order_freq" src="https://github.com/user-attachments/assets/114246a3-480e-40db-b5c8-5cf25c6a133e">

  #### 2. Customer Behavior and Preferences

- **Chicken Biryani** is consistently among the **top 3 dishes** across **all time slots** (Breakfast, Dinner, and Midnight Snack), showcasing its broad appeal throughout the day. Additionally, **vegetarian options** like **Paneer Butter Masala and Masala Dosa** rank highly during **Breakfast, Lunch, and Dinner**, indicating their strong customer preference during peak dining times.


- The **Midnight Snack** category has **low demand** (with orders generally under 50) , with **Masala Dosa** being the **most ordered** at **43 orders**, indicating a smaller but loyal customer base for late-night meals.
- **Bengaluru** and **Delhi** have the most **robust late-night restaurant scenes**, accounting for **51.41%** of all late-night restaurants in the dataset (21 out of 41). This prominence could be attributed to their larger, younger, and more diverse populations, which drive higher demand for late-night dining.
- The **low percentages** in cities like **Hyderabad, Chennai,** and **Ahmedabad** suggest an opportunity to expand late-night offerings to meet potential untapped demand.


<img width="530" align="center" alt="late_night_restaurants" src="https://github.com/user-attachments/assets/37de970d-ef01-4300-af10-8801f3b0c2c1">


#### 3. Operational Efficiency

- **73% of riders** have an average rating of **4.2 or higher**, demonstrating strong fleet performance with the majority consistently providing efficient service. To capitalize on this, recognizing and rewarding these high performers could further boost service quality.
- Additionally, **27% of riders** with ratings **closer to or below 3.7** may benefit from targeted support, such as training or route optimization, which could enhance their performance and elevate the overall fleet quality.


<img width="467" align="center" alt="high_performers" src="https://github.com/user-attachments/assets/bcb2ed7e-399c-4502-9f10-618bac8761b1">


### Recommendations 

**1. Revenue Generation & Dish Promotion**
   
  **Problem:** A significant portion of revenue is driven by a small selection of dishes, with the top 5 accounting for 37% of total revenue.

  **Solution:** Pro ote high-performing dishes through targeted marketing (in-app recommendations, email marketing) and dynamic pricing during peak hours. Create combo deals pairing popular dishes with underperforming items. Introduce varying portion sizes (e.g., snack-size, family-size) to cater to different customer needs and increase order value.
  
**2. Customer Engagement & Retention**

  **Problem:** Maintaining customer loyalty while boosting the engagement of infrequent buyers.

  **Solution:** Launch a loyalty program offering discounts on popular dishes like Chicken Biryani and Paneer Butter Masala for frequent customers. Create promotional campaigns (e.g., buy-one-get-one-free) for infrequent customers to encourage higher engagement. Upsell at checkout with combo offers for frequent customers, encouraging them to add complementary items to their orders.

**3. Operational Efficiency & Menu Optimization**
   
  **Problem:** Ensuring high demand dishes are always in stock and prepared efficiently during peak hours.

  **Solution:** Use popularity data (e.g., Chicken Biryani and Masala Dosa) to optimize kitchen staffing and ingredient procurement during lunch, dinner, and late-night shifts. Focus on promoting popular midnight snacks like Masala Dosa and Pasta Alfredo during late-night hours. Offer discounts or combos for late-night orders and run targeted ads on food delivery platforms.

**4. Rider Performance & Service Quality**
   
  **Problem:** Ensuring consistent and efficient delivery service.

  **Solution:** Set a performance benchmark (e.g., an average star rating of 4.3) for "exemplary" riders, rewarding them with incentives like monetary bonuses or recognition as "Rider of the Month". Provide targeted support or training for riders with ratings below 3.8, tracking their progress post-training.


### Caveat

It is important to note that this project is based on a self-created dataset designed to simulate real-world scenarios for analytical purposes. As such, the insights and findings derived from the analysis are not reflective of actual operational data or customer behavior from Zomato or any other organization. These results are hypothetical and intended solely for learning and demonstration purposes.

### Tools and Technologies

**SQL**: Data querying and aggregation.
**Python**: Data analysis and visualization.
**Visualization Libraries**: Matplotlib, Seaborn.
