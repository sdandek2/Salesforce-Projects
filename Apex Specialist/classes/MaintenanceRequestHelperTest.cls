@isTest
public class MaintenanceRequestHelperTest {
    private static testMethod List<Case> setup(){
        //create vehicle
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'Toyota Corola';
        vehicle.Model__c = 'XLS';
        vehicle.Air_Conditioner__c = true;
        insert vehicle;
        
        //create Equipment
        Product2 equipment = new Product2();
        equipment.Name = 'Stering';
        equipment.Replacement_Part__c = true;
        equipment.Cost__c = 500;
        equipment.Current_Inventory__c = 200;
        equipment.Maintenance_Cycle__c = 48;
        equipment.Warehouse_SKU__c = 'SKU';
        equipment.Lifespan_Months__c = 60;
        insert equipment;
        
        //create case
        List<Case> testCaseList = new List<Case>();
        for(Integer i = 0; i < 300; i++){
            Case newCase = new Case();
            newCase.Status = 'New';
            newCase.Origin = 'Phone';
            newCase.Vehicle__c = vehicle.Id;
            newCase.Equipment__c = equipment.Id;
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = 'Dummy';
            newCase.Date_Reported__c = Date.Today();    
            testCaseList.add(newCase);
        }
        insert testCaseList;
        return testCaseList;
    }
    private static testMethod void test(){
        List<Case> testCases =  MaintenanceRequestHelperTest.setup();
        List<Case> updateCaseList = new List<Case>();
        for(Case cases : testCases){
            cases.Status = 'Closed';
            updateCaseList.add(cases);
        }
        update updateCaseList;
        
        Integer caseClosedCount = [Select count() from case where Subject = 'Dummy' AND Type = 'Routine Maintenance'];
        system.assertNotEquals(300, caseClosedCount, 'Trigger worked and cases inserted');
    }
}