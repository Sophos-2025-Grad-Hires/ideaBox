/**
* Used to define methods to query AccountShare records
* Implements Object Selector Pattern for AccountShare object
* Extends fflib_SobjectSelector and Implements IAccountShare
*/
public without sharing class AccountShareSelector extends fflib_SObjectSelector implements IAccountShareSelector {

    /**
     * Method to return AccountShare sObjectType
     * @return Schema.SObjectType of Account
     */
    public Schema.SObjectType getSObjectType() {
        return AccountShare.sObjectType;
    }

    /**
     * Method to return fields of AccountShare
     * @return List of Schema.SObjectField of AccountShare to be queried
     */
    public List<Schema.SObjectField> getSObjectFIeldList() {
        return new List<Schema.SObjectField> {
            AccountShare.Id,
            AccountShare.AccountId,
            AccountShare.UserOrGroupId,
            AccountShare.AccountAccessLevel,
            AccountShare.OpportunityAccessLevel,
            AccountShare.RowCause
        };
    }

    /**
     * Method to return a QueryLocator selecting AccountShare records by paramaters
     * @param accIds Ids of account the accountshare is related to
     * @param userOrGrpIds Ids of User or Group the accountshare is related to
     * @param accAccessLvl Level of access to the account
     * @param oppAccessLvl Level of access to the opportunity
     * @param rowCause defines how the sharing is granted
     * @return List of AccountShare
     */
    public List<AccountShare> selectByAccUsrOrGrpAndAccess(Set<Id> accIds, Set<Id> userOrGrpIds, 
            String accAccessLvl, String oppAccessLvl, String rowCause) {
        String criteriaStr = 'AccountId IN :accIds' +
                ' AND UserOrGroupId IN :userOrGrpIds' +
                ' AND AccountAccessLevel = :accAccessLvl' +
                ' AND OpportunityAccessLevel = :oppAccessLvl' +
                ' AND RowCause = :rowCause';
        fflib_QueryFactory queryFactory = newQueryFactory().setCondition(criteriaStr);

        return Database.query(queryFactory.toSOQL());
    }
}