public with sharing class idbx_VoteObjectSelector {

    @AuraEnabled
    public static Integer getScore(String recordId) {
        // Null check to avoid NullPointerException if record doesn't exist or field is null
        idbx_Idea__c ideaRecord = [SELECT idbx_Idea_Points__c FROM idbx_Idea__c WHERE Id = :recordId LIMIT 1];
        if (ideaRecord != null && ideaRecord.idbx_Idea_Points__c != null) {
            return Integer.valueOf(ideaRecord.idbx_Idea_Points__c);
        }
        return 0; // Default score if not found or null
    }

    @AuraEnabled
    public static String getCurrentButtonStatus(String recordId) {
        List<idbx_Vote__c> ideaVoteList = getUserVoteForIdea(recordId);
        if (!ideaVoteList.isEmpty()) {
            return ideaVoteList[0].idbx_Type__c;
        }
        return null;
    }

    @AuraEnabled
    public static void vote(String recordId, String voteType) {
        List<idbx_Vote__c> ideaVoteList = getUserVoteForIdea(recordId);
        if (!ideaVoteList.isEmpty()) {
            ideaVoteList[0].idbx_Type__c = voteType;
            update ideaVoteList;
        } else {
            idbx_Vote__c newVote = new idbx_Vote__c(
                idbx_Idea__c = recordId,
                idbx_User__c = UserInfo.getUserId(),
                idbx_Type__c = voteType
            );
            insert newVote;
        }
    }

    private static List<idbx_Vote__c> getUserVoteForIdea(String recordId) {
        return [SELECT idbx_Type__c FROM idbx_Vote__c WHERE idbx_Idea__c = :recordId AND idbx_User__c = :UserInfo.getUserId()];
    }
}