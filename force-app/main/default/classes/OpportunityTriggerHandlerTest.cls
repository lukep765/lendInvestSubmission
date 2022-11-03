@isTest
public class OpportunityTriggerHandlerTest {


    //Tests closedWonOppsAmountSum after opp insert. Should return 5000.
    @isTest
    public static void insertShouldReturn5000() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2, FALSE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 2500;
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest();
        insert opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c FROM Account WHERE Id =: AccountList[0].Id ];
        system.debug(accResult.Total_Customer_Spend__c);
        system.assertEquals(5000, accResult.Total_Customer_Spend__c);
    }
    //Tests closedWonOppsAmountSum after opp update. Should return 5000.
    @isTest
    public static void updateShouldReturn5000() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2,TRUE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 2500;
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest();
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c FROM Account WHERE Id =: AccountList[0].Id ];
        system.debug(accResult.Total_Customer_Spend__c);
        system.assertEquals(5000, accResult.Total_Customer_Spend__c);
    }
    //Tests closedWonOppsAmountSum. Code should not run if opp is not closed won. Should return NULL.
    @isTest
    public static void oppNotClosedWonShouldReturnNull() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2,TRUE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.Amount = 2500;
            o.StageName = 'Qualification';
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest(); 
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c FROM Account WHERE Id =: AccountList[0].Id ];
        System.debug(accResult.Total_Customer_Spend__c);
        system.assertEquals(null,accResult.Total_Customer_Spend__c);
    }
    // Test customerClassification. Should return null
    @isTest
    public static void customerClassificationShouldBeNull() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2,TRUE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 1000;
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest();
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c, Customer_classification__c FROM Account WHERE Id =: AccountList[0].Id ];
        system.assertEquals(null, accResult.Customer_classification__c);
    }
    //test customer classification should return bronze
    @isTest
    public static void customerClassificationShouldBeBronze() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2,TRUE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 6000;
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest();
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c, Customer_classification__c FROM Account WHERE Id =: AccountList[0].Id ];
        system.assertEquals('BRONZE', accResult.Customer_classification__c);
    }
    //test customer classification should return Silver
    @isTest
    public static void customerClassificationShouldBeSilver() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2,TRUE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 16000;
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest();
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c, Customer_classification__c FROM Account WHERE Id =: AccountList[0].Id ];
        system.assertEquals('SILVER', accResult.Customer_classification__c);
    }
    //test customer classification should return Gold
    @isTest
    public static void customerClassificationShouldBeGold() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(2,TRUE);
        List<Account> accountList = DataFactory.AccountData(1, TRUE);
    
        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 30000;
            o.AccountId = accountList[0].Id;
        }
        //Test
        test.startTest();
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        Account accResult = [SELECT Id, Total_Customer_Spend__c, Customer_classification__c FROM Account WHERE Id =: AccountList[0].Id ];
        System.assertEquals('GOLD', accResult.Customer_classification__c);
    }
    //Test bulkification for after insert. Makes sure all ops and accounts that were created were commited to database and didn't hit DML limits. 
    @isTest
    public static void afterInsertBulk() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(200,FALSE);
        List<Account> accountList = DataFactory.AccountData(200, TRUE);
        Integer accCount = 0;

        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 30000;
            o.AccountId = accountList[accCount].Id;
            accCount += 1; 
        }
        //Test
        test.startTest();
        insert opportunityList;
        test.stopTest();
        
        //Query result and assert
        List<Opportunity> oppResult = [SELECT Id FROM Opportunity WHERE Id IN: opportunityList];
        List<Account> accResult = [SELECT Id FROM Account WHERE Id IN: accountList];
        System.assertEquals(opportunityList.size(), oppResult.size());
        System.assertEquals(accountList.size(), accResult.size());
    }
    //Test bulkification for after update. Makes sure all ops and accounts that were created were commited to database and didn't hit DML limits. 
    @isTest
    public static void afterUpdateBulk() {

        //Create data
        List<Opportunity> opportunityList = DataFactory.OpportunityData(200,TRUE);
        List<Account> accountList = DataFactory.AccountData(200, TRUE);
        Integer accCount = 0;

        //Arrange data
        for (Opportunity o : opportunityList) {
            o.StageName = 'Closed Won';
            o.Amount = 30000;
            o.AccountId = accountList[accCount].Id;
            accCount += 1; 
        }
        //Test
        test.startTest();
        update opportunityList;
        test.stopTest();
        
        //Query result and assert
        List<Opportunity> oppResult = [SELECT Id FROM Opportunity WHERE Id IN: opportunityList];
        List<Account> accResult = [SELECT Id FROM Account WHERE Id IN: accountList];
        System.assertEquals(opportunityList.size(), oppResult.size());
        System.assertEquals(accountList.size(), accResult.size());
    }

}
