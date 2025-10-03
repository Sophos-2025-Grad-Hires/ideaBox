public with sharing class idbx_VoteObjectSelector {
    @AuraEnabled
    public static Integer getScore(String recordId) {
        return (Integer)[SELECT idbx_Idea_Points__c FROM idbx_Idea__c  WHERE Id = :recordId].idbx_Idea_Points__c;
    }
    @AuraEnabled
    public static String getCurrentButtonStatus(String recordId) {
        List<idbx_Vote__c > ideaVoteList = [SELECT idbx_Type__c  FROM idbx_Vote__c  WHERE idbx_Idea__c  = :recordId AND idbx_User__c = :UserInfo.getUserId()];
        if (ideaVoteList.size() > 0){
            return ideaVoteList[0].idbx_Type__c ;
        }
        return null;
    }
    @AuraEnabled
    public static void vote(String recordId, String voteType){
        List<idbx_Vote__c > ideaVoteList = [SELECT idbx_Type__c  FROM idbx_Vote__c  WHERE idbx_Idea__c  = :recordId AND idbx_User__c = :UserInfo.getUserId()];
        if (ideaVoteList.size() > 0){
            ideaVoteList[0].idbx_Type__c  = voteType;
            update ideaVoteList;
        }
        else{
            idbx_Vote__c  newOppVote = new idbx_Vote__c (
                idbx_Idea__c = recordId,
                idbx_User__c = UserInfo.getUserId(),
                idbx_Type__c  = voteType
            );
            insert newOppVote;
        }
    }
}

    