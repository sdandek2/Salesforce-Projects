@isTest
public class WarehouseSyncScheduleTest {
    static testMethod void testGetCallout() {
        WarehouseCalloutServiceMock warehouseCalloutServiceMock = new WarehouseCalloutServiceMock();
        WarehouseSyncSchedule warehouseSyncSchedule = new WarehouseSyncSchedule();
        Test.setMock(HttpCalloutMock.class, warehouseCalloutServiceMock);
        String sch = '0 0 1 * * ?';
        Test.startTest();
        String jobID = System.schedule('WarehouseCalloutServiceScheduler', sch, warehouseSyncSchedule);
        Test.stopTest();        
    }    
}