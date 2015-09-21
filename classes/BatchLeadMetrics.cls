/*
Date: 03.07.2014
Author: Dorai
Description: Apex class to analyse Lead object and populate metric data with month on month data (last 6months) for the below reports
Version: v0.1
Reports: Marketing Metrics: Lead Count by Lead Source
                            Lead Converstion Rate by Lead Source
                            Won Opp Value by Lead Source
                            Sales Lead Volume Increase
                            Lead Aging Trend by month
                            Cost Per Lead
                            % Lead Converstion Rate Increase
                            
*/

global class BatchLeadMetrics implements Database.Batchable<sObject>, Database.stateful {

    String totLeads = 'totLeads';
    String closureRate = 'closureRate';
    String aging = 'aging';
    Integer firstQuarterCounter = 0;
    Integer secondQuarterCounter = 0;
    
    map<string, integer> countbyLeadsource = new  map<string, integer>();
    map<string, integer> convertedCountbyLeadsource = new  map<string, integer>();    
    map<Date,map<string,integer>> countMap= new map<Date,map<string, Integer>>();
    List<Sobject> oppCloseList = new List<Sobject>(); 
    
    Date d0=Util.d00;// 1-4-2015
    Date d1=Util.d01; // 1-3-2015
    Date d2=Util.d02; // 1-2-2015
    Date d3=Util.d03; // 1-1-2015
    Date d4=Util.d04; // 1-12-2014
    Date d5=Util.d05; // 1-11-2014
    Date d6=Util.d06;  // 1-10-2014
         
     List<Date> months = new List<Date>{d1,d2,d3,d4,d5,d6}; 
     

   public Database.QueryLocator start(Database.BatchableContext BC){    
    
    
        firstQuarterCounter = secondQuarterCounter = 0;
       try{
       for(integer i=1; i<=6; i++){
            
            Map<String, Integer> n = new Map<String, Integer>{totLeads => 0, aging => 0};
            countMap.put(months[i-1],n);
        }   
        for(Sobject s: [select count(id), LeadSource from opportunity where iswon = true and isclosed = true and createddate = LAST_N_Months:6 and leadsource !=null group by LeadSource]){
            oppCloseList.add(s);
        }
        }catch(Exception e){
             util.ExceptionHandler(e, 'BatchLeadMetrics', 'start');
        }  
          return Database.getQueryLocator('select leadsource, createddate, ConvertedDate, isconverted from lead where createddate >= :d6 and createddate <: d0');
       
       }
    
       public void execute(Database.BatchableContext BC, List<Lead> scope){      
        try{    
        for(Lead s : scope){ 
            
            if(s.LeadSource != null){
                if(countbyLeadsource.containskey(s.leadsource)){
                    countbyLeadsource.put(s.leadsource,countbyLeadsource.get(s.leadsource) +1);
                }else {
                    countbyLeadsource.put(s.leadsource, 1);
                }
                
            if(s.isConverted){
                    if(convertedCountbyLeadsource.containskey(s.leadsource)){
                        convertedCountbyLeadsource.put(s.leadsource,convertedCountbyLeadsource.get(s.leadsource) +1);   
                    }else {
                        convertedCountbyLeadsource.put(s.leadsource, 1);
                    }

                    //if(s.ConvertedDate >= d3 &&  )
                    if(s.ConvertedDate < d0  && s.ConvertedDate >= d3){
                        firstQuarterCounter++;
                    }
                    if(s.ConvertedDate < d3 && s.ConvertedDate >= d6){
                        secondQuarterCounter++;
                    }
            
            }       
            /*
            if(s.createddate >= d1.adddays(1)){
                calc(s,d0);         
            }else if(s.createddate < d1.adddays(1) && s.createddate >= d2.adddays(1)){
                calc(s,d1);             
            }else if(s.createddate < d2.adddays(1) && s.createddate >= d3.adddays(1)){
                calc(s,d2);             
            }else if(s.createddate < d3.adddays(1) && s.createddate >= d4.adddays(1)){
                calc(s,d3);             
            }else if(s.createddate < d4.adddays(1) && s.createddate >= d5.adddays(1)){
                calc(s,d4);             
            }else if(s.createddate < d5.adddays(1)){
                calc(s,d5);             
            }
            */
            if(s.createddate < d0 && s.createddate >= d1){           
                calc(s,d1);                  
            }else if(s.createddate < d1 && s.createddate >= d2){ 
                calc(s,d2);          
            }else if(s.createddate < d2 && s.createddate >= d3){
                calc(s,d3);                
            }else if(s.createddate < d3 && s.createddate >= d4){
                calc(s,d4);        
            }else if(s.createddate < d4 && s.createddate >= d5){
                calc(s,d5);        
            }else if(s.createddate < d5 && s.createddate >= d6){
                calc(s,d6);            
            } 

        }
        }
        }catch(Exception e){
             util.ExceptionHandler(e, 'BatchLeadMetrics', 'execute');
        }    
   }
   
       
   public void finish(Database.BatchableContext BC){ 
            try
            {  
            AIES_ACCENTURE__AIESMetricData__c[] obj = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
            
            AIES_ACCENTURE__AIESMetricMaster__c m = Util.getMetricMaster('BP_Lead_Aging_Trend');
            Integer i = 1;
            for(Date d: months){
            obj.add(Util.createMetricData(Util.monthName(d),  countmap.get(d).get(aging), m, i));
            i++;
            }
            
            AIES_ACCENTURE__AIESMetricMaster__c m1 = Util.getMetricMaster('BP_Lead_count');
             i = 1;
            for(String d: countbyLeadsource.keySet()){
            obj.add(Util.createMetricData(d, countbyLeadsource.get(d), m1, i));
            i++;
            }
            
            AIES_ACCENTURE__AIESMetricMaster__c m2 = Util.getMetricMaster('BP_Lead_Conversion_rate');
            i = 1;
            for(String d: convertedCountbyLeadsource.keySet()){
            obj.add(Util.createMetricData(d, (countbyLeadsource.get(d) == 0 ? 0 : convertedCountbyLeadsource.get(d)*100/countbyLeadsource.get(d)), m2, i));
            i++;
            }
           
            Decimal leadVolumeIncrease = ((countmap.get(d3).get(totLeads) + countmap.get(d4).get(totLeads) + countmap.get(d5).get(totLeads)/(countmap.get(d0).get(totLeads) + countmap.get(d1).get(totLeads) + countmap.get(d2).get(totLeads))/100))-100;        
            AIES_ACCENTURE__AIESMetricMaster__c m3 = Util.getMetricMaster('SM_BulletSalesVolInc');
            obj.add(Util.createMetricData('Key', leadVolumeIncrease, m3));
            
            AIES_ACCENTURE__AIESMetricMaster__c m4 = Util.getMetricMaster('SM_BulletLeadConversion');
            obj.add(Util.createMetricData('Key', ((secondQuarterCounter/firstQuarterCounter)*100), m4));
            
            AIES_ACCENTURE__AIESMetricMaster__c m6 = Util.getMetricMaster('BP_Opp_Won_Lead_Source');
            system.debug('oppCloseList**********'+oppCloseList);
            i = 1;
            if(oppCloseList != null)
            {
                for(SObject o: oppCloseList){
                 obj.add(Util.createMetricData(string.valueof(o.get('LeadSource')),  decimal.valueOf(string.valueof(o.get('expr0'))), m6, i));
                i++;
                }            
            }            
              
             upsert obj AIES_ACCENTURE__External_Id__c;   
            }
            catch(exception e)
            {
                util.exceptionHandler(e, 'BatchLeadMetrics', 'finish');

            }
   }
   
   public void calc(Lead s, Date d){
     
            map<string, Integer> monthRec= countmap.get(d);
            monthRec.put(totLeads,monthRec.get(totLeads)+1);
            if(s.isConverted){
                monthRec.put(aging, monthRec.get(aging) + s.createddate.date().daysbetween(s.ConvertedDate));
            }
            //monthRec.put(aging, monthRec.get(aging) + (s.isConverted ? s.createddate.date().daysbetween(s.ConvertedDate) : s.createddate.date().daysbetween(Date.today())));
            countMap.put(d,monthRec);
   
       }
}