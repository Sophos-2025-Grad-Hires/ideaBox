@isTest(isParallel=true)
public class AccountShareSelectorTest {

    private static final String ACCOUNT_NAME = 'Test Name';
    private static final String ACCOUNT_RECORD_TYPE_DEV_NAME = 'Partner';
    private static String accessLevelRead = 'Read';
    private static String accessLevelNone = 'None';
    private static String rowCauseManual = 'Manual';

	@testSetup
    private static void setupData(){
        sutil_AutomationBypassActivator.enableAutomationBypassSetting();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{Account.sObjectType});
		Account accountRecord = new svc_AccountBuilder()
            					.withName(ACCOUNT_NAME)
								.withRecordTypeName(ACCOUNT_RECORD_TYPE_DEV_NAME)
								.buildNew();
        uow.registerNew(accountRecord);
        uow.commitWork();
        sutil_AutomationBypassActivator.disableAutomationBypassSetting();
    }

    @isTest
    public static void selectByAccUsrOrGrpAndAccess_shouldReturnAccountShare_whenRecordIsExisting() {

        Account accountRecord = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME LIMIT 1];
		Group groupRecord = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Organization' LIMIT 1];
		getAccountShareRecord(accountRecord.Id, groupRecord.Id);
        Test.startTest();
        	List<AccountShare> result = new AccountShareSelector().selectByAccUsrOrGrpAndAccess(new Set<Id>{accountRecord.Id},
            new Set<Id>{groupRecord.Id}, accessLevelRead, accessLevelNone, rowCauseManual);
        Test.stopTest();
        Assert.areEqual(accountRecord.Id, result[0].AccountId, 'AccountShare retrieved is incorrect');
    }

    public static void getAccountShareRecord(Id testAccountId, Id testGroupId) {
        AccountShare accountShareRecord = new AccountShare(AccountId = testAccountId, UserOrGroupId = testGroupId, 
                AccountAccessLevel = accessLevelRead, OpportunityAccessLevel = accessLevelNone, RowCause = rowCauseManual);
        insert accountShareRecord;
    }
}