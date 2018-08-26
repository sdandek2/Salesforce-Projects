public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(){
        CreateDummyCases createDummyCases = new CreateDummyCases();
        List<Case> caseList = new List<Case>();
        List<Case> updatedCase = [Select Id,Type,Status,Vehicle__c,Equipment__c,Equipment__r.Maintenance_Cycle__c from Case where Id in :Trigger.New];
        for(Case oldCase: updatedCase){
            if(oldCase.Type == 'Routine Maintenance' && oldCase.Status == 'Closed'){
                caseList.add(createDummyCases.createCases(oldCase));
            }
        }

        if(caseList.size() > 0){
			insert caseList;            
        }
    }        
}