public class OpportunityTriggerHandler extends TriggerHandler {
     
    //Handle after insert trigger
    public override void afterInsert(){ 
        closedWonOppsAmountSum(Trigger.new);
    }
    
    //Handle after update trigger
    public override void afterUpdate() {
        closedWonOppsAmountSum(Trigger.new);
    }

    //Get accounts opportunity and sum opportunity amount. (Input Opportunity Account Id) 
    public static void closedWonOppsAmountSum(list<Opportunity> ops) {
        
        List<Id> accIds = new List<Id>();
        
        //Put opp accountIds into list if opportunity is closed won. 
        for (opportunity o : ops) {
            if (o.StageName == 'Closed Won') {
                accIds.add(o.AccountId);
            }    
        }
        List<Account> relatedAcc = [SELECT Id, Total_Customer_Spend__c, Customer_Classification__c, (SELECT Id, Amount FROM Opportunities WHERE stageName = 'Closed Won') FROM ACCOUNT WHERE Id IN: accIds];
        
        //Loop through accounts and sum amount of all related closed won opps
        for (Account acc : relatedAcc) {
            Decimal accTotalCustomerSpend = 0;

            for (Opportunity accOp : acc.Opportunities) {
                accTotalCustomerSpend += accOp.Amount;
            }
            acc.Total_Customer_Spend__c = accTotalCustomerSpend;
            //Calls customer classficiation method passes account related to trigger.new returns account with customer classification.
            customerClassification(acc);
        }
        if (relatedAcc.size()>0) {
            update relatedAcc;
        }
    }

    //Determines customer classification based on account total customer spend
    public static Account customerClassification(Account acc) {
        
        // Set minumum values for each classification
        final Decimal GOLD_MIN = 50000;
        final Decimal SILVER_MIN = 25000;
        final Decimal BRONZE_MIN = 10000;

        //Classification logic
        if(acc.Total_Customer_Spend__c < BRONZE_MIN) {
            acc.Customer_Classification__c = '';
        
        }else if(acc.Total_Customer_Spend__c >= BRONZE_MIN && acc.Total_Customer_Spend__c < SILVER_MIN) {
            acc.Customer_Classification__c = 'BRONZE';
        
        }else if(acc.Total_Customer_Spend__c>= SILVER_MIN && acc.Total_Customer_Spend__c < GOLD_MIN) {
            acc.Customer_Classification__c = 'SILVER';
        
        }else if(acc.Total_Customer_Spend__c >= GOLD_MIN){
            acc.Customer_Classification__c = 'GOLD';
        }
        return acc;
    }
}
