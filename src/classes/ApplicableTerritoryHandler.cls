public with sharing class ApplicableTerritoryHandler extends TriggerHandler {

    private Applicable_Territory__c[] newApplicableTerritoryList;

    protected override void setVariables(){
        this.newApplicableTerritoryList = Trigger.new;
    }

    protected override void beforeInsert(){
        validateUniqueness();
    }

    protected override void beforeUpdate(){
        validateUniqueness();
    }

    private void validateUniqueness(){
        Set<Id> serviceResourceIds = new Set<Id>();
        for (Applicable_Territory__c applicableTerritory : newApplicableTerritoryList)
            serviceResourceIds.add(applicableTerritory.Service_Resource__c);
        ServiceResource[] serviceResources = new ServiceResourceRepository().getServiceResourceWithApplicableTerritoriesByIds(serviceResourceIds);
        Map<Id, ServiceResource> serviceResourceMap = new Map<Id, ServiceResource>(serviceResources);
        for (Applicable_Territory__c newApplicableTerritory : newApplicableTerritoryList){
            for (Applicable_Territory__c existingApplicableTerritory : serviceResourceMap.get(newApplicableTerritory.Service_Resource__c).Applicable_Territories__r){
                validateUniqueServiceTerritory(newApplicableTerritory, existingApplicableTerritory);
                validateSinglePrimaryTerritory(newApplicableTerritory, existingApplicableTerritory);
            }
        }
    }

    @TestVisible
    private boolean validateUniqueServiceTerritory(Applicable_Territory__c newApplicableTerritory, Applicable_Territory__c existingApplicableTerritory){
        if (newApplicableTerritory.Service_Territory__c == existingApplicableTerritory.Service_Territory__c){
            newApplicableTerritory.addError(System.Label.Applicable_Territory_Territory_Already_Added);
            return false;
        }
        return true;
    }

    @TestVisible
    private boolean validateSinglePrimaryTerritory(Applicable_Territory__c newApplicableTerritory, Applicable_Territory__c existingApplicableTerritory){
        if (newApplicableTerritory.Territory_Type__c == 'P' &&
            newApplicableTerritory.Territory_Type__c == existingApplicableTerritory.Territory_Type__c){
            newApplicableTerritory.addError(System.Label.Applicable_Territory_Only_One_Primary);
            return false;
        }
        return true;
    }

}