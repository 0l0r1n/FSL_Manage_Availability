public class Util_Time {

  public static String convertTimeToString(Time timeToConvert){
    String hours = String.valueOf(timeToConvert.hour());
    String minutes = String.valueOf(timeToConvert.minute());
		return String.format('{0}:{1}',new List<String>{ hours.length() == 1 ? '0' + hours : hours, minutes.length() == 1 ? '0' + minutes : minutes});
	}

  public static Time convertStringToTime(String stringToConvert){
    String[] timeStringList = stringToConvert.split(':');
    Integer hours = Integer.valueOf(timeStringList[0]);
    Integer minutes = Integer.valueOf(timeStringList[1]);
    return Time.newInstance(hours, minutes, 0, 0);
  }
}