public without sharing class ChartHelper {
    
    @AuraEnabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        AggregateResult[] aggregateResult = [Select Family, SUM(Quantity_Remaining__c) Quantity from Product2 where IsActive = TRUE AND Quantity_Remaining__c > 0 Group By Family];
        for(AggregateResult result : aggregateResult ){
            ChartData data = new ChartData(result.get('Family').toString(), Integer.valueOf(result.get('Quantity')));
            cht.add(data);
        }
        return cht;
    }
    
    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}
        
        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }
    
}