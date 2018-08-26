@isTest
public class OrderTests {
    @testSetup
    static void SetupTestData(){
        TestDataFactory.InsertTestData(12);
    } 
    
    @isTest static void OrderUpdate_UnitTest(){
        Order order = [Select Id, Status from Order LIMIT 1];
        Product2 originalProduct = [Select Id, Quantity_Ordered__c from Product2 LIMIT 1];
        
        order.Status = Constants.ACTIVATED_ORDER_STATUS;
        update order;
        
        Product2 updatedProduct = [Select Id, Quantity_Ordered__c from Product2 LIMIT 1];
        
        TestDataFactory.VerifyQuantityOrdered(originalProduct, updatedProduct, Constants.DEFAULT_ROWS);
    }
    
    @isTest  static void OrderExtension_UnitTest(){
        PageReference pageReference = Page.OrderEdit;
        Test.setCurrentPage(pageReference);
        
        Order order = [Select Id, Status from Order LIMIT 1];
        ApexPages.StandardController standardController = new ApexPages.StandardController(order);
        OrderExtension orderExtension = new OrderExtension(standardController);
        orderExtension.OnFieldChange();
        orderExtension.First();
        orderExtension.GetFamilyOptions();
        orderExtension.GetHasNext();
        orderExtension.GetHasPrevious();
        orderExtension.GetPageNumber();
        orderExtension.GetTotalPages();
        orderExtension.Last();
        orderExtension.Next();
        orderExtension.Previous();
        orderExtension.SelectFamily();
        orderExtension.Save();
    }
}