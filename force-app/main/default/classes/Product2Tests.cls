@isTest (seeAllData=false)
private class Product2Tests {

  @isTest 
    static void Product2Extension_UnitTest(){
        Test.startTest();

            PageReference pageRef = Page.Product2New;
            Test.setCurrentPage(pageRef);
            Product2 prod = new Product2(name='Test', isActive=true);   

            ApexPages.StandardController stdcontroller = new ApexPages.StandardController(prod);        
            Product2Extension ext = new Product2Extension(stdcontroller);        
               System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());

            ext.addRows();
            System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());

            for (Integer i = 0; i < 5; i++) {
                Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];

                Product2 testProduct = new Product2();
                testProduct.Name = 'Test Product ' + i;
                testProduct.IsActive = true;
                testProduct.Initial_Inventory__c = 20;
                testProduct.Family = Constants.PRODUCT_FAMILY[0].getValue();
                wrapper.productRecord = testProduct;

                PricebookEntry testEntry = new PricebookEntry();
                testEntry.IsActive = true;
                testEntry.UnitPrice = 10;
                wrapper.pricebookEntryRecord = testEntry;
            }


        
            System.debug('productTests 37' + [SELECT Id FROM CollaborationGroup WHERE Name = 'Inventory Announcements']);
            ext.save();


            ext.GetFamilyOptions();
            ext.GetInventory();
        Test.stopTest();
        
        System.assertEquals(5, [Select Count() from Product2]);
    }
    
    static TestMethod void Product2Trigger_UnitTest(){
        Test.startTest();
        
            Product2 p = new Product2();
            p.Name='TestProduct';
            p.Family='Side';
            p.IsActive=true;
            p.Quantity_Ordered__c = 50;
            p.Initial_Inventory__c = 100;
            insert p;

            CollaborationGroup c = new CollaborationGroup();
            c.Name = 'Test Inventory Announcements';
            c.Description = 'test';
            c.CollaborationType = 'public';
            insert c;

            p.Quantity_Ordered__c = 96;
            update p;
            
        Test.stopTest();
    }
}