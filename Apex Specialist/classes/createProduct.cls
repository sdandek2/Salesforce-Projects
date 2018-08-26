public class createProduct {
    public static Product2 createNewProduct(Object results){
        Map<String, Object> resultsMap = (Map<String, Object>)results;
        Product2 product = new Product2();
        product.Replacement_Part__c = true;//(Boolean)resultsMap.get('replacement');
        product.Cost__c = (Integer)resultsMap.get('cost');
        product.Current_Inventory__c = (Integer)resultsMap.get('quantity');
        product.Lifespan_Months__c = (Integer)resultsMap.get('lifespan');
        product.Maintenance_Cycle__c = (Integer)resultsMap.get('maintenanceperiod');
        product.Warehouse_SKU__c = (String)resultsMap.get('sku');
        product.Name = (String)resultsMap.get('name');
        return product;
    }
    
}