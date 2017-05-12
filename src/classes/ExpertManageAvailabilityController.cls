public with sharing class ExpertManageAvailabilityController {

    @AuraEnabled
    public static List<TimeSlotWrapper> getTimeSlotsForWeek(String startOfWeek){
        List<TimeSlotWrapper> timeSlotWrappers = new List<TimeSlotWrapper>();
        try {
            for (TimeSlot timeSlot : ExpertService.getTimeSlotsForWeek(Date.parse(startOfWeek))){
                timeSlotWrappers.add(new TimeSlotWrapper(timeSlot));
        }
            } catch (Exception e){}
        return timeSlotWrappers;
    }

    @AuraEnabled
    public static void saveSlotsForWeek(String timeSlotWrappersString, String startOfWeek){
        List<TimeSlotWrapper> timeSlotWrappers = (List<TimeSlotWrapper>)JSON.deserialize(timeSlotWrappersString, List<TimeSlotWrapper>.class);
        List<TimeSlot> timeSlots = new List<TimeSlot>();
        for (TimeSlotWrapper timeSlotWrapper : timeSlotWrappers)
            timeSlots.add(timeSlotWrapper.convertToSObject());
        ExpertService.saveSlotsForWeek(timeSlots, Date.parse(startOfWeek));
    }

    public class TimeSlotWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String DayOfWeek;
        @AuraEnabled public String StartTime;
        @AuraEnabled public String EndTime;

        public TimeSlotWrapper(TimeSlot timeSlot){
            this.Id = timeSlot.Id;
            this.DayOfWeek = timeSlot.DayOfWeek;
            this.StartTime = Util_Time.convertTimeToString(timeSlot.StartTime);
            this.EndTime = Util_Time.convertTimeToString(timeSlot.EndTime);
        }

        public TimeSlot convertToSObject(){
            TimeSlot timeSlot = new TimeSlot();
            timeSlot.DayOfWeek = this.DayOfWeek;
            timeSlot.StartTime = Util_Time.convertStringToTime(this.StartTime);
            timeSlot.EndTime = Util_Time.convertStringToTime(this.EndTime);
            timeSlot.Type = 'Normal';
            return timeSlot;
        }
    }
}