@isTest
private class WarehouseCalloutServiceTest {
	static testMethod void testGetCallout() {
        WarehouseCalloutServiceMock warehouseCalloutServiceMock = new WarehouseCalloutServiceMock();
        Test.setMock(HttpCalloutMock.class, warehouseCalloutServiceMock);
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
    }
}