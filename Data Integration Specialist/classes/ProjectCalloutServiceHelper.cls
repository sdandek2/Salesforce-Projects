public class ProjectCalloutServiceHelper {
     List<Id> oppId;
    public ProjectCalloutServiceHelper(List<Id> opportunityId){
        this.oppId = opportunityId;
    }
    
    public String createJson(){
        Opportunity opportunityId = [Select Id,Name,Account.Name,closeDate,Amount from Opportunity where Id = :oppId];
        String inputJSON = '{\n'+
            '	"opportunityId": "' + opportunityId.Id + '",\n' + 
            '	"opportunityName": "'+ opportunityId.Name +'",\n'+
            '	"accountName": "'+ opportunityId.Account.Name +'",\n'+
            '	"closeDate": "'+ String.ValueOf(opportunityId.CloseDate).mid(0,10) +'",\n'+
            '	"amount": '+ opportunityId.Amount +'\n' +
            '}';
        return inputJSON;
    }
}