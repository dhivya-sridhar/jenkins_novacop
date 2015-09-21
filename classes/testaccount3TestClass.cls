@isTest

private class testaccount3TestClass {

    static testMethod void testaccount3() {
         list<Account> acm = new  list<Account>();
       
       Account a = new Account();
        a.Name='TestAccount';
       	insert a;
        integer count=0;
    	
        a.Name ='acme1';
    
        update a;
       // test.stopTest();
    }
}