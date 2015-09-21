/**
 *
 *    TestClassName: BatchCaseCRMJourney_StackChartTest
 *
 *    @Author : SunilKumar and Santosh Mohanty
 */
 

@isTest(seealldata = true)                               
                                
public class PDC_BatchCaseCRMJourney_SM6Test {

    /*static testmethod void testMethod1() {   
    
     Integer i=0;
        List<Case> caseList = new List<Case>();
        Case cs=new Case();
        cs.Status='Closed';
        cs.Origin='Email';
        caseList.add(cs);
        
        Case cs1=new Case();
        cs1.Status='Closed';
        cs1.Origin='Email';
        caseList.add(cs1);
        insert caseList;
       
        PDC_BatchCaseCRMJourney_SM6 a=new PDC_BatchCaseCRMJourney_SM6();
        database.executeBatch(a,2000);
        
        List<Case> caseList1 = new List<Case>();
        
        Database.BatchableContext batchableContext = null;
        PDC_BatchCaseCRMJourney_SM6 BatchClassObj = new PDC_BatchCaseCRMJourney_SM6();
        BatchClassObj.start(batchableContext);
        BatchClassObj.execute(batchableContext,caseList);
        BatchClassObj.finish(batchableContext);
     
        
    }*/

    static testmethod void testMethod1() {
        Date today = date.today();
        
        List<Case> testCaseList = new List<Case>();
        for(Integer x=1; x<=600; x++){
            Case testCase = new Case();
            if(x<=100){
                testCase.Status = 'New';
                testCase.Origin = 'Phone';
                //testCase.CreatedDate = today.addMonths(-1);
            }else if(x>100 && x<=200) {
                testCase.Status = 'New';
                testCase.Origin = 'Email';
                //testCase.CreatedDate = today.addMonths(-2);
            }else if(x>200 && x<=300) {
                testCase.Status = 'New';
                testCase.Origin = 'Phone';
                //testCase.CreatedDate = today.addMonths(-3);
            }else if(x>300 && x<=400) {
                testCase.Status = 'Closed';
                testCase.Origin = 'Phone';
                //testCase.ClosedDate = today.addMonths(-4);
            }else if(x>400 && x<=500) {
                testCase.Status = 'Closed';
                testCase.Origin = 'Email';
                //testCase.ClosedDate = today.addMonths(-5);
            }else {
                testCase.Status = 'Closed';
                testCase.Origin = 'Phone';
                //testCase.ClosedDate = today.addMonths(-6);
            }
            testCaseList.add(testCase);
        }
        insert testCaseList;
        
        //test.startTest();
        
        PDC_BatchCaseCRMJourney_SM6 testBatch = new PDC_BatchCaseCRMJourney_SM6();
        ID batchprocessid = Database.executeBatch(testBatch, 600);
        
        Database.BatchableContext batchableContext = null;
        PDC_BatchCaseCRMJourney_SM6 BatchClassObj = new PDC_BatchCaseCRMJourney_SM6();
        BatchClassObj.start(batchableContext);
        BatchClassObj.execute(batchableContext,testCaseList);
        BatchClassObj.finish(batchableContext);
        
        //test.stopTest();
        
    }

}