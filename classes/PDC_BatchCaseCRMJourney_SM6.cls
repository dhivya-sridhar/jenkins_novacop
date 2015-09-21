global class PDC_BatchCaseCRMJourney_SM6 implements Database.Batchable<sObject>, Database.stateful{

@TESTVISIBLE Date d00=Util.d00;
        @TESTVISIBLE Date d01=Util.d01;
        @TESTVISIBLE Date d02=Util.d02;
        @TESTVISIBLE Date d03=Util.d03;
        @TESTVISIBLE Date d04=Util.d04;
        @TESTVISIBLE Date d05=Util.d05;
        @TESTVISIBLE Date d06=Util.d06;       
public List<string> MonthList=new List<String>{Util.MonthName(d00),Util.MonthName(d01),Util.MonthName(d02),Util.MonthName(d03),Util.MonthName(d04),Util.MonthName(d05)};
public static Map<Integer,String> MonthMap=new Map<Integer,String>{1=> 'JAN',2=> 'FEB',3=> 'MAR',4=> 'APR',5=> 'MAY',6=> 'JUN',7=> 'JUL',8=> 'AUG',9=> 'SEP',10=> 'OCT',11=> 'NOV',12=> 'DEC' };
//public integer currentYear=Util.drillYear(Util.d00);
//public integer prevYear=Util.drillYear(Util.d00)-1;

Public Map<String,Decimal> closedCountMap=new Map<String,Decimal>();        
Public Map<String,Decimal> openCountMap=new Map<String,Decimal>();
 
   
public Database.QueryLocator start(Database.BatchableContext BC)
    {                          
         String query='select id,CreatedDate,lastModifiedDate,Origin,OwnerId,ClosedDate '+ 
                     ' from case where (CreatedDate>=:d06 and CreatedDate<=:d00) OR (ClosedDate>=:d06 and ClosedDate<=:d00)';
        return Database.getQueryLocator(query);
    }
public void execute(Database.BatchableContext BC,list<case> scope)
    {      
    
   try {      
     
      Integer i=0;
      
      Set<id> caseIDsSet=new Set<Id>();
      for (Case c:scope){
        caseIDsSet.add(c.id);
      }
  
  for (AggregateResult ar:[select Calendar_Month(ClosedDate) monthNumber,Calendar_Year(ClosedDate) closedYear,count(id) recordCount from case where isclosed=true
                                and id IN:caseIDsSet and ClosedDate>=:d06 and ClosedDate<=:d00 group by Calendar_Month(ClosedDate),Calendar_Year(ClosedDate) Order by Calendar_Month(ClosedDate)])
           { 
             
         
         system.debug('closed year'+(Integer)ar.get('closedYear'));      
             i++;               
             
                               
             Decimal dec00=(closedCountMap.get(MonthMap.get((Integer)ar.get('monthNumber'))+'-'+(Integer)ar.get('closedYear'))!=null ? closedCountMap.get(MonthMap.get((Integer)ar.get('monthNumber'))+'-'+(Integer)ar.get('closedYear')) : 0);
             Decimal dec01=dec00+((Decimal)ar.get('recordCount') !=null ? (Decimal)ar.get('recordCount') : 0);
             closedCountMap.put(MonthMap.get((Integer)ar.get('monthNumber'))+'-'+(Integer)ar.get('closedYear'),dec01);
               
               
               
           }
        
  for (AggregateResult ar:[select Calendar_Month(createdDate) monthNumber,Calendar_Year(createdDate) createdYear , count(id) recordCount from case where
                                isClosed=false and ID IN:caseIDsSet and createdDate>=:d06 and createdDate<=:d00 group by Calendar_Month(createdDate),Calendar_Year(createdDate) Order by Calendar_Month(createdDate)])
           { 
             i++;               
              
              
         system.debug('created year'+(Integer)ar.get('createdYear'));      
                           
           Decimal dec00=(openCountMap.get(MonthMap.get((Integer)ar.get('monthNumber'))+'-'+(Integer)ar.get('createdYear'))!=null ? openCountMap.get(MonthMap.get((Integer)ar.get('monthNumber'))+'-'+(Integer)ar.get('createdYear')) : 0);
           Decimal dec01=dec00+((Decimal)ar.get('recordCount')!=null ? (Decimal)ar.get('recordCount') : 0);
           openCountMap.put(MonthMap.get((Integer)ar.get('monthNumber'))+'-'+(Integer)ar.get('createdYear'),dec01);
            

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
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('ASD_Service_Metric_Case_Closure');
       
       
       Decimal closeRate=0.0;
       
    for (String s:MonthList){
          Integer j=0;
          system.debug('Key Exists - (True/False)'+openCountMap.containsKey(s));
          system.debug('Open Count Size'+openCountMap.size());
          
          system.debug('Closed Count Key Sets '+ openCountMap.keySet());
             if (openCountMap.containsKey(s) && openCountMap.size()>0 && closedCountMap.containsKey(s))
                {  
                  system.debug('Inside If Key Exists - (True/False)'+openCountMap.containsKey(s));
                  system.debug('Inside If Open Count Size'+openCountMap.size());
                  
                    system.debug('If Loop Started Inside Finish Method');
                    j++;
                    
                    closeRate= (closedCountMap.get(s)/openCountMap.get(s))*100;
                    obj.add(Util.createMetricData(s,closeRate,metricMaster1,j));
                }
             else if (!openCountMap.containsKey(s)){
             
               system.debug('Inside Else If Key Exists - (True/False)'+openCountMap.containsKey(s));
               system.debug('Inside Else If Open Count Size'+openCountMap.size());
                   system.debug(' Else If Loop Started Inside Finish Method');
                    j++;
                    obj.add(Util.createMetricData(s,0.0,metricMaster1,j));
             }           
           }
  upsert obj AIES_ACCENTURE__External_Id__c;
        }
        catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }
    }
 
}