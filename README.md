# Device Manufacturer Database 

## Project Description
The project goal was to design a relational database system that would replicate device creation and stock distribution in a business setting. 

## Technologies Used
* Microsoft SQL Management Studio - Version 2018
* Visual Studio (SSDT) - Version 2017
* LibreOffice Calc - Version 7.0

## Features
List of features ready and TODOs for future development
* Utilized SSIS and TSQL stored procedures to generate distribution hierarchy, geographical context, and product catalog
* Relational Database normalized to third normal form to prevent redundancy and ensure data integrity
* Stored Procedures to execute product requests at any level of the distribution if product is out of stock in current level
* Triggers to ensure data integrity of each product as it moves through the distribution channels
* Transaction Log to trace each individual products movement and location

To-do list:
* Code Refactoring to improve readability, reduce redundancy, and reduce load on server
* Create new procedures to handle bulk product requests
* Create Additional views to increase usability and convenience

## Getting Started
Requirements
* Visual Studio SSDT
* Microsoft SQL Server Management Studio
Environment Setup  
* git clone https://github.com/210104-msbi-reston/Kathleen-Labog-P1.git
* Open files in SQL folder in Sql Server Management Studio
* Execute CREATE and USE statements from file P1_CreateTable.sql to create database and tables
* Open Visual Studio (SSDT) and create an Integration services project  
* Use SSIS to extract each sheet of P1_Data.xls and names.csv to server by creating 5 separate packages with each of the data flow tasks pictured below 
  * <img src = "https://github.com/210104-msbi-reston/Kathleen-Labog-P1/blob/main/Images/project1SIS.png?raw=true">
* Execute CREATE and EXEC statements from P1_PopulateTableProcedures.sql to generate distribution levels and customers
* Execute CREATE statements from P1_TriggersAndDistributionProcedures.sql to create triggers and procedures
* Object explorer tables should look like image below: 
  * <img src = "https://github.com/210104-msbi-reston/Kathleen-Labog-P1/blob/main/Images/DatabaseManagementStudio.png?raw=true">

## Usage
* Stored Procedures available to create and manipulate stock
  * Customer return
    * EXEC guestReturn serialNo, storeID
  * Customer purchase
    * EXEC guestPurchase SSN, storeID, productID
  * Request product at store level
    * EXEC storeProductRequest storeID, productID
  * Request product at zone level
    * EXEC zoneProductRequest zoneID, productID
  * Request product at channel partner level
    * EXEC channelPartnerProductRequest channelPartnerID, productID
  * Request product at subdistributor level 
    * EXEC subDistributorProductRequest subDistributor, productID
  * Request product at distributor level
    * EXEC distributorProductRequest distributorID, productID
  * Request product at warehouse level
    * EXEC warehouseProductRequest warehouseID, productID
  * Request product at production house level
    * EXEC productHouseProductRequest productHouseID, productID
  * Create one random item at production house level
    * EXEC generateProductLogItem
  * Creates 100  random products at production house level
    * EXEC generateProductLogItems 
  * Creates n number of random items at each level
    * EXEC generateInventories n 
## License

This project uses the following license: 
* [SQL Server Management Studio ](https://docs.microsoft.com/en-us/legal/sql/sql-server-management-studio-license-terms)
* [SQL Server Data Tools ](https://docs.microsoft.com/en-us/legal/sql/sql-server-management-studio-license-terms)
* [LibreOffice] (https://www.libreoffice.org/about-us/licenses)

