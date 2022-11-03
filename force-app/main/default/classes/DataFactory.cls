@isTest
public class DataFactory {

    //Create accounts. Parameters (Count = Number of records, doInsert = If records should be inserted to database)
    public static List<Account> AccountData(Integer count, Boolean doInsert) {
        List<Account> accountList = new List<Account>();

        for (Integer i = 0; i < count; i++) {

            accountList.add(new Account(
            Name = 'Test Data Account ' + i
            ));
        }
        if (doInsert == TRUE) {
            insert accountList;
        }
        return accountList;
    }
  //Create opportunities. Parameters (Count = Number of records, doInsert = If records should be inserted to database)
  public static List<Opportunity> OpportunityData(Integer count, Boolean doInsert) {
    List<Opportunity> opportunityList = new List<Opportunity>();

    for (Integer i = 0; i < count; i++) {

        opportunityList.add(new Opportunity(
        Name = 'Test Data Opportunity ' + i,
        StageName = 'Prospecting',
        CloseDate = system.today().addDays(2)
        ));
    }
    if (doInsert == TRUE) {
        insert opportunityList;
    }
    return opportunityList;
}
}