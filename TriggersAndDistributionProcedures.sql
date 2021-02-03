--BUSINESS CYCLE

EXEC productHouseProductRequest 1, 100
EXEC warehouseProductRequest 1, 100
EXEC distributorProductRequest 1, 100
EXEC subDistributorProductRequest 1, 100
EXEC channelPartnerProductRequest 1, 100
EXEC zoneProductRequest 1,100
EXEC storeProductRequest 1, 100
EXEC guestPurchase 100000000, 1, 100
EXEC guestReturn 1000, 1
----DROPS
DROP PROCEDURE guestReturn
--exec guestReturnTr
DROP PROCEDURE guestPurchase 
--exec guestPurchase (SSN, storeID, productID)
DROP PROCEDURE storeProductRequest
--exec storeProductRequest(storeID, productID)
DROP PROCEDURE  zoneProductRequest
--exec zoneProductRequest (zoneID, productID)
DROP PROCEDURE channelPartnerProductRequest
--exec channelPartnerProductRequest (channelPartnerID, productID)
DROP PROCEDURE subDistributorProductRequest 
--exec subDistributorProductRequest (subDistributor, productID)
DROP PROCEDURE distributorProductRequest 
--EXEC distributorProductRequest (distributorID, productID)
DROP PROCEDURE warehouseProductRequest
--EXEC warehouseProductRequest (wHouse, productID)
DROP PROCEDURE productHouseProductRequest
--EXEC productHouseProductRequest (productHouseID,productID)
DROP PROCEDURE generateProductLogItem
DROP PROCEDURE generateProductLogItems

-----------------------------------------------------------------------------------
generateInventories 100
CREATE PROCEDURE generateInventories @times INT
AS
BEGIN
	DECLARE @productID INT
	DECLARE @productHouseID INT
	DECLARE @warehouseID INT
	DECLARE @distributorID INT
	DECLARE @subDistributorID INT
	DECLARE @channelPartnerID INT
	DECLARE @zoneID INT
	DECLARE @storeID INT
	DECLARE @counter INT = 0
	while (@counter < @times)
		BEGIN
			SET @counter += 1
			SET @storeID = (select top 1 storeID from tbl_Stores order by newid())
			SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())
			exec storeProductRequest @storeID, @productID
		END 
	SET @counter = 0
	while (@counter < @times)
		BEGIN
			SET @counter += 1
			SET @zoneID = (select top 1 zoneID from tbl_Zones order by newid())
			SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())
			exec zoneProductRequest @zoneID, @productID
		END 
	SET @counter = 0
	while (@counter < @times)
		BEGIN
			SET @counter += 1
			SET @channelPartnerID = (select top 1 channelPartnerID from tbl_ChannelPartners order by newid())
			SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())
			exec channelPartnerProductRequest @channelPartnerID, @productID
		END 
	SET @counter = 0
	while (@counter < @times)
		BEGIN
			SET @counter += 1
			SET @subDistributorID = (select top 1 subDistributorID from tbl_SubDistributors order by newid())
			SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())
			exec subDistributorProductRequest @subDistributorID, @productID
		END 
	SET @counter = 0
	while (@counter < @times)
		BEGIN
			SET @counter += 1
			SET @distributorID = (select top 1 distributorID from tbl_Distributors order by newid())
			SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())
			exec distributorProductRequest @distributorID, @productID
		END 
	SET @counter = 0
	while (@counter < @times)
		BEGIN
			SET @counter += 1
			SET @warehouseID = (select top 1 warehouseID from tbl_Warehouses order by newid())
			SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())
			exec warehouseProductRequest @warehouseID, @productID
		END 
	SET @counter = 0
	while (@counter < @times)
		BEGIN
		SET @counter += 1
		SET @productHouseID = (select top 1 productionHouseID from tbl_ProductionHouses order by newid())
		SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())

		INSERT INTO tbl_ProductionLog VALUES(@productHouseID, @productID)
		END
	
