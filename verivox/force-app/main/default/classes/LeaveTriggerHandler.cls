public with sharing class LeaveTriggerHandler {
    public static string approved = 'Approved';

    public LeaveTriggerHandler() {

    }
    public static void calculateAvailableVacationDays(Map<Id,Leave__c> mapLeave,List<Leave__c> listLeave){
        Set<Id> ownerIds = new Set<Id>();
        for (Leave__c leave : mapLeave.values()) {
            ownerIds.add(leave.OwnerId);
        }
        List<User> listUser = [SELECT Id,Total_vacation_days__c FROM User WHERE Id =: ownerIds];
        List<User> listUserToUpdate = new List<User>();
        for (Leave__c leave : listLeave) {
            for (User u : listUser) {
                if (leave.OwnerId == u.Id && leave.Status__c == approved){  
                    u.Total_vacation_days__c = leave.Current_Available_Vacation_Days__c;          
                }
                listUserToUpdate.add(u);
            }
        }
        List<Database.SaveResult> result = Database.update(listUserToUpdate, true);
    }

    public static void AvailableVacationDays(List<Leave__c> listLeave){
        Integer allHolidays=0;
        List<Holiday> holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
        Id userId = System.UserInfo.getUserId();
        User u = [SELECT Id,Total_vacation_days__c FROM User WHERE Id =: userId];
        for (Leave__c leave : listLeave) {
            if (leave.Start_Date__c != null && leave.End_Date__c != null) {
                Integer allDaysBetween = (leave.Start_Date__c.daysBetween(leave.End_Date__c))+1;
                System.debug('allDaysBetween : '+allDaysBetween);
                for(Integer k=0;k<allDaysBetween ;k++ ){
                    if(checkifItisWorkingDay(leave.Start_Date__c.addDays(k),holidays)){
                        allHolidays++;
                    }
                }
                leave.Total_vacation_days__c = allHolidays;  
                if (u.Total_vacation_days__c != 0) {
                    leave.Current_Available_Vacation_Days__c = u.Total_vacation_days__c-allHolidays;
                }
            }           
        }
        System.debug('allHolidays : '+allHolidays);
    }
    public static void handleAfterTrigger(List<Leave__c> listLeave,Map<Id,Leave__c> mapLeave){
        createApprovalProcess(listLeave,mapLeave);
    }
    public static void createApprovalProcess(List<Leave__c> listLeave,Map<Id,Leave__c> mapLeave){
        Set<Id> ownerIds = new Set<Id>();
        for (Leave__c leave : mapLeave.values()) {
            ownerIds.add(leave.OwnerId);
        }
        List<User> listUser = [SELECT Id,Total_vacation_days__c FROM User WHERE Id =: ownerIds];
        //Create approval process
        for (Leave__c leave : listLeave) {
            for (User user : listUser) {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(leave.id);
                req1.setSubmitterId(user.Id); 
                req1.setProcessDefinitionNameOrId('Leave_Approval');
                req1.setSkipEntryCriteria(true);
                Approval.ProcessResult result = Approval.process(req1);                  
            }         
        }
        //Create approval process
        
    }


    public static boolean checkifItisWorkingDay(Date currentDate,List<Holiday> holidays){
        Date weekStart  = currentDate.toStartofWeek();
       for(Holiday hDay:holidays){
               if(currentDate.daysBetween(hDay.ActivityDate) == 0){
                        return false;
               }
       }
      if(weekStart.daysBetween(currentDate) ==0 || weekStart.daysBetween(currentDate) == 6){
              return false;
       } else
              return true;
}
}