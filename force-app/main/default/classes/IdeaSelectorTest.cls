@isTest
private class IdeaSelectorTest {
    @isTest
    static void selectAll_shouldReturnIdeas_WhenIdeaRecordsExist() {
        // Arrange
        idbx_Idea__c idea1 = new idbx_Idea__c(
            Name = 'Test Idea 1',
            idbx_Description__c = 'First test idea',
            idbx_Category__c = 'Others',
            idbx_Status__c = 'Open'
        );
        idbx_Idea__c idea2 = new idbx_Idea__c(
            Name = 'Test Idea 2',
            idbx_Description__c = 'Second test idea',
            idbx_Category__c = 'Jira',
            idbx_Status__c = 'Rejected'
        );
        insert new List<idbx_Idea__c>{idea1, idea2};
        
        // Act
        Test.startTest();
        List<idbx_Idea__c> ideas = IdeaSelector.selectAll();
        Test.stopTest();

        // Assert
        System.assertEquals(2, ideas.size(), 'Should return 2 idea records');
        System.assertNotEquals(null, ideas[0].Id, 'Idea should have an Id');
        System.assertNotEquals(null, ideas[0].Name, 'Idea should have a Name');
        System.assertNotEquals(null, ideas[0].idbx_Category__c, 'Idea should have a Category');
        System.assertNotEquals(null, ideas[0].idbx_Status__c, 'Idea should have a Status');
        System.assertNotEquals(null, ideas[0].CreatedDate, 'Idea should have a CreatedDate');
        System.assertNotEquals(null, ideas[0].CreatedBy.Name, 'Idea should have CreatedBy.Name populated');
    }
    
    @isTest
    static void selectAll_shouldReturnEmptyList_WhenNoIdeaRecordsExist() {
        // Act
        Test.startTest();
        List<idbx_Idea__c> ideas = IdeaSelector.selectAll();
        Test.stopTest();
        
        // Assert
        System.assertEquals(0, ideas.size(), 'Should return an empty list when no Idea records exist');
    }
}