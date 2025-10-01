Schema.DescribeFieldResult typeField = Account.Type.getDescribe();
List<Schema.PicklistEntry> picklistValues = typeField.getPicklistValues();

Account acct = new Account(
    Name = 'Test Deployment Account',
    Type = picklistValues[0].getValue() // Safest generic option
);
insert acct;