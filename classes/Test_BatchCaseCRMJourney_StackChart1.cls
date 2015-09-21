/*
Date: 18/11/2014
Author: Sunil Kumar & Santosh Mohanty
Description: Apex class to create Metric Data Records for MYCRMJourney-Service Metrics
Version: v1.0
*/ 
global class Test_BatchCaseCRMJourney_StackChart1 implements Database.Batchable<sObject>,Database.stateful{
        
        @TESTVISIBLE Date d00=Util.d00;
        @TESTVISIBLE Date d01=Util.d01;
        @TESTVISIBLE Date d02=Util.d02;
        @TESTVISIBLE Date d03=Util.d03;
        @TESTVISIBLE Date d04=Util.d04;
        @TESTVISIBLE Date d05=Util.d05;
        @TESTVISIBLE Date d06=Util.d06;
        
public  List<Date> lsMonths = new List<Date>{d00,d01,d02,d03,d04,d05}; 
public List<AIES_ACCENTURE__AIESMetricData__c> obj = new List<AIES_ACCENTURE__AIESMetricData__c>();
public List<AIES_ACCENTURE__AIESMetricData__c> obj1 = new List<AIES_ACCENTURE__AIESMetricData__c>();  
public AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('New_Cases_Opened_per_month_per_Channel');          
public Set<String> originPickList{ 
   
  get{
    Schema.sObjectType objType = Case.getSObjectType(); 
    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
    Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
    list<Schema.PicklistEntry> values =fieldMap.get('Origin').getDescribe().getPickListValues();
    for (Schema.PicklistEntry a : values)
      { 
          if(originPickList == null){
          originPickList = new Set<String>();
          originPickList.add(a.getValue()); 
          system.debug('if picklist:'+a.getValue());
      }
      else
      {
          originPickList.add(a.getValue()); 
          system.debug('else picklist:'+a.getValue());
      }
     
    }return originPickList;
    }set;    }

public integer currentYear=Util.drillYear(Util.d00);
public integer prevYear=Util.drillYear(Util.d00)-1;

public Map<String,Integer> compareKeysMap=new Map<String,Integer> ();
         
public List<string> stackMonthList=new List<String>{Util.MonthName(d00),Util.MonthName(d01),Util.MonthName(d02),Util.MonthName(d03),Util.MonthName(d04),Util.MonthName(d05)};
public static Map<Integer,String> stackMonthsMap=new Map<Integer,String>{1=> 'JAN',2=> 'FEB',3=> 'MAR',4=> 'APR',5=> 'MAY',6=> 'JUN',7=> 'JUL',8=> 'AUG',9=> 'SEP',10=> 'OCT',11=> 'NOV',12=> 'DEC' };
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {                          
        String query='select id,createddate,lastmodifieddate,Origin,ownerid from case where isclosed=false and lastmodifieddate>=:d06 and lastmodifieddate<=:d00';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC,List<Case> scope)
    {
    
 try {      
      set<string> pickListSet= new set<string>();
      Integer i=0;
      
      Set<id> idSet=new Set<id>();
      for(Case obj:Scope){
      idSet.add(obj.id);
        }
  for (AggregateResult c:[select count(id) recordCount,calendar_month(lastmodifieddate) monthNumber,calendar_year(lastmodifieddate) caseYear,Origin from case where id in:idSet
                          and isclosed=false and lastmodifieddate>=:d06 and lastmodifieddate<=:d00 group by calendar_month(lastmodifieddate),calendar_year(lastmodifieddate),Origin Order By calendar_month(lastmodifieddate)])
           { 
               
               i++;
               
              if ((Integer)c.get('caseYear')==currentYear)
              {  
               system.debug('CurrentYear'+(Integer)c.get('caseYear'));             
               obj.add(Util.createMetricData(stackMonthsMap.get((Integer)c.get('monthNumber'))+'-'+currentYear,(Integer)c.get('recordCount'),(String)c.get('Origin'),metricMaster1,i));
               compareKeysMap.put(stackMonthsMap.get((Integer)c.get('monthNumber'))+'-'+currentYear+(String)c.get('Origin'),(Integer)c.get('recordCount'));
              }
              
              else if ((Integer)c.get('caseYear')==prevYear){
               system.debug('PrevYear'+(Integer)c.get('caseYear')); 
               obj.add(Util.createMetricData(stackMonthsMap.get((Integer)c.get('monthNumber'))+'-'+prevYear,(Integer)c.get('recordCount'),(String)c.get('Origin'),metricMaster1,i));
               compareKeysMap.put(stackMonthsMap.get((Integer)c.get('monthNumber'))+'-'+prevYear+(String)c.get('Origin'),(Integer)c.get('recordCount'));
              }       

          }    
     

     
     }
     
    catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchService MyCRMJourney Metric', 'finish');
        }
       
    }
    
    public void finish(Database.BatchableContext BC)
    {
    
      try
        { 
       system.debug('MonthList'+stackMonthList);
       system.debug('pickList'+originPickList);
       system.debug('compareKeysMap'+compareKeysMap.values()); 

       /*    for (String s:stackMonthList){
           
               for (String p:originPickList){ 
                
                 Integer j=0;
                 String sp=String.ValueOf(s)+String.ValueOf(p);
                 system.debug('Key+Origin'+sp);
                if (!compareKeysMap.containsKey(sp))
                {
                    j++;
                    system.debug('If Loop Started Inside Finish Method');
                    obj.add(Util.createMetricData(s,0,p,metricMaster1,j));
                }
                            
            }
           } 
           */

 Map<String,Decimal> result=new Map<String,Decimal>();
    
       for (AIES_ACCENTURE__AIESMetricdata__c md: Obj){
          Decimal count=0;
           if (result.containsKey(md.AIES_ACCENTURE__Key__c+md.AIES_ACCENTURE__Category__c)){
               
               count=count+md.AIES_ACCENTURE__value__c;
               result.put(md.AIES_ACCENTURE__Key__c+md.AIES_ACCENTURE__Category__c,count);
           }
           else  if (!result.containsKey(md.AIES_ACCENTURE__Key__c+md.AIES_ACCENTURE__Category__c))
           {
              result.put(md.AIES_ACCENTURE__Key__c+md.AIES_ACCENTURE__Category__c,md.AIES_ACCENTURE__value__c);
           }
       }
 
 system.debug('Result'+result.keySet()+'Values'+result.values());
 
 
 Map<String,Decimal> keyOrigin=new Map<String,Decimal>();
 
 for (String s:stackMonthList){
           
               for (String p:originPickList){ 
                
                keyOrigin.put(s+p,1);
                                                          
            }
           } 

system.debug('keyOrigin' + keyOrigin.keySet() + 'keyOrigin-Values' + keyOrigin.Values());


for(String fs:keyOrigin.KeySet()){
integer j=0;
if (result.containsKey(fs)){ 
  obj1.add(Util.createMetricData(fs.substring(0,8),Integer.ValueOf(result.get(fs)),fs.substring(8,fs.length()),metricMaster1,j));
  }
  else if (!result.containsKey(fs)) {
     obj1.add(Util.createMetricData(fs.substring(0,8),0,fs.substring(8,fs.length()),metricMaster1,j));
  }
j++;

}

system.debug('Final OBJ1'+ obj1 + 'Final Obj1 Size'+ obj1.size());

upsert obj1 AIES_ACCENTURE__External_Id__c; 



         }
       catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchService MyCRMJourney Metric', 'finish');
        }

  }
           
}