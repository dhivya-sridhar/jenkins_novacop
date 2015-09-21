/*
Date: 03.07.2014
Author: Dorai
Description: Application wide Data Completeness - all objects specified in the constructor set parameter 
                        Calculate last three individual months count, last three individual months stale count, 
                        record completeness for each oject and total records for each object 
Version: v0.1
Reports: Created the source for multiple reports  
*/ 

global class Batch_VolumeMetric_Data_Completeness implements Database.batchable<sobject>, Database.stateful
{

        @TESTVISIBLE Date d00=Util.d00;
        @TESTVISIBLE Date d01=Util.d01;
        @TESTVISIBLE Date d02=Util.d02;
        @TESTVISIBLE Date d03=Util.d03;
        @TESTVISIBLE Date d04=Util.d04;
        @TESTVISIBLE Date d05=Util.d05;      
        
    string objectName;   
    Set<String> masterList;  
    map<string,integer> myMap= new map<string,integer>();
    Integer lastMonthCount; 
    Integer secondLastMonthCount;
    Integer thirdLastMonthCount;   
     
    Integer ModifiedOneMonthAgo; 
    Integer ModifiedTwoMonthAgo;
    Integer ModifiedThreeMonthAgo;
      
    Integer totalRecords;
    Integer nullFieldsCount;
    Integer objectLevelNullFieldsCount;
    Integer complete;
    Integer aboveAverage;         
    Integer average;
    Integer belowAverage;    
    Set<String> processingList; 
    List<String> objectsList = new List<String>();
    Map<String,String> ObjMap = new Map<String,String>();
  /*  
 global Batch_VolumeMetric_Data_Completeness(Set<String> objs){
        try{
        processingList = objs;
        objectsList = new List<String>(objs); 
        objectName = objectsList[0];
        }catch(Exception e){
             util.ExceptionHandler(e, 'Batch_VolumeMetric_Data_Completeness', 'Batch_VolumeMetric_Data_Completeness');
        } 
        // Initializing variables
        totalRecords = nullFieldsCount = complete = aboveAverage = average = belowAverage = lastMonthCount = secondLastMonthCount = thirdLastMonthCount 
        = objectLevelNullFieldsCount = ModifiedOneMonthAgo = ModifiedTwoMonthAgo = ModifiedThreeMonthAgo = 0;         
 }  */
 
  global Batch_VolumeMetric_Data_Completeness(Map<String,String> finalMasterMap){
        try{
       ObjMap =finalMasterMap;
        processingList = finalMasterMap.keySet();
        objectsList.addAll(finalMasterMap.keySet()); 
        objectName = objectsList[0];
        }catch(Exception e){
             util.ExceptionHandler(e, 'Batch_VolumeMetric_Data_Completeness', 'Batch_VolumeMetric_Data_Completeness');
        } 
        // Initializing variables
        totalRecords = nullFieldsCount = complete = aboveAverage = average = belowAverage = lastMonthCount = secondLastMonthCount = thirdLastMonthCount 
        = objectLevelNullFieldsCount = ModifiedOneMonthAgo = ModifiedTwoMonthAgo = ModifiedThreeMonthAgo = 0;         
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {   
        //new query
        String query='Id, ';
       // try{
        //find our fields for object
        system.debug('objectName****'+objectName);
        Map<String, Schema.SObjectField> fieldMap  = Schema.getglobalDescribe().get(objectName).getDescribe().fields.getMap();
            
        //add our fields to a list
        masterList = new Set<string>();
            for(String flds: fieldMap.keyset()){
                If(flds.contains('__c')){
                masterList.add(flds);
                }
            }
        
        //loop our list to prep our result map and to build our query
            for(string mapPrep : masterList)
            {
                //set initial value of zero
                myMap.put((mapPrep.tolowercase()),0);
                //query build
                query=query + mapPrep + ', ';
            }
           /* }catch(Exception e){
             util.ExceptionHandler(e, 'Batch_VolumeMetric_Data_Completeness', 'start');
        }*/
        try{
        return Database.getQueryLocator('select LastModifiedDate, createddate,' + query.substring(0,query.length()-2) +' from '+ objectName + ' where createddate >='+ d05 );
        }
        catch(Exception e){
             //util.ExceptionHandler(e, 'Batch_VolumeMetric_Data_Completeness', 'start');
             return Database.getQueryLocator('SELECT Name FROM Account limit 0');
             
             
        }       
        
    }
  
    global void execute(Database.BatchableContext Bc, List<sobject> scope)
    {
        try{
        //loop records for this execution
        for(sobject item : scope)
        
        {
            //loop for each field
            for(string item0:masterList)
            {
                //null check
                system.debug('processing obj ---> ' + item0 );
                try
                {
                    if(item.get(item0) == null)
                    {
                        //get our current field, increment and put it back in
                        //myMap would contain the no of null occurrences of each field
                        
                        myMap.put(item0,(myMap.get(item0) == null ? 0 : myMap.get(item0) +1)); // suspected null pointer error and corrected
                        
                        //myMap.put(item0,myMap.get(item0)+1)
                         
                        nullFieldsCount++;   // 20k
                        objectLevelNullFieldsCount++; // 20k
                    }
                }
                catch(exception e)
                {
                
                }
                
                    
            }
            
            
            if(nullFieldsCount != 0){
              //if((100-((100/masterList.size())/nullFieldsCount)) == 100){complete++;} else  
              if((100-((100/masterList.size())/nullFieldsCount)) > 70){aboveAverage++;}
              else  if((100-((100/masterList.size())/nullFieldsCount)) > 40){average++;}
              else  {belowAverage++;}
            }
            
            else
            { 
                  complete++;
            }
            
            

          //record counter
         totalRecords++; //15lakh
            
            DATE d1 = date.today().addMonths(-1); // Jan 2015
            Date d2 = date.today().addMonths(-2); // Dec 2014
            Date d3 = date.today().addMonths(-3); // Nov 2014
            Date d4 = date.today().addMonths(-4); // Oct 2014
           
         /* DATE y1 = date.today().addYears(-1);  // 2014 Feb
            Date y2 = date.today().addYears(-2);  // 2013 Feb
            Date y3 = date.today().addYears(-3);  // 2012 Feb
            Date y4 = date.today().addYears(-4);  // 2011 Feb */
            
            if(Datetime.valueOf(item.get('createddate')).Date() > d4){
                if(Datetime.valueOf(item.get('createddate')).Date() < d3) {
                    thirdLastMonthCount++ ;
                }else if (Datetime.valueOf(item.get('createddate')).Date() < d2)  {
                    secondLastMonthCount++;
                }else if (Datetime.valueOf(item.get('createddate')).Date() < d1) {
                    lastMonthCount++;
                }
            }
            
          /*  if(Datetime.valueOf(item.get('LastModifiedDate')).Date() > y4){
                if(Datetime.valueOf(item.get('LastModifiedDate')).Date() < y3) {
                    ModifiedThreeMonthAgo++ ;
                }else if (Datetime.valueOf(item.get('LastModifiedDate')).Date() < y2) {
                    ModifiedTwoMonthAgo++;
                }else if (Datetime.valueOf(item.get('LastModifiedDate')).Date() < y1) {
                    ModifiedOneMonthAgo++; 
                }
            } */
           
      nullFieldsCount = 0;
            
            }
        }catch(Exception e){
             util.ExceptionHandler(e, 'Batch_VolumeMetric_Data_Completeness', 'execute');
        }
    }
  
  global void finish(Database.BatchableContext BC)
    {
        try{
            AIES_ACCENTURE__Volumetric_Data_Completeness__c v = new AIES_ACCENTURE__Volumetric_Data_Completeness__c();

            v.AIES_ACCENTURE__Object__c =  ObjMap.get(objectName); 
             
            if(totalRecords > 0){
                v.AIES_ACCENTURE__Complete__c      =  (complete*100/totalRecords);  
                v.AIES_ACCENTURE__AboveAverage__c  =  (aboveAverage*100/totalRecords);  
                v.AIES_ACCENTURE__BelowAverage__c  =  (belowAverage*100/totalRecords); 
            }   
            v.AIES_ACCENTURE__Total_Records__c =  totalRecords;    
            v.AIES_ACCENTURE__LastMonthCount__c = lastMonthCount;
            v.AIES_ACCENTURE__SecondLastMonthCount__c = secondLastMonthCount;
            v.AIES_ACCENTURE__ThirdLastMonthCount__c = thirdLastMonthCount; 
            
     // v.staleData1__c = ModifiedOneMonthAgo;
    // v.staleData2__c = ModifiedTwoMonthAgo;
   //  v.staleData3__c = ModifiedThreeMonthAgo;
   
            v.AIES_ACCENTURE__Portfolio__c = Util.portfolio;  
            v.AIES_ACCENTURE__ObjectName__c=objectName;
            System.debug('============= objectName ===================='+objectName) ;
            System.debug('=============ObjMap.get(objectName)===================='+ObjMap.get(objectName)) ;
            System.debug('================================='+v.AIES_ACCENTURE__Object__c) ;
            if(ObjMap.get(objectName)!=null){
        
       upsert v AIES_ACCENTURE__Object__c;  // will execute once
       
            }
            system.debug('v********'+v);
            
       string portfolio = Util.Portfolio;
       
       List<AIES_ACCENTURE__SObject__c> sobj = [select AIES_ACCENTURE__OverallCompleteness__c from AIES_ACCENTURE__SObject__c where name =: objectName 
                                and AIES_ACCENTURE__Portfolio__c = :Portfolio limit 1];
                                
                if(sobj != null){
                    for(AIES_ACCENTURE__SObject__c s: sobj){
                        if(totalRecords > 0 && masterList.size()>0){
                        s.AIES_ACCENTURE__OverallCompleteness__c = (objectLevelNullFieldsCount * 100) / (totalRecords * masterList.size());
                    }else{
                            s.AIES_ACCENTURE__OverallCompleteness__c =0;
                    }
                  }
                    
         update sobj; // will execute once 
                
                system.debug('sobj********'+sobj);
                }
            
        List<AIES_ACCENTURE__Field__c> objFields = new List<AIES_ACCENTURE__Field__c>();
            
         objFields = [Select AIES_ACCENTURE__APIName__c from AIES_ACCENTURE__Field__c 
                      where AIES_ACCENTURE__sObject__r.name =: objectName 
                      and AIES_ACCENTURE__sObject__r.AIES_ACCENTURE__portfolio__c =:Portfolio ];
              
           if (objFields.size() > 0){   // check the list size - updated here
           
            for(AIES_ACCENTURE__Field__c f:objFields){   
                   
                if(myMap.containsKey((f.AIES_ACCENTURE__APIName__c.tolowercase()))){
                    
                    if(totalRecords > 0){
                           
                           f.AIES_ACCENTURE__UtilizationRate__c = myMap.get((f.AIES_ACCENTURE__APIName__c.tolowercase()))/totalRecords;
                    }
                    
                    else{
                          f.AIES_ACCENTURE__UtilizationRate__c =0;
                    }
                } 
              }
             } 
         update objFields; // no of execution = count of null fields in the object
         
            system.debug('objFields********'+objFields);
          
          
         /* processingList.remove(objectName);
            If(!processingList.isEmpty()){ 
            Database.executeBatch(new Batch_VolumeMetric_Data_Completeness(processingList));
         }*/
            
            
           ObjMap.remove(objectName);
            
         //  objectLevelNullFieldsCount=0;
            
            If(!ObjMap.isEmpty()){ 
            Database.executeBatch(new Batch_VolumeMetric_Data_Completeness(ObjMap));
            }           
            
            }catch(Exception e){
             util.ExceptionHandler(e, 'Batch_VolumeMetric_Data_Completeness', 'finish');
            }   
    }
   }