END
-----------------------------------------------------------------------------------
CREATE PROCEDURE generateproductLogItem
AS
BEGIN
	DECLARE @productHouseID INT
	DECLARE @productID INT

	SET @productHouseID = (select top 1 productionHouseID from tbl_ProductionHouses order by newid())
	SET @productID = (select top 1 productID from tbl_ProductCatalog order by newid())

	INSERT INTO tbl_ProductionLog VALUES(@productHouseID, @productID)
END
-----------------------------------------------------------------------------------
CREATE PROCEDURE generateProductLogItems
AS
BEGIN
DECLARE @count INT = 0
	WHILE (@count < 100)
	BEGIN 
		SET @count += 1;
		EXEC generateproductLogItem
	END
END
----------------------------------------------------------------------------------
CREATE PROCEDURE productHouseProductRequest @productHouseID INT, @productID INT
AS BEGIN

	INSERT INTO tbl_ProductionLog VALUES(@productHouseID, @productID)
END
----------------------------------------------------------------------------------
CREATE PROCEDURE warehouseProductRequest @warehouseID INT, @productID INT
AS BEGIN
	DECLARE @productionHouseID INT = (SELECT productionHouseID FROM tbl_Warehouses WHERE warehouseID = @warehouseID)
	DECLARE @serialNo INT = (SELECT TOP 1 tbl_ProductionHouseInventory.serialNo 
						FROM tbl_ProductionHouseInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_ProductionHouseInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_ProductionHouseInventory.productionHouseID = @productionHouseID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec productHouseProductRequest @productionHouseID, @productID
				END
			SET @serialNo = (SELECT TOP 1 tbl_ProductionHouseInventory.serialNo 
						FROM tbl_ProductionHouseInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_ProductionHouseInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_ProductionHouseInventory.productionHouseID = @productionHouseID AND tbl_ProductionLog.productID = @productID))
			DECLARE @price MONEY = (SELECT price
					FROM tbl_ProductionHouseInventory 
					WHERE serialNo = @serialNo)
			INSERT INTO tbl_WarehouseInventory VALUES (@serialNo, @warehouseID, (@price * 1.8))

END

-----------------------------------------------------------------------------------

CREATE PROCEDURE distributorProductRequest @distributorID INT, @productID INT
AS BEGIN
	DECLARE @warehouseID INT = (SELECT TOP 1 warehouseID FROM tbl_Distributors WHERE distributorID = @distributorID)
	DECLARE @serialNo INT = (SELECT TOP 1 tbl_WarehouseInventory.serialNo 
						FROM tbl_WarehouseInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_WarehouseInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_WarehouseInventory.warehouseID = @warehouseID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec warehouseProductRequest @warehouseID, @productID
				END
					SET @serialNo = (SELECT TOP 1 tbl_WarehouseInventory.serialNo 
						FROM tbl_WarehouseInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_WarehouseInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_WarehouseInventory.warehouseID = @warehouseID AND tbl_ProductionLog.productID = @productID))
	
			DECLARE @price MONEY = (SELECT price
					FROM tbl_WarehouseInventory
					WHERE serialNo = @serialNo)
			INSERT INTO tbl_DistributorInventory VALUES (@serialNo, @distributorID, (@price * 1.8))

END
-----------------------------------------------------------------------------------

CREATE PROCEDURE subDistributorProductRequest @subDistributorID INT, @productID INT
AS BEGIN
	DECLARE @distributorID INT = (SELECT TOP 1 distributorID FROM tbl_SubDistributors WHERE subDistributorID = @subDistributorID)
	DECLARE @serialNo INT = (SELECT TOP 1 tbl_DistributorInventory.serialNo 
						FROM tbl_DistributorInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_DistributorInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_DistributorInventory.distributorID = @distributorID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec distributorProductRequest @distributorID, @productID
				END
					SET @serialNo = (SELECT TOP 1 tbl_DistributorInventory.serialNo 
						FROM tbl_DistributorInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_DistributorInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_DistributorInventory.distributorID = @distributorID AND tbl_ProductionLog.productID = @productID))
	
			DECLARE @price MONEY = (SELECT price
					FROM tbl_DistributorInventory
					WHERE serialNo = @serialNo)
			INSERT INTO tbl_SubDistributorInventory VALUES (@serialNo, @subDistributorID, (@price * 1.8))

