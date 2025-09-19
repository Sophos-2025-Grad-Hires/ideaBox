@isTest(isParallel=true)
private class ContactSelectorTest {
    private static final String PARAM_CON_EMAIL = 'testCon@abc.com';
    private static final String PARAM_ACC_NAME = 'testAcc';
    private static final String ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD = 'Selector should return a record.';

    @testSetup
    private static void setupData(){
        AutomationBypassActivator.enableAutomationBypassSetting();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( new Schema.SObjectType[] {Account.SObjectType, Contact.SObjectType});
        Account acc = AccountBuilder.anAccount().withRequiredFieldsSet()
            .withName(PARAM_ACC_NAME)
            .buildNew();
        uow.registerNew(acc);
        Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
            .withEmail(PARAM_CON_EMAIL)
            .withActiveContact(true)
            .withPartnerPortalActive(true)
            .withRecordType(ContactConstants.CON_REC_TYPE_PARTNER)
            .buildNew();
        con.l2a_Partner_Business_Association__c= 'Leads';
        con.l2a_Portal_Admin__c=true;
        uow.registerNew(con);
        uow.registerRelationship(con, Contact.AccountId, acc);
        uow.commitWork();
        AutomationBypassActivator.disableAutomationBypassSetting();
    }

    @isTest
    private static void selectByName_shouldReturnRecord_whenRecordsExists() {

        ContactBuilder conBuilder = ContactBuilder.aContact().withEmail(PARAM_CON_EMAIL);
        conBuilder.build();

        Test.startTest();
        Set<String> conEmails = new Set<String>();
        conEmails.add(PARAM_CON_EMAIL);
        IContactSelector selector = (IContactSelector) new ContactSelector();
        List<Contact> conList = selector.selectByEmail(conEmails);
        Test.stopTest();

        Assert.isNotNull(conList, ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    @isTest
    private static void selectByEmailAndAccount_shouldReturnRecord(){
        Contact cont = [SELECT Id, AccountId, Email FROM Contact LIMIT 1];

        Test.startTest();
        ContactSelector contSelector = new ContactSelector();
        List<Contact> contList = contSelector.selectByEmailAndAccount(new Set<String>{cont.Email}, new Set<Id>{cont.AccountId});
        Test.stopTest();

        Assert.areEqual(cont.Email, contList[0].Email, 'Contact with invalid Email returned');
        Assert.areEqual(cont.AccountId, contList[0].AccountId, 'Contact with invalid Account Id returned');
    }

    @isTest
    private static void selectByEmailWithAdditionalFields_shouldReturnRecord_whenRecordsExists() {

        ContactBuilder conBuilder = ContactBuilder.aContact().withEmail(PARAM_CON_EMAIL);
        conBuilder.build();

        Test.startTest();
            IContactSelector selector = (IContactSelector) new ContactSelector();
            List<Contact> conList = selector.selectByEmailWithAdditionalFields(PARAM_CON_EMAIL);
        Test.stopTest();

        Assert.areNotEqual(null, conList, ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    @isTest
    private static void selectActiveByAccountId_shouldReturnRecords_whenActiveContactWithRelatedAccountExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
            List<Contact> conList = new ContactSelector().selectActiveByAccountId(new Set<Id>{acc.Id});
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /**
     * used to test building soql query for Con object.
     */
    @isTest
    private static void ContactSelectorTest_shouldReturnFieldList_whenSpecifiedSObjectFields() {
        Test.startTest();
        ContactSelector selector = new ContactSelector();
        fflib_QueryFactory contactQueryFactory= selector.newQueryFactory();
        Test.stopTest();
        Assert.isTrue(contactQueryFactory!=null,'Error in initializing Contact Query Factory');
        Assert.isTrue(contactQueryFactory.toSOQL().containsIgnoreCase('from Contact'),'SOQL generated is incorrect');
    }

    @isTest
    private static void selectByPartnerEmail_ShouldReturnContact_whenRecordExists() {
        Test.startTest();
        IContactSelector selector = (IContactSelector) new ContactSelector();
        List<Contact> conList = selector.selectPartnerContactByEmail(PARAM_CON_EMAIL);
        Test.stopTest();
        Assert.isNotNull(conList, ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
        Assert.areEqual(conList[0].RecordType.DeveloperName, ContactConstants.CON_REC_TYPE_PARTNER , 'Should return a Contact with Partner Record Type');
    }

    @isTest
    private static void selectPartnerPortalContactByEmail_ShouldReturnContact_whenRecordExists() {
        Test.startTest();
        IContactSelector selector = (IContactSelector) new ContactSelector();
        List<Contact> conList = selector.selectPartnerPortalContactByEmail(PARAM_CON_EMAIL);
        Test.stopTest();

        Assert.isFalse(conList.isEmpty(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    @isTest
    private static void selectByAccountId_shouldReturnRecords_whenContactWithRelatedAccountExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
            List<Contact> conList = new ContactSelector().selectByAccountId(new Set<Id>{acc.Id});
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    @isTest
    private static void selectByIdWithAccount_shouldReturnRecords_whenContactExists() {
	    Test.startTest();
            IContactSelector contactSelector = (IContactSelector) new ContactSelector();
            Contact conRec = contactSelector.selectByEmail(new Set<String>{PARAM_CON_EMAIL})[0];
            List<Contact> conRecords = contactSelector.selectByIdWithAccount(new Set<Id> {conRec.Id});
        Test.stopTest();

        Assert.areEqual(1, conRecords.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    @isTest
    private static void searchRecordsSOSL_shouldReturnRecords() {
        Test.startTest();
        IContactSelector contactSelector = (IContactSelector) new ContactSelector();
        Contact conRec = contactSelector.selectByEmail(new Set<String>{PARAM_CON_EMAIL})[0];
        Id [] fixedSearchResults= new Id[]{conRec.Id};
        Test.setFixedSearchResults(fixedSearchResults);
        List<List<SObject>> contactData = contactSelector.searchRecordsSOSL(
                PARAM_CON_EMAIL, new List<String>{conRec.AccountId}, new List<String>());
        Test.stopTest();

        Assert.areEqual(1, contactData[0].size(), 'Contact should be returned');
    }

    @isTest
    private static void selectByEmailWithMarketingAutoCalcAdditionalFields_shouldReturnRecord_whenRecordsExists() {
        Test.startTest();
        IContactSelector selector = (IContactSelector) new ContactSelector();
        List<Contact> conList = selector.selectByEmailWithMarketingAutoCalcAdditionalFields(new Set<String>{PARAM_CON_EMAIL});
        Test.stopTest();

        Assert.isFalse(conList.isEmpty(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    @isTest
    private static void selectActiveByAccountIdWithLimit_shouldReturnRecords_whenContactWithRelatedAccountExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
            List<Contact> conList = new ContactSelector().selectActiveByAccountIdWithLimit(new Set<Id>{acc.Id}, 1);
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /*
    * Test to see if it returns List<Contact> of active Contact records for selectContactsForPartner
    */
    @isTest
    private static void selectContactsForPartner_shouldReturnRecords_whenContactWithRelatedAccountExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
        List<Contact> conList = new ContactSelector().selectContactsForPartner(new Set<Id>{acc.Id},fflib_IDGenerator.generate(Contact.SObjectType));
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /*
    * Test to see if it returns partner portal contact matching recordtype for selectPartnerPortalContactByRecordType
    */
    @isTest
    private static void selectPartnerPortalContactByRecordType_shouldReturnRecords_whenContactExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
        List<Contact> conList = new ContactSelector().selectPartnerPortalContactByRecordType(ContactConstants.CON_REC_TYPE_PARTNER,acc.Id);
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /*
	* Test method for selectAccountId
	*/
    @isTest
    private static void selectAccountId_shouldReturnRecords_whenContactExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
        List<Contact> conList = new ContactSelector().selectAccountId(new Set<Id>{acc.Id},'Leads');
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /*
	* Test method for searchContactByLastNameEmailAndAccountId
	*/
    @isTest
    private static void searchContactByLastNameEmailAndAccountId_shouldReturnRecords_whenContactExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
        List<Contact> conList = new ContactSelector().searchContactByLastNameEmailAndAccountId(new Set<Id>{acc.Id},ContactConstants.CONTACT_LASTNAME,PARAM_CON_EMAIL);
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /*
	* Test method for selectPartnerContactTypeAndRoleById
	*/
    @isTest
    private static void selectPartnerContactTypeAndRoleById_shouldReturnRecords_whenContactExists() {
        IContactSelector contactSelector = (IContactSelector) new ContactSelector();
        Contact conRec = contactSelector.selectByEmail(new Set<String>{PARAM_CON_EMAIL})[0];

        Test.startTest();
        List<Contact> conList = new ContactSelector().selectPartnerContactTypeAndRoleById(conRec.Id);
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }

    /*
	* Test method for selectByIdWithAdditionalFields
	*/
    @isTest
    private static void selectByIdWithAdditionalFields_shouldReturnRecords_whenContactExists() {
        IContactSelector contactSelector = (IContactSelector) new ContactSelector();
        Contact conRec = contactSelector.selectByEmail(new Set<String>{PARAM_CON_EMAIL})[0];

        Test.startTest();
        List<Contact> conList = new ContactSelector().selectByIdWithAdditionalFields(new Set<Id>{conRec.Id});
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }
    
    /*
	* Test method for searchByNameAndAccountId
	*/
    @isTest
    private static void searchByNameAndAccountId_shouldReturnRecords_whenContactExists() {
        Account acc = new AccountSelector().selectByName(new Set<String>{PARAM_ACC_NAME})[0];

        Test.startTest();
        List<List<Contact>> conList = new ContactSelector().searchByNameAndAccountId(ContactConstants.CONTACT_LASTNAME,acc.Id);
        Test.stopTest();

        Assert.areEqual(1, conList.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
    }
    
    /**
     * Method to check if selector is returning account for selectByIds() method
     */
    @isTest
    private static void selectByIds_shouldReturnRecord_whenRecordExists() {
        Test.startTest();
            ContactSelector contactSelector = new ContactSelector();
            Contact conRec = contactSelector.selectByEmail(new Set<String>{PARAM_CON_EMAIL})[0]; 
            List<Contact> conRecords = contactSelector.selectByIds(new Set<Id> {conRec.Id}, new List<String>{'Id'});
        Test.stopTest();
        
        Assert.areEqual(1, conRecords.size(), ASSERT_MESSAGE_SHOULD_RETURN_A_RECORD);
        
    }
}