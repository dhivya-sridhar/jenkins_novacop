/*************************************************************************************************************************************
Date        : 03.07.2014
Author      : Dorai Raj
Class Name  : BatchOpportunityMetric
Description : Apex class to analyse Opportunity object and populate metric data with month on month data (last 6months) for the below reports
Version     : v0.3
Reports     : Marketing Metrics: Total Opp Created
                            # Won Opp
                            # Lost Opp
                            % Win Rate
                            % Win Rate Improvement
                            % Opp Win Rate Improvement
                            % Lead Converstion Rate Increase
                            Opportunity Aging Trend
/*************************************************************************************************************************************/

global class BatchOpportunityMetric implements Database.Batchable<sObject>, Database.stateful
{
    @TestVisible String totOpp   = 'totalOpportunities';
    String wonOpp   = 'wonOpportunities';
    String lostOpp  = 'lostOpportunities';
    String aging    = 'agingDays';
    String winRate  = 'winRate';
    
    String winRateImprovement = 'winRateImprovement';
    
    map<Date,Integer> winOpp = new map<Date,Integer>();
    map<Date,Integer> lossOpp = new map<Date,Integer>();
    
   @TestVisible Date Age_d0=Util.d00;
   @TestVisible Date Age_d1=Util.d01;
   @TestVisible Date Age_d2=Util.d02;
   @TestVisible Date Age_d3=Util.d03;
   @TestVisible Date Age_d4=Util.d04;
   @TestVisible Date Age_d5=Util.d05;
   @TestVisible Date Age_d6=Util.d06;
   
   //List<AIES_ACCENTURE__Log__c> logs=new List<AIES_ACCENTURE__Log__c>();
                 
    List<Date> months = new List<Date>{Age_d1,Age_d2,Age_d3,Age_d4,Age_d5,Age_d6};
    map<Date,map<string,integer>> countMap= new map<Date,map<string, Integer>>();
    
      Map<String,Integer> monthsMap=new Map<String,Integer>{Util.monthName(Age_d1) => 0,Util.monthName(Age_d1) => 0,Util.monthName(Age_d3) => 0,Util.monthName(Age_d4) => 0,Util.monthName(Age_d5) => 0,Util.monthName(Age_d6) => 0};    
    Set<String> monthsSet=new Set<String>{Util.monthName(Age_d1),Util.monthName(Age_d2),Util.monthName(Age_d3),Util.monthName(Age_d4),Util.monthName(Age_d5),Util.monthName(Age_d6)};
    map<integer,string> mapQuarter  = new map< Integer,string>{3 => 'Q1', 6 =>'Q2', 9 =>'Q3', 12=>'Q4'};
    map<Date,integer> agingbymonth  = new map<Date,integer>{Age_d1 => 0, Age_d2 => 0, Age_d3 => 0, Age_d4 => 0, Age_d5 => 0, Age_d6 => 0} ;
    map<Date,integer> countbymonth  = new map<Date,integer>{Age_d1 => 0, Age_d2 => 0, Age_d3 => 0, Age_d4 => 0, Age_d5 => 0, Age_d6 => 0} ;
 
    Date dt = date.today();
    Integer currentMnt =dt.month();
    Integer currentQ =((currentMnt-1)/3) + 1;
    // this will give the end of previous quarter
    Date d0 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -2)*3))) , 1).addDays(-1); 
    Date d1 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -3)*3))) , 1).addDays(-1);
    Date d2 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -4)*3))) , 1).addDays(-1);
    Date d3 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -5)*3))) , 1).addDays(-1);
    Date d4 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -6)*3))) , 1).addDays(-1);
    Date d5 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -7)*3))) , 1).addDays(-1);
    Date d6 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -8)*3))) , 1).addDays(-1);
    // this will give the end of current quarter
    Date d7 = date.newInstance(dt.year(),currentMnt + (4 - (currentMnt - ((currentQ -1)*3))) , 1).addDays(-1);
    
    List<Date> quarters = new List<Date>{d0,d1,d2,d3,d4,d5}; 
    List<Date> quarter  = new List<Date>{d7,d0,d1,d2,d3,d4,d5,d6};//Please note we are not displaying data for Current Quarter
