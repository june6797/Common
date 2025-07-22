public with sharing class ChildProfileController {
    @AuraEnabled(cacheable=true)
    public static List<String> getSubjectFamilies(Id contactId) {
        Set<String> subjectSet = new Set<String>();

        List<Subscription__c> subs = [
            SELECT ProductId__r.Family
            FROM Subscription__c
            WHERE ContactId__c = :contactId
              AND ProductId__r.Family != null
        ];

        for (Subscription__c sub : subs) {
            subjectSet.add(sub.ProductId__r.Family);
        }

        return new List<String>(subjectSet);
    }
}