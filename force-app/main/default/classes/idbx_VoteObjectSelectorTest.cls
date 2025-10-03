@IsTest
private class idbx_VoteObjectSelectorTest {

    @IsTest
    static void testGetScore() {
        // Create required scorecard
        idbx_IdeaBox_Scorecard__c scorecard = new idbx_IdeaBox_Scorecard__c(Name = 'Test Scorecard');
        insert scorecard;

        // Create idea with valid fields
        idbx_Idea__c idea = new idbx_Idea__c(
            Name = 'Valid Title',
            idbx_Description__c = 'This is a valid description.',
            idbx_IdeaBox_Scorecard__c = scorecard.Id
        );
        insert idea;

        // Create related vote
        idbx_Vote__c vote = new idbx_Vote__c(
            idbx_Idea__c = idea.Id,
            idbx_User__c = UserInfo.getUserId(),
            idbx_Type__c = 'Upvote'
        );
        insert vote;

        // Re-query idea to get roll-up value
        idea = [SELECT idbx_Idea_Points__c FROM idbx_Idea__c WHERE Id = :idea.Id];

        Test.startTest();
        Integer score = idbx_VoteObjectSelector.getScore(idea.Id);
        Test.stopTest();

        System.assertNotEquals(null, score, 'Score should be calculated from roll-up');
    }

    @IsTest
    static void testGetCurrentButtonStatusWithVote() {
        idbx_IdeaBox_Scorecard__c scorecard = new idbx_IdeaBox_Scorecard__c(Name = 'Scorecard Vote');
        insert scorecard;

        idbx_Idea__c idea = new idbx_Idea__c(
            Name = 'Idea WithVote',
            idbx_Description__c = 'Description long enough to pass.',
            idbx_IdeaBox_Scorecard__c = scorecard.Id
        );
        insert idea;

        idbx_Vote__c vote = new idbx_Vote__c(
            idbx_Idea__c = idea.Id,
            idbx_User__c = UserInfo.getUserId(),
            idbx_Type__c = 'Upvote'
        );
        insert vote;

        Test.startTest();
        String status = idbx_VoteObjectSelector.getCurrentButtonStatus(idea.Id);
        Test.stopTest();

        System.assertEquals('Upvote', status, 'Should return the vote type');
    }

    @IsTest
    static void testGetCurrentButtonStatusWithoutVote() {
        idbx_IdeaBox_Scorecard__c scorecard = new idbx_IdeaBox_Scorecard__c(Name = 'Scorecard NoVote');
        insert scorecard;

        idbx_Idea__c idea = new idbx_Idea__c(
            Name = 'Idea NoVote',
            idbx_Description__c = 'This description is valid.',
            idbx_IdeaBox_Scorecard__c = scorecard.Id
        );
        insert idea;

        Test.startTest();
        String status = idbx_VoteObjectSelector.getCurrentButtonStatus(idea.Id);
        Test.stopTest();

        System.assertEquals(null, status, 'Should return null when no vote exists');
    }

    @IsTest
    static void testVoteInsert() {
        idbx_IdeaBox_Scorecard__c scorecard = new idbx_IdeaBox_Scorecard__c(Name = 'Scorecard Insert');
        insert scorecard;

        idbx_Idea__c idea = new idbx_Idea__c(
            Name = 'Insert Vote',
            idbx_Description__c = 'This description is long enough.',
            idbx_IdeaBox_Scorecard__c = scorecard.Id
        );
        insert idea;

        Test.startTest();
        idbx_VoteObjectSelector.vote(idea.Id, 'Downvote');
        Test.stopTest();

        List<idbx_Vote__c> votes = [SELECT idbx_Type__c FROM idbx_Vote__c WHERE idbx_Idea__c = :idea.Id AND idbx_User__c = :UserInfo.getUserId()];
        System.assertEquals(1, votes.size(), 'One vote should be inserted');
        System.assertEquals('Downvote', votes[0].idbx_Type__c, 'Vote type should match');
    }

    @IsTest
    static void testVoteUpdate() {
        idbx_IdeaBox_Scorecard__c scorecard = new idbx_IdeaBox_Scorecard__c(Name = 'Scorecard Update');
        insert scorecard;

        idbx_Idea__c idea = new idbx_Idea__c(
            Name = 'Update Vote',
            idbx_Description__c = 'Another valid description here.',
            idbx_IdeaBox_Scorecard__c = scorecard.Id
        );
        insert idea;

        idbx_Vote__c vote = new idbx_Vote__c(
            idbx_Idea__c = idea.Id,
            idbx_User__c = UserInfo.getUserId(),
            idbx_Type__c = 'Upvote'
        );
        insert vote;

        Test.startTest();
        idbx_VoteObjectSelector.vote(idea.Id, 'Downvote');
        Test.stopTest();

        idbx_Vote__c updatedVote = [SELECT idbx_Type__c FROM idbx_Vote__c WHERE Id = :vote.Id];
        System.assertEquals('Downvote', updatedVote.idbx_Type__c, 'Vote type should be updated');
    }
}