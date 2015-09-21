trigger ProjectSubmitForApproval  on Project__c (after insert) {
 system.debug('----'+Trigger.new[0].Id);
    for (Integer i = 0; i < Trigger.new.size(); i++) {
 
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(Trigger.new[0].Id);
            // submit the approval request for processing
            try{
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());
            }
            catch(Exception ex){
                system.debug(ex.getMessage());
            }
            
    }
 
}