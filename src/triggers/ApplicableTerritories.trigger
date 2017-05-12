trigger ApplicableTerritories on Applicable_Territory__c (before insert, before update) {
    new ApplicableTerritoryHandler().run();
}