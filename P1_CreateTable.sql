--CREATE DATABASE
CREATE DATABASE P1AppleInc
USE P1AppleInc

----DROP TABLES
DROP TABLE tbl_transactionLog
DROP TABLE tbl_Purchases
DROP TABLE tbl_StoreInventory
DROP TABLE tbl_ZoneInventory
DROP TABLE tbl_ChannelPartnerInventory
DROP TABLE tbl_SubDistributorInventory
DROP TABLE tbl_DistributorInventory
DROP TABLE tbl_WarehouseInventory
DROP TABLE tbl_ProductionHouseInventory
DROP TABLE tbl_ProductionLog
DROP TABLE tbl_Stores
DROP TABLE tbl_Zones
DROP TABLE tbl_ChannelPartners
DROP TABLE tbl_SubDistributors
DROP TABLE tbl_Distributors
DROP TABLE tbl_Warehouses
DROP TABLE tbl_ProductionHouses
DROP TABLE tbl_Countries
DROP TABLE tbl_Continents
DROP TABLE tbl_ProductCatalog
DROP TABLE tbl_Customers
DROP TABLE tbl_Names

--TABLE DEFINITION
CREATE TABLE tbl_Names
(
	nameID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(20)
)
CREATE TABLE tbl_Customers
(
	SSN int IDENTITY(100000000,1),
	name VARCHAR(20),
	CONSTRAINT PK_Customers PRIMARY KEY(SSN)
)
CREATE TABLE tbl_ProductCatalog
(
	productID INT IDENTITY(100,1),
	productType VARCHAR(20) NOT NULL,
	productName VARCHAR(20) NOT NULL,
	productBasePrice MONEY NOT NULL,
	CONSTRAINT PK_ProductCatalog PRIMARY KEY(productID)
)
CREATE TABLE tbl_Continents
(
	name VARCHAR(20),
	CONSTRAINT PK_Continents PRIMARY KEY(name)
)
CREATE TABLE tbl_Countries
(
	countryID INT IDENTITY(1,1), 
	name VARCHAR(20),
	continentName VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Countries PRIMARY KEY(countryID),
	CONSTRAINT FK_CountryContinent FOREIGN KEY(continentName) REFERENCES tbl_Continents(name)
)
CREATE TABLE tbl_ProductionHouses
(
	productionHouseID INT IDENTITY(1,1), 
	location VARCHAR(20),
	countryID INT NOT NULL,
	CONSTRAINT PK_ProductionHouses PRIMARY KEY(productionHouseID),
	CONSTRAINT FK_ProductionHouseCountry FOREIGN KEY(countryID) REFERENCES tbl_Countries(countryID)
)
CREATE TABLE tbl_Warehouses
(
	warehouseID INT IDENTITY(1,1), 
	productionHouseID INT NOT NULL,
	CONSTRAINT PK_Warehouses PRIMARY KEY(wareHouseID),
	CONSTRAINT FK_WarehouseProductionHouse FOREIGN KEY(productionHouseID) REFERENCES tbl_ProductionHouses(productionHouseID)
)
CREATE TABLE tbl_Distributors
(
	distributorID INT IDENTITY(1,1), 
	warehouseID INT NOT NULL,
	CONSTRAINT PK_Distributors PRIMARY KEY(distributorID),
	CONSTRAINT FK_DistributorWarehouse FOREIGN KEY(wareHouseID) REFERENCES tbl_Warehouses(warehouseID)
)
CREATE TABLE tbl_SubDistributors
(
	subDistributorID INT IDENTITY(1,1), 
	distributorID INT NOT NULL,
	CONSTRAINT PK_SubDistributors PRIMARY KEY(subDistributorID),
	CONSTRAINT FK_SubDistributorDistributor FOREIGN KEY(distributorID) REFERENCES tbl_Distributors(distributorID)
)
CREATE TABLE tbl_ChannelPartners
(
	channelPartnerID INT IDENTITY(1,1), 
	subDistributorID INT NOT NULL,
	CONSTRAINT PK_ChannelPartners PRIMARY KEY(channelPartnerID),
	CONSTRAINT FK_ChannelPartnerSubDistributor FOREIGN KEY(subDistributorID) REFERENCES tbl_SubDistributors(subDistributorID)
)
CREATE TABLE tbl_Zones
(
	zoneID INT IDENTITY(1,1), 
	channelPartnerID INT NOT NULL,
	CONSTRAINT PK_Zones PRIMARY KEY(zoneID),
	CONSTRAINT FK_ZonesChannelPartner FOREIGN KEY(channelPartnerID) REFERENCES tbl_ChannelPartners(channelPartnerID)
)
CREATE TABLE tbl_Stores
(
	storeID INT IDENTITY(1,1), 
	zoneID INT NOT NULL,
	CONSTRAINT PK_Stores PRIMARY KEY(storeID),
	CONSTRAINT FK_StoresZone FOREIGN KEY(zoneID) REFERENCES tbl_Zones(zoneID)
)
CREATE TABLE tbl_ProductionLog
(
	serialNo INT IDENTITY(1000,1),
	productionHouseID INT,
	productID INT,
	CONSTRAINT PK_ProductionLog PRIMARY KEY(serialNo),
	CONSTRAINT FK_ProductionLogProductionHouse FOREIGN KEY(productionHouseID) REFERENCES tbl_ProductionHouses(productionHouseID),
	CONSTRAINT FK_ProductionLogProductCatalog FOREIGN KEY (productID) REFERENCES tbl_ProductCatalog(productID)
)
CREATE TABLE tbl_ProductionHouseInventory
(
	serialNo INT,
	productionHouseID INT,
	price MONEY,
	CONSTRAINT PK_ProductionHouseInventory PRIMARY KEY(serialNo),
	CONSTRAINT FK_ProuctionHouseInventoryProductionHouses FOREIGN KEY(productionHouseID) REFERENCES tbl_ProductionHouses(productionHouseID),
	CONSTRAINT FK_ProuctionHouseInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo)
)
CREATE TABLE tbl_WarehouseInventory
(
	warehouseInsertID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	warehouseID INT,
	price MONEY,
	CONSTRAINT PK_WarehouseInventory PRIMARY KEY(serialNo),
	CONSTRAINT FK_WarehouseInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_WarehouseInventoryWarehouse FOREIGN KEY(warehouseID) REFERENCES tbl_Warehouses(warehouseID)
)
CREATE TABLE tbl_DistributorInventory
(
	distributorInsertID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	distributorID INT,
	price MONEY,
	CONSTRAINT PK_DistributorInventory PRIMARY KEY(serialNo),
	CONSTRAINT FK_DistributorInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_DistributorInventoryDistributor FOREIGN KEY(distributorID) REFERENCES tbl_Distributors(distributorID)
)
CREATE TABLE tbl_SubDistributorInventory
(
	subDistributorInsertID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	subDistributorID INT,
	price MONEY,
	CONSTRAINT PK_SubDistributorInventory PRIMARY KEY(subDistributorInsertID),
	CONSTRAINT FK_SubDistributorInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_SubDistributorInventorySubDistributor FOREIGN KEY(subDistributorID) REFERENCES tbl_SubDistributors(subDistributorID)
)
CREATE TABLE tbl_ChannelPartnerInventory
(
	channelPartnerInsertID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	channelPartnerID INT,
	price MONEY,
	CONSTRAINT PK_ChannelPartnerInventory PRIMARY KEY(channelPartnerInsertID),
	CONSTRAINT FK_ChannelPartnerInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_ChannelPartnerInventoryChannelPartner FOREIGN KEY(channelPartnerID) REFERENCES tbl_ChannelPartners(channelPartnerID)
)
CREATE TABLE tbl_ZoneInventory
(
	zoneInsertID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	zoneID INT,
	price MONEY,
	CONSTRAINT PK_ZoneInventory PRIMARY KEY(zoneInsertID),
	CONSTRAINT FK_ZoneInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_ZoneInventoryZone FOREIGN KEY(zoneID) REFERENCES tbl_Zones(zoneID)
)
CREATE TABLE tbl_StoreInventory
(
	storeInsertID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	storeID INT,
	price MONEY,
	CONSTRAINT PK_StoreInventory PRIMARY KEY(storeInsertID),
	CONSTRAINT FK_StoreInventoryProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_StoreInventoryStore FOREIGN KEY(storeID) REFERENCES tbl_Stores(storeID)
)
CREATE TABLE tbl_Purchases
(
	purchaseID INT IDENTITY(1,1),
	serialNo INT UNIQUE NOT NULL,
	SSN INT,
	CONSTRAINT PK_Purchases PRIMARY KEY(purchaseID),
	CONSTRAINT FK_PurchasesProductionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo),
	CONSTRAINT FK_PurchasesCustomer FOREIGN KEY(SSN) REFERENCES tbl_Customers(SSN)
)
CREATE TABLE tbl_TransactionLog
(
	transactionID INT IDENTITY(1,1) PRIMARY KEY,
	serialNo INT,
	trSource VARCHAR(100),
	trDestination VARCHAR(100),
	trTime DATETIME,
	CONSTRAINT fk_transactionLog FOREIGN KEY(serialNo) REFERENCES tbl_ProductionLog(serialNo)
)