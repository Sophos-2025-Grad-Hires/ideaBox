/*
* Used to define methods to build Contact Object
* Implements Object Builder Pattern for Contact object
* Extends fflib_DomainObjectBuilder
*/

public without sharing virtual class ContactBuilder extends fflib_DomainObjectBuilder {

    public static final String CONTACT_EMAIL =  'abc@xyz.com';

    public ContactBuilder() {
        super(Contact.sObjectType);
    }

    /**
     * Copy Constructor that constructs the Builder class based on the builder specified.
     *
     * @param copyFrom The builder to copy/clone this instance from
     */
    public ContactBuilder(ContactBuilder copyFrom) {
        super(copyFrom);
    }

    /**
     * Creates an existing SObject without issuing DML
     * Wrapper method to base class to allow for casting of specific SObjectType.
     */
    public Contact build() {
        return (Contact) this.build(false);
    }

    /**
     * Creates an New SObject (No Id) without issuing DML
     * Wrapper method to base class to allow for casting of specific SObjectType.
     */
    public Contact buildNew() {
        return (Contact) this.build(true);
    }

    /**
     * Returns Contact SObject associated to this builder
     * Wrapper method to base class to allow for casting of specific SObjectType.
     */
    public Contact record {
        get {
            return (Contact) this.getRecord();
        }
        private set;
    }

    /**
     * Alternative way of instantiating the class.
     */
    public static ContactBuilder aContact() {
        return new ContactBuilder();
    }

    /**
     * Sets required fields.
     */
    public ContactBuilder withRequiredFieldsSet(){
        this.withEmail(CONTACT_EMAIL);
        this.withFirstName(ContactConstants.CONTACT_FIRSTNAME);
        this.withLastName(ContactConstants.CONTACT_LASTNAME);
        return this;
    }

    /**
     * Sets required fields.
     */
    public ContactBuilder withUSMailingAddress(){
        this.withMailingStreet('101 Luis Street');
        this.withMailingCity('Albany');
        this.withMailingState('New York');
        this.withMailingCountry('United States of America');
        this.withMailingPostalCode('12203');
        this.withMailingCountryCode('US');
        return this;
    }

    /**
    * @description Returns a Clone of this instance
    */
    public ContactBuilder but() {
        return new ContactBuilder(this);
    }

    /**
     * Sets Contact's Email.
     */
    public ContactBuilder withEmail(String value) {
        this.set(Contact.Email, value);
        return this;
    }

     /**
     * Sets Contact's Last Name.
     */
    public ContactBuilder withLastName(String value) {
        this.set(Contact.LastName, value);
        return this;
    }

    /**
     * Sets Contact's Account.
     */
    public ContactBuilder withAccount(Account value) {
        this.set(Contact.AccountId, value.Id);
        return this;
    }

    /**
     * Sets Contact's Account by Id.
     */
    public ContactBuilder withAccountId(Id value) {
        this.set(Contact.AccountId, value);
        return this;
    }

    /**
	 * Method to populate the l2a_Last_Compliance_Check_Date__c field of the Contact
	 * @param value defines value of the l2a_Last_Compliance_Check_Date__c
	**/
	public ContactBuilder withLastComplianceCheckDate(Datetime value) {
		this.set(Contact.l2a_Last_Compliance_Check_Date__c, value);
		return this;
	}

    /**
	 * Method to populate the RecordType of the Contact
	 * @param value defines the RecordTypeDeveloperName
	 * @return current instance of ContactBuilder
	 */
	public ContactBuilder withRecordType(String recordTypeDeveloperName){
		this.set(Contact.RecordTypeId, Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName).getRecordTypeId());
		return this;
	}

    /**
     * Sets Contact's First Name.
     */
    public ContactBuilder withFirstName(String value) {
        this.set(Contact.FirstName, value);
        return this;
    }

    /**
    * Sets Contact's Phone.
    */
    public ContactBuilder withPhone(String value) {
        this.set(Contact.Phone, value);
        return this;
    }

    /**
    * Sets Contact's Mobile Phone.
    */
    public ContactBuilder withMobilePhone(String value) {
        this.set(Contact.MobilePhone, value);
        return this;
    }

    /**
    * Sets Contact's Mailing Country.
    */
    public ContactBuilder withMailingCountry(String value) {
        this.set(Contact.MailingCountry, value);
        return this;
    }

    /**
    * Sets Contact's Mailing Street.
    */
    public ContactBuilder withMailingStreet(String value) {
        this.set(Contact.MailingStreet, value);
        return this;
    }

    /**
    * Sets Contact's Mailing City.
    */
    public ContactBuilder withMailingCity(String value) {
        this.set(Contact.MailingCity, value);
        return this;
    }

    /**
    * Sets Contact's Mailing State.
    */
    public ContactBuilder withMailingState(String value) {
        this.set(Contact.MailingState, value);
        return this;
    }

    /**
    * Sets Contact's Mailing PostalCode.
    */
    public ContactBuilder withMailingPostalCode(String value) {
        this.set(Contact.MailingPostalCode, value);
        return this;
    }

    /**
    * Sets Contact's Mailing CountryCode.
    */
    public ContactBuilder withMailingCountryCode(String value) {
        this.set(Contact.MailingCountryCode, value);
        return this;
    }

    /**
    * Sets Contact's Active Contact.
    */
    public ContactBuilder withActiveContact(Boolean value) {
        this.set(Contact.l2a_Active_Contact__c, value);
        return this;
    }

    /**
    * Sets Contact's Source System.
    */
    public ContactBuilder withSourceSystem(String value) {
        this.set(Contact.l2a_Source_System__c, value);
        return this;
    }

    /**
    * Sets Contact's Role
    */
    public ContactBuilder withRole(String value) {
        this.set(Contact.l2a_Role__c, value);
        return this;
    }

    /**
    * Sets Contact's Partner Portal Active
    */
    public ContactBuilder withPartnerPortalActive(Boolean value) {
        this.set(Contact.l2a_Partner_Portal_Active__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_UUID__c of the Contact
     * @param value defines the l2a_UUID__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withUUID(String value) {
        this.set(Contact.l2a_UUID__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_SSO_Groups__c of the Contact
     * @param value defines the l2a_SSO_Groups__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withSSOGroups(String value) {
        this.set(Contact.l2a_SSO_Groups__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Central_Partner_Dashboard_Primary__c of the Contact
     * @param value defines the l2a_Central_Partner_Dashboard_Primary__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withCentralPartnerDashboardPrimary(Boolean value) {
        this.set(Contact.l2a_Central_Partner_Dashboard_Primary__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Cloud_Partner_Dashboard_Access__c of the Contact
     * @param value defines the l2a_Cloud_Partner_Dashboard_Access__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withCloudPartnerDashboardAccess(Boolean value) {
        this.set(Contact.l2a_Cloud_Partner_Dashboard_Access__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Job_Role__c of the Contact
     * @param value defines the l2a_Job_Role__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withJobRole(String value) {
        this.set(Contact.l2a_Job_Role__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Cancel_Online_Orders__c  of the Contact
     * @param value defines the l2a_Cancel_Online_Orders__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withCancelOnlineOrders(Boolean value) {
        this.set(Contact.l2a_Cancel_Online_Orders__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Place_Online_Orders__c  of the Contact
     * @param value defines the l2a_Place_Online_Orders__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withPlaceOnlineOrders(Boolean value) {
        this.set(Contact.l2a_Place_Online_Orders__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Track_Online_Orders__c  of the Contact
     * @param value defines the l2a_Track_Online_Orders__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withTrackOnlineOrders(Boolean value) {
        this.set(Contact.l2a_Track_Online_Orders__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_MDF_Requestor__c  of the Contact
     * @param value defines the l2a_MDF_Requestor__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withMDFRequestor(Boolean value) {
        this.set(Contact.l2a_MDF_Requestor__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_LC_Funnel_Stage__c of the Contact
     * @param value defines the l2a_LC_Funnel_Stage__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withFunnelStage(String value) {
        this.set(contact.l2a_LC_Funnel_Stage__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Contact_Role__c of the Contact
     * @param value defines the l2a_Contact_Role__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withContactRole(String value) {
        this.set(contact.l2a_Contact_Role__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Locale__c of the Contact
     * @param value defines the l2a_Locale__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withLocale(String value) {
        this.set(contact.l2a_Locale__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Contact_Status__c of the Contact
     * @param value defines the l2a_Contact_Status__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withContactStatus(String value) {
        this.set(contact.l2a_Contact_Status__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Contact_Created_From_Lead__c of the Contact
     * @param value defines the l2a_Contact_Created_From_Lead__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withContactCreatedFromLead(Boolean value) {
        this.set(contact.l2a_Contact_Created_From_Lead__c, value);
        return this;
    }

    /**
     * Method to populate the svc_Support_Language_Preference_Written__c of the Contact
     * @param value defines the svc_Support_Language_Preference_Written__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withPreferredLanguage(String value) {
        this.set(contact.svc_Support_Language_Preference_Written__c, value);
        return this;
    }

    /**
     * Method to populate the l2a_Lead_Id__c of the Contact
     * @param value defines the l2a_Lead_Id__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withLeadId(String value) {
        this.set(contact.l2a_Lead_Id__c, value);
        return this;
    }
	
	/**
     * Method to populate the GCLID__c of the Contact
     * @param value defines the GCLID__c field
     * @return current instance of ContactBuilder
     */
    public ContactBuilder withGCLID(String value) {
        this.set(contact.GCLID__c, value);
        return this;
    }
}