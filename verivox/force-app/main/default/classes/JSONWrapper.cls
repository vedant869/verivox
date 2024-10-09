public with sharing class JSONWrapper {
    public Boolean isReject;
    public String processInstanceWorkItemId;
    public static JSONWrapper parse(String json) {
        return (JSONWrapper) System.JSON.deserialize(json, JSONWrapper.class);
    }
}