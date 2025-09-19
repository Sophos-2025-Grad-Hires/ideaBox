/**
 * Test class to validate Selector
 * pattern implementation on User object.
 */
@isTest(isParallel=false) //Parallel execution disabled because this class has DML on User Object
private class UserSelectorTest {
    private static final String PARAM_USER_USERNAME = 'userselectortestuser@example.com.invalid';
    
    /**
     * Test method to verify selectByIds() return User records
     */
    @isTest
    private static void selectByIds_ShouldReturnUserRecord_WhenCalled(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( new List<sObjectType>{User.getSObjectType()});
        
        List<Profile> prof = new sutil_ProfileSelector().selectByName(new Set<String>{ProfileAndPermissionsConstants.PROFILE_INTERNAL_USER});
        
        User nUser = UserBuilder.newUser().withRequiredFieldswithGenericProfileAndUsername(prof[0].id, PARAM_USER_USERNAME).buildNew();
        uow.registerNew(nUser);
        
        uow.commitWork();
        
        Test.startTest();
        List<User> userList = new UserSelector().selectByIds(new Set<Id>{nUser.Id});
        Test.stopTest();
        
        Assert.areEqual(PARAM_USER_USERNAME, userList[0].Username, 'User Name should match');
    }
    
    /**
	 * Method to check if selector returns user record based on Ids
	 */
    @isTest
    private static void selectActiveByIds_ShouldReturnUser_WhenOwnerIdIsPassed(){
        AutomationBypassActivator.enableAutomationBypassSetting();
        User userRecord = new User();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( new List<sObjectType>{User.getSObjectType()});
        List<Profile> prof = new sutil_ProfileSelector().selectByName(new Set<String>{ProfileAndPermissionsConstants.PROFILE_INTERNAL_USER});
        User nUser = UserBuilder.newUser().withRequiredFieldswithGenericProfileAndUsername(prof[0].id, PARAM_USER_USERNAME).buildNew();
        uow.registerNew(nUser);
        uow.commitWork();
        AutomationBypassActivator.disableAutomationBypassSetting();
        
        Test.startTest();
        Database.QueryLocator queryLocator = new UserSelector().selectActiveByIds(new Set<Id>{nUser.Id});
        Database.QueryLocatorIterator userIterator = queryLocator.iterator();
        while(userIterator.hasNext()) {
            userRecord = (User)userIterator.next();
        }
        Test.stopTest();
        
        Assert.areEqual(nUser.Id, userRecord.Id, 'User Id should match');
    }
    
    /**
     * Test method to verify selectByName() return User records
     */
    @isTest
    private static void selectByName_ShouldReturnUserRecord_WhenCalledByName(){
        AutomationBypassActivator.enableAutomationBypassSetting();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( new List<sObjectType>{User.getSObjectType()});
        
        List<Profile> prof = new sutil_ProfileSelector().selectByName(new Set<String>{ProfileAndPermissionsConstants.PROFILE_INTERNAL_USER});
        
        User nUser = UserBuilder.newUser().withRequiredFieldswithGenericProfileAndUsername(prof[0].id, PARAM_USER_USERNAME).buildNew();
        uow.registerNew(nUser);
        
        uow.commitWork();
        AutomationBypassActivator.disableAutomationBypassSetting();
        
        Test.startTest();
        List<User> getUserList = new UserSelector().selectByIds(new Set<Id>{nUser.Id});
        List<User> userList = new UserSelector().selectByName(new List<String>{getUserList[0].Name});
        Test.stopTest();
        
        Assert.areEqual(PARAM_USER_USERNAME, userList[0].Username, 'User Name should match');
    }
}