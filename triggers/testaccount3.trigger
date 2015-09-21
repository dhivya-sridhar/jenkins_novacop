trigger testaccount3 on Account (before update) {
    
    Account[] acc =Trigger.new;
    
    for(Account aa :acc){
    aa.name= aa.name+ '_AIESTest';
           
    }

}