/**
* Used to define methods to query Account Object
* Implements Object Selector Pattern for Account object
* Extends fflib_SobjectSelector and Implements IAccountSelector
*/
public without sharing class AccountSelector extends fflib_SObjectSelector implements IAccountSelector {

    private final Set<String> territoryFields = new Set<String>{'l2a_Territory__r.Name'};
    private static final String CREATEDDATE = 'CreatedDate';
    private static final String CONTACTS_RELATIONSHIP_NAME = 'Contacts';
    private static final String ACTIVE_CONTACT_TRUE_CONDITION = 'l2a_Active_Contact__c = TRUE';
    private static final String APPROVED_STATUS = AccountConstants.PARTNER_PROGRAM_STATUS_APPROVED;
    private static final String ID_IN_RECORDIDS = 'Id IN :recordIds';

    /**
     * Method to return Account sObjectType
     * @return Schema.SObjectType of Account
     */
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    /**
     * Method to return fields of Account
     * @return List of Schema.SObjectField of Account to be queried
     */
    public List<Schema.SObjectField> getSObjectFIeldList() {
        return new List<Schema.SObjectField> {
            Account.AccountNumber,
            Account.Account_Balance__c,
            Account.Account_Status__c,
            Account.BillingAddress,
            Account.BillingCity,
            Account.BillingCountry,
            Account.BillingCountryCode,
            Account.BillingPostalCode,
            Account.BillingState,
            Account.BillingStateCode,
            Account.BillingStreet,
            Account.Credit_Limit__c,
            Account.CSP_Partner_Status__c,
            Account.Delivery_Terms__c,
            Account.Fax,
            Account.Id,
            Account.Industry,
            Account.Industry_Header__c,
            Account.Local_Address__c,
            Account.Local_City__c,
            Account.Local_Country__c,
            Account.Local_Name__c,
            Account.Local_State__c,
            Account.MSP_Partner_Status__c,
            Account.MSP_Sub_Type__c,
            Account.Name,
            Account.NFR_Program_Status__c,
            Account.On_Hold__c,
            Account.On_Hold_Reason__c,
            Account.OwnerId,
            Account.ParentId,
            Account.Partner_Level__c,
            Account.Partner_Type__c,
            Account.Partner_Program_Status__c,
            Account.Partner_T_s_and_C_s_Version__c,
            Account.PDB_Change_License_Wizard__c,
            Account.PDB_Create_New_Monthly_Account__c,
            Account.PDB_Create_Virtual_FW__c,
            Account.PDB_Tenant_Unlink__c,
            Account.PDB_Trial_Creation__c,
            Account.PDB_Update_Billing__c,
            Account.Pending_Balance__c,
            Account.Phone,
            Account.RecordTypeId,
            Account.Record_Status__c,
            Account.l2a_Billing_Region_Formula__c,
            Account.Reseller_ID__c,
            Account.Sector__c,
            Account.Sender_ID__c,
            Account.ShippingAddress,
            Account.ShippingCity,
            Account.ShippingCountry,
            Account.ShippingCountryCode,
            Account.Shipping_Method__c,
            Account.ShippingPostalCode,
            Account.ShippingState,
            Account.ShippingStateCode,
            Account.ShippingStreet,
            Account.Size_of_Company__c,
            Account.Type,
            Account.Website,
            Account.l2a_Account_Created_From_Lead__c,
            Account.l2a_Account_Group__c,
            Account.l2a_Billing_Account__c,
            Account.l2a_Billing_Country_ISO_Formula__c,
            Account.l2a_Billing_Country__c,
            Account.l2a_Billing_Country__r.l2a_Region__c,
            Account.l2a_Billing_Country__r.l2a_Sub_Region__c,
            Account.l2a_Billing_County__c,
            Account.l2a_Billing_Region_Formula__c,
            Account.l2a_Billing_Sub_Region_Formula__c,
            Account.l2a_ContinuouslyScreened__c,
            Account.l2a_Current_ARR__c,
            Account.l2a_Current_MRR__c,
            Account.l2a_CustomerStatus__c,
            Account.l2a_Date_Became_A_Customer__c,
            Account.l2a_Date_Became_Inactive__c,
            Account.l2a_Default_EDI_Message_Contact__c,
            Account.l2a_Default_Time_Zone__c,
            Account.l2a_Is_Billing_Account_At_0__c,
            Account.l2a_Is_Billing_Account_At_20__c,
            Account.l2a_Is_Master_Licensing_Enabled__c,
            Account.l2a_Is_Enterprise_Management_Enabled__c,
            Account.l2a_New_Logo__c,
            Account.l2a_NFR_Auto_Renewal_Rejection_Reason__c,
            Account.l2a_EDI_Account_Number__c,
            Account.l2a_Hierarchy_Level__c,
            Account.l2a_Last_Compliance_Check_Date__c,
            Account.l2a_Last_Compliance_Check_Status__c,
            Account.l2a_MSP_Distributor__c,
            Account.l2a_MSP_Distributor_Margin__c,
            Account.l2a_MSP_Must_use_a_distributor__c,
            Account.l2a_MSP_T_S_And_C_S_Version__c,
            Account.l2a_New_Logo_Checkbox__c,
            Account.l2a_NFR_Auto_Renewal_Eligibility__c,
            Account.l2a_NFR_Auto_Renewal_Rejection_Reason__c,
            Account.l2a_Office__c,
            Account.l2a_Origin__c,
            Account.l2a_Partner_Referral_ID__c,
            Account.l2a_Partner_Sub_Type__c,
            Account.l2a_PO_Required__c,
            Account.l2a_Preferred_Distributor_Date__c,
            Account.l2a_Preferred_Distributor_Link__c,
            Account.l2a_Preferred_Distributor_Status__c,
            Account.l2a_Prevent_Updates_From_Central__c,
            Account.l2a_Sales_New_Logo_StartDate__c,
            Account.l2a_Sales_Organization_Formula__c,
            Account.l2a_Show_MSP_Pricing_in_Partner_Portal__c,
            Account.l2a_Source_System__c,
            Account.l2a_Support_Main_Level__c,
            Account.l2a_Supported_Billing_Types__c,
            Account.l2a_Sync_Message__c,
            Account.l2a_Sync_Status__c,
            Account.l2a_Unique_Account_ID__c,
            Account.l2a_UUID__c,
            Account.l2a_X2_Tier_Calculation_Enabled__c,
            Account.om_Billing_Country_ISO_Code_2__c,
            Account.l2a_Matching_Rule_Formula__c,
            Account.l2a_Matching_Rule_Filter__c,
            Account.l2a_Territory__c,
            Account.l2a_License_Schedule_Email__c,
            Account.l2a_Default_License_Schedule_Deliver_To__c,
            Account.Legacy_ID__c,
            Account.l2a_Partner_Attainment_Billings_USD__c,
            Account.l2a_MDF_Eligible__c
        };
    }

    /**
     * Method to return a QueryLocator selecting all Account records
     * @return Database.QueryLocator of the query
     */
    public Database.QueryLocator selectAccount() {
        return Database.getQueryLocator(newQueryFactory().toSOQL());
    }

    /**
     * Method to return a QueryLocator selecting Account records By Name
     * @param List of Names to be used as a condition of the SOQL
     * @return Database.QueryLocator of the query
     */
    public List<Account> selectByName(Set<String> accName) {
        fflib_QueryFactory queryFactory = newQueryFactory();

        // Include these fields in the query selection in addition to the ones defined in the getSObjectFIeldList method
        queryFactory.selectFields(territoryFields).setCondition('Name in :accName');

        return Database.query(String.escapeSingleQuotes(queryFactory.toSOQL()));
    }

    /**
     * Method to return a List of Accounts filtering by Sender Id
     * @param Set of Sender Ids
     * @return List of Accounts
     */
    public List<Account> selectBySenderId(Set<String> senderId) {
         return Database.query(newQueryFactory().setCondition('Sender_ID__c in :senderId').toSOQL());
    }

    /**
     * Method to return a List of Accounts filtering by Account Type and Reseller Id
     * @param Set of Reseller Ids
     * @return List of Accounts
     */
    public List<Account> selectByResellerId(Set<String> resellerId) {
        Set<String> types = new Set<String>{AccountConstants.ACC_TYPE_RESELLER, AccountConstants.ACC_TYPE_PARTNER};
        return Database.query(newQueryFactory().setCondition('Type IN :types and Reseller_ID__c IN :resellerId').toSOQL());
    }
     /**
     * Method to return a QueryLocator selecting Account records by Shipping Address
     * @param List of shippingAddress to be used as a condition of the SOQL
     * @return Database.QueryLocator of the query
     */
    public List<Account> selectByShippingAddress(Set<String> shippingAddress) {
        return Database.query(newQueryFactory().setCondition('ShippingStreet IN :shippingAddress').toSOQL());
    }

    /**
     * Method to return a QueryLocator selecting Account records by Ids
     * @param List of recordIds to be used as a condition of the SOQL
     * @return Database.QueryLocator of the query
     */
    public List<Account> selectById(Set<Id> recordIds){
        return (List<Account>) selectSObjectsById(recordIds);
    }

    /**
     * Method to return a QueryLocator selecting Account records by Ids
     * @param List of recordIds to be used as a condition of the SOQL
     * @return Database.QueryLocator of the query
     */
    public List<Account> selectByIdWithOpptyQuote(Set<Id> accountIds){
      fflib_QueryFactory query = newQueryFactory();
      query.setCondition('Id IN :accountIds');

      new opp_OpportunitySelector().
            addQueryFactorySubselect(query, 'Opportunities').setLimit( 1 );
      new cpq_SBQQQuoteSelector().
            addQueryFactorySubselect(query, 'SBQQ__Quotes__r').setLimit( 1 );
      return (List<Account>) Database.query( query.toSOQL() );
   }

   /**
     * Method to return a QueryLocator selecting Account records for NFR Batch
     *  @param List of recordIds to be used as a condition of the SOQL
     * @return Database.QueryLocator of the query
     */
    public Database.QueryLocator selectActiveNFRAccounts(Set<Id> accountIds) {
        fflib_QueryFactory query = newQueryFactory();
        return Database.getQueryLocator(query.setCondition('Id IN : accountIds').toSOQL());
    }
	
	/**
     * Method to return a List<Account> selecting Account records 
     * By Account Id
     * @param Set of account Ids to be used as a condition of the SOQL
     * @return List<Account> of the query
     */
    public List<Account> selectByAccountId(Set<Id> accId) {
        fflib_QueryFactory query = newQueryFactory();
        setFields(query);
        return (List<Account>) Database.query( query.setCondition('Id in :accId ').toSOQL() );
    }

    private void setFields(fflib_QueryFactory query){
        query.selectField('l2a_Billing_Country__r.pp_Group__c');
        query.selectField('Partner_Level__c');
        query.selectField('l2a_Partner_Attainment_Billings_USD__c');
    }

    /**
     * Method to return a QueryLocator selecting active NFR Account records of type Partner
     * @return List of Account and related opportunity of type NFR
     */
    public Database.QueryLocator fetchNFRAccountWithNFROpportunityCreated() {
        String acctType = opp_OpportunityConstants.NFR_TYPE;
        String user = AccountConstants.SCHEDULE_USER;
        String status = AccountConstants.ACC_STATUS_ACTIVE;
        String accPartnerType = AccountConstants.ACC_TYPE_PARTNER;
        String recordCreationStatus = cpq_QuoteConstants.SBQQSTATUS_DRAFT;
        String accCondition = 'Account_Status__c =: status AND NFR_Program_Status__c =: status AND Type =: accPartnerType AND NFR_Records_Creation_Status__c =: recordCreationStatus AND Partner_Level__c != null AND ID NOT IN (SELECT AccountId FROM Opportunity WHERE Type =: acctType AND CreatedBy.Name =: user)';
        fflib_QueryFactory querys = newQueryFactory();
        return Database.getQueryLocator(querys.setCondition(accCondition).toSOQL());
    }

    /**
     * Method to return List of Accounts filtering by account Ids along with first created Contact record
     * @param Set of Account Ids to be used as a condition in SOQL
     * @return List of Accounts
     */
    public List<Account> selectByIdWithContact(Set<Id> accIds){
        fflib_QueryFactory accountqueryFactory = newQueryFactory();
        accountqueryFactory.setCondition('Id IN: accIds');
        accountqueryFactory.subSelectQuery(CONTACTS_RELATIONSHIP_NAME)
                           .selectFields(new ContactSelector().getSObjectFieldList())
                           .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.ASCENDING)
                           .setLimit(1);
        return (List<Account>) Database.query(accountqueryFactory.toSOQL());
    }

    /**
     * Method to return List of Accounts filtering by account Ids along with first created active Contact record
     * @param Set of Account Ids to be used as a condition in SOQL
     * @return List of Accounts
     */
    public List<Account> selectByIdWithPrimaryContact(Set<Id> accIds){
        fflib_QueryFactory accountqueryFactory = newQueryFactory();
        accountqueryFactory.setCondition('Id IN: accIds');
        accountqueryFactory.subSelectQuery(CONTACTS_RELATIONSHIP_NAME)
                           .selectFields(new ContactSelector().getSObjectFieldList())
                           .setCondition(ACTIVE_CONTACT_TRUE_CONDITION)
                           .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.ASCENDING)
                           .setLimit(1);
        return (List<Account>) Database.query(accountqueryFactory.toSOQL());
    }

	/*
     * Method to return List of Accounts filtering by Partner Level and Sub-Region
	 * along with first created active Contact record
     */
    public List<Account> selectByPartnerLevelAndSubRegionWithPrimaryContact(String partnerLevel, String subRegion){
        fflib_QueryFactory accountqueryFactory = newQueryFactory(false);
		accountqueryFactory.selectFields(new List<String> {'Id', 'Name', 'Partner_Type__c'})
		                   .setCondition('Partner_Level__c = :partnerLevel AND l2a_Billing_Sub_Region_Formula__c = :subRegion AND Account_Status__c = \'Active\'');
        accountqueryFactory.subSelectQuery(CONTACTS_RELATIONSHIP_NAME)
                           .selectField('Id')
                           .setCondition(ACTIVE_CONTACT_TRUE_CONDITION)
                           .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.ASCENDING)
                           .setLimit(1);
        return (List<Account>) Database.query(accountqueryFactory.toSOQL());
    }

    /**
     * Method to return List of Accounts filtering by contact Ids along with first created active Contact record
     * @param Set of Contact Ids to be used as a condition in SOQL
     * @return List of Accounts
     */
    public List<Account> selectByContactIdWithPrimaryContact(Set<Id> contIds){
        fflib_QueryFactory accountqueryFactory = newQueryFactory();
           accountqueryFactory.setCondition('Id IN (SELECT AccountId FROM Contact WHERE Id IN :contIds)');
           accountqueryFactory.subSelectQuery(CONTACTS_RELATIONSHIP_NAME)
                              .selectFields(new ContactSelector().getSObjectFieldList())
                              .setCondition(ACTIVE_CONTACT_TRUE_CONDITION)
                              .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.ASCENDING)
                              .setLimit(1);
        return (List<Account>) Database.query(accountqueryFactory.toSOQL());
   }

   /**
     * Method to return a QueryLocator selecting Account records of with active Contract
     * @return Database.QueryLocator of the query
     */
    public Database.QueryLocator selectAccountsWithActiveContract() {
        String whereCondition = 'Id IN (SELECT AccountId FROM Contract WHERE Status = \'Activated\') AND RecordType.DeveloperName IN (\'Customer\', \'Partner\')';
        return Database.getQueryLocator(newQueryFactory().setCondition(whereCondition).toSOQL());
    }

     /**
     * Method to return a QueryLocator selecting Account records with empty l2a_Sales_New_Logo_StartDate__c
     * @return Database.QueryLocator of the query
     */
    public Database.QueryLocator selectAccountsWithoutSalesNewLogoStartDate(string recordTypeName) {
        String whereCondition = 'l2a_Sales_New_Logo_StartDate__c = null AND RecordType.DeveloperName =: recordTypeName';
        return Database.getQueryLocator(newQueryFactory().setCondition(whereCondition).toSOQL());
    }

    /**
     * Method to return List of Accounts filtering by Ids along with additional fields required for Central Sync
     * @param Set<Id> of accounts to be used as a condition in SOQL
     * @return List of Accounts
     */
    public List<Account> selectByIdWithAdditionalFields(Set<Id> accIds) {
        Set<String> mspProgramValidStatuses = l2a_MSPLoyaltyConstants.MSP_PROGRAM_SYNC_STATUSES;
        fflib_QueryFactory accountQueryFactory = newQueryFactory();
        accountQueryFactory.setCondition('Id = :accIds')
            .selectFields(setFieldsForCentralSync())
            .subSelectQuery('Orders')
            .setLimit(1);
        new l2a_MSPProgramSelector()
            .addQueryFactorySubselect(accountQueryFactory, 'MSP_Programs__r')
            .setCondition('Loyalty_Status__c IN :mspProgramValidStatuses')
            .setOrdering('l2a_Sales_New_Logo_StartDate__c', fflib_QueryFactory.SortOrder.ASCENDING)
            .addOrdering('Loyalty_Status__c', fflib_QueryFactory.SortOrder.ASCENDING)
            .setLimit(1);
        
        return (List<Account>) Database.query(accountQueryFactory.toSOQL());
    }

    /**
    * Method to return a QueryLocator selecting Account records by OwnerId excluding Accounts with AccountTeamMember.
    * @param List of OwnerId to be used as a condition of the SOQL
    * @param limitCount maximum number of records to be retrieved
    * @return Database.QueryLocator of the query
    */
    public Database.QueryLocator selectAccountWithoutTeamMemberByOwnerId(Set<String> ownerId, Integer limitCount) {
        return Database.getQueryLocator(newQueryFactory().setCondition('OwnerId IN : ownerId AND Id NOT IN (SELECT AccountId FROM AccountTeamMember)').setLimit(limitCount).toSOQL());
    }

    /**
     * Method to return a List of Accounts filtering by name and partner type
     * @param nameKey string used to search for account name
     * @param accType string used to search for account with specific partner type
     * @return List of Accounts
     */
    public List<Account> selectByNameKey(String nameKey, String accType) {
        String condition = 'Name LIKE :nameKey AND Partner_Program_Status__c = :APPROVED_STATUS AND Partner_Type__c = :accType '
                            + 'AND l2a_Billing_Region_Formula__c != null AND Account_Status__c = \'Active\'';
        return Database.query(newQueryFactory()
                .setCondition(condition)
                .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.DESCENDING)
                .setLimit(5)
                .toSOQL());
    }

    /**
    * Method to return a List of Internal Accounts with Contacts for NFR
    * @return List of Accounts
    */
    public List<Account> selectInternalAccountsAndContactsForNFR() {
        fflib_QueryFactory queryFactory = newQueryFactory();
        String condition = 'Recordtype.Name = \''+AccountConstants.ACC_TYPE_SOPHOS_INTERNAL + '\' ' +
                           'AND Name LIKE \'%'+ opp_OpportunityConstants.NFR_TYPE +'%\'';
        queryFactory.selectField('l2a_Billing_Sub_Region_Formula__c');
        queryFactory.setCondition(condition);
        queryFactory.subSelectQuery(CONTACTS_RELATIONSHIP_NAME)
                           .selectFields(new ContactSelector().getSObjectFieldList())
                           .setCondition(ACTIVE_CONTACT_TRUE_CONDITION);
        return (List<Account>) Database.query(queryFactory.toSOQL());
    }


    /**
     * Method to return a List of Accounts filtering by name, partner type and sub-region
     * @param nameKey string used to search for account name
     * @param accType string used to search for account with specific partner type
     * @param accSubRegion string used to search for account with specific sub-region
     * @return List of Accounts
     */
    public List<Account> selectByNameKeyAndSubRegion(String nameKey, String accType, String accSubRegion) {
        String condition = 'Name LIKE :nameKey AND Partner_Program_Status__c = :APPROVED_STATUS AND Partner_Type__c = :accType '
                            + 'AND l2a_Billing_Region_Formula__c != null AND Account_Status__c = \'Active\''
                            + 'AND l2a_Billing_Sub_Region_Formula__c = :accSubRegion';
        return Database.query(newQueryFactory()
                .setCondition(condition)
                .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.DESCENDING)
                .toSOQL());
    }

    /**
    * Find account based on search term (excluding already selectedIds)
    * Used in the custom lookup component
    * @param searchTerm search term
    * @param selectedIds exluded ids
    * @param partnerType the account partner type
    * @param recordLimit the number of records to be returned
    * @return list of accounts - matching the search term
    */
    public List<Account> findByAllFieldsBasedOnPartnerTypeAndExcludedId(String searchTerm, List<String> selectedIds, String partnerType, Integer recordLimit) {
        String wildcardTerm = String.escapeSingleQuotes(searchTerm) + '*';

        List<List<SObject>> searchResults = [FIND :wildcardTerm IN ALL FIELDS RETURNING Account(Id, Name, BillingCity, Account_Status__c
                                             WHERE Partner_Program_Status__c = :APPROVED_STATUS AND Partner_Type__c = :partnerType AND Id NOT IN :selectedIds)
                                             LIMIT :recordLimit];
        return (List<Account>) searchResults.get(0);
    }

    /**
    * Get recently viewed accounts of the user
    * @param recordLimit number of records returned
    * @return list of accounts - recently viewed
    */
    public List<Account> selectRecentlyViewedAccountsByPartnerType(String partnerType, Integer recordLimit) {
        String condition = 'Partner_Program_Status__c = :APPROVED_STATUS AND Partner_Type__c = :partnerType AND LastViewedDate != null';

        return Database.query(newQueryFactory().setCondition(condition)
                              .addOrdering('LastViewedDate', fflib_QueryFactory.SortOrder.DESCENDING)
                              .setLimit(recordLimit).toSOQL());
    }

    /**
     * Method to set additional relationship fields needed for Central Sync
     * @return List of field names to be queried
     */
    private List<String> setFieldsForCentralSync() {
        return new List<String> {
            'Owner.FirstName',
            'Owner.LastName',
            'Owner.Phone',
            'Owner.MobilePhone',
            'RecordType.DeveloperName',
            'l2a_MSP_Distributor__r.l2a_UUID__c',
            'l2a_Partner_Account__c',
            'l2a_Partner_Account__r.l2a_UUID__c'
        };
    }

    /**
     * Method to return a QueryLocator selecting Account records specified record type
     * @return List<Account> of the query
     */
    public List<Account> selectAccountbyRecordType(String recordTypeName) {
        String whereCondition = 'RecordType.DeveloperName =: recordTypeName';
        return (List<Account>) Database.query(newQueryFactory().setCondition(whereCondition).toSOQL());
    }
    /**
     * Selects partner account details querying specific fields required
     * @param recordTypeName specify developer name of account record type
     * @param companyName specify name of account
     * @param accountRegion specify country region
     * @param accountSubRegion specify country sub-region
     * @return List of accounts
     */
    public List<Account> selectByNameRegionRecType(String recordTypeName, String companyName, String accountRegion, String accountSubRegion){
        List<String> acctFields = new List<String>{'Id', 'Name', 'Phone', 'BillingStreet', 'BillingCity', 
        'BillingStateCode', 'BillingPostalCode','BillingCountrycode','Size_of_Company__c','Industry_Header__c'};
        return (List<Account>) Database.query(newQueryFactory(false)
            .selectFields(acctFields)
            .setCondition('RecordType.DeveloperName = :recordTypeName AND Name LIKE :companyName AND l2a_Billing_Country__r.l2a_Region__c = :accountRegion AND l2a_Billing_Country__r.l2a_Sub_Region__c =: accountSubRegion')
            .toSOQL());
    }
     /**
     * Method to return a List of Accounts filtering by name and partner type
     * @param nameKey string used to search for account name
     * @param accType string used to search for account with specific partner type
     * @param accountRegion 
     * @param accountSubRegion 
     * @return List of Accounts
     */
    public List<Account> selectByNameAndType(String nameKey, String accType, String accountRegion, String accountSubRegion) {
        return Database.query(newQueryFactory()
                .setCondition('Name LIKE :nameKey AND Partner_Program_Status__c = \'Approved\' AND Partner_Type__c = :accType AND l2a_Billing_Country__r.l2a_Region__c = :accountRegion AND l2a_Billing_Country__r.l2a_Sub_Region__c =: accountSubRegion')
                .addOrdering(CREATEDDATE, fflib_QueryFactory.SortOrder.DESCENDING)
                .toSOQL());
    }
    
     /**
     * Selects partner account details querying specific fields required
     * @param Set of Id
     * @return List of accounts
     */
    public List<Account> selectByIdWithRequiredFields(Set<Id> accountIdSet){
        List<String> acctFields = new List<String>{'Id','Name','BillingCountry','l2a_Billing_Country__r.l2a_Region__c','l2a_Billing_Country__r.l2a_Sub_Region__c'};
        return (List<Account>) Database.query(newQueryFactory(false)
            .selectFields(acctFields)
            .setCondition('Id IN :accountIdSet')
            .toSOQL());
    }
    /**
     * Method to return a List of Msp partner account
     * @param Set of MSP account Id
     * @return List of Accounts
     */
    public List<Account> selectByMSPAccountId(Set<ID> setAccountId) {
        fflib_QueryFactory accountQueryFactory = newQueryFactory(false);
        accountQueryFactory.selectField('Id')
                        .selectField('l2a_Theater_Text__c');
		return Database.query(accountQueryFactory.setCondition('Id IN :setAccountId').toSOQL());
	}

    /**
     * Method to return List of Accounts filtering by Ids along with additional fields required for Central Sync
     * @param Set<Id> of accounts to be used as a condition in SOQL
     * @return List of Accounts
     */
    public List<Account> selectByIdWithMSPAdditionalFields(Set<Id> accIds) {
        Set<String> mspProgramValidStatuses = l2a_MSPLoyaltyConstants.MSP_PROGRAM_SYNC_STATUSES;
        fflib_QueryFactory accountQueryFactory = newQueryFactory();
        accountQueryFactory.selectField('id')
            .setCondition('Id = :accIds')
            .subSelectQuery('Contracts')
            .selectField('cpq_Zuora_Subscription_Number__c')
            .setCondition('cpq_Opportunity_Type__c = \'MSP\' and status = \'Activated\'')
            .setLimit(1);
        new l2a_MSPProgramSelector()
            .addQueryFactorySubselect(accountQueryFactory, 'MSP_Programs__r')
            .setCondition('Loyalty_Status__c IN :mspProgramValidStatuses')
            .addOrdering('Loyalty_Status__c', fflib_QueryFactory.SortOrder.ASCENDING)
            .setLimit(1);
        return (List<Account>) Database.query(accountQueryFactory.toSOQL());
    }

    /**
    * find quote by Ids with specified fields
	* @param recordIds Set<Id> account ids
	* @param fields List<String> additional fields
    */ 
    public List<Account> selectByIds(Set<Id> recordIds, List<String> fields) {
        return Database.query(newQueryFactory(false).selectFields(fields).setCondition(ID_IN_RECORDIDS).toSOQL());
    }
}