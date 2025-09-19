/**
 * Used to define methods to query Contact Object (implements Object Selector Pattern for Contact object)
 * Extends fflib_SobjectSelector
 */
public without sharing class ContactSelector extends fflib_SObjectSelector implements IContactSelector {

    private static final String ACCOUNT_NAME = 'Account.Name';
    private static final String ID_IN_RECORDIDS = 'Id IN :recordIds';

    /**
     * Method to return Contact sObjectType
     * @return Schema.SObjectType of Contact
     */
    public Schema.SObjectType getSObjectType() {
        return Contact.sObjectType;
    }

    /**
     * Method to return fields of Contact
     * @return List of Schema.SObjectField of Contact to be queried
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Contact.AccountId,
            Contact.Email,
            Contact.Fax,
            Contact.FirstName,
            Contact.GCLID__c,
            Contact.Id,
            Contact.LastName,
            Contact.LeadSource__c,
            Contact.MailingAddress,
            Contact.MailingCity,
            Contact.MailingCountry,
            Contact.MailingCountryCode,
            Contact.MailingPostalCode,
            Contact.MailingState,
            Contact.MailingStateCode,
            Contact.MailingStreet,
            Contact.MiddleName,
            Contact.MobilePhone,
            Contact.Name,
            Contact.OwnerId,
            Contact.Phone,
            Contact.RecordTypeId,
            Contact.Salutation,
            Contact.Suffix,
            Contact.Title,
            Contact.l2a_Active_Contact__c,
            Contact.l2a_Cancel_Online_Orders__c,
            Contact.l2a_Central_Partner_Dashboard_Primary__c,
            Contact.l2a_Lead_Id__c,
            Contact.l2a_Contact_Status__c,
            Contact.l2a_ContinuouslyScreened__c,
            contact.l2a_Cloud_Partner_Dashboard_Access__c,
            Contact.l2a_Job_Role__c,
            Contact.l2a_Last_Compliance_Check_Date__c,
            Contact.l2a_Last_Compliance_Check_Status__c,
            Contact.l2a_LC_Funnel_Stage__c,
            Contact.l2a_LC_MQL_Start_Date__c,
            Contact.l2a_LC_Status_Reason__c,
            Contact.l2a_Locale_Language_Code__c,
            Contact.l2a_Mailing_County__c,
            Contact.l2a_Mailing_Country__c,
            Contact.l2a_MDFIncentiveAppRole__c,
            Contact.l2a_MDF_Requestor__c,
            Contact.l2a_Partner_Portal_Active__c,
            Contact.l2a_Place_Online_Orders__c,
            Contact.l2a_Potential_Duplicate__c,
            Contact.l2a_Source_System__c,
            Contact.l2a_SSO_Groups__c,
            Contact.l2a_Track_Online_Orders__c,
            Contact.l2a_UUID__c,
			Contact.l2a_Matching_Rule_Filter__c,
			COntact.l2a_Matching_Rule_Formula__c,
            Contact.svc_Sync_External_Id__c,
            Contact.l2a_LC_SAL_Start_Date__c,
            Contact.l2a_LC_MQL_Close_Date__c
        };
    }

    /**
     * Method to return a QueryLocator selecting Contact records
     * @return Database.QueryLocator of the query
     */
    public Database.QueryLocator selectContact() {
        return Database.getQueryLocator(newQueryFactory().toSOQL());
    }

    /**
     * Selects Contacts by Emails
     * @param Email to be used as a condition of the SOQL
     * @return List of Contacts
     */
    public List<Contact> selectByEmail(Set<String> conEmail) {
        List<String> acctFields = new List<String>{ACCOUNT_NAME, 'l2a_Mailing_Country__r.ISO_Code_2__c'};
        return (List<Contact>) Database.query(newQueryFactory().selectFields(acctFields)
                                .setCondition('Email in :conEmail').toSOQL());
    }

    /**
     * Selects Contacts by Email and Account Ids
     *
     * @param Set of Emails
     * @param Set of Account Ids
     * @return List of Contacts
     */
    public List<Contact> selectByEmailAndAccount(Set<String> emailSet, Set<Id> accountIdSet){
        return (List<Contact>) Database.query(newQueryFactory(false)
            .selectFields(new List<SObjectField>{
                Contact.Id,
                Contact.AccountId,
                Contact.Email,
                Contact.RecordTypeId
            })
            .setCondition('Email IN :emailSet AND AccountId IN :accountIdSet')
            .toSOQL());
    }

	/**
     * Method to return a List<Contact> selecting Contact records with additional fields
     * @param recordIds to be used as a condition of the SOQL
     * @return List of the Contact
     */
    public List<Contact> selectByIdWithAccount(Set<Id> recordIds){
        List<String> additionalFieldList = new List<String>{ACCOUNT_NAME, 'l2a_Mailing_Country__r.ISO_Code_2__c'};
        return Database.query(newQueryFactory().setCondition('Id IN :recordIds')
                                .selectFields(additionalFieldList)
                                .setLimit(50000)
                                .toSOQL());
    }

    /**
     * Method to return a QueryLocator selecting Contact records
     * @param Email to be used as a condition of the SOQL
     * @return List of the Contact
     */
    public List<Contact> selectByEmailWithAdditionalFields(String conEmail) {
        // additional fields for svc_FullEmailMatchingStep
		List<String> additionalFields = new List<String>{ACCOUNT_NAME, 'Account.RecordTypeId',
                                                         'Account.RecordType.Name', 'RecordType.Name'};
        return (List<Contact>) Database.query(newQueryFactory().setCondition('Email = :conEmail').selectFields(additionalFields).toSOQL());
    }
    
    /**
     * Method to return a QueryLocator selecting Contact records to be ranked for l2a_MarketingContactUpdateProcess
     * @param Email to be used as a condition of the SOQL
     * @return List of the Contact
     */
    public List<Contact> selectByEmailWithMarketingAutoCalcAdditionalFields(Set<String> conEmail) {
        fflib_QueryFactory contactQueryFactory = newQueryFactory();
        contactQueryFactory.selectFields(setFieldsForMarketingAutomationCalculation()).setCondition('Email in :conEmail').setOrdering('l2a_Contact_Rank_Score__c', fflib_QueryFactory.SortOrder.DESCENDING);
		contactQueryFactory.subSelectQuery('Partner_Orders__r').selectField('Id');
        contactQueryFactory.subSelectQuery('Opportunities').selectField('Id');
        contactQueryFactory.subSelectQuery('OpportunitiesPartnerContact__r').selectField('Id');
        contactQueryFactory.subSelectQuery('Journeys__r').selectField('Id');
		return (List<Contact>) Database.query(String.escapeSingleQuotes(contactQueryFactory.toSOQL()));
    }

    /**
    * Method to set additional relationship fields needed for l2a_MarketingContactUpdateProcess
    * @return List of field names to be queried
    */
	private List<String> setFieldsForMarketingAutomationCalculation() {

        List<String> fieldNames = new List<String>();
        List<Schema.FieldSetMember> fieldSetMemebers = SObjectType.Contact.FieldSets.l2a_Field_Set_for_Marketing_Contact_Calc.getFields();
        for(Schema.FieldSetMember member : fieldSetMemebers) {
            fieldNames.add(member.getFieldPath().toLowerCase());
        }
        fieldNames.add('Account.Type');
        return fieldNames;
    }

    /**
	 * Method to return List<Contact> records by Ids
     * @param Set of recordIds to be used as a condition of the SOQL
     * @return List of Contact records
	 */
    public List<Contact> selectById(Set<Id> recordIds){
        return (List<Contact>) selectSObjectsById(recordIds);
    }

    /**
	 * Method to return a List<Contact> of active Contact records
     * with a certain Account Id
     * @param accountIds to filter the records with
     * @return List of Contact records
	 */
    public List<Contact> selectActiveByAccountId(Set<Id> accountIds) {
        return (List<Contact>) Database.query(newQueryFactory().setCondition('AccountId IN :accountIds AND l2a_Active_Contact__c=TRUE ').addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.ASCENDING).toSOQL());
    }

    /**
     * Method to return a List<Contact> of active Contact records
     * with a certain Account Id and limited record
     * @param accountIds to filter the records with
     * @param maxCount to set the max number of records returned
     * @return List of Contact records
     */
    public List<Contact> selectActiveByAccountIdWithLimit(Set<Id> accountIds, final Integer maxCount) {
        return (List<Contact>) Database.query(newQueryFactory().setCondition('AccountId IN :accountIds AND l2a_Active_Contact__c=TRUE ').setLimit(maxCount).toSOQL());
    }

    /**
     * Method to return List of Contacts filtering by Ids along with additional fields required for NetExam
     * @param contIds Ids to be used as a condition in SOQL
     * @return List of Contacts
     */
    public List<Contact> selectByIdsWithAdditionalAccountFields(Set<Id> contIds) {
        fflib_QueryFactory contactQueryFactory = newQueryFactory();
        fflib_SObjectSelector accountSelector = new AccountSelector();
        accountSelector.configureQueryFactoryFields(contactQueryFactory, 'Account');
        fflib_SObjectSelector userSelector = new UserSelector();
        userSelector.configureQueryFactoryFields(contactQueryFactory, 'Account.Owner');
        contactQueryFactory.setCondition('Id = :contIds');
        return (List<Contact>) Database.query(contactQueryFactory.toSOQL());
    }

    /**
    * Select partner contact authentication detail
    * @param contactEmail the partner contact email
    * @return List<Contact> list of possible contacts with partner email
    */
	public List<Contact> selectPartnerContactByEmail(String contactEmail) {
        String partnerRectype = ContactConstants.CON_REC_TYPE_PARTNER;
        // additional fields for partner fields
		List<String> additionalFields = new List<String>{'l2a_Cancel_Online_Orders__c', 'l2a_MSP_Usage_File_Access__c', 'l2a_Track_Online_Orders__c',
                							            'l2a_Place_Online_Orders__c','l2a_Portal_Access_Type__c', 'l2a_Portal_Admin__c',
                                                        'l2a_Role__c','RecordType.DeveloperName','Account.l2a_Incentive_Participant__c', 'Account.l2a_MDF_Eligible__c',
                                                        'Account.Partner_Type__c', 'Account.l2a_Show_MSP_Pricing_in_Partner_Portal__c',
            								            'Account.l2a_Stock_Approval__c', 'Account.l2a_X2_Tier_Calculation_Enabled__c',
                                                        'Account.Partner_Program_Status__c'};

        return (List<Contact>) Database.query(newQueryFactory().selectFields(additionalFields).setCondition('Email = :contactEmail AND RecordType.DeveloperName = :partnerRectype AND l2a_Active_Contact__c = TRUE')
                                                .addOrdering('l2a_Partner_Portal_Active__c', fflib_QueryFactory.SortOrder.DESCENDING, true).toSOQL());
    }

    /**
    * Select partner contact authentication detail
    * @param contactEmail the partner contact email
    * @return List<Contact> list of possible contacts with partner email
    */
    public List<Contact> selectPartnerContactByEmailAndPartnerType(String contactEmail, Set<String> partnerTypes) {
		String query = newQueryFactory().selectFields(new List<String>{'l2a_Track_Online_Orders__c', 'Account.l2a_Billing_Country__c', 'Account.l2a_Sub_Region__c'})
            			.setCondition('Email = :contactEmail AND l2a_Active_Contact__c = true AND l2a_Partner_Portal_Active__c = true AND Account.Partner_Type__c IN :partnerTypes').toSOQL();
        return (List<Contact>) Database.query(query);
    }

    /**
    * Select partner portal active partner contact using Email matching
    * @param contactEmail the partner contact email
    * @return List<Contact> list of possible Partner contacts that are partner portal active
    */
    public List<Contact> selectPartnerPortalContactByEmail(String contactEmail) {
        String partnerRectype = ContactConstants.CON_REC_TYPE_PARTNER;
		String query = newQueryFactory()
                        .setCondition('RecordType.DeveloperName = :partnerRectype AND Email = :contactEmail AND l2a_Partner_Portal_Active__c = true')
                        .toSOQL();
        return (List<Contact>) Database.query(query);
    }

    /**
    * Get the partner contact partner type and role
    * @param contactId
    * @return Contact contact with matching Id
    */
    public List<Contact> selectPartnerContactTypeAndRoleById(Id contactId) {
        return (List<Contact>) Database.query(newQueryFactory().selectFields(new List<String>{'Account.Partner_Type__c','l2a_Role__c'}).setCondition('Id = :contactId').toSOQL());
    }

    /**
    * Method to return List of Contacts filtering by Ids along with additional fields required for Central Sync
    * @param Set<Id> of contacts to be used as a condition in SOQL
    * @return List of Contacts
    */
    public List<Contact> selectByIdWithAdditionalFields(Set<Id> contIds) {
        fflib_QueryFactory contactQueryFactory = newQueryFactory();
           contactQueryFactory.setCondition('Id = :contIds')
                              .selectFields(setFieldsForCentralSync());

        return (List<Contact>) Database.query(contactQueryFactory.toSOQL());
    }

    /**
	 * Method to return a List<Contact> of Contact records
     * with a certain Account Id
     * @param accountIds to filter the records with
     * @return List of Contact records
	 */
    public List<Contact> selectByAccountId(Set<Id> accountIds) {
        return this.selectByAccountId(accountIds, 50000);
    }

    /**
	* Method to return a List<Contact> of Contact records
    * with a certain Account Id
    * @param accountIds to filter the records with
    * @param itemLimit to the number of records
    * @return List of Contact records
	*/
    public List<Contact> selectByAccountId(Set<Id> accountIds, final Integer itemLimit) {
        return (List<Contact>) Database.query(newQueryFactory().setCondition('AccountId IN :accountIds').setLimit(itemLimit).toSOQL());
    }

    /**
	* Method to return a List<Contact> of Contact records
    * with a certain Account Id
    * @param accountIds to filter the records with
    * @param itemLimit to the number of records
    * @return List of Contact records
	*/
    public List<Contact> selectByAccountId(Set<Id> accountIds, Set<String> fields, final Integer itemLimit) {
        return (List<Contact>) Database.query(newQueryFactory().selectFields(fields).setCondition('AccountId IN :accountIds').setLimit(itemLimit).toSOQL());
    }

   /**
    * Method to set additional relationship fields needed for Central Sync
    * @return List of field names to be queried
    */
	private List<String> setFieldsForCentralSync() {
        return new List<String> {
           ACCOUNT_NAME,
           'Account.Partner_Program_Status__c',
           'Account.Record_Status__c',
           'Account.l2a_Billing_Sub_Region_Formula__c',
           'Account.l2a_MDF_Authorized__c',
           'Account.l2a_UUID__c'
        };
    }

	/**
	 * Search contacts using SOSL given partial contact name and account parent id
	 */
	public List<List<Contact>> searchByNameAndAccountId(String contactName, String parentId){
		String sWildCardText = '%' + String.escapeSingleQuotes(contactName) + '%';

		return [FIND :sWildCardText IN Name FIELDS RETURNING
			Contact (Id, Name, AccountId, Account.Name, Email, Phone,FirstName,LastName WHERE AccountId = :parentId AND l2a_Active_Contact__c = TRUE)];
	}

    /**
	* Search contacts using SOSL given partial contact name and account parent id
    * Used in the custom lookup component
	* @param searchTerm search term
	* @param parentId the parent account id
	* @param itemLimit number of records to be returned
	* @return list of matching contacts
	*/
	public List<Contact> findByNameAndAccountId(String searchTerm, String parentId, final Integer itemLimit) {
		String wildcardTerm = String.escapeSingleQuotes(searchTerm) + '*';
        
        String searchQuery = 'FIND :wildcardTerm IN Name FIELDS RETURNING Contact (Id, Name, AccountId, ' +
                             'Account.Name WHERE AccountId = \'' + String.escapeSingleQuotes(parentId) + '\') LIMIT :itemLimit';
        
        List<List<SObject>> searchResults = search.query(searchQuery);
        
        return (List<Contact>) searchResults.get(0);
	}

    /**
	 * Method to return a List<List<SObject>> which is a List of Contact in usage of this method
     * @param searchString to filter the records in SOSL format
     * @param accArray to use as reference in the searchString
     * @param emailsToExclude to use as reference in the searchString
     * @return List<List<SObject>>
	 */
	public List<List<SObject>> searchRecordsSOSL(String searchString, List<String> accArray,
            List<String> emailsToExclude) {
            String searchquery =
                'FIND\'' +
                String.escapeSingleQuotes(searchString) +
                '\'IN ALL FIELDS RETURNING Contact(id, name, email ' +
                'where email != null AND AccountId IN :accArray AND email NOT IN :emailsToExclude) ' +
                'LIMIT 10';
		return search.query(searchquery);
	}

    /**
	 * Method to return a List<Contact> of active Contact records
     * with a certain Account Id
     * @param accountIds to filter the records with
     * @return List of Contact records
	 */
    public List<Contact> selectContactsForPartner(Set<Id> accountIds, Id contactId) {
        return (List<Contact>) Database.query(newQueryFactory().setCondition('Id != :contactId AND AccountId IN :accountIds AND l2a_Active_Contact__c=TRUE ').toSOQL());
    }

    /**
    * Select partner portal contact matching recordtype
    * @param recordtype developer name and partner account id
    * @return List<Contact>
    */
    public List<Contact> selectPartnerPortalContactByRecordType(String recordtypeName,String partnerAccountId) {
        String query = newQueryFactory()
                        .setCondition('RecordType.DeveloperName = :recordtypeName AND accountId = :partnerAccountId')
                        .toSOQL();
        return (List<Contact>) Database.query(query);
    }

    /**
     * Method to return a List<Contact> used to populate parnter portal distributor contact
     * with a certain Account Id 
     * @param accountIds to filter the records with
     * @param searchString 
     * @return List of Contact records
    **/
    public List<Contact> selectAccountId(Set<Id> accountIds,String searchString) {
        return (List<Contact>) Database.query(newQueryFactory().setCondition('AccountId IN :accountIds AND l2a_Partner_Business_Association__c INCLUDES (\'' +searchString+ '\')').addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING).toSOQL());
    }
    
	/**
     * Method to return a List<Contact> used to populate parnter portal distributor contact
     * with a certain Account Id 
     * @param accountIds to filter the records with
     * @param LastName and Email 
     * @return List of Contact records
    **/
    public List<Contact> searchContactByLastNameEmailAndAccountId(Set<Id> accountIds,String lastName, String email) {
        return (List<Contact>) Database.query(newQueryFactory().setCondition('AccountId IN :accountIds AND LASTNAME =:lastName AND Email =:email').toSOQL());
    }
    
    /** 
    * find quote by Ids with specified fields
	* @param recordIds Set<Id> Contact ids
	* @param fields List<String> additional fields
    */ 
    public List<Contact> selectByIds(Set<Id> recordIds, List<String> fields) {
        return Database.query(newQueryFactory(false).selectFields(fields).setCondition(ID_IN_RECORDIDS).toSOQL());
    }
}