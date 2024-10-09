@RestResource(urlMapping='/leave/*')
global with sharing class RestWebForLeaveApplications {
    public RestWebForLeaveApplications() {

    }
    @HttpGet
    global static List<User> doGet() {
        List<leave__c> listLeave = new List<leave__c>();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String emailId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('emailId'+emailId);
        List<User> listUser = [select id,name,Email,Total_vacation_days__c from User where Email =: emailId];
        return listUser;
    }
}