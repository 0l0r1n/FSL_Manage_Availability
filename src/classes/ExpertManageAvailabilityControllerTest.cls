@isTest
private class ExpertManageAvailabilityControllerTest {

    @TestSetup
    static void dataSetup(){
        OperatingHours oh = TestFactory.createOperatingHoursWithTimeSlot();
        ServiceTerritory st = new ServiceTerritory(Name = 'test', OperatingHoursId = oh.Id, IsActive = True);
        insert st;
        ServiceResource sr = (ServiceResource)TestFactory.createServiceResource(TestFactory.createUserWithFieldServicePermissions(), true);
        insert new Applicable_Territory__c(Territory_Type__c = 'P', Service_Resource__c = sr.Id, Service_Territory__c = st.Id);
    }

    static testmethod void test_endToEnd(){
        User u = [SELECT id, (Select Id FROM ServiceResources) From User WHERE Name = 'Harry Potter'][0];
        System.runAs(u){
            // HACK the following line of code is to circumvent that dataSetup runs at a separate context
            update new OperatingHours(Id = [SELECT Id from OperatingHours Limit 1].Id, TimeZone = UserInfo.getTimezone().getId());
            // END HACK
            TimeSlot monday = new TimeSlot( DayOfWeek = 'Monday',
                                            StartTime = Util_Time.convertStringToTime('8:00'),
                                            EndTime = Util_Time.convertStringToTime('20:00'));
            TimeSlot tuesday = new TimeSlot( DayOfWeek = 'Tuesday',
                                            StartTime = Util_Time.convertStringToTime('8:00'),
                                            EndTime = Util_Time.convertStringToTime('20:00'));
            TimeSlot friday = new TimeSlot( DayOfWeek = 'Friday',
                                            StartTime = Util_Time.convertStringToTime('8:00'),
                                            EndTime = Util_Time.convertStringToTime('20:00'));

            TimeSlot[] timeSlots = new TimeSlot[] { monday, tuesday, friday };
            ExpertManageAvailabilityController.TimeSlotWrapper [] slotWrappers = new ExpertManageAvailabilityController.TimeSlotWrapper[]{};
            for (TimeSlot slot : timeSlots)
                slotWrappers.add(new ExpertManageAvailabilityController.TimeSlotWrapper(slot));
            String slotsString = JSON.serialize(slotWrappers);
            String dateString = System.today().toStartOfWeek().format();
            ExpertManageAvailabilityController.saveSlotsForWeek(slotsString, dateString);
            List<ExpertManageAvailabilityController.TimeSlotWrapper> slotsForWeek = ExpertManageAvailabilityController.getTimeSlotsForWeek(dateString);
            System.assertEquals(3, slotsForWeek.size());
        }
    }
}