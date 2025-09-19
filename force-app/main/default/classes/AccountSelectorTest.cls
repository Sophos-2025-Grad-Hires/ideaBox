@isTest(isParallel=true)
private class AccountSelectorTest {
    private static final String PARAM_ACC_NAME = 'testAcc';
    private static final String PARAM_ACC_SENDER_ID = '12345';
    private static final String PARAM_RECORD_TYPE_PARTNER = 'Partner';
    private static final String PARAM_CONTACT_EMAIL = 'contest@example.com.invalid';
    private static final String LAST_NAME = 'Test Contact';
    private static final String FIRST_NAME = 'Test Contact';
    private static final String ACC_STATUS = 'Active';
    private static final String NFR_PROGRAM_STATUS = 'Active';
    private static final String ACC_TYPE_PARTNER = 'Partner';
    private static final String PARAM_ORDER_NAME = 'Order Name';
    private static final String PARTNER_LEVEL = 'Platinum';
    private static final String PARTNER_PROGRAM_STATUS_APPROVED = 'Approved';
    private static final String PARAM_COUNTRY = 'United States of America';
	private static final String PARAM_REGION = 'North America';
	private static final String PARAM_SUB_REGION = 'USA';
	private static final String PARAM_CURRENCY = 'USD';
	private static final String PARAM_STREET = 'Alm Street';
    private static final String ASSERT_MESSAGE = 'Selector should return an Account';

