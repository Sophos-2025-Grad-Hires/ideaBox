public with sharing class IdeaSelector {
    @AuraEnabled(cacheable=true)
    public static List<idbx_Idea__c> selectAll() {
        return [SELECT Id, Name, idbx_Description__c, idbx_Category__c, idbx_Status__c, CreatedDate, CreatedBy.Name FROM idbx_Idea__c];
    }
}