trigger LeaveTrigger on Leave__c (after insert, before insert, after update) {
    if (trigger.isAfter && trigger.isUpdate) {
        LeaveTriggerHandler.calculateAvailableVacationDays(Trigger.newMap,Trigger.new);        
    }if (trigger.isBefore && trigger.isInsert) {
        LeaveTriggerHandler.AvailableVacationDays(Trigger.new);        
    }if (trigger.isAfter && trigger.isInsert) {
        LeaveTriggerHandler.handleAfterTrigger(Trigger.new,Trigger.newMap);
        
    }

}
