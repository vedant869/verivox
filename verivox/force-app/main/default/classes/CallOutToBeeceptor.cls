public with sharing class CallOutToBeeceptor {
    public CallOutToBeeceptor() {

    }
    @Future(callout=true)
    public static void sendUserData(String leaveRecord) {
        try {
            Leave__c leave = [SELECT Id, name, Current_Available_Vacation_Days__c FROM Leave__c WHERE Id =: leaveRecord];
            // Create a new HTTP request
            String Body = String.valueOf(leave);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:beeceptor/*');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(Body);

            // Create an HTTP object to send the request
            Http http = new Http();
            // Send the request and receive the response
            HttpResponse res = http.send(req);

            // Handle the response
            if (res.getStatusCode() == 200) {
                // Process the response, e.g., parse the JSON response
                String responseBody = res.getBody();
                System.debug('Response: ' + responseBody);
            } else {
                System.debug('Error: ' + res.getStatus());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
}