END
-----------------------------------------------------------------------------------
CREATE PROCEDURE channelPartnerProductRequest @channelPartnerID INT, @productID INT
AS BEGIN
	DECLARE @subDistributorID INT = (SELECT TOP 1 subDistributorID FROM tbl_ChannelPartners WHERE channelPartnerID = @channelPartnerID)
	DECLARE @serialNo INT = (SELECT TOP 1 tbl_SubDistributorInventory.serialNo 
						FROM tbl_SubDistributorInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_SubDistributorInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_SubDistributorInventory.subDistributorID = @subDistributorID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec subDistributorProductRequest @subDistributorID, @productID
				END
					SET @serialNo = (SELECT TOP 1 tbl_SubDistributorInventory.serialNo 
						FROM tbl_SubDistributorInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_SubDistributorInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_SubDistributorInventory.subDistributorID = @subDistributorID AND tbl_ProductionLog.productID = @productID))
	
			DECLARE @price MONEY = (SELECT price
					FROM tbl_subDistributorInventory
					WHERE serialNo = @serialNo)
			INSERT INTO tbl_ChannelPartnerInventory VALUES (@serialNo, @channelPartnerID, (@price * 1.8))

END
-----------------------------------------------------------------------------------
CREATE PROCEDURE zoneProductRequest @zoneID INT, @productID INT
AS BEGIN
	DECLARE @channelPartnerID INT = (SELECT TOP 1 channelPartnerID FROM tbl_Zones WHERE zoneID = @zoneID)
	DECLARE @serialNo INT = (SELECT TOP 1 tbl_channelPartnerInventory.serialNo 
						FROM tbl_channelPartnerInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_ChannelPartnerInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_ChannelPartnerInventory.channelPartnerID = @channelPartnerID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec channelPartnerProductRequest @channelPartnerID, @productID
				END
					SET @serialNo = (SELECT TOP 1 tbl_channelPartnerInventory.serialNo 
						FROM tbl_channelPartnerInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_ChannelPartnerInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_ChannelPartnerInventory.channelPartnerID = @channelPartnerID AND tbl_ProductionLog.productID = @productID))

			DECLARE @price MONEY = (SELECT price
					FROM tbl_ChannelPartnerInventory
					WHERE serialNo = @serialNo)
			INSERT INTO tbl_ZoneInventory VALUES (@serialNo, @zoneID, (@price * 1.8))

END
-----------------------------------------------------------------------------------

CREATE PROCEDURE storeProductRequest @storeID INT, @productID INT
AS BEGIN
	DECLARE @zoneID INT = (SELECT TOP 1 zoneID FROM tbl_Stores WHERE storeID = @storeID)
	DECLARE @serialNo INT = (SELECT TOP 1 tbl_ZoneInventory.serialNo 
						FROM tbl_ZoneInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_ZoneInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_ZoneInventory.zoneID = @zoneID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec zoneProductRequest @zoneID, @productID
				END
					SET @serialNo = (SELECT TOP 1 tbl_ZoneInventory.serialNo 
						FROM tbl_ZoneInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_ZoneInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_ZoneInventory.zoneID = @zoneID AND tbl_ProductionLog.productID = @productID))

			DECLARE @price MONEY = (SELECT price
					FROM tbl_ZoneInventory
					WHERE serialNo = @serialNo)
			INSERT INTO tbl_StoreInventory VALUES (@serialNo, @storeID, (@price * 1.8))

END
-----------------------------------------------------------------------------------

