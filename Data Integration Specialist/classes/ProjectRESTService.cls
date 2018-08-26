@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
        Savepoint savePoint = Database.setSavepoint();
        try{
            Project__c project = new Project__c();
            project.Name = ProjectName;
            project.Opportunity__c = OpportunityId;
            project.Start_Date__c = StartDate;
            project.End_Date__c = EndDate;
            project.Billable_Amount__c = Amount;
            project.Status__c = Status;
            project.ProjectRef__c = ProjectRef;
            upsert project;
            
            Opportunity opp = [Select Id, Name, DeliveryInstallationStatus__c  from Opportunity where Id = :OpportunityId ];
            opp.DeliveryInstallationStatus__c = 'In progress';
            update opp;
            
            return 'OK';
        }
        Catch(Exception ex){
            Database.rollback(savePoint);
            return ex.getMessage();
        }
    }
    
}