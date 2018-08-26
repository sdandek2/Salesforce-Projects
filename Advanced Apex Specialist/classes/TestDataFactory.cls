public class TestDataFactory {
    
    public static CollaborationGroup ConstructCollaborationGroup(){
        CollaborationGroup collaborationGroup = new CollaborationGroup();
        collaborationGroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        collaborationGroup.CollaborationType = 'Public';
        return collaborationGroup;
    }
    
    public static List<Product2> ConstructProducts(Integer cnt){
        List<Schema.PickListEntry> familyPicklistValues = Constants.PRODUCT_FAMILY;
        List<Product2> products = new List<Product2>();
        
        for(Integer i = 0; i < cnt; i++){
            Product2 product = new Product2();
            product.Name = 'Test Product ' + i;
            product.Initial_Inventory__c = 10;
            product.IsActive = True;
            product.Family = familyPicklistValues[Math.mod(i, familyPicklistValues.size())].getValue();
            products.add(product);
        }
        return products;   
    }
    
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        List<PriceBookEntry> priceBookEntryList = new List<PriceBookEntry>();
        
        for(Product2 products : prods){
            PriceBookEntry priceBookEntry = new PriceBookEntry();
            priceBookEntry.Product2Id = products.Id;
            priceBookEntry.IsActive = TRUE;
            priceBookEntry.UnitPrice = 1;
            priceBookEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            priceBookEntryList.add(priceBookEntry);
        }
        return priceBookEntryList;
    }
    
    public static List<Account> ConstructAccounts(Integer cnt){
        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i < cnt; i++){
            Account account = new Account();
            account.Name = 'Test Account ' + i;
            accountList.add(account);
        }
        return accountList;       
    }
    
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i < cnt; i++){
            Contact contact = new Contact();
            contact.LastName = 'Test Contact ' + i;
            contact.AccountId = accts[Math.mod(i, accts.size())].Id;
            contactList.add(contact);
        }
        return contactList;
    }
    
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        List<Order> orderList = new List<Order>();
        for(Integer i = 0; i < cnt; i++){
            Order order = new Order();
            order.Name = 'Test Order ' + i;
            order.EffectiveDate = Date.today();
            order.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            order.Status = 'Draft';
            order.AccountId = accts[Math.mod(i, accts.size())].Id;
            orderList.add(order);
        }       
        return orderList;
    }
    
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        List<OrderItem> orderItemList = new List<OrderItem>();
        for(Integer i = 0; i < cnt; i++){
            OrderItem orderItem = new OrderItem();
            orderItem.Quantity = Constants.DEFAULT_ROWS;
            orderItem.UnitPrice = 5;
            orderItem.OrderId = ords[Math.mod(i, ords.size())].Id;
            orderItem.PricebookEntryId = pbes[Math.mod(i, pbes.size())].Id;
            orderItemList.add(orderItem);
        }
        return orderItemList;
    }
    
    public static void InsertTestData(Integer cnt){
        List<Account> accounts = constructAccounts(cnt);
        insert accounts;
        
        List<Contact> contacts = constructContacts(cnt, accounts);
        insert contacts;
        
        List<Product2> products = constructProducts(cnt);
        insert products;
        
        List<PricebookEntry> pricebookEntries = constructPricebookEntries(products);
        insert pricebookEntries;
        
        List<Order> orders = constructOrders(cnt, accounts);
        insert orders;
        
        List<OrderItem> orderItems = constructOrderItems(cnt, pricebookEntries, orders);
        insert orderItems; 
        
        
        CollaborationGroup collaborationGroup = ConstructCollaborationGroup();
        insert collaborationGroup;
    }
    
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        Integer newQuantity = (Integer)originalProduct.Quantity_Ordered__c + qtyOrdered;
        System.assertEquals(updatedProduct.Quantity_Ordered__c, newQuantity, 'Updated Value is Equal to Original + Quantity ordered');
    }
}