CREATE PROCEDURE guestPurchase @SSN INT, @storeID INT, @productID INT
AS BEGIN

	DECLARE @serialNo INT = (SELECT TOP 1 tbl_StoreInventory.serialNo 
						FROM tbl_StoreInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_StoreInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_StoreInventory.storeID = @storeID AND tbl_ProductionLog.productID = @productID))
			IF (@serialNo IS NULL) 
				BEGIN
					exec storeProductRequest @storeID, @productID
				END
					SET @serialNo =  (SELECT TOP 1 tbl_StoreInventory.serialNo 
						FROM tbl_StoreInventory 
						LEFT JOIN  tbl_ProductionLog ON
						tbl_StoreInventory.serialNo = tbl_ProductionLog.serialNo
						WHERE (tbl_StoreInventory.storeID = @storeID AND tbl_ProductionLog.productID = @productID))

			INSERT INTO tbl_Purchases VALUES ( @serialNo, @SSN)

END
-----------------------------------------------------------------------------------
exec guestReturn 1002, 1
CREATE PROCEDURE guestReturn @serialNo INT, @storeID INT
AS BEGIN
	DECLARE @productionHouseID INT = (SELECT TOP 1 productionHouseID FROM tbl_ProductionLog WHERE serialNo = @serialNo)
	DECLARE @price MONEY = (SELECT TOP 1 productBasePrice FROM tbl_ProductCatalog PC WHERE productID = (SELECT productID FROM tbl_ProductionLog WHERE serialNo = @serialNo)) 
	INSERT INTO tbl_ProductionHouseInventory VALUES ( @serialNo, @productionHouseID,@price)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo,CONCAT('Store: ', @storeID), CONCAT('Production House: ', @productionHouseID), GETDATE())
	DELETE FROM tbl_Purchases WHERE serialNo = @serialNo
END



DROP TRIGGER trg_sendProductToProductionHouseInventory
DROP TRIGGER trg_deleteProductionHouseInstance
DROP TRIGGER trg_deleteWarehouseInstance
DROP TRIGGER trg_deleteDistributorInstance
DROP TRIGGER trg_deleteSubDistributorInstance
DROP TRIGGER trg_deleteChannelPartnerInstance
DROP TRIGGER trg_deleteZoneInstance
DROP TRIGGER trg_deleteStoreInstance
-----------------------------------------------------------------------------------
--TRIGGERS
CREATE TRIGGER trg_sendProductToProductionHouseInventory
ON tbl_ProductionLog
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT
	DECLARE @productionHouseID INT
	DECLARE @price MONEY

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_ProductionLog ORDER BY serialNo DESC)
	SET @productionHouseID = (SELECT TOP 1 productionHouseID FROM tbl_ProductionLog ORDER BY serialNo DESC)
	SET @price = (SELECT TOP 1 productBasePrice FROM tbl_ProductCatalog PC WHERE productID = (SELECT productID FROM tbl_ProductionLog WHERE serialNo = @serialNo)) 
	INSERT INTO tbl_ProductionHouseInventory VALUES(@serialNo,@productionHouseID, @price)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, (CONCAT('Production House: ', @productionHouseID , ' Manufacturing Floor')), (CONCAT('Production House: ', @productionHouseID , ' Inventory')),GETDATE())
