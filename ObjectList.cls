public class ObjectList{
    @auraenabled (cacheable=true)
    public static list<EntityDefinition> getObjectList(){
         return [SELECT Id, MasterLabel,  
                    DeveloperName,
                    QualifiedApiName
                    FROM EntityDefinition
                    WHERE IsApexTriggerable = true ORDER BY MasterLabel
                    ];
    }  
    
    @auraenabled (cacheable=true)
    public static list<sObject> getRecords(string objectAPIName){
        String str = 'Select Id, Name from '+objectAPIName+' Order by CreatedDate Limit 10';
        system.debug('String>> '+str);
        list<sObject> sObjLst = Database.query(str);
        System.debug('List>> '+sObjLst);
        return sObjLst;
    }
}