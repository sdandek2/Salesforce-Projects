public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout = true)
    public static void runWarehouseEquipmentSync(){
        HttpResponse response = httpSetup.Setup(WAREHOUSE_URL);
        List<Product2> productList = new List<Product2>();
        if (response.getStatusCode() == 200) {
            List<Object> resultsObject = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for (Object results: resultsObject){
                productList.add(createProduct.createNewProduct(results));
            }
            if(productList.size() > 0 ){
                system.debug(productList);
                insert productList;
            }
        }   
    }       
}