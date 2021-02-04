SELECT * FROM tbl_Queries
CREATE TABLE tbl_Queries
(
	queryID INT PRIMARY KEY IDENTITY(1,1),
	query VARCHAR(255)
)

INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_ProductionHouseInventory WHERE(productionHouseID = [productionHouseID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_WarehouseInventory WHERE(warehouseID = [warehouseID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_DistributorInventory WHERE(distributorID = [distributorID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_SubDistributorInventory WHERE(subDistributorID = [subDistributorID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_ChannelPartnerInventory WHERE(channelPartnerID = [channelPartnerID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_ZoneInventory WHERE(zoneID = [zoneID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_StoreInventory WHERE (storeID = [storeID])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_TransactionLog WHERE (serialNo = [serialNo])')
INSERT INTO tbl_Queries VALUES ('SELECT * FROM tbl_ProductionLog')
INSERT INTO tbl_Queries VALUES ('SELECT Count(serialNo) FROM tbl_StoreInventory WHERE storeID = [storeID ')
INSERT INTO tbl_Queries VALUES ('SELECT Quantity, [Product Name] FROM customerView WHERE [Store Number] = [Store Number]')

DROP VIEW customerView
CREATE VIEW customerView AS SELECT s.StoreID AS [Store Number],c.productName AS [Product Name], s.price AS [Price], Count(s.serialNo) AS [Quantity]
FROM tbl_StoreInventory AS s 
LEFT JOIN tbl_ProductionLog AS p on s.serialNo = p.serialNo 
LEFT JOIN tbl_ProductCatalog AS c ON p.productID = c.productID 
GROUP BY s.storeID, c.productName, s.price

CREATE VIEW recentTransactionsView AS SELECT TOP 10 * FROM tbl_TransactionLog ORDER BY transactionID DESC
SELECT Quantity, [Product Name] FROM customerView WHERE [Store Number] = [Store Number]
SELECT * FROM tbl_StoreInventory WHERE storeID = 1
