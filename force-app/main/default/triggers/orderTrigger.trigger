trigger orderTrigger on Order (after update) {
   
    if(Trigger.new != null) { 
        OrderHelper.afterUpdate(Trigger.new, Trigger.old);
    }
}