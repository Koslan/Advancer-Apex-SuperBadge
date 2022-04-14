@isTest (SeeAllData=false)
private class OrderTests {
    
    @testSetup
    static void SetupTestData() {
        TestDataFactory.insertTestData(2);
    }
 
    static testmethod void OrderUpdate_UnitTest() {
    	Order selectedOrder = [Select name,Status, Id from Order limit 1];
        Product2 oldProd = [Select Quantity_Ordered__c, Name, Id from Product2 LIMIT 1];
        
        selectedOrder.Status = Constants.ACTIVATED_ORDER_STATUS;
        update selectedOrder;
        
        Product2 updatedProd = [Select Quantity_Ordered__c, Name, Id FROM Product2 LIMIT 1];
        
        TestDataFactory.verifyQuantityOrdered(oldProd,updatedProd,Constants.DEFAULT_ROWS);
    }
    
    @istest 
    private static  void OrderExtension_UnitTest() {

        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);
        Order CurOrder = [SELECT Id,Status FROM Order LIMIT 1];

        ApexPages.StandardController controller = new Apexpages.StandardController(CurOrder);
        OrderExtension extension = new OrderExtension(controller);
        
        System.assertEquals(2, extension.orderItemList.size());
                extension.OnFieldChange();
                extension.SelectFamily();
                extension.Save();
                extension.First();
        		extension.Next();
                extension.Previous();
        		extension.Last();
                extension.GetHasPrevious();
                extension.GetHasNext();
                extension.GetTotalPages();
                extension.GetPageNumber();
        
        List<SelectOption> options = extension.GetFamilyOptions();
    } 
}