# RShiny

## Introduction
We have built an application in R Shiny to explore the immigration trend in Canada from various countries across the globe from 1980 to 2013. The main purpose of this application is to identify the top contributing countries to immigration in Canada and study the changes in the number of immigrants from these countries(1980 to 2013).

## Dataset
For conducting our analysis, we have used a dataset published by the United Nations, Department of Economic and Social Affairs, Population Division. This dataset provides the number of immigrants in Canada from 1980 to 2013. After removing rows with "Unknown" country, we have 195 rows in our dataset, i.e., immigration data from 195 countries across the world. Some of the features associated with the country of origin are Continent, Region and DevName. Continent and Region provide geographic information about the country of origin. As the name suggests, Continent specifies the name of the Continent in which the country of origin lies and has 6 unique values (Asia, Europe, Northern America, Latin America and the Caribbean, Africa, and Oceania). These continents have also been subdivided into smaller units called Regions. There are 22 unique regions in our dataset. Some of the regions are Southern Asia, Northern Africa, Western Europe, and Caribbean. DevName specifies the development status of the country. DevName column has two unique values, Developed and Developing.

## Analysis
To explore the data, we have used data visualization techniques like pie chart, line graph, and dendrogram. These visualizations are interactive as the user can apply filters on year of immigration, country of origin, or continent. Apart from this, we have also performed an Independent Samples t-test to determine the effect of the development status of a country (Developing or Developed) on immigrants from that country. The user can study this effect for any year (1980 to 2013) by selecting the year of immigration in the filter panel.

## Instructions to Navigate through the Application
1. Click on the Shiny App Link (https://canada-immigration.shinyapps.io/term_project/) to launch the application in a browser window.
2. Scroll down to view the first tab, Summary.
   a. Select year in the Filter by Year panel, which drives the data displayed in two sub-tabs, Top Contributors and Continent-wise Contribution.
   b. The top 6 contributors of immigrants to Canada during the selected year are displayed in the Top Contributors sub-tab.
   c. Click on Continent-wise Contribution sub-tab to view the pie-chart highlighting the continent-wise distribution of immigrants during the selected year.
   d. Change the selected year of immigration and access the updated sub-tabs again.
3. Scroll down in the Summary tab to browse the data used in the analysis.
   a. Apply filters on the data using the panel on the left side.
   b. Change the range of number of immigrants and year of immigration using the sliders.
   c. Filter the data by selecting one or more continents and click on Filter button.
   d. Search for any keyword in the dataset using the Search filed.
   e. Sort the data in increasing or decreasing order of a particular attribute by clicking on the attribute name
4. Scroll up and click on the Visual Comparison tab.
   a. Select or deselect countries using the checkboxes in the line chart panel and analyze the line chart showing the changes in number of immigrants from selected countries during 1980 to 2013.
   b. Scroll down to view the Dendrogram showing the top 5 contributing countries from each continent. Include and/or exclude continents using the checkboxes in the dendrogram panel.
5. Scroll up again and click on the Statistical Analysis tab.
   a. Select year in the Filter by Year panel on the left.
   b. Analyze the results of the statistical test (Independent Samples t-Test) for the selected year of immigration.
   c. Change the selected year of immigration and analyze the updated results.
   d. Compare the statistical decision for two or more years (For eg. 1980 and 2013, Different statistical decision for both the years).

## Observations
1. India, China, Philippines, Pakistan, United States of America and United Kingdom were the top 6 contributing countries to immigrants throughout from 1980 to 2013.
2. Europe was the largest contributing continent in 1980, but immigrants from Europe have decreased over the years.
3. From the late 1990s, Asia has replaced Europe as the largest contributor.
4. Immigrants from United Kingdom have significantly decreased after 1994, whereas immigrants from China, India and Philippines have significantly increased over the years.
5. Number of immigrants from United States of America have not changed significantly over the years.
6. Using the Independent Samples t-test, we could conclude that the development status of a country affected the number of immigrants from that country till 1983. The difference between the number of immigrants from developed and developing nations was not significant from 1984 to 2013.

## References

[1] World Life Expectancy, https://www.worldlifeexpectancy.com/canada-life-expectancy
[2] Government of Canada, https://www.canada.ca/en/immigration-refugees-citizenship/ campaigns/immigration-matters/track-record.html
[3] Statistics Canada, 2022, https://www150.statcan.gc.ca/n1/daily-quotidien/221026/ dq221026a-eng.htm
[4] WorldAtlas, https://www.worldatlas.com/geography/continents-by-number-of-countries.html [5] Kaggle, https://www.kaggle.com/datasets/danishasif/canada-immigratation
[6] Statstutor, The Statistics Tutor’s Quick Guide to Commonly Used Statistical Tests. https:// www.statstutor.ac.uk/resources/uploaded/tutorsquickguidetostatistics.pdf
