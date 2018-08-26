public class CreateDummyCases {
    public Case createCases(Case oldCaseValues){
        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.Origin = 'Phone';
        newCase.Vehicle__c = oldCaseValues.Vehicle__c;
        newCase.Equipment__c = oldCaseValues.Equipment__c;
        newCase.Type = 'Routine Maintenance';
		newCase.Subject = 'Dummy';
		newCase.Date_Reported__c = Date.Today();        
        newCase.Date_Due__c = Date.Today().addDays(Integer.valueOf(oldCaseValues.Equipment__r.Maintenance_Cycle__c));
        return newCase;
    }
}