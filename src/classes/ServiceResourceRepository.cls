public class ServiceResourceRepository extends SObjectRepository {

  public SObjectType getSObjectType(){
    return ServiceResource.SObjectType;
  }

  public ServiceResource getServiceResourceByUserId(Id userId) {
    return getServiceResourceByUserId(new Set<Id>{userId})[0];
  }

  public List<ServiceResource> getServiceResourceByUserId(Set<Id> userIds) {
    return [ select Id
             from   ServiceResource
             where  RelatedRecordId in :userIds ];
  }

  public ServiceResource getServiceResourceForRunningUserWithApplicableTerritories(){
    return getServiceResourceWithApplicableTerritoriesByUserIds(new Set<Id> { UserInfo.getUserId() } )[0];
  }

  public List<ServiceResource> getServiceResourceWithApplicableTerritoriesByUserIds(Set<Id> userIds){
    return [SELECT Id, RelatedRecordId,
            (SELECT Service_Territory__c, Territory_Type__c FROM Applicable_Territories__r)
            FROM ServiceResource WHERE RelatedRecordId IN :userIds];
  }

  public List<ServiceResource> getServiceResourceWithApplicableTerritoriesByIds(Set<Id> serviceResourceIds){
    return [SELECT Id,
            (SELECT Service_Territory__c, Territory_Type__c FROM Applicable_Territories__r)
            FROM ServiceResource WHERE Id IN :serviceResourceIds];
  }

}