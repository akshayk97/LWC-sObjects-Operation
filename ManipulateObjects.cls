public with sharing class ManipulateObjects {
  
  @AuraEnabled(cacheable=true)
  public static List<List<String>> getObjectFields(String objectName, String fieldset){
      String labelString;
      String apiNameString;
      String typeString;

      List<List<String>> result = new List<List<String>> ();
      List<Schema.FieldSetMember> fieldSetList;
      Schema.SObjectType objectType = null;

      try {
         // System.debug('getting => objectName ' + objectName + ' -> fieldset ' + fieldset);

          if(String.isNotBlank(objectName)){
              objectType = Schema.getGlobalDescribe().get(objectName);
              Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
              Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
              Schema.FieldSet fieldSett = fieldSetMap.get(fieldset);
              fieldSetList = fieldSett.getFields();
              
              for(Schema.FieldSetMember field : fieldSetList){
                  labelString = field.Label;
                  apiNameString = field.getFieldPath();
                  result.add(new List<String> {labelString,apiNameString});
              }

          }
      } catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }

      return result;
  }


  @AuraEnabled(cacheable=true)
  public static List<SObject> getSobjectData(String objectName, String fieldset, String field, String sortOrder, String recordLimit){
      String query;
      List<List<String>> fieldList = ManipulateObjects.getObjectFields(objectName, fieldset);
      
      String fieldsToQuery = '';

      System.debug('recordLimit ' + recordLimit);

      for(List<String> fld : fieldList){
          fieldsToQuery = fieldsToQuery + fld[1] + ',';
      }

      fieldsToQuery = fieldsToQuery.removeStart(',');
      fieldsToQuery = fieldsToQuery.removeEnd(',');

      System.debug('---> fieldList ' + fieldsToQuery);

      query  = 'SELECT '+ fieldsToQuery +' FROM '+objectName;
      if(field != null && sortOrder !=null){
          query += ' ORDER BY '+field+' '+sortOrder;
      }
      query += ' Limit '+ recordLimit; 

      System.debug('recordLimit ' + query);
      return Database.query(query);
  }



  @AuraEnabled
  public static Boolean updateSObject(List<SObject> data){
      Boolean isSuccess = false;
      try {
          System.debug('update data ---> ' + data);
          update data;
          isSuccess = true;   
      } catch (Exception e) {
          isSuccess = false;
      }

      return isSuccess;
  }

  @AuraEnabled
  public static Boolean deleteSObjectRecord(SObject deleteRec){
      Boolean isSuccess = false;
      try {
          System.debug('delete data ---> ' + deleteRec);
          delete deleteRec;
          isSuccess = true;   
      } catch (Exception e) {
          System.debug('error ' + e.getMessage());
          isSuccess = false;
      }

      return isSuccess;
  }

  @AuraEnabled(cacheable=true)
  public static List<ContentDocument> getSobjectDocuments(String recId){
  /*  List<ContentDocumentLink> contentDocList;
    if(String.isNotBlank(recId)){
        contentDocList =  [SELECT LinkedEntityId, Id, ShareType, Visibility, 
        ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recId];
    }
    return contentDocList.size()>0 ? contentDocList : null; */
    System.debug(recId);
    List<ContentDocumentLink> contentDocList;
    List<ContentDocumentLink> cdls = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recId];
    Set<Id> documentIds = new Set<Id>();
    for (ContentDocumentLink cdl : cdls) {
        documentIds.add(cdl.ContentDocumentId);
     }
// ContentDocumentLink doesn't support semi-joins, which is frustrating.
    List<ContentDocument> documents = [SELECT Id, FileType, Title, FileExtension FROM ContentDocument WHERE Id IN :documentIds];

    return documents;
  }


  @AuraEnabled
  public static Boolean deleteSelectedDocuments(List<String> recIds){
    Boolean isdeleted = false;
    if(recIds.size() > 0){
        try{
        List<ContentDocument> documents = [SELECT Id FROM ContentDocument WHERE Id IN: recIds];

        if(documents.size() > 0){
            delete documents;
            isdeleted = true;
        }else {
            isdeleted = false;
        }
    }catch(Exception e){
        System.debug('Error ' + e.getMessage());
        isdeleted = false;
    }
    }

    return isdeleted;
  }
  
}