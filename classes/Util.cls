global with sharing class Util{
    
    
    //public static String Portfolio= String.valueof(AIES_ACCENTURE__PortfolioID__c.getInstance().get(util.getNameSpace()+'ID__C'));
    public static String Portfolio= String.valueof(AIES_ACCENTURE__PortfolioID__c.getInstance().get('AIES_ACCENTURE__ID__C'));

    
    public static List<string> communityUserlicenses = new  List<string>{'SSP', 'POWER_SSP', 'PID_Customer_Portal_Standard', 'PID_Customer_Portal_Basic', 'High_Volume_Customer_Portal_User', 
        'PID_Partner_Community', 'PID_Customer_Community_Login', 'PID_Partner_Community_Login', 'PID_Customer_Community'};
            
            public static List<string> salesUserlicenses = new  List<string>{'SFDC'};
                
                public static List<string> charterUserlicenses = new  List<string>{'CSN_External_User', 'PID_CHATTER', 'CSN_User'};
                    
                    public static List<string> forceUserlicenses = new  List<string>{'FDC_ONE'};
                        
                        
/* Backup as on 3/14/2015                   
    public static Date d00 = System.today().toStartOfMonth().adddays(-1);
*/
    public static Date d00 = System.today().toStartOfMonth();   
    public static Date d01 = d00.addmonths(-1);
    public static Date d02 = d00.addmonths(-2);
    public static Date d03 = d00.addmonths(-3);
    public static Date d04 = d00.addmonths(-4);
    public static Date d05 = d00.addmonths(-5); 
    public static Date d06 = d00.addmonths(-6);
    public static Date d07 = d00.addmonths(+1);
    
    //++ 3/15/2015- Added by Amit - So that we can have dates till last 12 months
    public static Date d7thMonth = d00.addmonths(-7);
    public static Date d8thMonth = d00.addmonths(-8);
    public static Date d9thMonth = d00.addmonths(-9);
    public static Date d10thMonth = d00.addmonths(-10);
    public static Date d11thMonth = d00.addmonths(-11);
    public static Date d12thMonth = d00.addmonths(-12);// ++ Amit --This will fetch the date 1 year back from today
    public static long timeDiff ;
    
   public static Long SubtractDate(DateTime highDate, DateTime lowDate){
       timeDiff = highDate.getTime() - lowDate.getTime();
       return timeDiff/(3600*1000) ;  // 1 hour=60 mins, 1 min=60 sec, 1sec= 1000 milliseconds
 
       } 
   public static String dateYear(Date d)
   
   {
        string result= '-'+string.valueof(d).substring(0,4);
        System.Debug('Date'+result);
        return result;
   }    
   
    public static Integer drillYear(Date d)
   
   {
        string result= string.valueof(d).substring(0,4);
        System.Debug('Date'+result);
        return integer.valueOf(result);
   }    
    
   /* public static date chooseDate(Datetime d)
    {
        if(Test.IsRunningTest())
            return d00;
        
        if(d < d00 && d >= d01)// recordsCreated date < 2/03/2015   &&     recordsCreated date >=2/2/2015 return current month
          { 
            return d00; 
        }
        else if(d < d01 && d >= d02)
        {
            return d01; 
        }
        else if(d < d02 && d >= d03)
        {
            return d02; 
        }
        else if(d < d03 && d >= d04)
        {
            return d03; 
        }
        else if(d < d04 && d >= d05)
        {
            return d04; 
        }
        else if(d < d05 && d >= d06)
        {
            return d05; 
        }
        
        else if(d > d00)
        {
            return d07; 
        }
        return null;
    }   
    */
    
     public static date chooseDate(Datetime d)
    {
        //if(Test.IsRunningTest())
          //  return d01;
        
        if(d >= d01 && d < d00)//d>=feb && d<mar
                  { 
            return d01; 
        }
        else if(d >= d02 && d < d01)//d>=jan&& d<feb
        {
            return d02; 
        }
        else if(d >= d03 && d < d02)
        {
            return d03; 
        }
        else if(d >=d04 && d < d03)
        {
            return d04; 
        }
        else if(d >= d05 && d < d04)
        {
            return d05; 
        }
        else if(d > d06 && d < d05)
        {
            return d06; 
        }
        
        else if(d >= d00)
        {
            return d07; 
        }
        return null;
    }   
    
    public static String monthName(Date d){
        
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(1,'JAN');
        monthMap.put(2,'FEB');
        monthMap.put(3,'MAR');
        monthMap.put(4,'APR');
        monthMap.put(5,'MAY');
        monthMap.put(6,'JUN');
        monthMap.put(7,'JUL');
        monthMap.put(8,'AUG');
        monthMap.put(9,'SEP');
        monthMap.put(10,'OCT');
        monthMap.put(11,'NOV');
        monthMap.put(12,'DEC');
        
        return (monthMap.get(d.month()) + '-' + String.valueOf(d.year()));
        
    }
    
    public static AIES_ACCENTURE__AIESMetricMaster__c getMetricMaster(String metricName){
        
        AIES_ACCENTURE__AIESMetricMaster__c mmetricMasterList;
        
        try{
            mmetricMasterList = [select id, name from AIES_ACCENTURE__AIESMetricMaster__c where name =: metricName limit 1];
        }catch(Exception e){               
        }
        return mmetricMasterList;
    }
    
/*
    public static String getNameSpace()
    {
        
        if (Label.Namespace == 'none')
        {
            return '';
            
        }
        else
        {
            return Label.Namespace+'__';
        }
        
        
    }
*/
/*  
    public static string getSystemAdminLabel()
    {
        if (Label.SystemAdminName == 'none')
        {
            return '';
            
        }
        else
        {
            return Label.SystemAdminName; 
        }
        
    }    
*/ 
/*   
    public static String getTheme()
    {
        if (Label.Theme == 'none')
        {
            return '';
            
        }
        else
        {
            return Label.Theme;
        }
        
    }   
*/  
    
    public static AIES_ACCENTURE__AIESMetricMaster__c createMetricMaster(String metricName, String title, String labelX, String labelY){
        
        AIES_ACCENTURE__AIESMetricMaster__c m = new AIES_ACCENTURE__AIESMetricMaster__c();
        
        //List<AIES_ACCENTURE__AIESMetricData__c>  metricDataList = [select MetricMaster__c from AIES_ACCENTURE__AIESMetricData__c where Portfolio__c = ''];//'=: Portfolio];
        /*List<AIES_ACCENTURE__AIESMetricMaster__c> mm = [select id, name from AIES_ACCENTURE__AIESMetricMaster__c where name =: metricName and id in (select MetricMaster__c from AIES_ACCENTURE__AIESMetricData__c where Portfolio__c =: Portfolio)];// (select MetricMaster__c from AIES_ACCENTURE__AIESMetricData__c where Portfolio__c =:Portfolio) ];
system.debug('mm**'+mm);
if(mm != null){
delete mm;
}
insert m;*/
        
        List<AIES_ACCENTURE__AIESMetricMaster__c> mmetricMasterList = [select id, name from AIES_ACCENTURE__AIESMetricMaster__c where name =: metricName];
        
        if(mmetricMasterList.size() > 0){
            m=mmetricMasterList[0];
        }else{
            m.name = metricName;
            m.AIES_ACCENTURE__Title__c = title;
            m.AIES_ACCENTURE__Label_X__c = labelX;
            m.AIES_ACCENTURE__Label_Y__c = labelY;
            m.AIES_ACCENTURE__MetricType__c = 'Chart';
            insert m;
        }
        return m;
    }
    
    public static AIES_ACCENTURE__AIESMetricData__c createMetricData(String key, Decimal value, AIES_ACCENTURE__AIESMetricMaster__c m){
         system.debug('@@@'+Portfolio);    
        AIES_ACCENTURE__AIESMetricData__c a = new AIES_ACCENTURE__AIESMetricData__c();
        try{
            a.AIES_ACCENTURE__Key__c = key;                        
            a.AIES_ACCENTURE__Value__c = value.setScale(2);
            a.AIES_ACCENTURE__Portfolio__c = Portfolio; //UserInfo.getOrganizationId();
            a.AIES_ACCENTURE__MetricMaster__c = m.id;
            a.AIES_ACCENTURE__External_Id__c = a.AIES_ACCENTURE__Portfolio__c + '::' + m.name + '::'+ a.AIES_ACCENTURE__Key__c;
            
            
        }catch(Exception e){
        }
        return a;
    }
    
    public static AIES_ACCENTURE__AIESMetricData__c createMetricData(String key, Decimal value, AIES_ACCENTURE__AIESMetricMaster__c m, Integer seq){
         system.debug('@@@'+Portfolio);
        AIES_ACCENTURE__AIESMetricData__c a = new AIES_ACCENTURE__AIESMetricData__c();
        try{
            a.AIES_ACCENTURE__Key__c = key;                        
            a.AIES_ACCENTURE__Value__c = value.setScale(2);
            a.AIES_ACCENTURE__Portfolio__c =Portfolio; //id.valueof(Portfolio); //UserInfo.getOrganizationId();
            a.AIES_ACCENTURE__MetricMaster__c = m.id;
            a.AIES_ACCENTURE__External_Id__c = a.AIES_ACCENTURE__Portfolio__c + '::' + m.name + '::'+ a.AIES_ACCENTURE__Key__c;
            a.AIES_ACCENTURE__SortOrder__c = seq;
          system.debug('@@@'+a);  
            
        }catch(Exception e){
        }
        return a;
    }
    
    public static AIES_ACCENTURE__AIESMetricData__c createMetricData(String key, Decimal value, Decimal value2, AIES_ACCENTURE__AIESMetricMaster__c m){
        
        AIES_ACCENTURE__AIESMetricData__c a = new AIES_ACCENTURE__AIESMetricData__c();
        try{
            a.AIES_ACCENTURE__Key__c = key;                        
            a.AIES_ACCENTURE__Value__c = value.setScale(2);
            a.AIES_ACCENTURE__Value2__c = value2.setScale(2);
            a.AIES_ACCENTURE__Portfolio__c = Portfolio; //UserInfo.getOrganizationId();
            a.AIES_ACCENTURE__MetricMaster__c = m.id;
            a.AIES_ACCENTURE__External_Id__c = a.AIES_ACCENTURE__Portfolio__c + '::' + m.name + '::'+ a.AIES_ACCENTURE__Key__c;
            
        }catch(Exception e){
        }
        return a;
    }

  public static AIES_ACCENTURE__AIESMetricData__c createMetricData(String key, Integer value, String Org, AIES_ACCENTURE__AIESMetricMaster__c m,Integer seq){
        
        AIES_ACCENTURE__AIESMetricData__c a = new AIES_ACCENTURE__AIESMetricData__c();
        try{
            a.AIES_ACCENTURE__Key__c = key;                        
            a.AIES_ACCENTURE__Value__c = value;
            a.AIES_ACCENTURE__Portfolio__c = Portfolio; //UserInfo.getOrganizationId();
            a.AIES_ACCENTURE__Category__c=Org;
            a.AIES_ACCENTURE__MetricMaster__c = m.id;
            a.AIES_ACCENTURE__External_Id__c = a.AIES_ACCENTURE__Portfolio__c + '::' + m.name + '::'+ a.AIES_ACCENTURE__Key__c+'::'+a.AIES_ACCENTURE__Category__c;
            a.AIES_ACCENTURE__SortOrder__c = seq;
            
        }catch(Exception e){
        }
        return a;
    }  
    
    /*
        public static boolean createBatchLog(String name, String totrecords, String measureval, String status, String key){
        
        boolean flag = false;
        BatchLogs__c bl = new BatchLogs__c();
        try{
            bl.Batch_Name__c = name;
            bl.Measures__c = measureval;
            bl.Status__c = status;
            bl.Total_records__c = totrecords;
            bl.External_Id__c = key;
            insert bl;
            flag = true;
            
        }catch(Exception e){
        
        }
        return flag;
    }
    
    */
    public static list<SelectOption> getPicklistValues(SObject obj, String fld)
    {
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values)
        { 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }
    
    
    public static void exceptionHandler(Exception e, String className, String methodName){
        
    }
    
    public static void upsertMetricData(List<AIES_ACCENTURE__AIESMetricData__c> metricdataList){
        
        try
        {
            upsert metricdataList AIES_ACCENTURE__External_Id__c; 
        }
        
        catch(exception e)
        {
            exceptionHandler(e, 'Util', 'upsertMetricData');
            
        }    
        
    }
    
    public static void upsertMetricData(AIES_ACCENTURE__AIESMetricData__c metricdata){
        try
        {
            upsert metricdata AIES_ACCENTURE__External_Id__c; 
        }
        
        catch(exception e)
        {
            exceptionHandler(e, 'Util', 'upsertMetricData');
            
        }
        
        
    }
    
     /*public static void upsertBatchLogs(List<BatchLogs__c> BatchLogsList){
        
        try
        {
            upsert BatchLogsList External_Id__c; 
        }
        
        catch(exception e)
        {
            exceptionHandler(e, 'Util', 'upsertBatchLogsData');
            
        }    
        
    }
    
       public static void upsertBatchLogs(BatchLogs__c BatchLogsList){
        
        try
        {
            upsert BatchLogsList External_Id__c; 
        }
        
        catch(exception e)
        {
            exceptionHandler(e, 'Util', 'upsertBatchLogsData');
            
        }    
        
    }*/
    
    global static void insertCustomSettingData(){
        List<AIES_ACCENTURE__ChartType__c> chartTypeList = new List<AIES_ACCENTURE__ChartType__c>();
        
        Map<string,string> map_customsettingChartLabel = new Map<string,string>();
        Map<string,string> map_customsettingType = new Map<string,string>();
        
        map_customsettingChartLabel.put('Funnel','Funnel');
        map_customsettingChartLabel.put('Thermometer','Thermometer');
        map_customsettingChartLabel.put('Vled','Vertilcal Lead');
        map_customsettingChartLabel.put('Bar2D','Bar 2D');
        map_customsettingChartLabel.put('Line','Line');
        map_customsettingChartLabel.put('Doughnut3D','Doughnut 3D');
        map_customsettingChartLabel.put('Column3D','Column 3D');
        map_customsettingChartLabel.put('Bulb','Bulb');
        map_customsettingChartLabel.put('Bar3D','Bar 3D');        
        map_customsettingChartLabel.put('Pie3D','Pie 3D');
        map_customsettingChartLabel.put('Pareto2D','Pareto 2D');
        map_customsettingChartLabel.put('AngularGauge','Angular Gauge');
        map_customsettingChartLabel.put('Pyramid','Pyramid');
        map_customsettingChartLabel.put('Column2D','Column 2D');
        map_customsettingChartLabel.put('Pie2D','Pie 2D');
        map_customsettingChartLabel.put('Area2D','Area 2D');
        map_customsettingChartLabel.put('Doughnut2D','Doughnut 2D');
        map_customsettingChartLabel.put('HLinearGauge','HLinear Gauge');        
        map_customsettingChartLabel.put('Hled','Horizontal Lead');
        map_customsettingChartLabel.put('Pareto3D','Pareto 3D');        
        map_customsettingChartLabel.put('Cylinder','Cylinder');
        map_customsettingChartLabel.put('ZoomLine','Zoom Line');
        map_customsettingChartLabel.put('MSColumn3D','Column 3D');        
        map_customsettingChartLabel.put('StackedColumn3D','Stacked Column3D');
        map_customsettingChartLabel.put('MSLine','Line');
        map_customsettingChartLabel.put('MSBar2D','Bar 2D');
        map_customsettingChartLabel.put('Marimekko','Marimekko');        
        map_customsettingChartLabel.put('MSArea','Area');
        map_customsettingChartLabel.put('MSColumn2D','Column 2D');
        map_customsettingChartLabel.put('MSBar3D','Bar 3D');
        
        
        
        map_customsettingType.put('Funnel','keyPair');
        map_customsettingType.put('Thermometer','Score');
        map_customsettingType.put('Vled','Score');
        map_customsettingType.put('Bar2D','keyPair');
        map_customsettingType.put('Line','keyPair');
        map_customsettingType.put('Doughnut3D','keyPair');
        map_customsettingType.put('Column3D','keyPair');
        map_customsettingType.put('Bulb','Score');
        map_customsettingType.put('Bar3D','keyPair');        
        map_customsettingType.put('Pie3D','keyPair');
        map_customsettingType.put('Pareto2D','keyPair');
        map_customsettingType.put('AngularGauge','Score');
        map_customsettingType.put('Pyramid','keyPair');
        map_customsettingType.put('Column2D','keyPair');
        map_customsettingType.put('Pie2D','keyPair');
        map_customsettingType.put('Area2D','keyPair');
        map_customsettingType.put('Doughnut 2D','keyPair');
        map_customsettingType.put('HLinearGauge','Score');        
        map_customsettingType.put('Hled','Score');
        map_customsettingType.put('Pareto3D','keyPair');        
        map_customsettingType.put('Cylinder','Score');
        map_customsettingType.put('ZoomLine','multiSeries');
        map_customsettingType.put('MSColumn3D','multiSeries');        
        map_customsettingType.put('StackedColumn3D','multiSeries');
        map_customsettingType.put('MSLine','multiSeries');
        map_customsettingType.put('MSBar2D','multiSeries');
        map_customsettingType.put('Marimekko','multiSeries');        
        map_customsettingType.put('MSArea','multiSeries');
        map_customsettingType.put('MSColumn2D','multiSeries');
        map_customsettingType.put('MSBar3D','multiSeries');
        
        // add more values (or) move this adding values to some other class for more readable 
        //
        List<AIES_ACCENTURE__ChartType__c> chartTypeListToInsert = new List<AIES_ACCENTURE__ChartType__c>();
        chartTypeList = AIES_ACCENTURE__ChartType__c.getall().values();
        set<string> customSettingSet = new set<string>();
        for(integer i=0;i<chartTypeList.size();i++){
            customSettingSet.add(chartTypeList[i].name);            
        }        
        for(string sx : map_customsettingChartLabel.keySet()){
            if(customSettingSet.contains(sx)){ 
                //do nothing 
            }
            else{
                chartTypeListToInsert.add(new AIES_ACCENTURE__ChartType__c(Name=sx,AIES_ACCENTURE__ChartLabel__c =map_customsettingChartLabel.get(sx),AIES_ACCENTURE__Type__c=map_customsettingType.get(sx)));
            }
        }        
        if(chartTypeListToInsert.size() > 0){
            Database.insert(chartTypeListToInsert);
        }
    }
    
    
    // To Clean existing Metric data records before start creating new records on Metric data
    
    global static void cleanExistingMetricData(String metricName){
    
            List<AIES_ACCENTURE__AIESMetricData__c> mmetricMasterList = [select id, name,AIES_ACCENTURE__MetricMaster__r.name,AIES_ACCENTURE__Portfolio__c from AIES_ACCENTURE__AIESMetricData__c where AIES_ACCENTURE__MetricMaster__r.name  =: metricName and  AIES_ACCENTURE__Portfolio__c=: Portfolio];
            try{
                if(mmetricMasterList.size() > 0){
                    Database.delete(mmetricMasterList);
                } 
            }
            catch(System.DmlException ex){
                system.debug('ERROR===>'+ex.getMessage()+'==@line No==>'+ex.getLineNumber());
            }
    }
    
    
    
    webservice static string  createOverviewRecommendData(Id currentPortfolioId) //dynamic insert record in OverviewAndRecomendation Object when click "Create Overvie data" button from Portfolio detail page
    { 
        
        
        list<AIES_ACCENTURE__Overview_Recommendation__c> finalRecordList=new list<AIES_ACCENTURE__Overview_Recommendation__c>();  
        List<AIES_ACCENTURE__Overview_Recommendation__c> overviewRecommendationTemplate = new List<AIES_ACCENTURE__Overview_Recommendation__c >();
        overviewRecommendationTemplate  = [select id, name, AIES_ACCENTURE__Portfolio__c,AIES_ACCENTURE__Overview__c,AIES_ACCENTURE__IsTemplate__c,
                                           AIES_ACCENTURE__Recommendation__c,AIES_ACCENTURE__SME_Recommendation__c,AIES_ACCENTURE__Summary__c from AIES_ACCENTURE__Overview_Recommendation__c 
                                           where AIES_ACCENTURE__IsTemplate__c=true and AIES_ACCENTURE__Portfolio__c=null limit 20];
        List<AIES_ACCENTURE__Overview_Recommendation__c> ExistingRecommendationsData = [select id, name, AIES_ACCENTURE__Portfolio__c,AIES_ACCENTURE__Recommendation__c,
                                                                        AIES_ACCENTURE__SME_Recommendation__c,AIES_ACCENTURE__Summary__c from AIES_ACCENTURE__Overview_Recommendation__c 
                                                                        where AIES_ACCENTURE__IsTemplate__c=false and AIES_ACCENTURE__Portfolio__c=:currentPortfolioId limit 20];
        String returnval='';
        
        try{
            if(overviewRecommendationTemplate.size()>0)
            {
                if(ExistingRecommendationsData.size()>0){
                    
                    returnval='update';                  
                }
                else{    
                    for(AIES_ACCENTURE__Overview_Recommendation__c overRec : overviewRecommendationTemplate )
                    { 
                        AIES_ACCENTURE__Overview_Recommendation__c overviewRecommendation=new AIES_ACCENTURE__Overview_Recommendation__c();  
                        overviewRecommendation.Name=overRec.Name; 
                        overviewRecommendation.AIES_ACCENTURE__Portfolio__c=currentPortfolioId;
                        overviewRecommendation.AIES_ACCENTURE__Recommendation__c=overRec.AIES_ACCENTURE__Recommendation__c;
                        overviewRecommendation.AIES_ACCENTURE__SME_Recommendation__c=overRec.AIES_ACCENTURE__SME_Recommendation__c;
                        overviewRecommendation.AIES_ACCENTURE__Summary__c=overRec.AIES_ACCENTURE__Summary__c;
                        overviewRecommendation.AIES_ACCENTURE__Overview__c=overRec.AIES_ACCENTURE__Overview__c;
                        finalRecordList.add(overviewRecommendation);
                     }
                    insert finalRecordList;
                    returnval='insert'; 
                 }   
            }
             
        }
        catch (Exception e) {
           returnval= 'error';
           system.Debug('error Message :'+e.getMessage());
        }
        
       return returnval;
    } 
}