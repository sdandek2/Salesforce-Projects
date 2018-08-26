public class BillingCalloutService {
    @future(callout = true)
    public static void callBillingService(String ProjectRef, Decimal Amount){
        ServiceCredentials__c serviceCredentials = ServiceCredentials__c.getValues('BillingServiceCredential');
        
        //creating project
        BillingServiceProxy.project billingProject = new BillingServiceProxy.project();
        billingProject.username = serviceCredentials.Username__c;
        billingProject.password = serviceCredentials.Password__c;
        billingProject.projectRef = ProjectRef;
        billingProject.billAmount = Amount;
        
        //calling InvoicesPortSoap11
        BillingServiceProxy.InvoicesPortSoap11 billingInvoice = new BillingServiceProxy.InvoicesPortSoap11();
        String response = billingInvoice.billProject(billingProject);
        if(response == 'OK'){
            Project__c project = [Select Id,Status__c from Project__c where ProjectRef__c = :ProjectRef];
            project.Status__c = 'Billed';
            update project;
        }
    }
}