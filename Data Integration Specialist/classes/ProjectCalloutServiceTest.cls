@isTest
private class ProjectCalloutServiceTest {
    @testSetup
    private static void setup(){
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.name = 'Test Opportunity';
        newOpportunity.CloseDate = Date.today();
        newOpportunity.Amount = 2000;
        newOpportunity.StageName = 'Prospecting';
        insert newOpportunity;
        
        ServiceTokens__c serviceToken = new ServiceTokens__c();
        serviceToken.Name = 'ProjectServiceToken';
        serviceToken.Token__c = 'aaabbbbbabbabababababa';
        insert serviceToken;
    }
    
    private static testMethod void createOpportunitySuccess(){
        ProjectCalloutServiceMock projectCalloutServiceMock = new ProjectCalloutServiceMock();
        Opportunity opportunity = [Select Id from Opportunity where name = 'Test Opportunity' LIMIT 1];
        List<Id> opportunityList = new List<Id>();
        opportunityList.add(opportunity.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, projectCalloutServiceMock);
        ProjectCalloutService.postOpportunityToPMS(opportunityList);
        Test.stopTest();    
        Opportunity opportunityCheck = [select Id,Name,StageName from Opportunity where id =: opportunity.Id];
        System.assertEquals('Submitted Project',opportunityCheck.StageName, 'Created OK');
    }
    
    private static testMethod void createOpportunityFailure(){
        ProjectCalloutServiceMockFailure projectCalloutServiceMockFailure = new ProjectCalloutServiceMockFailure();
        Opportunity opportunity = [Select Id from Opportunity where name = 'Test Opportunity' LIMIT 1];
        List<Id> opportunityList = new List<Id>();
        opportunityList.add(opportunity.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, projectCalloutServiceMockFailure);
        ProjectCalloutService.postOpportunityToPMS(opportunityList);
        Test.stopTest();    
        Opportunity opportunityCheck = [select Id,Name,StageName from Opportunity where id =: opportunity.Id];
        System.assertEquals('Resubmit Project',opportunityCheck.StageName, 'Bad Request');
    }
}