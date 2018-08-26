public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> opportunityId){
        QueueablePMSCall queueablePMSCall = new QueueablePMSCall(opportunityId);
        System.enqueueJob(queueablePMSCall);
    }

    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts{
        List<Id> oppId;
        public QueueablePMSCall(List<Id> opportunityId){
            this.oppId = opportunityId;
        }
        
        public void execute(QueueableContext queueableContext){
            ProjectCalloutServiceHelper projectCalloutServiceHelper = new ProjectCalloutServiceHelper(oppId);
            String jsonValue = projectCalloutServiceHelper.createJson();
            ServiceTokens__c token = ServiceTokens__c.getValues('ProjectServiceToken');
            String requestToken = token.Token__c;
            HttpResponse response = httpSetup.Setup(requestToken, jsonValue);
            Opportunity opportunity = [Select Id,Name from Opportunity where Id = :oppId]; 
            if(response.getStatusCode() == 201){
                opportunity.StageName = 'Submitted Project';
                system.debug(response.getStatus());
            }
            else{
                opportunity.StageName = 'Resubmit Project';
                system.debug(response.getStatus());
            }
            update opportunity;
        } 
    }
}