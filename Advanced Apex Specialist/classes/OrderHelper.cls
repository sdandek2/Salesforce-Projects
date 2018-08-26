public class OrderHelper {
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status == Constants.DRAFT_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }
        RollUpOrderItems(orderIds);
    }

    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        Map<Id, Product2> productMap = new Map<Id, Product2>();

        List<OrderItem> OrderItems = [Select Id,Product2Id from OrderItem where OrderId In :activatedOrderIds ];

        for(OrderItem oItem : OrderItems ){
            productMap.put(oItem.Product2Id, [Select Id , Quantity_Ordered__c from Product2 where Id =: oItem.Product2Id]);
        }

		AggregateResult[] orderList = [SELECT Product2Id, SUM(Quantity) FROM OrderItem WHERE Product2Id In :productMap.keySet() GROUP BY Product2Id];
        for(AggregateResult ar : orderList){
            productMap.get(ar.get('Product2Id').toString()).Quantity_Ordered__c = Integer.valueOf(ar.get('expr0'));
            system.debug(Integer.valueOf(ar.get('expr0')));
        }
        
        if(productMap.size() > 0){
            update productMap.values();
        }
    }

}