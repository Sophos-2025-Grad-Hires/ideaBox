/**
 * Used to define methods to query User Object 
 * Implements Object Selector Pattern for User object
 * Extends fflib_SobjectSelector
 */
public inherited sharing class UserSelector extends fflib_SObjectSelector {

    /**
     * Method to return User sObjectType
     * @return Schema.SObjectType of User
     */
    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }

    /**
     * Method to return fields of User
     * @return List of Schema.SObjectField of User to be queried
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            User.AccountId,
            User.Id, 
            User.Name,
            User.FirstName,
            User.LastName,
            User.Email,
            user.Username,
            user.ProfileId,
            user.IsPortalEnabled,
            User.UserRoleId,
            User.IsActive,
            User.ManagerId,
            User.ContactId,
            User.EmployeeNumber,
            User.Legacy_ID__c,
            User.Phone, 
            User.MobilePhone
        };
    }

    /**
     * Method to return a QueryLocator selecting User by LastName
     * @param accountIdSet to be used as a condition of the SOQL
     * @return List of the users
     */
    public List<User> selectPartnerUserByAccountID(Set<Id> accountIdSet) {
        String condition = 'IsActive = true and IsPortalEnabled = true and AccountId in :accountIdSet';
        fflib_QueryFactory query = newQueryFactory();
        query.setCondition(condition);
        return (List<User>) Database.query(query.toSOQL());
    }

    /**
     * Method to return a single user, meant to be used to retrieve Test-created
     * user records to be used as running users. 
     * @param username to be used as a condition of the SOQL
     * @return User record
     */
    @TestVisible
    private User selectByUsername(String username) {
        DateTime dateTimeOneHourAgo = System.Now().addHours(-1);
        return ((List<User>) Database.query(newQueryFactory()
                .setCondition('Username = :username AND CreatedDate > :dateTimeOneHourAgo')
                .addOrdering('CreatedDate', fflib_QueryFactory.SortOrder.DESCENDING)
                .setLimit(1)
                .toSOQL()))[0];
    }

    /**
     * Returns List<User> by selecting User by User Id Set
     * @param - List<Id> - list of user Ids
     * @return - List of User records
     */
    public List<User> selectByIds(Set<Id> userIdSet){
        fflib_QueryFactory queryFactory = newQueryFactory();
        queryFactory.selectField('Account.Partner_Type__c');
        queryFactory.selectField('Profile.Name');
        queryFactory.setCondition('Id in :userIdSet');
        return (List<User>)Database.query(queryFactory.toSOQL());
    }

    /**
     * Returns List<User> by selecting User by Contact Id
     * @param - List<Id> - list of Contact Ids
     * @return - List of User records
     */
    public List<User> selectByContactIds(List<Id> contactIdList){
        fflib_QueryFactory queryFactory = newQueryFactory();
        queryFactory.setCondition('ContactId IN : contactIdList');
        return (List<User>)Database.query(queryFactory.toSOQL());
    }
    
    /**
    * Query matching user based on name and profile
    * @param userName - the name of user
    * @param profileName - the name of user's profile
    * @return List<User> list of matching user
    */
    public List<User> selectByNameAndProfileName(String userName, String profileName) {
        return (List<User>) Database.query(newQueryFactory().setCondition('Name = :userName AND Profile.Name = :profileName').toSOQL());
    }
    
    /**
    * Query matching user based on legacy ids
    * @param legacyIds - Set of legacy ids
    * @return Database.QueryLocator of the query
    */
    public Database.QueryLocator selectByLegacyIds(Set<String> legacyIds) {
        return Database.getQueryLocator(newQueryFactory().setCondition('Legacy_ID__c IN :legacyIds').toSOQL());
    }

    private class SelectorException extends Exception {}

    /**
     * Method to return active users based on Ids in userIds set
     * @param userIds - Set of User Ids
     * @return Database.QueryLocator of the query
     */
    public Database.QueryLocator selectActiveByIds(Set<Id> userIds) {
        return Database.getQueryLocator(newQueryFactory().setCondition('Id IN :userIds AND IsActive = TRUE').toSOQL());
    }

    /**
    * Query matching user based on name for New deal registration approver user
    * @param listOfNames
    * @return List<User>
    */
    public List<User> selectByName(List<String> listOfNames) {
        return (List<User>)Database.query(newQueryFactory().setCondition('Name IN :listOfNames').toSOQL());
    }
}