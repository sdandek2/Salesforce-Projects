@isTest
private class ProjectRESTServiceTest {
    @testSetup
    private static void setup(){
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.name = 'Test Opportunity';
        newOpportunity.CloseDate = Date.today();
        newOpportunity.Amount = 2000.00;
        newOpportunity.StageName = 'Prospecting';
        newOpportunity.DeliveryInstallationStatus__c = 'Completed';
        insert newOpportunity;
    }
    
    private testMethod static void testSucess(){
        Opportunity opp = [Select Id,Amount from Opportunity where Name = 'Test Opportunity'];
        String response = ProjectRESTService.postProjectData('123456','Test1', opp.Id, Date.today(), Date.today() + 20, Double.valueOf(opp.Amount) ,'Billable');
        system.assertEquals('OK', response);
        Opportunity successOpp = [select Id, DeliveryInstallationStatus__c from Opportunity where ID = :opp.Id LIMIT 1];
        system.assertEquals('In progress', successOpp.DeliveryInstallationStatus__c);
    }    
    
    private testMethod static void testFailure(){
        Opportunity opp = [Select Id,Amount from Opportunity where Name = 'Test Opportunity'];
        String response = ProjectRESTService.postProjectData('123456','Test1', opp.Id, Date.today(), Date.today() + 20, Double.valueOf(opp.Amount) ,'New');
        system.debug(response);
        Opportunity failureOpp = [select Id, DeliveryInstallationStatus__c from Opportunity where ID = :opp.Id LIMIT 1];
        system.assertEquals('Completed', failureOpp.DeliveryInstallationStatus__c);       
    }
}