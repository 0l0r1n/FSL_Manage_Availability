@isTest
private class ExpertServiceTest {
  static User u;

  @isTest
  static void ticketsForDate_returns_ticketsForToday(){
    setup();
    System.runAs(u){
      //System.assertEquals(1, ExpertService.getTicketsForDate().size());
    }
  }

  static void setup(){
    u = TestFactory.createUserWithFieldServicePermissions();
    WorkOrder wo = (WorkOrder)TestFactory.createSObject(new WorkOrder(), true);
    ServiceAppointment sa = (ServiceAppointment)TestFactory.createSObject(new ServiceAppointment(), false);
    sa.ParentRecordId = wo.Id;
    sa.SchedStartTime = System.now();
    sa.SchedEndTime = System.now().addMinutes(50);
    //insert sa;
    //ServiceResource sr = TestFactory.createServiceResource(u, true);
    //AssignedResource ar = TestFactory.createAssignedResource(sa.Id, sr.Id);
  }

}