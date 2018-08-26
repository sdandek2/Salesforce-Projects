global class WareHouseSyncScheduleHelper implements Schedulable{
    global void execute(SchedulableContext ctx) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}