//    quarter[0] = d7; // 2015-04-10
  //  quarter[1] = d0; // 2015-03-31
    map<string, decimal> valueBySource = new map<string, decimal>();

    public Database.QueryLocator start(Database.BatchableContext BC){
        try{
            for(date currentDate : quarters){
        
                map<String, Integer> n = new map<String, Integer>{totOpp => 0, wonOpp => 0, lostOpp => 0, winRate => 0, aging => 0, winRateImprovement => 0 };
        
                countMap.put(currentDate, n);
                winOpp.put(currentDate,0);
                lossOpp.put(currentDate,0);
            }
        }catch(exception e){
            util.exceptionHandler(e, 'BatchOpportunityMetric', 'start');
        }      
        
        String query = 'select stagename, createddate, closedate, leadSource, amount ,IsClosed , IsWon from opportunity where createddate >= :d6 and createddate <:d0';// createddate > :d2 and createddate <= :d0
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<opportunity> scope){      
        try{    
            for(opportunity s : scope){
                //if(s.createddate < d0 && s.createddate >= d1){ /*For example -d0 =2014-12-31 00:00:00 & d1=2014-06-30 00:00:00,we need to include 31st Dec*/
                if(s.createddate <= d0 && s.createddate > d1){
//                 <=2015-03-31 00:00:00 && >2014-12-31 00:00:00
                    calc(s,d0);         
                //}else if(s.createddate < d1 && s.createddate >= d2){
                }else if(s.createddate <= d1 && s.createddate > d2){    
                    calc(s,d1);             
                //}else if(s.createddate < d2 && s.createddate >= d3){
                }else if(s.createddate <= d2 && s.createddate > d3){    
                    calc(s,d2);             
                //}else if(s.createddate < d3 && s.createddate >= d4){
                }else if(s.createddate <= d3 && s.createddate > d4){    
                    calc(s,d3);         
                //}else if(s.createddate < d4 && s.createddate >= d5){
                }else if(s.createddate <= d4 && s.createddate > d5){    
                    calc(s,d4); 
                }
        // new win/loss rate calculation method
        calcCloseDate(s);
        }
    
        for(opportunity s : scope){ 
                  System.debug(s.createddate+'aaaa'+Age_d1+'bbbbb'+Age_d0);  
            if(s.createddate < Age_d0  && s.createddate >= Age_d1){
                /*
                countbymonth.put(Age_d0,countbymonth.get(Age_d0)+1);   
                agingbymonth.put(Age_d0, agingbymonth.get(Age_d0) + ( s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));
                */
                countbymonth.put(Age_d1,countbymonth.get(Age_d1)+1);   
                agingbymonth.put(Age_d1, agingbymonth.get(Age_d1) + ( s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));               
    
            }else if(s.createddate < Age_d1 && s.createddate >= Age_d2){
/*              
                countbymonth.put(Age_d1,countbymonth.get(Age_d1)+1); 
                agingbymonth.put(Age_d1, agingbymonth.get(Age_d1) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));   
*/              
                countbymonth.put(Age_d2,countbymonth.get(Age_d2)+1); 
                agingbymonth.put(Age_d2, agingbymonth.get(Age_d2) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));                
    
            }else if(s.createddate < Age_d2 && s.createddate >= Age_d3){
/*                countbymonth.put(Age_d2,countbymonth.get(Age_d2)+1); 
                agingbymonth.put(Age_d2, agingbymonth.get(Age_d2) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate))); 
*/              
                countbymonth.put(Age_d3,countbymonth.get(Age_d3)+1); 
                agingbymonth.put(Age_d3, agingbymonth.get(Age_d3) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));                
    
            }else if(s.createddate < Age_d3 && s.createddate >= Age_d4){
/*                countbymonth.put(Age_d3,countbymonth.get(Age_d3)+1); 
                agingbymonth.put(Age_d3, agingbymonth.get(Age_d3) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));
*/              
                countbymonth.put(Age_d4,countbymonth.get(Age_d4)+1); 
                agingbymonth.put(Age_d4, agingbymonth.get(Age_d4) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));                
    
            }else if(s.createddate < Age_d4 && s.createddate >= Age_d5){
/*                countbymonth.put(Age_d4,countbymonth.get(Age_d4)+1); 
                agingbymonth.put(Age_d4, agingbymonth.get(Age_d4) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));
*/              
                countbymonth.put(Age_d5,countbymonth.get(Age_d5)+1); 
                agingbymonth.put(Age_d5, agingbymonth.get(Age_d5) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));                
    
            //}else if(s.createddate < Age_d5){
            }else if(s.createddate < Age_d5 && s.createddate >= Age_d6){    
/*              countbymonth.put(Age_d5,countbymonth.get(Age_d5)+1); 
                agingbymonth.put(Age_d5, agingbymonth.get(Age_d5) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate))); 
*/              
                countbymonth.put(Age_d6,countbymonth.get(Age_d6)+1); 
                agingbymonth.put(Age_d6, agingbymonth.get(Age_d6) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));                
            }
                
            if(s.amount != null){
                if(valueBySource.containsKey(s.leadSource)) {
                    valueBySource.put(s.leadSource, valueBySource.get(s.leadSource)+ s.amount);
                }
                else {
                    valueBySource.put(s.leadSource, s.amount);
                }  
            }   
        }
        }catch(exception e){
            util.exceptionHandler(e, 'BatchOpportunityMetric', 'execute');
        }
    }
   
    public void finish(Database.BatchableContext BC){
   
        try{ 
        
           integer i=1;
             String currentYear= String.ValueOf(Util.drillYear(Age_d0));
             String prevYear=String.ValueOf(Util.drillYear(Age_d0)-1);
                
             System.debug('CurrentYear'+currentYear+'PrevYear'+prevYear);
                 
             decimal prevYearCount=0.0;
             decimal prevYearDivision=0.0;
             decimal prevYearDivisionQ1=0.0;
             decimal prevYearcountQ1=0.0;
             Decimal prevYearCountQ11=0.0;
             decimal prevYearDivisionQ2=0.0;
             decimal prevYearcountQ2=0.0;
             Decimal prevYearCountQ22=0.0;
             decimal prevYearDivisionQ3=0.0;
             decimal prevYearcountQ3=0.0;
             Decimal prevYearCountQ33=0.0;
             decimal prevYearDivisionQ4=0.0;
             decimal prevYearcountQ4=0.0;
             Decimal prevYearCountQ44=0.0;
             
             decimal currentYearCount=0.0;
             decimal currentYearDivision=0.0;
             decimal currentYearDivisionQ1=0.0;
             decimal currentYearcountQ1=0.0;
             Decimal currentYearCountQ11=0.0;
             decimal currentYearDivisionQ2=0.0;
             decimal currentYearcountQ2=0.0;
             Decimal currentYearCountQ22=0.0;
             decimal currentYearDivisionQ3=0.0;
             decimal currentYearcountQ3=0.0;
             Decimal currentYearCountQ33=0.0;
             decimal currentYearDivisionQ4=0.0;
             decimal currentYearcountQ4=0.0;
             Decimal currentYearCountQ44=0.0;
     
            for(Date d: quarters){
            
                map<string, Integer> monthRec= countmap.get(d);
                
                if(monthRec.get(totOpp) != 0){
                    monthRec.put(aging,monthRec.get(aging)/monthRec.get(totOpp));   
                    monthRec.put(winRate,((monthRec.get(wonOpp)*100)/monthRec.get(totOpp)));   
                }   
            }
           
        AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>();
        AIES_ACCENTURE__AIESMetricMaster__c m   = Util.getMetricMaster('BSM_Total_Opportunities');
            
            for(integer count1 = 1; count1<=4 ; count1++){ 
            
            system.debug('@@@###'+countmap.get(quarter[count1]).get(totOpp));                    
                obj.add(Util.createMetricData(string.valueof(MapQuarter.get(quarter[count1].month())) + ' '+ string.valueof(quarter[count1].year()),  countmap.get(quarter[count1]).get(totOpp), m, count1));
        /*logs.add(new Log__c(
                        Name =  'Total oportunities ' ,
                        Class_Name__c = 'BatchOpportunityMetric',
                        Error_Description__c = 'string.valueof(MapQuarter.get(quarter[count].month()))='+string.valueof(MapQuarter.get(quarter[count].month()))+
                        '#string.valueof(quarter[count].year())='+string.valueof(quarter[count].year())+
                        '#countmap.get(quarter[count]).get(totOpp)='+countmap.get(quarter[count]).get(totOpp)+
                        '#count='+ count,
                        Portfolio_Name__c = Util.Portfolio,
                        Line_Number__c = 0
                        ));         */        
            }
            

        // the next 4 metrics ignores the current quarter and calculates for the last 4 quarter  
        AIES_ACCENTURE__AIESMetricMaster__c m1 = Util.getMetricMaster('BSM_Won_Opportunity');
            for(integer count = 1; count<=4 ; count++){//
                obj.add(Util.createMetricData(string.valueof(MapQuarter.get(quarter[count].month())) + ' '+ string.valueof(quarter[count].year()),  winOpp.get(quarter[count]), m1, count));
            }           
 
        AIES_ACCENTURE__AIESMetricMaster__c m2 = Util.getMetricMaster('BSM_Lost_Opportunity');
            for(integer count = 1; count<=4 ; count++){
                obj.add(Util.createMetricData(string.valueof(MapQuarter.get(quarter[count].month())) + ' '+ string.valueof(quarter[count].year()),  lossOpp.get(quarter[count]), m2, count));
            }   
            
        AIES_ACCENTURE__AIESMetricMaster__c m3 = Util.getMetricMaster('BSM_Win_Rate');
            for(integer count = 1; count<=4 ; count++){
                Decimal winRate;
            
                if((decimal.valueOf(winOpp.get(quarter[count])) + (decimal.valueOf(lossOpp.get(quarter[count])))) > 0) {
                    
                    /* We r multiplying denominator with 100
                    winRate = (decimal.valueOf(winOpp.get(quarter[count1])) / ((decimal.valueOf(winOpp.get(quarter[count1])) + decimal.valueOf(lossOpp.get(quarter[count1])))) * 100);
                    */
                    
                    winRate = (decimal.valueOf(winOpp.get(quarter[count])) * 100) / ((decimal.valueOf(winOpp.get(quarter[count])) + decimal.valueOf(lossOpp.get(quarter[count])))) ; //Updated formula                  
                }else{
                
                    winRate = 0;                
                }
            
                obj.add(Util.createMetricData(string.valueof(MapQuarter.get(quarter[count].month())) + ' '+ string.valueof(quarter[count].year()),  winRate.setScale(2) , m3, count));
            }                      
        

        AIES_ACCENTURE__AIESMetricMaster__c m4 = Util.getMetricMaster('BSM_Win_Rate_Improvement');
            for(integer count = 1; count<=4 ; count++){
                Decimal winRateImprovement = 0;
                Decimal currentQuaterWinRate;
                Decimal previousQuaterWinRate;
                
                if((decimal.valueOf(winOpp.get(quarter[count])) + (decimal.valueOf(lossOpp.get(quarter[count])))) > 0) {
                currentQuaterWinRate = (decimal.valueOf(winOpp.get(quarter[count])) * 100) / (decimal.valueOf(winOpp.get(quarter[count])) + decimal.valueOf(lossOpp.get(quarter[count])));
                    
                previousQuaterWinRate = (decimal.valueOf(winOpp.get(quarter[count+1])) * 100) / (decimal.valueOf(winOpp.get(quarter[count+1])) + decimal.valueOf(lossOpp.get(quarter[count+1])));
                }    
                if(previousQuaterWinRate > 0 && count != 4){
                    /* We r multiplying denominator with 100
                    winRateImprovement = (decimal.valueOf(winOpp.get(quarter[count1])) / decimal.valueOf(winOpp.get(quarter[count1+1])))  * 100;
                    */
                    
                    winRateImprovement = (( currentQuaterWinRate - previousQuaterWinRate ) / previousQuaterWinRate )*100;
                    
                    
                    //winRateImprovement = ( ( decimal.valueOf(winOpp.get(quarter[count1])) - decimal.valueOf(winOpp.get(quarter[count1+1])) ) / decimal.valueOf(winOpp.get(quarter[count1+1])) ) * 100;                   
                }else{
                    
                    winRateImprovement = 0;
                }
               
               obj.add(Util.createMetricData(string.valueof(MapQuarter.get(quarter[count].month())) + ' '+ string.valueof(quarter[count].year()),  winRateImprovement.setScale(2), m4, count)); 
            }
            
        AIES_ACCENTURE__AIESMetricMaster__c m5 = Util.getMetricMaster('SM_BulletWinRate');
        
            Decimal winRateImp = 0;
            if(decimal.valueOf(winOpp.get(quarter[2])) > 0){
                system.debug('------------winOpp.get(quarter[1]--------'+winOpp.get(quarter[1])+'-quarter[2]--'+winOpp.get(quarter[2])+'===='+winOpp.get(quarter[1]));
                /* We r multiplying denominator with 100
                winRateImp = (decimal.valueOf(winOpp.get(quarter[1])) - decimal.valueOf(winOpp.get(quarter[2]))) / (decimal.valueOf(winOpp.get(quarter[1]))) *100;
                */
                winRateImp = ( ( (decimal.valueOf(winOpp.get(quarter[1])) - decimal.valueOf(winOpp.get(quarter[2]))) * 100) / decimal.valueOf(winOpp.get(quarter[2])));           
              }  
                
              obj.add(Util.createMetricData('Key', winRateImp , m5));                   
             
        AIES_ACCENTURE__AIESMetricMaster__c m7 = Util.getMetricMaster('BP_Won_Opportunity_Value');
            i=1;
           
            for(String s: valueBySource.keyset()){
                if (s != null && valueBySource.get(s)!= null){
                   obj.add(Util.createMetricData(s, valueBySource.get(s), m7, i));
                 i++;
                }
             }
      
      //System.debug('winOpp********'+winOpp);
        //System.debug('lossOpp'+ lossOpp);
      
/*  START: Batch Class Logic for Opportunity Aging by Month */

     //   System.debug('winOpp********'+winOpp);
      //  System.debug('lossOpp'+ lossOpp);   
            
        AIES_ACCENTURE__AIESMetricMaster__c m6 = Util.getMetricMaster('SM_OpportunitiesAgingByMonth');
   
        List<AIES_ACCENTURE__AIESMetricData__c> objList=[Select id,AIES_ACCENTURE__Key__c,AIES_ACCENTURE__Value__c 
                                                         from AIES_ACCENTURE__AIESMetricData__c 
                                                         where AIES_ACCENTURE__MetricMaster__r.Name='SM_OpportunitiesAgingByMonth'
                                          ];
         Map<String,Decimal> objMap=new Map<String,Decimal>();
         Set<String> objSet=new Set<String>();
         Map<String,Decimal> quarterMap=new Map<String,Decimal>();
        if (objList.size()>0)
        {
           for (AIES_ACCENTURE__AIESMetricData__c md:objList){
           objMap.put(md.AIES_ACCENTURE__Key__c,md.AIES_ACCENTURE__Value__c);
           objSet.add(md.AIES_ACCENTURE__Key__c);
           }
        } 
        system.debug('ExistingMap'+objMap);
        system.debug('ExistingSet'+objSet);
        system.debug('NewMap'+monthsMap);
        system.debug('NewSet'+monthsSet);
        system.debug('monthsMap'+monthsMap);
        
        if (objList.size()>0){
        for (String s: objSet){  
  
        if(monthsMap.containsKey(s)==false && s.contains(currentYear))
        
        {  
          system.debug('IF BLOCK STARTS');
          If( s.contains('JAN-')|| s.contains('FEB-') || s.contains('MAR-')){ 
           currentYearCountQ11=currentYearCountQ11+objMap.get(s);           
           system.debug('currentYearCountQ11'+currentYearCountQ11);
           }
           If( s.contains('APR-')|| s.contains('MAY-') || s.contains('JUN-')){ 
           currentYearCountQ22=currentYearCountQ22+objMap.get(s);           
           system.debug('currentYearCountQ22'+currentYearCountQ22);
           }
           If( s.contains('JUL-')|| s.contains('AUG-') || s.contains('SEP-')){ 
           currentYearCountQ33=currentYearCountQ33+objMap.get(s);           
           system.debug('currentYearCountQ33'+currentYearCountQ33);
           }
           If( s.contains('OCT-')|| s.contains('NOV-') || s.contains('DEC-')){ 
           currentYearCountQ44=currentYearCountQ44+objMap.get(s);           
           system.debug('currentYearCountQ44'+currentYearCountQ44);
           }
        }
        
        else if (monthsMap.containsKey(s)==false && s.contains(prevYear))
        
        {  
          system.debug('IF BLOCK STARTS');
          If( s.contains('JAN-')|| s.contains('FEB-') || s.contains('MAR-')){ 
           prevYearCountQ11=prevYearCountQ11+objMap.get(s);           
           system.debug('prevYearCountQ11'+prevYearCountQ11);
           }
           If( s.contains('APR-')|| s.contains('MAY-') || s.contains('JUN-')){ 
           prevYearCountQ22=prevYearCountQ22+objMap.get(s);           
           system.debug('prevYearCountQ22'+prevYearCountQ22);
           }
           If( s.contains('JUL-')|| s.contains('AUG-') || s.contains('SEP-')){ 
           prevYearCountQ33=prevYearCountQ33+objMap.get(s);           
           system.debug('prevYearCountQ33'+prevYearCountQ33);
           }
           If( s.contains('OCT-')|| s.contains('NOV-') || s.contains('DEC-')){ 
           prevYearCountQ44=prevYearCountQ44+objMap.get(s);           
           system.debug('prevYearCountQ44'+prevYearCountQ44);
           }
        }
        
      }
      }
       
        system.debug('Existing Metric Data'+objMap);
        
              system.debug('---months----------'+months+'========Date Age_d6==='+Age_d6);
             
             for(Date d: months){                    
                    system.debug('---date----------'+d+'====Util.monthName(d),=='+Util.monthName(d));
                    system.debug('Each-loopval===>'+Util.monthName(d)+'====countbymonth.get(d) ='+'countbymonth.get(d)'+'====='+agingbymonth.get(d)+'/'+countbymonth.get(d));
                    obj.add(Util.createMetricData(Util.monthName(d),(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d)), m6,i));                   
                    i++; 
/*        logs.add(new Log__c(
                        Name =  'Month Name ='+d ,
                        Class_Name__c = 'BatchOpportunityMetric',
                        Error_Description__c = 'Util.monthName(d)='+Util.monthName(d)+'#agingbymonth.get(d)='+agingbymonth.get(d)+'#countbymonth.get(d)='+countbymonth.get(d),
                        Portfolio_Name__c = Util.Portfolio,
                        Line_Number__c = 0
                        ));
*/                      
                        
                    
                                                       
                    system.debug('Record Created****Sort Order'+i);
                    system.debug('agingMonth'+agingbymonth.get(d));
                    system.debug('countbyMonth'+countbymonth.get(d));
              
                                                  
                   if (countbymonth.get(d)> 0 && Util.drillYear(d)==Util.drillYear(Age_d0) && (Util.monthName(d)=='JAN'+Util.dateYear(d) || Util.monthName(d)=='FEB'+Util.dateYear(d) || Util.monthName(d)=='MAR'+Util.dateYear(d))){
        
                            currentYeardivisionQ1=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            currentYearcountQ1=currentYearcountQ1+currentYeardivisionQ1;
                            system.debug('currentYearcountQ1'+currentYearcountQ1);
                   }
                   
                   else if (countbymonth.get(d)> 0 && Util.drillYear(d)==(Util.drillYear(Age_d0)-1) && (Util.monthName(d)=='JAN'+Util.dateYear(d) || Util.monthName(d)=='FEB'+Util.dateYear(d) || Util.monthName(d)=='MAR'+Util.dateYear(d))){
        
                            prevYeardivisionQ1=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            prevYearcountQ1=prevYearcountQ1+prevYeardivisionQ1;
                            system.debug('prevYearcountQ1'+prevYearcountQ1);
                  }
                   
                   
                   if (countbymonth.get(d)> 0 && Util.drillYear(d)==Util.drillYear(Age_d0) && (Util.monthName(d)=='APR'+Util.dateYear(d) || Util.monthName(d)=='MAY'+Util.dateYear(d) || Util.monthName(d)=='JUN'+Util.dateYear(d))){
        
                            currentYeardivisionQ2=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            currentYearcountQ2=currentYearcountQ2+currentYeardivisionQ2;
                            system.debug('currentYearcountQ2'+currentYearcountQ2);
                   }
                 else if (countbymonth.get(d)> 0 && Util.drillYear(d)==(Util.drillYear(Age_d0)-1) && (Util.monthName(d)=='APR'+Util.dateYear(d) || Util.monthName(d)=='MAY'+Util.dateYear(d) || Util.monthName(d)=='JUN'+Util.dateYear(d))){
        
                            prevYeardivisionQ2=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            prevYearcountQ2=prevYearcountQ2+prevYeardivisionQ2;
                            system.debug('prevYearcountQ2'+prevYearcountQ2);
                   }
                   
                   if (countbymonth.get(d)> 0 && Util.drillYear(d)==Util.drillYear(Age_d0) && (Util.monthName(d)=='JUL'+Util.dateYear(d) || Util.monthName(d)=='AUG'+Util.dateYear(d) || Util.monthName(d)=='SEP'+Util.dateYear(d))){
        
                            currentYeardivisionQ3=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            currentYearcountQ3=currentYearcountQ3+currentYeardivisionQ3;
                            system.debug('currentYearcountQ3'+currentYearcountQ3);
                   }
                   
                  else if (countbymonth.get(d)> 0 && Util.drillYear(d)==(Util.drillYear(Age_d0)-1) && (Util.monthName(d)=='JUL'+Util.dateYear(d) || Util.monthName(d)=='AUG'+Util.dateYear(d) || Util.monthName(d)=='SEP'+Util.dateYear(d))){
        
                            prevYeardivisionQ3=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            prevYearcountQ3=prevYearcountQ3+prevYeardivisionQ3;
                            system.debug('prevYearcountQ3'+prevYearcountQ3);
                   }
                   
                   if (countbymonth.get(d)> 0 && Util.drillYear(d)==Util.drillYear(Age_d0) && (Util.monthName(d)=='OCT'+Util.dateYear(d) || Util.monthName(d)=='NOV'+Util.dateYear(d) || Util.monthName(d)=='DEC'+Util.dateYear(d))){
        
                            currentYeardivisionQ4=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            currentYearcountQ4=currentYearcountQ4+currentYeardivisionQ4;
                            system.debug('currentYearcountQ4'+currentYearcountQ4);
                   }
                  else if (countbymonth.get(d)> 0 && Util.drillYear(d)==(Util.drillYear(Age_d0)-1) && (Util.monthName(d)=='OCT'+Util.dateYear(d) || Util.monthName(d)=='NOV'+Util.dateYear(d) || Util.monthName(d)=='DEC'+Util.dateYear(d))){
        
                            prevYeardivisionQ4=(countbymonth.get(d) == 0 ? 0 : agingbymonth.get(d)/countbymonth.get(d));
                            prevYearcountQ4=prevYearcountQ4+prevYeardivisionQ4;
                            system.debug('prevYearcountQ4'+prevYearcountQ4);
                   }
             
                }
          
          
          
           obj.add(Util.createMetricData('Q1-'+currentYear,currentYearcountQ1+currentYearCountQ11,m6,i));
           obj.add(Util.createMetricData('Q2-'+currentYear,currentYearcountQ2+currentYearCountQ22,m6,i+1));
           obj.add(Util.createMetricData('Q3-'+currentYear,currentYearcountQ3+currentYearCountQ33,m6,i+2));
           obj.add(Util.createMetricData('Q4-'+currentYear,currentYearcountQ4+currentYearCountQ44,m6,i+3));
           obj.add(Util.createMetricData('Q1-'+prevYear,prevYearcountQ1+prevYearCountQ11,m6,i));
           obj.add(Util.createMetricData('Q2-'+prevYear,prevYearcountQ2+prevYearCountQ22,m6,i+1));
           obj.add(Util.createMetricData('Q3-'+prevYear,prevYearcountQ3+prevYearCountQ33,m6,i+2));
           obj.add(Util.createMetricData('Q4-'+prevYear,prevYearcountQ4+prevYearCountQ44,m6,i+3));
           
           currentYearCount=currentYearCountQ1+currentYearCountQ11+currentYearCountQ2+currentYearCountQ22+currentYearCountQ3+currentYearCountQ33+currentYearCountQ4+currentYearCountQ44;
           prevYearCount=prevYearcountQ1+prevYearcountQ11+prevYearcountQ2+prevYearcountQ22+prevYearcountQ3+prevYearcountQ33+prevYearcountQ4+prevYearcountQ44;
          
           obj.add(Util.createMetricData(currentYear,currentYearCount,m6,i+4));
           obj.add(Util.createMetricData(String.valueOf(Util.drillYear(Age_d0)-1),prevYearCount,m6,i+4));
     
 /* END : Batch Class Logic for Opportunity Aging by Month */
                          
        upsert obj AIES_ACCENTURE__External_Id__c;
        
    /*if (logs.size() >0)
        Database.Insert(logs);      
      */              
          }catch(exception e){
                util.exceptionHandler(e, 'BatchOpportunityMetric', 'finish');
                system.debug('ERROR-------------------'+e.getMessage()+'---Line--'+e.getLineNumber());
            }
    }
    
    /******************************
     * Method Name: Calc
     * Description: Count lost and won Opportunity 
     * Paramenters: Opportunity, Date
     * Return Value: NA
    /*******************************/
   
    public void calc(Opportunity s, Date d){
    
        map<string, Integer> monthRec= countmap.get(d);
        monthRec.put(totOpp,monthRec.get(totOpp)+1);            
        monthRec.put(aging, monthRec.get(aging) + (s.IsClosed == false ? s.createddate.date().daysbetween(Date.today()) : s.createddate.date().daysbetween(s.closeDate)));
            if(s.IsClosed == true && s.IsWon == false){
                
                monthRec.put(lostOpp,monthRec.get(lostOpp)+1);
            }else if(s.IsWon == true){
                
                monthRec.put(wonOpp,monthRec.get(wonOpp)+1); 
            }
            countMap.put(d,monthRec);
    }//END calc function 
    
    /******************************
     * Method Name: calcClosedDate
     * Description: Win loss calculation 
     * Paramenters: Opportunity
     * Return Value: NA
    /*******************************/
   
   //Loss Opp analysis (opp where isClosed=true and iswon=false)
    
    public void calcCloseDate(Opportunity s){

        if(s.IsClosed == true && s.IsWon == false){
            for(integer i = 1; i<=5 ; i++){
                map<string, Integer> monthRec = new map<string, Integer>();
                    /*if((s.CreatedDate > quarter[i+1] && s.CreatedDate <= quarter[i]) || 
                        (s.CreatedDate < quarter[i] && s.CloseDate > quarter[i]) || 
                        (s.CloseDate > quarter[i+1] && s.CloseDate <= quarter[i] ))*/
                     //if(s.CreatedDate < quarter[i] && s.CloseDate > quarter[i+1] && s.CreatedDate <= s.CloseDate)
                   if(s.CreatedDate <= quarter[i] && s.CloseDate <= quarter[i] && s.CloseDate > quarter[i+1] && s.CreatedDate <= s.CloseDate)
                    {
                        lossOpp.put(quarter[i],lossOpp.get(quarter[i])+1);
                                          
                    }
                }
                
            }
            
            
            //Win Opp analysis (opp where isClosed=true and iswon=true)
            
            else if(s.IsClosed == true && s.IsWon == true)
            {
                map<string, Integer> monthRec = new map<string, Integer>();
                for(integer i = 1; i<=5 ; i++)
                {
                    /*if((s.CreatedDate > quarter[i+1] && s.CreatedDate <= quarter[i]) || 
                    s.CreatedDate > 2014-09-30 && s.CreatedDate <= 2014-12-31 ||
                        (s.CreatedDate < quarter[i] && s.CloseDate > quarter[i]) || 
                    s.CreatedDate < 2014-12-31 && s.CloseDate > 2014-12-31 ||                    
                    (s.CloseDate > quarter[i+1] && s.CloseDate <= quarter[i] ))
                    */
                    if(s.CreatedDate <= quarter[i] && s.CloseDate <= quarter[i] && s.CloseDate > quarter[i+1] && s.CreatedDate <= s.CloseDate)
                  // if(s.CreatedDate <= s.CloseDate && s.CreatedDate <= quarter[i] && s.CreatedDate > quarter[i-1] && s.CloseDate>=quarter[i])     
                    
                    {
                        winOpp.put(quarter[i],(winOpp.get(quarter[i]))+1);
                    }
                }
                               
            
            }       
   }//END calcCloseDate function

}