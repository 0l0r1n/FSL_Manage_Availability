public class ExpertService {

    public static List<TicketExpertWrapper> getTicketsForDate(){
        List<TicketExpertWrapper> tickets = new List<TicketExpertWrapper>();
        for (ServiceAppointment sa : new ServiceAppointmentRepository().getAppointmentsForRunningUser()){
            TicketExpertWrapper ticket = new TicketExpertWrapper();
            ticket.title = sa.AppointmentNumber;
            ticket.startDate = sa.SchedStartTime.format('dd/MM/YYYY - HH:mm');
            ticket.customerFirstName = sa.Contact.FirstName;
            ticket.customerLastName = sa.Contact.LastName;
            ticket.city = sa.City;
            ticket.recordId = sa.ParentRecordId;
            tickets.add(ticket);
        }
        return tickets;
    }

	public static List<TimeSlot> getTimeSlotsForWeek(Date startOfWeek){
        ServiceResource serviceResource = new ServiceResourceRepository().getServiceResourceForRunningUserWithApplicableTerritories();
        return new OperatingHoursRepository()
                    .getOperatingHoursByServiceResourceMembershipForWeek(serviceResource, startOfWeek)
                    .TimeSlots;
    }

    public static void saveSlotsForWeek(List<TimeSlot> timeSlots, Date startOfWeek){
        ServiceResource serviceResource = new ServiceResourceRepository().getServiceResourceForRunningUserWithApplicableTerritories();
        try {
            deleteOperatingHoursAndMembershipsForResourceForWeek(serviceResource, startOfWeek);
        } catch (Exception e) {

        } finally {
            createMembershipForResourceForWeek(serviceResource, startOfWeek, createOperatingHoursForWeek(timeSlots, startOfWeek));
        }
    }

    public static void deleteOperatingHoursAndMembershipsForResourceForWeek(ServiceResource serviceResource, Date startOfWeek){
        // SObjectUnitOfWork does not work here. Don't know why. Don't touch this.
        OperatingHours hours = new OperatingHoursRepository().getOperatingHoursByServiceResourceMembershipForWeek(serviceResource, startOfWeek);
        List<ServiceTerritoryMember> membership = new ServiceTerritoryMemberRepository().getMembershipForResourceForWeek(serviceResource, startOfWeek);
        delete membership;
        delete hours;
    }

    public static Id createOperatingHoursForWeek(List<TimeSlot> timeSlots, Date startOfWeek){
        SObjectUnitOfWork  uow = new SObjectUnitOfWork(new List<Schema.SObjectType> { OperatingHours.SObjectType, TimeSlot.SObjectType});
        OperatingHours operatingHoursForWeek = new OperatingHours(name = UserInfo.getUserId() + ' ' + startOfWeek,
                                                  TimeZone = UserInfo.getTimezone().getId());
        uow.registerNew(operatingHoursForWeek);
        uow.registerNew(timeSlots);
        for (TimeSlot slot : timeSlots){
            uow.registerRelationship(slot, TimeSlot.OperatingHoursId, operatingHoursForWeek);
        }
        uow.commitWork();
        return operatingHoursForWeek.Id;
    }

    public static void createMembershipForResourceForWeek(ServiceResource serviceResource, Date startOfWeek, Id OperatingHoursId){
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType> { ServiceTerritoryMember.SObjectType });
		for (Applicable_Territory__c applicableTerritory : serviceResource.Applicable_Territories__r ){
			ServiceTerritoryMember serviceTerritoryMember = new ServiceTerritoryMember();
			serviceTerritoryMember.OperatingHoursId = OperatingHoursId;
            serviceTerritoryMember.ServiceTerritoryId = applicableTerritory.Service_Territory__c;
            serviceTerritoryMember.TerritoryType = applicableTerritory.Territory_Type__c;
            serviceTerritoryMember.ServiceResourceId = serviceResource.Id;
			serviceTerritoryMember.EffectiveStartDate = startOfWeek;
			serviceTerritoryMember.EffectiveEndDate = startOfWeek.addDays(6);
			uow.registerNew(serviceTerritoryMember);
		}
		uow.commitWork();
    }

    public class TicketExpertWrapper {
        @AuraEnabled public String title;
        @AuraEnabled public String recordId;
        @AuraEnabled public String customerFirstName;
        @AuraEnabled public String customerLastName;
        @AuraEnabled public String city;
        @AuraEnabled public String startDate;
    }

}