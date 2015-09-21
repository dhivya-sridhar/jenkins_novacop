/*
Date: 20/11/2014
Author: Santosh Mohanty
Description: 
Version: v1.0
*/ 
global class BatchCaseCRMJourney_SM2 implements Database.Batchable<sObject>, Database.stateful{
        
        @TESTVISIBLE Date d00=Util.d00;
        @TESTVISIBLE Date d01=Util.d01;
        @TESTVISIBLE Date d02=Util.d02;
        @TESTVISIBLE Date d03=Util.d03;
        @TESTVISIBLE Date d04=Util.d04;
        @TESTVISIBLE Date d05=Util.d05;
        Date d06=Util.d06;
        
        String year=Util.dateYear(d00);
        
    List<Date> lsMonths = new List<Date>{d00,d01,d02,d03,d04,d05};
    List <String> lsMonthNames=new List <String> {'JAN','FEB','MAR','APR','MAY','JUN','JULY','AUG','SEP','OCT','NOV','DEC'};    
    set<string> monthYear=new Set<string>();
       
    Map<string,set<id>> count=new Map<string,set<id>>();
    Map<string,set<id>> casecountSLA  =new Map<string,set<id>>();
    set<id> setSLA=new set<id>();
    Map<string,Set<id>> totalCount=new Map<string,Set<id>>();
    Set<id> totalCases=new set<id>(); 
    
    Integer totalCaseCount=0;
    Integer defaultCont=0;
      
   public Database.QueryLocator start(Database.BatchableContext BC)
    
    {
         String query=' Select id,lastmodifieddate,createddate,IsEscalated,(select whatid,whoid,id ,createddate,lastmodifieddate,isclosed from Tasks ) ' +
                      ' from Case where lastmodifieddate>=: d06';         
            return Database.getQueryLocator(query);
      }      
    public void execute(Database.BatchableContext BC,list<Case> scope)
    {    
      try  {
             
         for (Case cs:scope){
             totalCaseCount +=1;
             Date tempDate1 = util.chooseDate(cs.lastModifiedDate);          
             set<id> caseIDSet=new set<id>();
             
             if(cs.Tasks.size()>0){
             
              for(Task t: cs.Tasks ){
                 sYSTEM.debug(tempDate1 +'sss'+d05);                                          
               if(tempDate1 !=null && tempDate1.month() ==d05.month())                    
                      {  
                        system.debug('******5******');
                        caseIDSet.add(t.whatid);
                        count.put(util.monthName(tempDate1),caseIDSet); 
                                               
                     }
                   else if(tempDate1 !=null && tempDate1.month()== d04.month())                   
                     {
                     system.debug('******6******');                     
                        caseIDSet.add(t.whatid);
                        count.put(util.monthName(tempDate1),caseIDSet); 
                     }
                     else if(tempDate1 !=null && tempDate1.month()==d03.month())
                     {
                     system.debug('******7******');
                        caseIDSet.add(t.whatid);
                        count.put(util.monthName(tempDate1),caseIDSet); 
                     }
                     else if(tempDate1 !=null && tempDate1.month()==d02.month())
                     {
                     system.debug('******8******');
                         caseIDSet.add(t.whatid);
                        count.put(util.monthName(tempDate1),caseIDSet); 
                     } 
                     else if(tempDate1 !=null && tempDate1.month()==d01.month())
                     {
                     system.debug('******9******');
                        caseIDSet.add(t.whatid);
                        count.put(util.monthName(tempDate1),caseIDSet); 
                     }
                     else if (tempDate1 !=null && tempDate1.month()==d00.month())
                     {
                     system.debug('******10******');
                         caseIDSet.add(t.whatid);
                        count.put(util.monthName(tempDate1),caseIDSet); 
                     }
                   
                else{
                   
                   //caseIDSet.add(t.whatid);
                   //count.put(util.monthName('Nov-14'),caseIDSet);
                   //count.put('Nov-14',caseIDSet);        
                   //do nothing 
                  }                                
                }
             
             
                
                }
    /*  start- logic to calculate cases within SLA*/  
          
          if(tempDate1 !=null && tempDate1.month() ==d05.month())                    
             {
             
               
               totalCases.add(cs.id);
               totalCount.put(util.monthName(tempDate1),totalCases);
               if(cs.isEscalated==false)
           
               {
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                      
               }
              } 
          else if (tempDate1 !=null && tempDate1.month() ==d04.month()){
          
               totalCases.add(cs.id);
               totalCount.put(util.monthName(tempDate1),totalCases);
               if(cs.isEscalated==false)
           
               {
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                      
               }
          
          } 
          
          else if (tempDate1 !=null && tempDate1.month() ==d03.month()){
          
               totalCases.add(cs.id);
               totalCount.put(util.monthName(tempDate1),totalCases);
               if(cs.isEscalated==false)
           
               {
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                      
               }
          
          } 
          
          else if (tempDate1 !=null && tempDate1.month() ==d02.month()){
          
               totalCases.add(cs.id);
               totalCount.put(util.monthName(tempDate1),totalCases);
               if(cs.isEscalated==false)
           
               {
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                      
               }
          
          } 
          
          else if (tempDate1 !=null && tempDate1.month() ==d01.month()){
          
               totalCases.add(cs.id);
               totalCount.put(util.monthName(tempDate1),totalCases);
               if(cs.isEscalated==false)
           
               {
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                      
               }
          
          } 
          
          else if (tempDate1 !=null && tempDate1.month() ==d00.month()){
          
               totalCases.add(cs.id);
               totalCount.put(util.monthName(tempDate1),totalCases);
               if(cs.isEscalated==false)
           
               {
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                      
               }
          
          } 
          
       
    
          /* if(cs.isEscalated==false)
           
           {
                if(tempDate1 !=null && tempDate1.month() ==d05.month())                    
                      { 
                        setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                       }  
                else if (tempDate1 !=null && tempDate1.month() ==d04.month()){
                          setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);                          
                       }
                else if (tempDate1 !=null && tempDate1.month() ==d03.month()){
                          setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);                          
                       }
                else if (tempDate1 !=null && tempDate1.month() ==d02.month()){
                          setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);                          
                       } 
                else if (tempDate1 !=null && tempDate1.month() ==d00.month()){
                          setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);                          
                       }
                else if (tempDate1 !=null && tempDate1.month() ==d00.month()){
                          setSLA.add(cs.id);
                        casecountSLA.put(util.monthName(tempDate1),setSLA);
                                                  
                       } 
                                        
           }*/
    
    /* End - Case within SLA */         
                
         } 
       }
        catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }  
    }
    public void finish(Database.BatchableContext BC)
    {
    try{
            system.debug('Count Data:'+count.Values());
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('SerM_ClosedFirstResponse');            
            Integer sortOrder = 1;
            Decimal createdpercent= 0.0;  
                                
            for(string org:count.keyset()){
            
            createdpercent= count.get(org).size();
            obj.add(Util.createMetricData(org,createdpercent, metricMaster1 , sortOrder ));
            sortOrder ++;                            
            }
         system.debug('MetricDataSize:'+ obj.size());
         upsert obj AIES_ACCENTURE__External_Id__c;   
      }
      
      catch(exception e)            
        {
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }
        
    /*  Finish Method for Cases Closed within SLA*/
    
       try{
            system.debug('Count Data:'+count.Values());
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            AIES_ACCENTURE__AIESMetricMaster__c metricMaster1 = Util.getMetricMaster('SerM_CasesClosedWithinSLA');            
            Integer sortOrder = 1;
            Decimal totalSLACount=0.0 ;
            Decimal count1=1;
            Decimal percentage=0.0;   
            
            //monthYear.add(casecountSLA.keyset());                                      
            for(Date d:lsMonths){

             
               if(casecountSLA.containsKey(Util.monthName(d)))
               {

                 count1= totalCount.get(Util.monthName(d)).size();
                 totalSLACount=casecountSLA.get(Util.monthName(d)).size() ;
                 percentage= (totalSLACount/count1) * 100 ;                               
                                                        
                 
              }
               
               else 
               {
                 percentage=0.0;
                    
               }  
             obj.add(Util.createMetricData(Util.monthName(d),percentage, metricMaster1 , sortOrder ));              
             sortOrder ++;  
            }
         system.debug('MetricDataSize:'+ obj.size());
         upsert obj AIES_ACCENTURE__External_Id__c;   
      }
      
      catch(DMLexception e)     
             
        {   
            util.exceptionHandler(e, 'BatchServiceCaseMetric', 'finish');
        }    
        
    }
        
}