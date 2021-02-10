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
* Use SSIS to create data flow tasks to extract each sheet of P1_Data.xls and names.csv to server 

(include all environment setup steps)

> Be sure to include BOTH Windows and Unix command  
> Be sure to mention if the commands only work on a specific platform (eg. AWS, GCP)

- All the `code` required to get started
- Images of what it should look like

## Usage

> Here, you instruct other people on how to use your project after they’ve installed it. This would also be a good place to include screenshots of your project in action.


## License

This project uses the following license: 
* [SQL Server Management Studio ](https://docs.microsoft.com/en-us/legal/sql/sql-server-management-studio-license-terms)
* [SQL Server Data Tools ](https://docs.microsoft.com/en-us/legal/sql/sql-server-management-studio-license-terms)
* [LibreOffice] (https://www.libreoffice.org/about-us/licenses)

