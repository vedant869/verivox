public with sharing class HandleApprovals {
    public static string vf_emailtemplate = 'Approval Email Template';
    public HandleApprovals() {

    }
    @InvocableMethod(callout=true label='handleApprovals')  
    public static void handleApprovalsFromFlow(List<JSONWrapper> listRecordIdBoolean){

        String processInstanceWorkItemId = listRecordIdBoolean[0].listProcessInstanceWorkItemId;
        Boolean reject = listRecordIdBoolean[0].isReject;
        String leaveRecordId = listRecordIdBoolean[0].leaveRecordId;
        EmailTemplate templateId = [SELECT Id, Name FROM EmailTemplate WHERE Name =: vf_emailtemplate];

        ProcessInstanceWorkitem piw =  [SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE Id =:processInstanceWorkItemId];
        Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();

            req1.setComments('Your request has been approved!');
            if(reject){
                req1.setAction('Reject');
            }else{
                req1.setAction('Approve');
            }
            req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});

            // Use the ID from the newly created item to specify the item to be worked
            req1.setWorkitemId(piw.Id);

            if(!Test.isRunningTest()){
                Approval.ProcessResult result =  Approval.process(req1);
                System.debug('result : '+result);
            }
            if(!reject){
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId.Id, UserInfo.getUserId(), leaveRecordId);
                email.saveAsActivity = false;
                Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
                CallOutToBeeceptor.sendUserData(leaveRecordId);
            }



    }
    public class JSONWrapper{
        @InvocableVariable(required=true)
        public String listProcessInstanceWorkItemId;
        @InvocableVariable(required=true)
        public Boolean isReject;
        @InvocableVariable(required=true)
        public String leaveRecordId;
    }
}