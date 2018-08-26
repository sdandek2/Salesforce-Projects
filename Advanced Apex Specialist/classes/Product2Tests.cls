@isTest
public class Product2Tests {
    @testSetup
    static void SetupTestData(){
    } 
    static TestMethod void Product2Extension_UnitTest(){
        PageReference pageReference = Page.Product2New;
        Test.setCurrentPage(pageReference);
        
        List<product2> product = TestDataFactory.ConstructProducts(1);
        ApexPages.StandardController standardController = new ApexPages.StandardController(product.get(0));
        Product2Extension productExtension = new Product2Extension(standardController);
        
        System.assert(productExtension.productsToInsert.size() == Constants.DEFAULT_ROWS);
        //System.assertEquals(Constants.DEFAULT_ROWS, productExtension.productsToInsert.size() , 'Product Size equals defaul rows');
        
        productExtension.addRows();
        System.assert(productExtension.productsToInsert.size() == Constants.DEFAULT_ROWS * 2);
        //System.assertEquals(Constants.DEFAULT_ROWS * 2, productExtension.productsToInsert.size() , 'Product Size doubled');
        
        for(Integer i = 0; i < 5 ; i++){
            Product2Extension.ProductWrapper productWrapper = productExtension.productsToInsert[i];            
            List<product2> productList = TestDataFactory.ConstructProducts(1);
            productWrapper.productRecord = productList.get(0);
            
            PriceBookEntry priceBookEntry = new PriceBookEntry();
            priceBookEntry.IsActive = TRUE;
            priceBookEntry.UnitPrice = 1;
            priceBookEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            productWrapper.pricebookEntryRecord = priceBookEntry;
            
        }
        productExtension.save();
        List<Product2> productList = [SELECT Id, Name FROM Product2];
        System.assertEquals(Constants.DEFAULT_ROWS, productList.size(), '5 Records Inserted');
        
        List<SelectOption> selectOptionsList = productExtension.GetFamilyOptions();
        System.assertEquals(Constants.DEFAULT_ROWS, selectOptionsList.size(), '5 Entries in Family PickList');
        
        productExtension.GetInventory();
    }
    
    @isTest static void Product2Trigger_UnitTest(){
        TestDataFactory.InsertTestData(12);
        Product2 product = [Select Id, Name, Quantity_Ordered__c from Product2 LIMIT 1];
        product.Quantity_Ordered__c = 20;
        update product;
        
        Product2 productnew = [Select Id, Name, Quantity_Ordered__c from Product2 LIMIT 1];
        system.assertEquals(20, productnew.Quantity_Ordered__c, 'Product Quantity updated');
    }
}