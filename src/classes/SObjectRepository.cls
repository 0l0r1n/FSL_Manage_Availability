public abstract class SObjectRepository {

  abstract SObjectType getSObjectType();

  public SObjectRepository(){
    assertIsAccessible();
  }

  public List<SObject> getSObjectsCustom(QueryParams queryParams){
    return Database.query(
      String.format(
        'SELECT {0} FROM {1} WHERE {2}',
          new String[]{
            queryParams.fields,
            getSObjectType().getDescribe().getName(),
            queryParams.condition
          }
        )
      );
  }

  public void assertIsAccessible(){
    if(!getSObjectType().getDescribe().isAccessible())
      throw new InaccessibleSObjectException(String.format(
        'Permission to access {0} denied',
         new String[] {
           getSObjectType().getDescribe().getLabel()
         }
       )
     );
  }
  public class QueryParams {
    public String fields;
    public String condition;
  }

  public class InaccessibleSObjectException extends Exception {}

}