/*
Date: 18/11/2014
Author: Santosh Mohanty
Description: Apex class to create Metric Data Records for MYCRMJourney-Service Metrics
Version: v1.0
*/ 
global class BatchCaseCRMJourney_SM3 implements Database.Batchable<sObject>, Database.stateful{
        
       @TESTVISIBLE Date d00=Util.d00;
        @TESTVISIBLE Date d01=Util.d01;
        @TESTVISIBLE Date d02=Util.d02;
        @TESTVISIBLE Date d03=Util.d03;
        @TESTVISIBLE Date d04=Util.d04;
        @TESTVISIBLE Date d05=Util.d05;
        @TESTVISIBLE  Date d06=Util.d06;
        Date d07=Util.d07;
     String year1=Util.dateYear(d00);        
     List<Date> lsMonths = new List<Date>{d00,d01,d02,d03,d04,d05}; 
    // List <String> lsMonthNames=new List <String> {'JAN','FEB','MAR','APR','MAY','JUN','JULY','AUG','SEP','OCT','NOV','DEC'};  
     
     Map<String,integer>caseCreatedDateM1 =new Map<String,integer>();
     Map<String,Decimal>caseTimeDifference1 =new Map<String,Decimal>();
     Map<String,Set<id>> monthlyOwner1= new Map<String,Set<id>>();
     Set<id> ownerIds=new Set<id>(); 
     
     Map<String,integer>caseCreatedDateM2 =new Map<String,integer>();
     Map<String,Decimal>caseTimeDifference2 =new Map<String,Decimal>();
     Map<String,Set<id>> monthlyOwner2= new Map<String,Set<id>>();
     
     Map<String,integer>caseCreatedDateM3 =new Map<String,integer>();
     Map<String,Decimal>caseTimeDifference3 =new Map<String,Decimal>();
     Map<String,Set<id>> monthlyOwner3= new Map<String,Set<id>>(); 
       
     Decimal diffMonth1=1;
     Decimal diffMonth2=1;
     Decimal diffMonth3=1;
     Decimal diffMonth4=1;
     Decimal diffMonth5=1;
     Decimal diffMonth6=1;
     Decimal diffMonth7=1;
     Integer caseCount1=1;
     Integer caseCount2=1;
     Integer caseCount3=1;
     Integer caseCount4=1;
     Integer caseCount5=1;
     Integer caseCount6=1;
     Integer caseCount7=1;
     
     Decimal diffTask1=1;
     Decimal diffTask2=1;
     Decimal diffTask3=1;
     Decimal diffTask4=1;
     Decimal diffTask5=1;
     Decimal diffTask6=1;
     Integer taskCount1=1;
     Integer taskCount2=1;
     Integer taskCount3=1;
     Integer taskCount4=1;
     Integer taskCount5=1;
     Integer taskCount6=1;
     
     Decimal diffselfService1=1;
     Decimal diffselfService2=1;
     Decimal diffselfService3=1;
     Decimal diffselfService4=1;
     Decimal diffselfService5=1;
     Decimal diffselfService6=1;
     Integer countService1=1;
     Integer countService2=1;
     Integer countService3=1;
     Integer countService4=1;
     Integer countService5=1;
     Integer countService6=1;
                
        
     Decimal days,hours,minutes;       
 
      
    public Database.QueryLocator start(Database.BatchableContext BC)
    {                          
        String query = ' Select CreatedById,CreatedDate,ClosedDate,IsClosed,LastModifiedById, LastModifiedDate, '+
                       ' Origin,OwnerId from case where LastModifiedDate >= :d06';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC,list<Case> scope)
    {            
         
       /* Set<String> objectFields = Schema.SObjectType.Case.fields.getMap().keySet(); */
      Set<ID> caseIdSet = new Set<ID>();
      for(Case caseObj : scope){
      caseIdSet.add(caseObj.id);
      
      }
     
         for (Case cs: scope)
         {
             
             Date tempDate1 = util.chooseDate(cs.CreatedDate);  //case created 
             Date tempDate2 = util.chooseDate(cs.ClosedDate);   //case Closed
              if(tempDate1 !=null && tempDate2!=null && tempDate1.month() == d05.month() && tempDate2.month() ==d05.month())
               {
                     
                      diffMonth5 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference1.put(Util.monthName(d05),diffMonth5 ); 
                      ownerIds.add(cs.ownerId);
                      monthlyOwner1.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM1.put(Util.monthName(d05),caseCount5);
                      caseCount5 +=1; 
                
                
               /* if(objectFields.contains('IsSelfServiceClosed')) {                                         
                   if(cs.IsSelfServiceClosed==true){
                        
                    
                      diffselfService5 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference3.put(Util.monthName(d05),diffselfService5); 
                      Set<id> OwnerIdSelfService =new Set<id>();
                      OwnerIdSelfService .add(cs.ownerId);
                      monthlyOwner3.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM3.put(Util.monthName(d05),countService5);
                      countService5 +=1; 
                     }  
                   }*/             
               } 
               
           else if(tempDate1 !=null && tempDate2!=null && tempDate1.month() == d04.month() && tempDate2.month() ==d04.month())
               {
                    
                      diffMonth4 +=Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference1.put(Util.monthName(d04),diffMonth4 );
                      ownerIds.add(cs.ownerId);
                      monthlyOwner1.put(Util.monthName(d04),ownerIds);
                      caseCreatedDateM1.put(Util.monthName(d04),caseCount4);
                      caseCount4 +=1;     
                   
                 /*  if(objectFields.contains('IsSelfServiceClosed')) {
                      if(cs.IsSelfServiceClosed==true){
                        
                     
                      diffselfService4 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference3.put(Util.monthName(d05),diffselfService4); 
                      Set<id> OwnerIdSelfService =new Set<id>();
                      OwnerIdSelfService .add(cs.ownerId);
                      monthlyOwner3.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM3.put(Util.monthName(d05),countService4);
                      countService4 +=1; 
                     } 
                   }  */            
               } 
          else if(tempDate1 !=null && tempDate2!=null && tempDate1.month() == d03.month() && tempDate2.month() ==d03.month())
               { 
                     
                      diffMonth3 +=Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference1.put(Util.monthName(d03),diffMonth3 );
                      ownerIds.add(cs.ownerId);
                      monthlyOwner1.put(Util.monthName(d03),ownerIds);
                      caseCreatedDateM1.put(Util.monthName(d03),caseCount3);
                      caseCount3 +=1;  
                 
                /*  if(objectFields.contains('IsSelfServiceClosed')) {
                      if(cs.IsSelfServiceClosed==true){
                        
                      
                      diffselfService3 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference3.put(Util.monthName(d05),diffselfService3); 
                      Set<id> OwnerIdSelfService =new Set<id>();
                      OwnerIdSelfService .add(cs.ownerId);
                      monthlyOwner3.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM3.put(Util.monthName(d05),countService3);
                      countService3 +=1; 
                     }  
                   }  */             
               }   
               
          else if(tempDate1 !=null && tempDate2!=null && tempDate1.month() == d02.month() && tempDate2.month() ==d02.month())
               {
                     
                      diffMonth2 +=Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference1.put(Util.monthName(d02),diffMonth2);
                      ownerIds.add(cs.ownerId);
                      monthlyOwner1.put(Util.monthName(d02),ownerIds);
                      caseCreatedDateM1.put(Util.monthName(d02),caseCount2);
                      caseCount2 +=1; 
                      
                
                 /*  if(objectFields.contains('IsSelfServiceClosed')) {
                             
                      if(cs.IsSelfServiceClosed==true){
                        
                     
                      diffselfService2 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference3.put(Util.monthName(d05),diffselfService2); 
                      Set<id> OwnerIdSelfService =new Set<id>();
                      OwnerIdSelfService .add(cs.ownerId);
                      monthlyOwner3.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM3.put(Util.monthName(d05),countService2);
                      countService2 +=1; 
                     }
                    } */           
               }           
          else if(tempDate1 !=null && tempDate2!=null && tempDate1.month() == d01.month() && tempDate2.month() ==d01.month())
               {
                     
                      diffMonth1 +=Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference1.put(Util.monthName(d01),diffMonth1);
                      ownerIds.add(cs.ownerId);
                      monthlyOwner1.put(Util.monthName(d01),ownerIds);
                      caseCreatedDateM1.put(Util.monthName(d01),caseCount1);
                      caseCount1 +=1; 
                      
               
                /*   if(objectFields.contains('IsSelfServiceClosed')) {
                         
                      if(cs.IsSelfServiceClosed==true){
                        
                      
                      diffselfService1 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference3.put(Util.monthName(d05),diffselfService1); 
                      Set<id> OwnerIdSelfService =new Set<id>();
                      OwnerIdSelfService .add(cs.ownerId);
                      monthlyOwner3.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM3.put(Util.monthName(d05),countService1);
                      countService1 +=1; 
                     } 
                    }   */            
               }  
           
          else if(tempDate1 !=null && tempDate2!=null && tempDate1.month() == d00.month() && tempDate2.month() == d00.month())
               {
                     
                      diffMonth6 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference1.put(Util.monthName(d00),diffMonth6 );
                      ownerIds.add(cs.ownerId);
                      monthlyOwner1.put(Util.monthName(d00),ownerIds);
                      caseCreatedDateM1.put(Util.monthName(d00),caseCount6);
                      caseCount6 +=1;    
                                          
                 
                /*   if(objectFields.contains('IsSelfServiceClosed')) {
                      if(cs.IsSelfServiceClosed==true){                        
                     
                      diffselfService6 += Util.SubtractDate(cs.ClosedDate,cs.CreateDdate);
                      caseTimeDifference3.put(Util.monthName(d05),diffselfService6); 
                      Set<id> OwnerIdSelfService =new Set<id>();
                      OwnerIdSelfService .add(cs.ownerId);
                      monthlyOwner3.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM3.put(Util.monthName(d05),countService6);
                      countService6 +=1; 
                     }
                   }     */       
               } 
            }                
           
  for (Task t:[select id,whoid,whatid,createddate,lastmodifieddate,ownerid from task where what.type = 'Case' and whatid in : caseIdSet ]){
              
             Date tempTaskDate1 = util.chooseDate(t.CreatedDate);   //Task created 
             Date tempTaskDate2 = util.chooseDate(t.LastmodifiedDate);

if(tempTaskDate1 !=null && tempTaskDate2!=null && tempTaskDate1.month() == d05.month() && tempTaskDate2.month() == d05.month()){
                  
                      diffTask5 += Util.SubtractDate(t.LastModifiedDate,t.CreatedDate);
                      caseTimeDifference2.put(Util.monthName(d05),diffTask5); 
                      Set<id> taskOwnerIds=new Set<id>();
                      taskOwnerIds.add(t.ownerId);
                      monthlyOwner2.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM2.put(Util.monthName(d05),taskCount5 );
                      taskCount5 +=1;            
             }
            else if(tempTaskDate1 !=null && tempTaskDate2!=null && tempTaskDate1.month() == d04.month() && tempTaskDate2.month() == d04.month()){
             
                      diffTask4 += Util.SubtractDate(t.LastModifiedDate,t.CreatedDate);
                      caseTimeDifference2.put(Util.monthName(d05),diffTask4); 
                      Set<id> taskOwnerIds=new Set<id>();
                      taskOwnerIds.add(t.ownerId);
                      monthlyOwner2.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM2.put(Util.monthName(d05),taskCount4);
                      taskCount4 +=1;
             }
             
          else if(tempTaskDate1 !=null && tempTaskDate2!=null && tempTaskDate1.month() == d03.month() && tempTaskDate2.month() == d03.month()){
                     
                      diffTask3 += Util.SubtractDate(t.LastModifiedDate,t.CreatedDate);
                      caseTimeDifference2.put(Util.monthName(d05),diffTask3); 
                      Set<id> taskOwnerIds=new Set<id>();
                      taskOwnerIds.add(t.ownerId);
                      monthlyOwner2.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM2.put(Util.monthName(d05),taskCount3);
                      taskCount3 +=1;                          
             }
             
           else if(tempTaskDate1 !=null && tempTaskDate2!=null && tempTaskDate1.month() == d02.month() && tempTaskDate2.month() == d02.month()){
                       
                      diffTask2 += Util.SubtractDate(t.LastModifiedDate,t.CreatedDate);
                      caseTimeDifference2.put(Util.monthName(d05),diffTask2); 
                      Set<id> taskOwnerIds=new Set<id>();
                      taskOwnerIds.add(t.ownerId);
                      monthlyOwner2.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM2.put(Util.monthName(d05),taskCount2);
                      taskCount2 +=1;         
            }
            
           else if(tempTaskDate1 !=null && tempTaskDate2!=null && tempTaskDate1.month() == d01.month() && tempTaskDate2.month() == d01.month()){
                       
                      diffTask1 += Util.SubtractDate(t.LastModifiedDate,t.CreatedDate);
                      caseTimeDifference2.put(Util.monthName(d05),diffTask1); 
                      Set<id> taskOwnerIds=new Set<id>();
                      taskOwnerIds.add(t.ownerId);
                      monthlyOwner2.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM2.put(Util.monthName(d05),taskCount1);
                      taskCount1 +=1;       
            }
            
          else if(tempTaskDate1 !=null && tempTaskDate2!=null && tempTaskDate1.month() == d00.month() && tempTaskDate2.month() == d00.month()){
                       
                      diffTask6 += Util.SubtractDate(t.LastModifiedDate,t.CreatedDate);
                      caseTimeDifference2.put(Util.monthName(d05),diffTask6); 
                      Set<id> taskOwnerIds=new Set<id>();
                      taskOwnerIds.add(t.ownerId);
                      monthlyOwner2.put(Util.monthName(d05),ownerIds);
                      caseCreatedDateM2.put(Util.monthName(d05),taskCount6);
                      taskCount6 +=1;       
            }
             
           } 
           }                                                             
      
    
    public void finish(Database.BatchableContext BC)
    { 
          
      try
        {
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('SerM_AvgCloseTimeTrendPerRep');            
            Integer sortOrder = 1;   
                
          for(Date d:lsMonths){
          
                Decimal finalTimeDifference = 0.0;
                Decimal avgTimeToResolve=0.0;
                integer finalCaseCount;
                Integer finalUsersCount;
                           
            if(caseCreatedDateM1.containsKey(Util.MonthName(d)))
               {
 
                        finalCaseCount= caseCreatedDateM1.get(Util.MonthName(d));
                        finalUsersCount= monthlyOwner1.get(Util.MonthName(d)).size();
                        finalTimeDifference = caseTimeDifference1.get(Util.MonthName(d));                 
                        avgTimeToResolve=(finalTimeDifference/finalUsersCount)/finalUsersCount;                
                }       
            else {
                    avgTimeToResolve=0;
                 }         
                obj.add(Util.createMetricData(Util.MonthName(d),avgTimeToResolve, metricMaster1 , sortOrder ));
                sortOrder ++;
            } 
            upsert obj AIES_ACCENTURE__External_Id__c;
        }
        
        
        
        
        catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }
  
  /* Logic: Avg call handing time per case per user*/  
  
       try
        {
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('SerM_AvgTaskResolutionTimePerCase');            
            Integer sortOrder = 1;   
                
          for(Date d:lsMonths){
          
                Decimal finalTimeDifferenceTask = 0.0;
                Decimal avgTimeToResolve=0.0;
                integer finalCaseCount;
                integer finalTaskCount;
                Integer finalUsersCount;
                           
            if(caseCreatedDateM2.containsKey(Util.MonthName(d)))
               {
 
                        finalCaseCount= caseCreatedDateM1.get(Util.MonthName(d));
                        finalTaskCount= caseCreatedDateM2.get(Util.MonthName(d));
                        finalUsersCount= monthlyOwner2.get(Util.MonthName(d)).size();
                        finalTimeDifferenceTask = caseTimeDifference2.get(Util.MonthName(d));                
                        avgTimeToResolve=(finalTimeDifferenceTask / finalTaskCount)/finalCaseCount;                
                }       
            else {
                    avgTimeToResolve=0;
                 }         
                obj.add(Util.createMetricData(Util.MonthName(d),avgTimeToResolve, metricMaster1 , sortOrder ));
                sortOrder ++;
            } 
            upsert obj AIES_ACCENTURE__External_Id__c;
        }
        
        
        
        
        catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }
      
  /* Cases Deflected through Self Service Portal */
  
       try
        {
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('SerM_CaseThroughSelfService');            
            Integer sortOrder = 1;   
                
          for(Date d:lsMonths){
          
                integer finalServiceCount=1;
                integer finalCaseCount=1;
                Decimal percentage=0.0;
                           
            if(caseCreatedDateM3.containsKey(Util.MonthName(d)))
               {
 
                        finalServiceCount= caseCreatedDateM3.get(Util.MonthName(d));
                        finalCaseCount = caseCreatedDateM1.get(Util.MonthName(d));
                       // finalTimeDifference = caseTimeDifference1.get(Util.MonthName(d));                 
                        percentage=(finalServiceCount/finalCaseCount ) * 100;                
                }       
            else {
                    percentage=0;
                 }         
                obj.add(Util.createMetricData(Util.MonthName(d),percentage, metricMaster1 , sortOrder ));
                sortOrder ++;
            } 
            upsert obj AIES_ACCENTURE__External_Id__c;
        }
        
        
        
        
        catch(exception e)            
        {
            System.Debug('Exception Occured');
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }    
        
    }
          
            
}