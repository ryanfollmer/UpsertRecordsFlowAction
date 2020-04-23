@IsTest
public class UpsertRecordsActionTest {
    
    @IsTest
    private static void testDefaultBehavior(){
        List<UpsertRecordsAction.UpsertRequest> requests = new List<UpsertRecordsAction.UpsertRequest>();

        UpsertRecordsAction.UpsertRequest ur = new UpsertRecordsAction.UpsertRequest();

        List<Account> accounts = new List<Account>();

        accounts.add(new Account(Name='Account 1', ExternalID__c='123'));
        accounts.add(new Account(Name='Account 2', ExternalID__c='456'));

        ur.records = accounts;
        requests.add(ur);

        List<UpsertRecordsAction.UpsertResult> results = UpsertRecordsAction.upsertRecords(requests);

        System.assert(results != null, 'Upsert Results should not be null.');
        System.assertEquals(2, results[0].results.size(), 'Result collection should contain 2 items.');
    }

    @IsTest
    private static void testUpsertUsingExternalIdKey(){

        Account a1 = new Account(Name='Account 1', ExternalID__c='123');
        insert a1;

        List<UpsertRecordsAction.UpsertRequest> requests = new List<UpsertRecordsAction.UpsertRequest>();

        UpsertRecordsAction.UpsertRequest ur = new UpsertRecordsAction.UpsertRequest();

        List<Account> accounts = new List<Account>();

        accounts.add(a1);
        accounts.add(new Account(Name='Account 2', ExternalID__c='456'));

        ur.records = accounts;
        
        // Custom text field on Account object - flagged as External ID 
        ur.externalIDField = 'ExternalID__c';

        requests.add(ur);

        List<UpsertRecordsAction.UpsertResult> results = UpsertRecordsAction.upsertRecords(requests);

        System.assert(results != null, 'Upsert Results should not be null.');
        System.assertEquals(2, results[0].results.size(), 'Result collection should contain 2 items.');

    }
}
