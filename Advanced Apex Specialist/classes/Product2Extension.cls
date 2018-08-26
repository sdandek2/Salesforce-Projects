public class Product2Extension {
    
    public List<ProductWrapper> productsToInsert {get;set;}
    
    public Product2Extension(ApexPages.StandardController standardController){
        productsToInsert = new List<ProductWrapper>();
        AddRows();
    }
    
    public void AddRows(){
        for ( Integer i=0; i<constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }
    
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(constants.SELECT_ONE, constants.SELECT_ONE));
        for(Schema.PicklistEntry picklistValues : constants.PRODUCT_FAMILY){
            options.add(new SelectOption(picklistValues.getValue() ,picklistValues.getValue()));
        }
        return options;
    }
    
    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public PageReference Save(){
        SavePoint sp = Database.setSavepoint();
        try {
            List<Product2> productList = new List<Product2>();
            List<PriceBookEntry> pricebookentryList = new List<PriceBookEntry>();
            for(ProductWrapper productwrapperResult: productsToInsert) {
                if(productwrapperResult.productRecord != NULL && productwrapperResult.pricebookEntryRecord != NULL && productwrapperResult.productRecord.Name != NULL && productwrapperResult.productRecord.Family != NULL && productwrapperResult.productRecord.Initial_Inventory__c != NULL && productwrapperResult.pricebookEntryRecord.UnitPrice != NULL){
                    productList.add(productwrapperResult.productRecord);
                    PriceBookEntry pricebookentry = productwrapperResult.pricebookEntryRecord;
                    pricebookentry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    //pricebookentry.Product2Id = productwrapperResult.productRecord.Id;
                    pricebookentryList.add(pricebookentry);   
                }
            }
            insert productList;
            
            for(Integer i = 0; i < pricebookentryList.Size(); i++){
                pricebookentryList[i].Product2Id = productList[i].Id;
            }
            insert pricebookentryList;
            
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            AddRows();  //Do not remove
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }
    
    public class ProductWrapper{
        public Product2 productRecord {get; set;}
        public PriceBookEntry pricebookEntryRecord {get; set;}
        
        public ProductWrapper() {
            productRecord = new product2();
            pricebookEntryRecord = new pricebookEntry();
        }
    }
    
}