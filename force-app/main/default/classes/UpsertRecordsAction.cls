public with sharing class UpsertRecordsAction {

    @InvocableMethod(
            label='Upsert Records'
            description='Updates existing records (or inserts them if they do not exist).')
    public static List<UpsertResult> upsertRecords(List<UpsertRequest> request) {
        List<SObject> records = new List<SObject>();
        String externalIdFieldName;

        for (UpsertRequest req: request ) {
            externalIdFieldName = req.externalIDField;
            records.addAll(req.records);
        }

        List<UpsertResult> results = new List<UpsertResult>();
        UpsertResult res = new UpsertResult();

        Schema.SObjectType sObjectType = records.get(0).getSObjectType();
        SObjectField externalIDField = getUpsertKeyField(sObjectType, externalIdFieldName);

        if (sObjectType != null) {
            List<SObject> castRecords = (List<SObject>)Type.forName('List<' + sObjectType + '>').newInstance();
            castRecords.addAll(records);

            if (externalIDField == null) {
                Database.upsert(castRecords);
            } else {
                Database.upsert(castRecords, externalIDField);
            }

            res.results = castRecords;
            results.add(res);
        }

        return results;
    }

    private static SObjectField getUpsertKeyField(Schema.SObjectType objectType, string fieldName) {
        if (String.isBlank(fieldName)) {
            return null;
        }

        Map<String,Schema.SObjectField> objectFields = objectType.getDescribe().fields.getMap();

        return objectFields.get(fieldName);
    }

    public class UpsertRequest {
        @InvocableVariable(label='Records to Upsert' required=true)
        public List<SObject> records;

        @InvocableVariable(label='External ID Field (Optional)')
        public String externalIDField;
    }

    public class UpsertResult {
        @InvocableVariable(label='Upserted Records')
        public List<SObject> results;
    }
}