    @testSetup
    private static void ediMessage_DataSetup() {
        AutomationBypassActivator.enableAutomationBypassSetting();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Account.SObjectType,
                Contact.SObjectType
            }
        );

        Account accRec = AccountBuilder.anAccount()
                                    .withRequiredFieldsSet()
                                    .withName(PARAM_ACC_Name)
                                    .withType(AccountConstants.ACC_TYPE_RESELLER)
                                    .withSenderId(PARAM_ACC_SENDER_ID)
                                    .withSupplierId(PARAM_ACC_SENDER_ID)
                                    .withAccountStatus(ACC_STATUS)
                                    .withNFRProgramStatus(NFR_PROGRAM_STATUS)
                                    .withType(ACC_TYPE_PARTNER)
                                    .withRecordType(PARAM_RECORD_TYPE_PARTNER)
                                    .withPartnerLevel(PARTNER_LEVEL)
                                    .withPartnerProgramStatus(PARTNER_PROGRAM_STATUS_APPROVED)
                                    .withBillingCountryLookup(createCountry().Id)
            						.withShippingStreet(PARAM_STREET)
            						.buildNew();
        uow.registerNew(accRec);
        Contact conRecord = ContactBuilder.aContact()
                                    .withLastName(LAST_NAME)
                                    .withFirstName(FIRST_NAME)
                                    .withEmail(PARAM_CONTACT_EMAIL)
                                    .withAccount(accRec)
                                    .withActiveContact(true)
                                    .buildNew();
        uow.registerNew(conRecord, Contact.AccountId, accRec);
        uow.commitWork();
        createOrder(accRec);
        AutomationBypassActivator.disableAutomationBypassSetting();
    }

    private static Country__c createCountry() {
        fflib_SObjectUnitOfWork uowcountry = new fflib_SObjectUnitOfWork(new List<sObjectType>{ Country__c.getSObjectType() });
        Country__c countryRec = new l2a_CountryBuilder()
            .withName(PARAM_COUNTRY)
            .withRegion(PARAM_REGION)
            .withSubRegion(PARAM_SUB_REGION)
            .withCurrency(PARAM_CURRENCY).buildNew();
        uowcountry.registerNew(countryRec);
        uowcountry.commitWork();
        return countryRec;
    }

    private static void createOrder(Account accRec){
        fflib_SObjectUnitOfWork uow2 = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] {Order.SObjectType });
        Order orderRecord = om_OrderBuilder.anOrder()
            .withRequiredFieldsSet()
            .withAccountId(accRec.Id)
            .withStatus(om_OrderConstants.DRAFT)
            .withTCCheck(false)
            .withName(PARAM_ORDER_NAME)
            .withProvisionedDate(system.today())
            .withEffectiveDate(system.today())
            .buildNew();
        uow2.registerNew(orderRecord, Order.End_User_Account__c, accRec);
        uow2.commitWork();
    }

    @isTest
    private static void selectByName_shouldReturnRecord_whenRecordsExists() {
        Test.startTest();
        Set<String> accNames = new Set<String>();
        accNames.add(PARAM_ACC_Name);
        IAccountSelector selector = (IAccountSelector) new AccountSelector();
        List<Account> accList = selector.selectByName(accNames);
        Test.stopTest();
        Assert.areEqual(1, accList.size(), 'Selector should return a record.');
    }

    @isTest
    private static void selectAccount_withSenderIdExists() {
        Test.startTest();
        IAccountSelector selector = (IAccountSelector) new AccountSelector();
        Set<String> senderIDs = new Set<String>();
        senderIds.add(PARAM_ACC_SENDER_ID);
        List<Account> accList = selector.selectBySenderId(senderIds);
        Test.stopTest();
        Assert.areEqual(PARAM_ACC_SENDER_ID, accList[0].Sender_ID__c, 'Sender Id is incorrect');
    }

    @isTest
    private static void selectAccount_withResellerIdExists() {
        Test.startTest();
        IAccountSelector selector = (IAccountSelector) new AccountSelector();
        Set<String> resellerIDs = new Set<String>();
        resellerIDs.add(PARAM_ACC_SENDER_ID);
        List<Account> accList = selector.selectByResellerId(resellerIDs);
        Test.stopTest();
        Assert.areEqual(PARAM_ACC_SENDER_ID, accList[0].Reseller_Id__c, 'Reseller Id is incorrect');
    }

    @isTest
    private static void selectAccountTest_shouldReturnRecord_whenRecordExists() {
        List<Account> accRecords = new List<Account>();
        Test.startTest();
        IAccountSelector selector = (IAccountSelector) new AccountSelector();
        Database.QueryLocator accountQueryLocator = selector.selectAccount();
        Test.stopTest();
        Database.QueryLocatorIterator accountIterator = accountQueryLocator.iterator();
        while(accountIterator.hasNext()) {
            accRecords.add((Account)accountIterator.next());
        }
        Assert.areEqual(1, accRecords.size(), 'Selector should all Accounts');
	}

    /**
     * Method to check if Database.getQueryLocator is generating query
     * and returning Accounts with active status and NFR status
     */
    @isTest
    private static void selectActiveNFRAccounts_shouldReturnQuery_whenInvoked(){
        List<Account> accRecords = new List<Account>();
        Test.startTest();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        IAccountSelector selector = (IAccountSelector) new AccountSelector();
        Database.QueryLocator accountQueryLocator = selector.selectActiveNFRAccounts(new Set<Id>{acc.Id});
        Test.stopTest();
        Database.QueryLocatorIterator accountIterator = accountQueryLocator.iterator();
        while(accountIterator.hasNext()) {
            accRecords.add((Account)accountIterator.next());
        }
        Assert.areEqual(ACC_STATUS, accRecords[0].Account_Status__c, 'Selector should return active accounts');
        Assert.areEqual(NFR_PROGRAM_STATUS, accRecords[0].NFR_Program_Status__c, 'Selector should return active NFR accounts');
    }

    /**
     * Method to check if selector is returning first created contact associated with Account
     */
    @isTest
    private static void selectByIdWithContact_shouldReturnRecord_whenRecordExists(){
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        Set<String> accName = new Set<String>{PARAM_ACC_NAME};
        List<Account> accRecord = accSelector.selectByName(accName);
        Set<Id> accId = new Set<Id>{accRecord[0].Id};
        List<Account> accList = accSelector.selectByIdWithContact(accId);
        Test.stopTest();

        Boolean isAccountLst = accList != null && !accList.isEmpty() && accList[0].Contacts != null && !accList[0].Contacts.isEmpty() && accList[0].Contacts[0] != null;
        Assert.isTrue(isAccountLst,'Selector should return Contact related to Account');    
    }

    /**
     * Method to check if selector is returning first created contact associated with Account
     */
    @isTest
    private static void selectByIdWithPrimaryContact_shouldReturnRecord_whenRecordExists(){
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByName(new Set<String>{PARAM_ACC_NAME});
        List<Account> accList = accSelector.selectByIdWithPrimaryContact(new Set<Id>{accRecord[0].Id});
        Test.stopTest();

        Boolean isAccountLst = accList != null && !accList.isEmpty() && accList[0] != null;
        Boolean isPrimaryContactExists = accList[0].Contacts != null && accList[0].Contacts.size() == 1;
        Assert.isTrue(isAccountLst, 'Account list should not be null or empty');
        Assert.isTrue(isPrimaryContactExists, 'Selector should return 1 primary Contact related to Account');
    }

    /**
     * Method to check if selector is returning first created contact associated with Account
     */
    @isTest
    private static void selectByContactIdWithPrimaryContact_shouldReturnRecord_whenRecordExists(){
        Test.startTest();
        List<Contact> conRecord = new ContactSelector().selectByEmail(new Set<String>{PARAM_CONTACT_EMAIL});
        List<Account> accList = new AccountSelector().selectByContactIdWithPrimaryContact(new Set<Id>{conRecord[0].Id});
        Test.stopTest();

        Boolean isContactRelatedToAcc = accList[0].Contacts != null && !accList[0].Contacts.isEmpty();
        Boolean accListNotEmpty = accList != null && !accList.isEmpty();
        Assert.isTrue(accListNotEmpty, 'Account list should not be null or empty');
        Assert.isTrue(isContactRelatedToAcc, 'Account should have Contacts');
        Assert.isTrue(accList[0].Contacts[0] != null, 'Selector should return primary Contact related to Account');
    }

     @isTest
    private static void selectAccountsWithActiveContract_shouldReturnRecord_whenRecordExists(){
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        Database.QueryLocator accountQueryLocator = accSelector.selectAccountsWithActiveContract();
        Test.stopTest();
        List<Account> accRecords = new List<Account>();
        Database.QueryLocatorIterator accountIterator = accountQueryLocator.iterator();
        while(accountIterator.hasNext()) {
            accRecords.add((Account)accountIterator.next());
        }
        Assert.areEqual(0, accRecords.size(), 'No account record should be returned');
    }

    /**
     * Method to check if selector is returning account for selectByIdWithAdditionalFields() method
     */
    @isTest
    private static void selectByIdWithAdditionalFields_shouldReturnRecord_whenRecordExists() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByName(new Set<String>{PARAM_ACC_NAME});
        List<Account> accList = accSelector.selectByIdWithAdditionalFields(new Set<Id>{accRecord[0].Id});
        Test.stopTest();
        Boolean orderReturned = accList != null && !accList.isEmpty() && accList[0].Orders != null && !accList[0].Orders.isEmpty() && accList[0].Orders[0] != null;
        Assert.areEqual(1, accList.size(), ASSERT_MESSAGE);
        Assert.isTrue( orderReturned, 'Selector should return Order related to Account');    
    }

    /**
     * Method to check if Database.getQueryLocator is generating query
     * and returning Accounts with same OwnerId
     */
    @isTest
    private static void selectAccountWithoutTeamMemberByOwnerId_shouldReturnQuery_whenInvoked(){
        List<Account> accRecords = new List<Account>();
        Test.startTest();
        IAccountSelector selector = (IAccountSelector) new AccountSelector();
        Database.QueryLocator accountQueryLocator = selector.selectAccountWithoutTeamMemberByOwnerId(new Set<String>{UserInfo.getUserId()}, 1);
        Test.stopTest();
        Database.QueryLocatorIterator accountIterator = accountQueryLocator.iterator();
        while(accountIterator.hasNext()) {
            accRecords.add((Account)accountIterator.next());
        }
        Assert.areEqual(1, accRecords.size(), 'Selector should return account');
    }

    /**
     * Method to check if selector is returning account for selectByNameKey() method
     */
    @isTest
    private static void selectByNameKey_shouldReturnRecord_whenRecordExists() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByNameKey(PARAM_ACC_NAME, 'Reseller');
        Test.stopTest();

        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByNameKey() method
     */
    @isTest
    private static void selectInternalAccountsAndContactsForNFR_shouldReturnInternalNFRAccounts_whenRecordExists() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] {Account.SObjectType});
        AutomationBypassActivator.enableAutomationBypassSetting();
        Account accRec = AccountBuilder.anAccount()
                                    .withRequiredFieldsSet()
                                    .withName('Test NFR Account')
                                    .withNFRProgramStatus(NFR_PROGRAM_STATUS)
                                    .withRecordType('Sophos_Internal')
                                    .buildNew();
        uow.registerNew(accRec);
        uow.commitWork();
        AutomationBypassActivator.disableAutomationBypassSetting();

        Test.startTest();
            AccountSelector accSelector = new AccountSelector();
            List<Account> resultsList = accSelector.selectInternalAccountsAndContactsForNFR();
        Test.stopTest();

        Assert.areEqual(1, resultsList.size(), 'Selector should return Internal NFR Account');
    }

    /**
     * Method to check if selector is returning account for selectByNameKeyAndSubRegion() method
     */
    @isTest
    private static void selectByNameKeyAndSubRegion_shouldReturnRecord_whenRecordExists() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByNameKeyAndSubRegion(PARAM_ACC_NAME, 'Reseller', 'USA');
        Test.stopTest();

        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectAccountbyRecordType() method
     */
    @isTest
    private static void selectAccountbyRecordType_shouldReturnRecord_whenRecordExistsTest() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectAccountbyRecordType(PARAM_RECORD_TYPE_PARTNER);
        accSelector.selectAccountsWithoutSalesNewLogoStartDate(PARAM_RECORD_TYPE_PARTNER);
        Test.stopTest();

        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByNameRegionRecType() method
     */
    @isTest
    private static void selectByNameRegionRecType_shouldReturnRecord_whenRecordExistsTest() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByNameRegionRecType(ACC_TYPE_PARTNER, PARAM_ACC_NAME, PARAM_REGION, PARAM_SUB_REGION);
        Test.stopTest();
        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByNameAndType() method
     */
    @isTest
    private static void selectByNameAndType_shouldReturnRecord_whenRecordExistsTest() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByNameAndType(PARAM_ACC_NAME, AccountConstants.ACC_TYPE_RESELLER, PARAM_REGION, PARAM_SUB_REGION);
        Test.stopTest();
        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByIdWithRequiredFields() method
     */
    @isTest
    private static void selectByIdWithRequiredFields_shouldReturnRecord_whenRecordExistsTest() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRec = accSelector.selectByName(new Set<String>{PARAM_ACC_NAME});
        accSelector.selectById(new Set<Id>{accRec[0].Id});
        accSelector.selectByAccountId(new Set<Id>{accRec[0].Id});
        List<Account> accRecord = accSelector.selectByIdWithRequiredFields(new Set<Id>{accRec[0].Id});
        Test.stopTest();
        Assert.areEqual(PARAM_ACC_NAME, accRecord[0].Name, ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByShippingAddress() method
     */
    @isTest
    private static void selectByShippingAddress_shouldReturnRecord_whenRecordExistsTest() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByShippingAddress(new Set<String>{PARAM_STREET});
        Test.stopTest();
        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for fetchNFRAccountWithNFROpportunityCreated() method
     */
    @isTest
    private static void fetchNFRAccountWithNFROpportunityCreated_shouldReturnNFRRecord_whenRecordExists() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        Database.QueryLocator qlRecord = accSelector.fetchNFRAccountWithNFROpportunityCreated();
        Test.stopTest();
        Assert.isTrue(qlRecord!=null, ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByPartnerLevelAndSubRegionWithPrimaryContact() method
     */
    @isTest
    private static void selectByPartnerLevelAndSubRegionWithPrimaryContact_shouldReturnRecord_whenRecordExists() {
        Test.startTest();
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByPartnerLevelAndSubRegionWithPrimaryContact(PARTNER_LEVEL, PARAM_SUB_REGION);
        Test.stopTest();
        Assert.areEqual(1, accRecord.size(), ASSERT_MESSAGE);
    }

    /**
     * Method to check if selector is returning account for selectByIds() method
     */
    @isTest
    private static void selectByIds_shouldReturnRecord_whenRecordExists() {
        AccountSelector accSelector = new AccountSelector();
        List<Account> accRecord = accSelector.selectByName(new Set<String>{PARAM_ACC_NAME});
        
        Test.startTest();
        List<Account> resultsList = accSelector.selectByIds(new Set<Id>{accRecord[0].Id}, new List<String>{'Id'});
        Test.stopTest();

        Assert.areEqual(1, resultsList.size(), 'Selector should return one Account and mentioned fields');
    }

}