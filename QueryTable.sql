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