END
-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteProductionHouseInstance
ON tbl_WarehouseInventory
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT
	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_WarehouseInventory ORDER BY warehouseInsertID DESC)
	--transactionlog
	DECLARE @productionHouseID INT
	DECLARE @warehouseID INT
	SET @productionHouseID =(SELECT TOP 1 productionHouseID FROM tbl_ProductionHouseInventory WHERE serialNo = @serialNo)
	SET @warehouseID =(SELECT TOP 1 warehouseID FROM tbl_WarehouseInventory WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Production House: ', @productionHouseID), CONCAT('Warehouse: ', @warehouseID), GETDATE())
	
	DELETE FROM tbl_ProductionHouseInventory WHERE serialNo = @serialNo
END
-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteWarehouseInstance
ON tbl_DistributorInventory
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_DistributorInventory ORDER BY distributorInsertID DESC)
	--transactionlog
	DECLARE @distributorID INT
	DECLARE @warehouseID INT
	SET @distributorID =(SELECT TOP 1 distributorID FROM tbl_DistributorInventory WHERE serialNo = @serialNo)
	SET @warehouseID =(SELECT TOP 1 warehouseID FROM tbl_WarehouseInventory WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Warehouse: ', @warehouseID), CONCAT('Distributor: ', @distributorID), GETDATE())
	
	DELETE FROM tbl_WarehouseInventory WHERE serialNo = @serialNo
END
-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteDistributorInstance
ON tbl_SubDistributorInventory
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_SubDistributorInventory ORDER BY subDistributorInsertID DESC)
	--transaction log
	DECLARE @distributorID INT
	DECLARE @subDistributorID INT
	SET @distributorID =(SELECT TOP 1 distributorID FROM tbl_DistributorInventory WHERE serialNo = @serialNo)
	SET @subDistributorID =(SELECT TOP 1 subDistributorID FROM tbl_SubDistributorInventory WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Distributor: ', @distributorID), CONCAT('SubDistributor: ', @subDistributorID), GETDATE())
	
	DELETE FROM tbl_DistributorInventory WHERE serialNo = @serialNo
END
-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteSubDistributorInstance
ON tbl_ChannelPartnerInventory
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_ChannelPartnerInventory ORDER BY channelPartnerInsertID DESC)
	DECLARE @channelPartnerID INT
	DECLARE @subDistributorID INT
	SET @channelPartnerID =(SELECT TOP 1 channelPartnerID FROM tbl_ChannelPartnerInventory WHERE serialNo = @serialNo)
	SET @subDistributorID =(SELECT TOP 1 subDistributorID FROM tbl_SubDistributorInventory WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Sub Distributor: ', @subDistributorID), CONCAT('Channel Partner: ', @channelPartnerID), GETDATE())
	
	DELETE FROM tbl_SubDistributorInventory WHERE serialNo = @serialNo
END
-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteChannelPartnerInstance
ON tbl_ZoneInventory
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_ZoneInventory ORDER BY zoneInsertID DESC)

	DECLARE @channelPartnerID INT
	DECLARE @zoneID INT
	SET @channelPartnerID =(SELECT TOP 1 channelPartnerID FROM tbl_ChannelPartnerInventory WHERE serialNo = @serialNo)
	SET @zoneID =(SELECT TOP 1 zoneID FROM tbl_ZoneInventory WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Channel Partner: ', @channelPartnerID), CONCAT('Zone: ', @zoneID),GETDATE())
	
	DELETE FROM tbl_ChannelPartnerInventory WHERE serialNo = @serialNo
END

-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteZoneInstance
ON tbl_StoreInventory
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_StoreInventory ORDER BY storeInsertID DESC)
	DECLARE @storeID INT
	DECLARE @zoneID INT
	SET @storeID =(SELECT TOP 1 storeID FROM tbl_StoreInventory WHERE serialNo = @serialNo)
	SET @zoneID =(SELECT TOP 1 zoneID FROM tbl_ZoneInventory WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Zone: ', @zoneID),CONCAT('Store: ', @storeID),GETDATE())
	
	DELETE FROM tbl_ZoneInventory WHERE serialNo = @serialNo
END
-----------------------------------------------------------------------------------
CREATE TRIGGER trg_deleteStoreInstance
ON tbl_Purchases
AFTER INSERT AS 
BEGIN
	DECLARE @serialNo INT

	SET @serialNo = (SELECT TOP 1 serialNo FROM tbl_Purchases ORDER BY purchaseID DESC)
	DECLARE @storeID INT
	DECLARE @SSNID INT
	SET @storeID =(SELECT TOP 1 storeID FROM tbl_StoreInventory WHERE serialNo = @serialNo)
	SET @SSNID =(SELECT TOP 1 SSN FROM tbl_Purchases WHERE serialNo = @serialNo)
	INSERT INTO tbl_TransactionLog VALUES( @serialNo, CONCAT('Store: ', @storeID), CONCAT('Customer: ', @SSNID),GETDATE())
	
	DELETE FROM tbl_ZoneInventory WHERE serialNo = @serialNo
	DELETE FROM tbl_StoreInventory WHERE serialNo = @serialNo
END


