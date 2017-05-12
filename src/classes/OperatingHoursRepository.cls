public class OperatingHoursRepository extends SObjectRepository {

  public SObjectType getSObjectType(){
    return OperatingHours.SObjectType;
  }

  public OperatingHours getOperatingHoursByServiceResourceMembershipForWeek(ServiceResource serviceResource, Date startOfWeek){
    Set<Id> operatingHoursIds = new Set<Id>();
    for (ServiceTerritoryMember stm : new ServiceTerritoryMemberRepository().getMembershipForResourceForWeek(serviceResource, startOfWeek)){
      operatingHoursIds.add(stm.OperatingHoursId);
    }
    return [SELECT Id,
           (SELECT Id, StartTime, EndTime, DayOfWeek FROM TimeSlots)
           FROM OperatingHours
           WHERE Id IN: operatingHoursIds
           LIMIT 1];
  }
}