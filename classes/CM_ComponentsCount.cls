/*
Date: 03.07.2014
Author: Dorai
Description: Apex class to populate metrics data showing count of components (VF Page, VF Components, Classes and Triggers)
Version: v0.1
Reports: Code Metrics
*/

global class CM_ComponentsCount {
    
    global static void CM_ComponentsCount(){  
    Id Portfolio = Util.Portfolio;  
    system.debug('Portfolio----->' + Portfolio );
        try{
        AIES_ACCENTURE__AIESMetricMaster__c m = Util.getMetricMaster('CM_ComponentsCount_Detail');
                
        AIES_ACCENTURE__AIESMetricData__c[] metricList = new List<AIES_ACCENTURE__AIESMetricData__c>();
        
        metricList.add(Util.createMetricData('VF Pages',
                                            database.countQuery('select count() from  AIES_ACCENTURE__VFPage__c where AIES_ACCENTURE__Portfolio__c = :portfolio'),
                                            m));
        
        metricList.add(Util.createMetricData('VF Components',
                                            database.countQuery('select count() from AIES_ACCENTURE__VFComponent__c where AIES_ACCENTURE__Portfolio__c = :portfolio'),
                                            m));
                                            
        metricList.add(Util.createMetricData('Apex Triggers',
                                            database.countQuery('select count() from AIES_ACCENTURE__ApexTrigger__c where AIES_ACCENTURE__Portfolio__c = :portfolio'),
                                            m));
                                            
        metricList.add(Util.createMetricData('Apex Classes',
                                            database.countQuery('select count() from AIES_ACCENTURE__ApexClass__c where AIES_ACCENTURE__Portfolio__c = :portfolio'),
                                            m));

        Integer value = 0;
        for(AIES_ACCENTURE__AIESMetricData__c currentData : metricList)
        {
            value = value + Integer.valueOf(currentData.AIES_ACCENTURE__Value__c);
        }
                                            
        AIES_ACCENTURE__AIESMetricMaster__c m1 = Util.getMetricMaster('CM_ComponentsCount_Count');
                
        AIES_ACCENTURE__AIESMetricData__c[] metricList1 = new List<AIES_ACCENTURE__AIESMetricData__c>(); 
        
        metricList.add(Util.createMetricData('CM_ComponentsCount_Count',value, m1));                                                   
        
        util.upsertMetricData(metricList);
        
    }catch(Exception e){
        util.exceptionHandler(e, 'CM_ComponentsCount', 'CM_ComponentsCount');
    }
}
}