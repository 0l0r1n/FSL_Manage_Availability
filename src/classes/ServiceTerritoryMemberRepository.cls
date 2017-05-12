public class ServiceTerritoryMemberRepository extends SObjectRepository {

  public Schema.SObjectType getSObjectType(){
    return ServiceTerritoryMember.SObjectType;
  }

  public List<ServiceTerritoryMember> getMembershipForResourceForWeek(ServiceResource serviceResource, Date startOfWeek){
    Set<Id> serviceTerritoryIds = new Set<Id>();
    for (Applicable_Territory__c at : serviceResource.Applicable_Territories__r){
      serviceTerritoryIds.add(at.Service_Territory__c);
    }
    return  [SELECT OperatingHoursId
             FROM ServiceTerritoryMember
             WHERE ServiceTerritoryId IN: serviceTerritoryIds
             AND EffectiveStartDate =: startOfWeek
             AND EffectiveEndDate =: startOfWeek.addDays(6)
             AND ServiceResourceId =: serviceResource.Id
            ];
  }
}