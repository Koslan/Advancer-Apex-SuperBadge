public without sharing class OrderHelper {

    public static List<Double> check = new List<Double>();
    public Static List<Product2> pr;

    public static void afterUpdate(List<Order> newOrderList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();

        for ( Integer i=0; i < newOrderList.size(); i++){
            if (newOrderList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status == Constants.DRAFT_ORDER_STATUS){
                orderIds.add(newOrderList[i].Id);
            }
        }
        
        updateOrderItems(orderIds);
    }

    public static void updateOrderItems(Set<Id> activatedOrderIds){
    
        Map<Id, Product2> productMap =new Map<ID,Product2>();
        List<OrderItem> orderId = [SELECT OrderID,Product2Id 
                                    FROM OrderItem 
                                    WHERE OrderId IN: activatedOrderIds];
        
        for(OrderItem o: orderId){
            Product2 p = [SELECT name,Quantity_Ordered__c 
                            FROM Product2 
                            WHERE Id=: o.Product2Id];
            productmap.put(o.Product2Id, p);
            
        } 

        pr = new List<Product2>();
    
        AggregateResult[] groupedResults =[SELECT Product2Id ,SUM(Quantity) 
                                            FROM OrderItem 
                                            WHERE Product2Id IN : productMap.keySet() 
                                            GROUP BY Product2Id];
    
        for(AggregateResult ag : groupedResults){
            Product2 p = productMap.get((Id)ag.get('Product2Id'));
            p.Quantity_Ordered__c = (Double)ag.get('expr0');
            pr.add(p);
            check.add((Double)ag.get('expr0'));     
        }
        
        update pr;
    }
}