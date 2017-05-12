public class ServiceAppointmentRepository extends SObjectRepository {

    public SObjectType getSObjectType(){
        return ServiceAppointment.SObjectType;
    }

    public List<ServiceAppointment> getAppointmentsForRunningUser(){
        return getAppointmentsByExpert(UserInfo.getUserId());
    }

    public List<ServiceAppointment> getServiceAppointmentsWithAssignedResourcesById(Set<Id> serviceAppointmentIds){
        return [SELECT Id,
                (SELECT Id, ServiceAppointmentId FROM ServiceResources)
                FROM ServiceAppointment
                WHERE Id IN: serviceAppointmentIds];
    }

    public List<ServiceAppointment> getAppointmentsByExpert(Id userId){
        Set<Id> applicableIds = new Set<Id>();
        for (AssignedResource ar : [SELECT ServiceAppointmentId
                                    FROM AssignedResource
                                    WHERE ServiceResourceId IN
                                    (SELECT Id FROM ServiceResource
                                    WHERE RelatedRecordId =: userId)
                                    ]){
            applicableIds.add(ar.ServiceAppointmentId);
        }
        return [
            SELECT AppointmentNumber, ContactId, SchedStartTime,
            Contact.FirstName, Contact.LastName,
            ParentRecordId, Street,
            City, PostalCode
            FROM ServiceAppointment
            WHERE Id IN: applicableIds
            AND SchedStartTime = TODAY
            ORDER BY SchedStartTime ASC
        ];
    }

}