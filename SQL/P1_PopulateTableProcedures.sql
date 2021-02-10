--DROP PROCEDURES
DROP PROCEDURE populateWarehouses
DROP PROCEDURE populateDistributors
DROP PROCEDURE populateSubDistributors
DROP PROCEDURE populateChannelPartners
DROP PROCEDURE populateZones
DROP PROCEDURE populateStores
DROP PROCEDURE populateCustomers

----CREATE PROCEDURES
exec populateWarehouses
CREATE PROCEDURE populateWarehouses
AS
BEGIN
DECLARE @warehouseID INT = 0
DECLARE @productionHouseID INT = 1
WHILE (@warehouseID < (((SELECT COUNT(*)FROM tbl_ProductionHouses) * 2)-1))
	BEGIN
		SET @warehouseID = @warehouseID + 1
		IF (@warehouseID % 2 = 0)
		BEGIN
			SET @productionHouseID = @productionHouseID + 1
		END
		INSERT INTO tbl_Warehouses VALUES(
		@productionHouseID)
	END
END
exec populateDistributors
CREATE PROCEDURE populateDistributors
AS
BEGIN
DECLARE @distributorID INT = 0
DECLARE @warehouseID INT = 1
WHILE (@distributorID < (((SELECT COUNT(*)FROM tbl_Warehouses) * 2)-1))
	BEGIN
		SET @distributorID = @distributorID + 1
		IF (@distributorID % 2 = 0)
		BEGIN
			SET @warehouseID = @warehouseID + 1
		END
		INSERT INTO tbl_Distributors VALUES(
		@warehouseID)
	END
END
exec populateSubDistributors
CREATE PROCEDURE populateSubDistributors
AS
BEGIN
DECLARE @subDistributorID INT = 0
DECLARE @distributorID INT = 1
WHILE (@subDistributorID < (((SELECT COUNT(*)FROM tbl_Distributors) * 2)-1))
	BEGIN
		SET @subDistributorID = @subDistributorID + 1
		IF (@subDistributorID % 2 = 0)
		BEGIN
			SET @distributorID = @distributorID + 1
		END
		INSERT INTO tbl_SubDistributors VALUES(
		@distributorID)
	END
END
exec populateChannelPartners
CREATE PROCEDURE populateChannelPartners
AS
BEGIN
DECLARE @channelPartnerID INT = 0
DECLARE @subDistributorID INT = 1
WHILE (@channelPartnerID < (((SELECT COUNT(*)FROM tbl_SubDistributors) * 2)-1))
	BEGIN
		SET @channelPartnerID = @channelPartnerID + 1
		IF (@channelPartnerID % 2 = 0)
		BEGIN
			SET @subDistributorID = @subDistributorID + 1
		END
		INSERT INTO tbl_ChannelPartners VALUES(
		@subDistributorID)
	END
END

exec populateZones
CREATE PROCEDURE populateZones
AS
BEGIN
DECLARE @zoneID INT = 0
DECLARE @channelPartnerID INT = 1
WHILE (@zoneID < (((SELECT COUNT(*)FROM tbl_ChannelPartners) * 2)-1))
	BEGIN
		SET @zoneID = @zoneID + 1
		IF (@zoneID % 2 = 0)
		BEGIN
			SET @channelPartnerID = @channelPartnerID + 1
		END
		INSERT INTO tbl_Zones VALUES(
		@channelPartnerID)
	END
END
exec populateStores
CREATE PROCEDURE populateStores
AS
BEGIN
DECLARE @storeID INT = 0
DECLARE @zoneID INT = 1
WHILE (@storeID < (((SELECT COUNT(*)FROM tbl_Zones) * 2)-1))
	BEGIN
		SET @storeID = @storeID + 1
		IF (@storeID % 2 = 0)
		BEGIN
			SET @zoneID= @zoneID + 1
		END
		INSERT INTO tbl_Stores VALUES(
		@zoneID)
	END
END
exec populateCustomers
CREATE PROCEDURE populateCustomers
AS
BEGIN
DECLARE @name VARCHAR(20) = ''
DECLARE @SSN INT = 0
WHILE (@SSN < 999)
	BEGIN
		SET @SSN = @SSN + 1
		SET @name = (SELECT top 1 name from tbl_Names order by NEWID())
		
		INSERT INTO tbl_Customers VALUES(@name)

	END
END

--Populate Distribution Levels
EXEC populateWarehouses
EXEC populateDistributors
EXEC populateSubDistributors
EXEC populateChannelPartners
EXEC populateZones
EXEC populateStores
EXEC populateCustomers
