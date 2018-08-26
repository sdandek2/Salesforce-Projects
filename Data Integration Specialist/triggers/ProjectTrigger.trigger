trigger ProjectTrigger on Project__c (after update) {
    for(Project__c project : Trigger.New){
        if(project.Status__c == 'Billable'){
			BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
        }
    }
}