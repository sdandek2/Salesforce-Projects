public class Product2Helper {
    static List<CollaborationGroup> COLLABORATION_GROUP = [SELECT Id FROM CollaborationGroup WHERE Name =: Constants.INVENTORY_ANNOUNCEMENTS OR Name = :('TEST'+ Constants.INVENTORY_ANNOUNCEMENTS ) LIMIT 1 ];

    public static void AfterUpdate(List<Product2> oldList, List<Product2> newList){
		List<Product2> needsAnnouncement = new List<Product2>();

		Map<String, Decimal> inventorySettingsMap = new Map<String, Decimal>();
        
        List<Inventory_Setting__mdt> inventorySettingsList = [Select Id, DeveloperName, MasterLabel, Low_Quantity_Alert__c from Inventory_Setting__mdt]; 	
        for(Inventory_Setting__mdt inventorySettingsResults : inventorySettingsList){
            inventorySettingsMap.put(inventorySettingsResults.DeveloperName, inventorySettingsResults.Low_Quantity_Alert__c );
        }
        
        for(Product2 product : newList){
            if(product.Quantity_Remaining__c < inventorySettingsMap.get(product.Family)){
                needsAnnouncement.add(product);
            }
        }

        PostAlerts(needsAnnouncement);
    }

    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            textSegmentInput.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            messageBodyInput.messageSegments.add(textSegmentInput);
            
            ConnectApi.AnnouncementInput announcementInput = new ConnectApi.AnnouncementInput();
            announcementInput.expirationDate = Date.today() + 1;
            announcementInput.sendEmails = FALSE;
            announcementInput.body = messageBodyInput;
            
            toPost.add(announcementInput);
        }
        AnnouncementQueueable announcementQueueable = new AnnouncementQueueable();
        AnnouncementQueueable.toPost = toPost;
		System.enqueueJob(announcementQueueable);
    }
}