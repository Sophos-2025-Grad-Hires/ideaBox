@isTest(isParallel=true)
public class ContactBuilderTest {
    private static final String PARAM_ACCOUNT_NAME_1 = 'Test Account 1';
    private static final String ACCOUNT_TYPE_PARTNER = 'Partner';
    private static final String PARAM_EMAIL = 'xyz@abc.com';
    private static final String PARAM_LNAME = 'abcd';
    private static final String PARAM_FNAME = 'test';
    private static final String PARAM_PHONE = '1234567890';
    private static final String PARAM_STREET = '101 Luis Street';
    private static final String PARAM_CITY = 'Albany';
    private static final String PARAM_STATE = 'New York';
    private static final String PARAM_COUNTRY = 'United States of America';
    private static final String PARAM_POSTAL_CODE = '12203';
    private static final String PARAM_COUNTRY_CODE = 'US';
    private static final String PARAM_SOURCE ='Sophos_Central';
    private static final String PARAM_UUID = 'contUUID';
    private static final String PARAM_SSO_GROUPS = 'Sophos';
    private static final String PARAM_JOB_ROLE = 'IT Director/Manager';
    private static final String PARAM_LANGUAGE = 'FR';

    @testSetup
    private static void setupData(){
        AutomationBypassActivator.enableAutomationBypassSetting();
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork( new Schema.SObjectType[] {Account.SObjectType});
        Account acc = AccountBuilder.anAccount().withRequiredFieldsSet().withName(PARAM_ACCOUNT_NAME_1).withType(ACCOUNT_TYPE_PARTNER).buildNew();
        uow.registerNew(acc);
        uow.commitWork();
        AutomationBypassActivator.disableAutomationBypassSetting();
    }
    /**
     * Tests that withRequiredFields() sets pre-defined fields to acceptable values.
    */
    @isTest
    private static void contactBuilder_shouldPopulateRequiredFields(){
        Test.startTest();
        Contact con = ContactBuilder.aContact().withRequiredFieldsSet().buildNew();
        Test.stopTest();

        System.assertEquals(ContactBuilder.CONTACT_EMAIL, con.Email, 'Email should be ' + ContactBuilder.CONTACT_EMAIL);
        System.assertEquals(ContactConstants.CONTACT_FIRSTNAME, con.FirstName, 'FirstName should be ' + ContactConstants.CONTACT_FIRSTNAME);
        System.assertEquals(ContactConstants.CONTACT_LASTNAME, con.LastName, 'LastName should be ' + ContactConstants.CONTACT_LASTNAME);
    }

    /**
     * Tests that withAccountId() sets AccountId field.
    */
    @isTest
    private static void withAccountId_shouldPopulateAccountId(){
        Test.startTest();
        Contact con = ContactBuilder.aContact().withEmail(PARAM_EMAIL).buildNew();
        Test.stopTest();

        System.assertEquals(PARAM_EMAIL, con.Email, 'Invalid Email Address');
    }

    /**
     * Tests that withRenewalQuoted() sets SBQQ__RenewalQuoted__c field.
    */
    @isTest
    private static void withRenewalQuoted_shouldPopulateField(){
        IAccountSelector accSelector = (IAccountSelector) new AccountSelector();
        List<Account> accList = accSelector.selectByName(new Set<String>{PARAM_ACCOUNT_NAME_1});

        Test.startTest();
        Contact con = ContactBuilder.aContact()
        .withFirstName(PARAM_FNAME).withLastName(PARAM_LNAME)
        .withActiveContact(true).withPhone(PARAM_PHONE)
        .withMobilePhone(PARAM_PHONE).withAccount(accList[0])
        .withCancelOnlineOrders(true).withPlaceOnlineOrders(true)
        .withTrackOnlineOrders(true).withMDFRequestor(true)
        .withContactCreatedFromLead(true)
        .withAccountId(accList[0].Id).buildNew();
        Test.stopTest();

        System.assertEquals(PARAM_FNAME, con.FirstName, 'FirstName should be Last name of the contact');
        System.assertEquals(PARAM_LNAME, con.LastName, 'LastName should be Last name of the contact');
        System.assertEquals(true, con.l2a_Active_Contact__c, 'Contact should be Active');
        System.assertEquals(PARAM_PHONE, con.Phone, 'Phone should be '+PARAM_PHONE);
        System.assertEquals(true, con.l2a_Cancel_Online_Orders__c, 'l2a_Cancel_Online_Orders__c should be true');
        System.assertEquals(true, con.l2a_Place_Online_Orders__c, 'l2a_Place_Online_Orders__c should be true');
        System.assertEquals(true, con.l2a_Track_Online_Orders__c, 'l2a_Track_Online_Orders__c should be true');
        System.assertEquals(true, con.l2a_MDF_Requestor__c, 'l2a_MDF_Requestor__c should be true');
        System.assertEquals(PARAM_PHONE, con.MobilePhone, 'Mobile Phone should be '+PARAM_PHONE);
        System.assertEquals(true, con.l2a_Contact_Created_From_Lead__c, 'l2a_Contact_Created_From_Lead__c should be true');
    }

    /**
     * Tests that withActiveContact() sets l2a_Active_Contact__c field.
    */
    @isTest
    private static void withActiveContact_shouldPopulateField(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withActiveContact(true)
                .buildNew();
        Test.stopTest();

        System.assert(con.l2a_Active_Contact__c, 'Active Contact should be true');
    }

