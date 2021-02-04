--CREATE NEW PRODUCT
INSERT INTO tbl_ProductCatalog VALUES('Streaming', 'Apple TV', 100.00)
--SEARCH CATALOG
SELECT * FROM tbl_ProductCatalog
--REQUEST THAT PRODUCT
--Product Distribution
EXEC productHouseProductRequest 1, 131
EXEC warehouseProductRequest 1, 131
EXEC distributorProductRequest 1, 131
EXEC subDistributorProductRequest 1, 131
EXEC channelPartnerProductRequest 1, 131
EXEC zoneProductRequest 1,131
EXEC storeProductRequest 1, 131
--View Cycle
SELECT * FROM recentTransactionsView
--Customer Transaction 
EXEC guestPurchase 100000000, 1, 131
EXEC guestReturn 1000, 1

--Queries
SELECT * FROM tbl_DistributorInventory ORDER BY distributorInsertID DESC
SELECT Quantity, [Product Name],Price FROM customerView WHERE [Store Number] = 1
SELECT * FROM customerView
SELECT * FROM tbl_Countries
SELECT * FROM tbl_Queries