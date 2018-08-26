public class OrderExtension {
    
    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}
    
    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;
    
    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }
        total = 0;
        refreshData();
        for(OrderItem orderItemResult : orderRecord.OrderItems){
            orderItemMap.put(orderItemResult.Product2Id, orderItemResult);
            if(orderItemResult.Quantity > 0){
                if(null == pieData) {
                    pieData = new List<chartHelper.ChartData>();
                }
                chartHelper.ChartData chartData = new chartHelper.ChartData(orderItemResult.Product2.Name, orderItemResult.Quantity * orderItemResult.UnitPrice);
                pieData.add(chartData);
                total = total + (orderItemResult.Quantity * orderItemResult.UnitPrice);
            }
        } 
        populateData();
    }
    
    public void populateData(){
        orderItemList = new List<OrderItem>();
        List<PricebookEntry> pricebookEntryList = standardSetController.getRecords();
        for(PricebookEntry pricebookEntryResult : pricebookEntryList){
            if(orderItemMap.containsKey(pricebookEntryResult.Product2Id)){
                orderItemList.add(orderItemMap.get(pricebookEntryResult.Product2Id));
            }
            else{
                OrderItem orderItem = new OrderItem();
                orderItem.PricebookEntryId  = pricebookEntryResult.Id;
                orderItem.Product2Id = pricebookEntryResult.Product2Id;
                orderItem.Quantity = Constants.DEFAULT_ROWS;
                orderItem.UnitPrice = 5;
                orderItem.Product2 = pricebookEntryResult.Product2;
                orderItemList.add(orderItem);
                orderItemMap.put(pricebookEntryResult.Product2Id, orderItem);
            }
        }
    }
    
    public void OnFieldChange(){
        pieData = null;
        total = 0;
        for(OrderItem orderItemResult : orderItemList){
            orderItemMap.put(orderItemResult.Product2Id, orderItemResult);
            if(orderItemResult.Quantity > 0){
                if(null == pieData) {
                    pieData = new List<chartHelper.ChartData>();
                }
                chartHelper.ChartData chartData = new chartHelper.ChartData(orderItemResult.Product2.Name, orderItemResult.Quantity * orderItemResult.UnitPrice);
                pieData.add(chartData);
                total = total + (orderItemResult.Quantity * orderItemResult.UnitPrice);
            }
        }        
        
        
    }
    
    public void SelectFamily(){
        refreshData();
        populateData();
    }
    
    public void Save(){
        System.SavePoint savePoint = Database.setSavepoint();
        try{
            if(orderRecord.Pricebook2Id == null) {
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            upsert orderRecord;   
            
            List<OrderItem> upsertOrderItemList = new List<OrderItem>();
            List<OrderItem> deleteOrderItemList = new List<OrderItem>();
            
            
            for (OrderItem orderItemResult : orderItemMap.values()) {
                if(orderItemResult.Quantity > 0){
                    if(orderItemResult.OrderId == null){
                        orderItemResult.Id = orderRecord.Id;
                    }
                    orderItemList.add(orderItemResult);
                }
                else if(orderItemResult.Id != Null){
                    deleteOrderItemList.add(new OrderItem(Id = orderItemResult.Id));
                    orderItemResult.Id = NULL;
                }
            }
            upsert upsertOrderItemList;
            delete deleteOrderItemList;
        }
        catch(Exception e){
            Database.rollback(savepoint);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));            
        }
        
    }
    
    public void refreshData(){
        if(selectedFamily == Constants.SELECT_ONE){
            standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, Product2.Name, Product2Id, Product2.Quantity_Remaining__c from PriceBookEntry Where IsActive = TRUE ]));
        }
        else{
            standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name, Product2.Name, Product2Id, Product2.Quantity_Remaining__c from PriceBookEntry Where IsActive = TRUE AND Product2.Family =: selectedFamily]));
        }
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    }
    
    public void First(){
        standardSetController.first();
        populateData();
    }
    
    public void Next(){
        standardSetController.next();
        populateData();
    }
    
    public void Previous(){
        standardSetController.previous();
        populateData();
    }
    
    public void Last(){
        standardSetController.last();     
        populateData();
    }
    
    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }
    
    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }
    
    public Integer GetTotalPages(){
        Integer totalPages = standardSetController.getResultSize() / Constants.DEFAULT_ROWS;
        return totalPages;
    }
    
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }
    
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(constants.SELECT_ONE, constants.SELECT_ONE));
        for(Schema.PicklistEntry picklistValues : constants.PRODUCT_FAMILY){
            options.add(new SelectOption(picklistValues.getValue() ,picklistValues.getValue()));
        }
        return options;
    }
    
    public static Order QueryOrderRecord(Id orderId){
        return [SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,(SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,Product2.Name, Product2.Family, Product2.Quantity_Remaining__c FROM OrderItems)FROM Order WHERE Id = :orderId];
    }   
}