@isTest
private class BillingCalloutServiceTest {
    @testSetup
    private static void setup(){
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.name = 'Test Opportunity';
        newOpportunity.CloseDate = Date.today();
        newOpportunity.Amount = 2000;
        newOpportunity.StageName = 'Prospecting';
        insert newOpportunity;
        
        Project__c project = new Project__c();
        project.Name = 'Project1';
        project.Opportunity__c = newOpportunity.Id;
        project.Start_Date__c = Date.today();
        project.End_Date__c = Date.today() + 20;
        project.Billable_Amount__c = 2000;
        project.Status__c = 'Running';
        project.ProjectRef__c = '1234';
        insert project;
        
        ServiceCredentials__c serviceCredentials = new ServiceCredentials__c();
        serviceCredentials.Name = 'BillingServiceCredential';
        serviceCredentials.Username__c = 'siddy';
        serviceCredentials.Password__c = '1234';
        insert serviceCredentials;
    }
    
    private static testMethod void testSuccess(){
    BillingCalloutServiceMock mock = new BillingCalloutServiceMock();
        test.setMock(WebServiceMock.class, mock);
        Project__C project = [Select Id,ProjectRef__c from Project__c where Name = 'Project1' LIMIT 1];
        project.Status__c = 'Billable';
        update project;
    }
    
    private static testMethod void testFailure(){
        BillingCalloutServiceMockFailure mock = new BillingCalloutServiceMockFailure();
        test.setMock(WebServiceMock.class, mock);
        Project__C project = [Select Id,ProjectRef__c from Project__c where Name = 'Project1' LIMIT 1];
        project.Status__c = 'Billable';
        update project;
    }
}