    /**
     * Tests that 'withMailing' Address methods sets their respective fields.
    */
    @isTest
    private static void withMailingMethods_shouldPopulateMailingAddressField(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withUSMailingAddress()
                .buildNew();
        Test.stopTest();

        System.assertEquals(PARAM_STREET, con.MailingStreet, 'MailingStreet should be ' + PARAM_STREET);
        System.assertEquals(PARAM_CITY, con.MailingCity, 'MailingCity should be ' + PARAM_CITY);
        System.assertEquals(PARAM_STATE, con.MailingState, 'MailingState should be ' + PARAM_STATE);
        System.assertEquals(PARAM_COUNTRY, con.MailingCountry, 'MailingCountry should be ' + PARAM_COUNTRY);
        System.assertEquals(PARAM_POSTAL_CODE, con.MailingPostalCode, 'MailingPostalCode should be ' + PARAM_POSTAL_CODE);
        System.assertEquals(PARAM_COUNTRY_CODE, con.MailingCountryCode, 'MailingCountryCode should be ' + PARAM_COUNTRY_CODE);
    }

    /**
     * Tests that withUUID() sets l2a_UUID field.
     */
    @isTest
    private static void withUUID_shouldPopulateField_whenCalled(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withUUID(PARAM_UUID)
                .buildNew();
        Test.stopTest();
        
        System.assertEquals(PARAM_UUID, con.l2a_UUID__c, 'UUID should be ' + PARAM_UUID);
    }

    /**
     * Tests that withSSOGroups() sets l2a_SSO_Groups__c field.
     */
    @isTest
    private static void withSSOGroups_shouldPopulateField_whenCalled(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withSSOGroups(PARAM_SSO_GROUPS)
                .buildNew();
        Test.stopTest();
        
        System.assertEquals(PARAM_SSO_GROUPS, con.l2a_SSO_Groups__c, 'SSO Groups should be ' + PARAM_SSO_GROUPS);
    }

    /**
     * Tests that withCentralPartnerDashboardPrimary() sets l2a_Central_Partner_Dashboard_Primary__c field.
     */
    @isTest
    private static void withCentralPartnerDashboardPrimary_shouldPopulateField_whenCalled(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withCentralPartnerDashboardPrimary(true)
                .buildNew();
        Test.stopTest();
        
        System.assert(con.l2a_Central_Partner_Dashboard_Primary__c, 'Central Partner Dashboard Primary should be true');
    }

    /**
     * Tests that withCloudPartnerDashboardAccess() sets l2a_Cloud_Partner_Dashboard_Access__c field.
     */
    @isTest
    private static void withCloudPartnerDashboardAccess_shouldPopulateField_whenCalled(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withCloudPartnerDashboardAccess(true)
                .buildNew();
        Test.stopTest();
        
        System.assert(con.l2a_Cloud_Partner_Dashboard_Access__c, 'Cloud Partner Dashboard Access should be true');
    }

    /**
     * Tests that withJobRole() sets l2a_Job_Role__c field.
     */
    @isTest
    private static void withJobRole_shouldPopulateField_whenCalled(){
        Test.startTest();
            Contact con = ContactBuilder.aContact().withRequiredFieldsSet()
                .withJobRole(PARAM_JOB_ROLE)
                .buildNew();
        Test.stopTest();
        
        System.assertEquals(PARAM_JOB_ROLE, con.l2a_Job_Role__c, 'Job Role should be ' + PARAM_JOB_ROLE);
    }
    
    /**
     * Tests that one is able to clone one builder into another.
    */
    @isTest
    private static void contactBuilder_shouldCopyFromAnotherBuilder(){
        Test.startTest();
        TestContactBuilder conBuilder = new TestContactBuilder(ContactBuilder.aContact().withRequiredFieldsSet());
        conBuilder.withNewField().build();
        Contact con = conBuilder.record;
        Test.stopTest();

        System.assert(conBuilder.isNewFieldSetSet, 'The new field should be set');
        System.assertNotEquals(null, con, 'record should not be blank');
    }

    private class TestContactBuilder extends ContactBuilder{
        private Boolean isNewFieldSetSet = false;

        public TestContactBuilder(ContactBuilder copyFrom) {
            super(copyFrom);
        }

        public TestContactBuilder withNewField(){
            this.isNewFieldSetSet = true;
            return this;
        }
    }

    /**
     * Tests that withSourceSystem() sets Source System field.
    */
    @isTest
    private static void withSourceSystem_shouldPopulateSourceSystem(){
        Test.startTest();
        Contact con = ContactBuilder.aContact().withSourceSystem(PARAM_SOURCE).buildNew();
        Test.stopTest();

        System.assertEquals(PARAM_SOURCE, con.l2a_Source_System__c, 'Invalid Source System');
    }
    
    /**
     * Tests that withSourceSystem() sets Source System field.
    */
    @isTest
    private static void withPreferredLanguage_shouldPopulateSourceSystem(){
        Test.startTest();
        Contact con = ContactBuilder.aContact().withPreferredLanguage(PARAM_LANGUAGE).buildNew();
        Test.stopTest();

        System.assertEquals(PARAM_LANGUAGE, con.svc_Support_Language_Preference_Written__c, 'Invalid Preferred Language');
    }
}