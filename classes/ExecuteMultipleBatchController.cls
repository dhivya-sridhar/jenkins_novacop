global class ExecuteMultipleBatchController{
    
    public Integer batchJobCount{get;set;}

    public void initialize(){
            batchJobCount = getBatchJobs().size();
    }   
       
    
    global static List<Database.Batchable<sObject>> getBatchJobs(){
        
        List<Database.Batchable<sObject>> batchJobList = new List<Database.Batchable<sObject>>();        
        
        batchJobList.add(new AIES_ACCENTURE.BatchStaleDataAccountMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchStaleDataContactMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchStaleDataLeadMetric());
        
        batchJobList.add(new AIES_ACCENTURE.BatchUserLoginMetrics());
        batchJobList.add(new AIES_ACCENTURE.BatchChatterMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchOpportunityMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchLeadMetrics());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseMetric());

        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageAccountMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageCaseMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageContactMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageLeadMetric());
        
        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageOppMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageOPPOverdueMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchAppEffUsageOPPValueRangeMetric());
        batchJobList.add(new AIES_ACCENTURE.BatchLeadConversionMetrics());
        batchJobList.add(new AIES_ACCENTURE.BatchAplicationMetrics());
        
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM1());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM2());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM3());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM4());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM5());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM6());
        batchJobList.add(new AIES_ACCENTURE.BatchCaseCRMJourney_SM7());


        Set<String> masterList = new Set<string>();
        masterList.add('Opportunity');
        masterList.add('Case');
        masterList.add('Lead');
        batchJobList.add(new AIES_ACCENTURE.BatchTransactionDataGrowth(masterList, new map<Date,Integer>(),0));
  
        Set<String> masterList2 = new Set<string>();
        masterList2.add('Account');
        masterList2.add('Contact');
        batchJobList.add(new AIES_ACCENTURE.BatchMasterDataGrowth(masterList2, new map<Date,Integer>(),0));  

        List<String> masterList3 = new List<string>();
        Set<String> finalmasterList = new Set<string>();
        Map<String,String> finalMasterMap = new Map<String,String>();
        //add all the standard objects that needs volume metric to run against, this should be replace with the query – all objects in the sObject__c
        masterList3.add('Account');
        masterList3.add('Asset');
        masterList3.add('Campaign');
        masterList3.add('Case');
        masterList3.add('Contact');
        masterList3.add('Contract');
        masterList3.add('Lead');
        masterList3.add('Opportunity');
        masterList3.add('Solution');
        masterList3.add('User');
        //following code adds all the custom objects
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for(String s: gd.keyset()){
            if(s.contains('__c') && !((s.toUpperCase()).contains('AIES_ACCENTURE'))){
                masterList3.add(s);
            }
        }
        List<Schema.DescribeSObjectResult> descResult=  Schema.describeSObjects(masterList3);
        for(DescribeSObjectResult tsr : descResult) {                       
            finalMasterMap.put(tsr.getName(),tsr.getLabel());                       
        }
        batchJobList.add(new AIES_ACCENTURE.Batch_VolumeMetric_Data_Completeness (finalMasterMap));

        return batchJobList;
    }


    @RemoteAction
    global static void executeBatchJob(Integer batchIndex){
            database.executeBatch(getBatchJobs().get(batchIndex));
    }
    
    @RemoteAction
    global static Integer checkQueueCount(){
    
        Integer batchProcessingCount = [SELECT count() 
                                        FROM AsyncApexJob 
                                        WHERE JobType='BatchApex' 
                                        AND(Status = 'Processing' 
                                            OR Status = 'Preparing' 
                                            OR Status = 'Queued')];
                                            
        return  batchProcessingCount;                                   
    }
    
    @RemoteAction
    global static void executeApexScript(){
    
        AIES_ACCENTURE.UA_AppUsageByLicense.UA_AppUsageByLicense();
        AIES_ACCENTURE.UA_UserLoginTypeTrend.UA_UserLoginTypeTrend();
        
        AIES_ACCENTURE.ChatterFeedReporting  ua3 = new AIES_ACCENTURE.ChatterFeedReporting();
        AIES_ACCENTURE.FeedCommentReporting   ua4 = new AIES_ACCENTURE.FeedCommentReporting();
        AIES_ACCENTURE.AEU_DataCompleteness  ua5 = new AIES_ACCENTURE.AEU_DataCompleteness();

        AIES_ACCENTURE.DashboardMetric.DashboardMetric();
        AIES_ACCENTURE.ReportMetric.populateMetric();
        
        AIES_ACCENTURE.CM_WorkFlows  ua10 = new AIES_ACCENTURE.CM_WorkFlows();
        AIES_ACCENTURE.CM_ApprovalProcessData  ua13 = new AIES_ACCENTURE.CM_ApprovalProcessData();
        AIES_ACCENTURE.AEU_FieldUsage  ua14 = new AIES_ACCENTURE.AEU_FieldUsage();
        
        AIES_ACCENTURE.UA_ChatterLoad.UA_ChatterLoad();
        
        AIES_ACCENTURE.CM_ViolationsByPriority.CM_ViolationsByPriority();
        AIES_ACCENTURE.CM_ComponentsCount.CM_ComponentsCount();
        
        AIES_ACCENTURE.batchObjectAccessPermissions ua15 = new AIES_ACCENTURE.batchObjectAccessPermissions();
        ua15.DoProcess();
        
        AIES_ACCENTURE.CM_CodeLines ua16 = new AIES_ACCENTURE.CM_CodeLines();
        AIES_ACCENTURE.CM_DegreeOfCustomization ua17 = new AIES_ACCENTURE.CM_DegreeOfCustomization();
        
        AIES_ACCENTURE.Util.insertCustomSettingData(); 
                                        
    }
    
    @RemoteAction
    global static String getBatchJobsJSON(){
        
        List<AsyncApexJob> asyncApexJobList = [SELECT  ApexClass.name, Status, CompletedDate 
                                               FROM AsyncApexJob 
                                               WHERE JobType='BatchApex'  
                                               Order By CompletedDate 
                                               ASC LIMIT :getBatchJobs().size()];
        
        String batchListString = JSON.serializePretty(asyncApexJobList);  
                                   
        return  batchListString ;                                   
   }
    
}