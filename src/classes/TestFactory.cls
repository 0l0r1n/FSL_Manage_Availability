// source - https://github.com/dhoechst/Salesforce-Test-Factory
@isTest
public class TestFactory {

	public static SObject createSObjectSystemDefaulfValues(String objectName){
		return Schema.getGlobalDescribe().get(objectName).newSObject(null, true);
	}

  public static User createUserWithFieldServicePermissions() {
    User user = (User)createSObject(new User(), false);
    System.runAs(user){
      PermissionSet fieldServicePermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Admin_License' LIMIT 1];
      PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = fieldServicePermissionSet.Id, AssigneeId = user.Id);
      insert psa;
    }
    return user;
  }

  public static OperatingHours createOperatingHoursWithTimeSlot(){
	  OperatingHours oh = new OperatingHours(Name = 'Test OH');
	  insert oh;
      TimeSlot monday = new TimeSlot( DayOfWeek = 'Monday',
                                      StartTime = Util_Time.convertStringToTime('8:00'),
                                      EndTime = Util_Time.convertStringToTime('20:00'),
                                      OperatingHoursId = oh.Id );
      TimeSlot friday = new TimeSlot( DayOfWeek = 'Friday',
                                      StartTime = Util_Time.convertStringToTime('8:00'),
                                      EndTime = Util_Time.convertStringToTime('20:00'),
                                      OperatingHoursId = oh.Id );
	  TimeSlot[] timeSlots  = new TimeSlot[]{ monday, friday };
      insert timeslots;
      return oh;
  }

  public static ServiceResource createServiceResource(User u, Boolean doInsert) {
    ServiceResource sr = new ServiceResource(
      Name = 'Gandalf The White',
      RelatedRecordId = u.Id,
      IsActive = True
    );
    if (doInsert)
      insert sr;
    return sr;
  }

  public static AssignedResource createAssignedResource(Id serviceAppointmentId, Id serviceResourceId){
    AssignedResource ar = new AssignedResource(ServiceAppointmentId = serviceAppointmentId, ServiceResourceId = serviceResourceId);
    insert ar;
    return ar;
  }

	public static SObject createSObject(SObject sObj) {
		// Check what type of object we are creating and add any defaults that are needed.
		String objectName = String.valueOf(sObj.getSObjectType());
		// Construct the default values class. Salesforce doesn't allow '__' in class names
		String defaultClassName = 'TestFactory.' + objectName.replaceAll('__c|__', '') + 'Defaults';
		// If there is a class that exists for the default values, then use them
		if (Type.forName(defaultClassName) != null) {
			sObj = createSObject(sObj, defaultClassName);
		}
		return sObj;
	}

	public static SObject createSObject(SObject sObj, Boolean doInsert) {
		SObject retObject = createSObject(sObj);
		if (doInsert) {
			insert retObject;
		}
		return retObject;
	}

	public static SObject createSObject(SObject sObj, String defaultClassName) {
		// Create an instance of the defaults class so we can get the Map of field defaults
		Type t = Type.forName(defaultClassName);
		if (t == null) {
			Throw new TestFactoryException('Invalid defaults class.');
		}
		FieldDefaults defaults = (FieldDefaults)t.newInstance();
		addFieldDefaults(sObj, defaults.getFieldDefaults());
		return sObj;
	}

	public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
		SObject retObject = createSObject(sObj, defaultClassName);
		if (doInsert) {
			insert retObject;
		}
		return retObject;
	}

	public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
		return createSObjectList(sObj, numberOfObjects, (String)null);
	}

	public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
		SObject[] retList = createSObjectList(sObj, numberOfObjects, (String)null);
		if (doInsert) {
			insert retList;
		}
		return retList;
	}

	public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
		SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
		if (doInsert) {
			insert retList;
		}
		return retList;
	}

	public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
		SObject[] sObjs = new SObject[] {};
		SObject newObj;

		// Get one copy of the object
		if (defaultClassName == null) {
			newObj = createSObject(sObj);
		} else {
			newObj = createSObject(sObj, defaultClassName);
		}

		// Get the name field for the object
		String nameField = nameFieldMap.get(String.valueOf(sObj.getSObjectType()));
		if (nameField == null) {
			nameField = 'Name';
		}

		// Clone the object the number of times requested. Increment the name field so each record is unique
		for (Integer i = 0; i < numberOfObjects; i++) {
			SObject clonedSObj = newObj.clone(false, true);
			clonedSObj.put(nameField, (String)clonedSObj.get(nameField) + ' ' + i);
			sObjs.add(clonedSObj);
		}
		return sObjs;
	}

	private static void addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
		// Loop through the map of fields and if they are null on the object, fill them.
		for (String field : defaults.keySet()) {
			if (sObj.get(field) == null) {
				sObj.put(field, defaults.get(field));
			}
		}
	}

	// When we create a list of SObjects, we need to
	private static Map<String, String> nameFieldMap = new Map<String, String> {
		'Contact' => 'LastName',
		'Case' => 'Subject',
		'WorkOrder' => 'Description'
	};

	public class TestFactoryException extends Exception {}

	// Use the FieldDefaults interface to set up values you want to default in for all objects.
	public interface FieldDefaults {
		Map<String, Object> getFieldDefaults();
	}

	// To specify defaults for objects, use the naming convention [ObjectName]Defaults.
	// For custom objects, omit the __c from the Object Name

	public class AccountDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults() {
			return new Map<String, Object> {
				'Name' => 'Test Account'
			};
		}
	}

	public class ContactDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults() {
			return new Map<String, Object> {
				'FirstName' => 'First',
				'LastName' => 'Last'
			};
		}
	}

	public class OpportunityDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults() {
			return new Map<String, Object> {
				'Name' => 'Test Opportunity',
				'StageName' => 'Closed Won',
				'CloseDate' => System.today()
			};
		}
	}

	public class CaseDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults() {
			return new Map<String, Object> {
				'Subject' => 'Test Case'
			};
		}
	}

	public class WorkOrderDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults() {
			return new Map<String, Object> {

			};
		}
	}

  public class ServiceAppointmentDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      Datetime now = System.now();
		return new Map<String, Object> {
            'EarliestStartTime' => now,
            'DueDate' => now,
            'SchedStartTime' => now
		};
    }
  }

	public class WorkTypeDefaults implements FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
      Datetime now = System.now();
			return new Map<String, Object> {
        		'Name' => 'Invisibility Cloak Maintenance',
				'DurationType' => 'Hours',
				'EstimatedDuration' => 2
			};
    }
  }

	public class UserDefaults implements FieldDefaults {
		public Map<String, Object> getFieldDefaults() {
			return new Map<String, Object> {
				'LastName' => 'Potter',
				'FirstName' => 'Harry',
				'Email' => 'harry.potter@hogwarts.co.uk',
				'Username' => 'harry.potter@hogwarts.co.uk',
				'Alias' => 'hpott',
        'CommunityNickname' => 'boy_who_lived',
				'LocaleSidKey' => 'en_GB',
				'TimeZoneSidKey' => 'GMT',
				'LanguageLocaleKey' => 'en_US',
				'EmailEncodingKey' => 'UTF-8',
        'ProfileId' => [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id
			};
		}
	}
}