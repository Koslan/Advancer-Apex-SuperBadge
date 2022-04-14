public with sharing class TestDataFactory {
    public static List<Product2> product2List = new List<Product2>();
    public static List<PricebookEntry> pBentryies = new List<PricebookEntry>();
    public static List<Account> accounts = new List<Account>();
    public static List<Contact> contacts = new List<Contact>();
    public static List<Order> orders = new List<Order>();
    public static List<OrderItem> orderItems = new List<OrderItem>();
    static Collaborationgroup namegroup = new Collaborationgroup ();


    public static void InsertTestData(Integer val){
        product2List = TestDataFactory.genProducts(val);
        insert product2List;

        pBentryies = TestDataFactory.genPricebookEntries(product2List);
        insert pBentryies;

        accounts = TestDataFactory.genAccounts(val);
        insert accounts;

        insert TestDataFactory.gencontacts(val, accounts);

        orders = TestDataFactory.genOrders(val,accounts);
        insert orders;

        System.debug('TestDataFactory.InsertTestData  : row19:: ' + orders);    

        insert TestDataFactory.genOrderItems(val, pBentryies, orders);
    }



    public static Collaborationgroup genCollaborationgroup(){
        namegroup.CollaborationType  =  'Public';
        namegroup.Name = 'TEST'  +  Constants.INVENTORY_ANNOUNCEMENTS;
        return namegroup;
    }

    public static List<Product2> genProducts(Integer cnt){
        List<Product2> product2List = new List<Product2>();
               
        Integer picklistSize = Constants.PRODUCT_FAMILY.size();
        System.debug(picklistSize + ' ' + Constants.PRODUCT_FAMILY[0].getValue());

        for(Integer j = 0, i = 0; j < cnt; j++){
            Product2 p = new Product2();
            p.Name = 'TestData Product '  + i;
            p.IsActive = true;
            p.Initial_Inventory__c = 10;
            p.Family = Constants.PRODUCT_FAMILY[j].getValue();
            if(j == picklistSize - 1){
                j = 0;
            }
            i++;
            product2List.add(p);
        }
        System.debug('before insert ' + product2List);
        System.debug('after insert ' + product2List);
        return product2List;
    }


    public static List<PricebookEntry> genPricebookEntries(List<Product2> prods){
        List<PriceBookEntry> priceBooks =  new List<PriceBookEntry>();
        
        for(product2 p : prods){
            PricebookEntry pbe = new PricebookEntry();
            pbe.UnitPrice = (Decimal)100;
            pbe.IsActive = true;
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            
            priceBooks.add(pbe);
        }
            
        return priceBooks;
    }

    public static List<Account> genAccounts(Integer cnt){
        List<Account> accounts = new List<Account>();
        for(Integer j = 0, i = 0; j < cnt; j++){
            Account a = new Account();
            a.Name = 'Account' + i;
            a.Rating = 'Hot';
            i++;
            accounts.add(a);
        }
        return accounts;
    }




    public static List<Contact> genContacts(Integer cnt, List<Account> accts){
        List<Contact> contacts = new List<Contact>();
        for(Integer j = 0, i = 0; j < cnt; j++){
            Contact c = new Contact();
            c.AccountId = accts.get(i).Id;
            c.LastName = 'Contact ' + i;
            i++;
            contacts.add(c);
        }
        return contacts;
    }

    public static List<Order> genOrders(Integer cnt, List<Account> accts){
        List<Order> orders = new List<Order>();
        for(Integer j = 0, i = 0; j < cnt; j++){
          Contract c = new Contract(AccountId = accts.get(i).Id,Status = 'Draft',StartDate  = date.today(),ContractTerm  = 12);
          Order o = new Order();
          o.AccountId = accts.get(i).Id;
          o.EffectiveDate = date.today();
          o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
          o.ContractId = c.Id ;
          o.Status = 'Draft';
          i++;
          orders.add(o);
        }
        return orders;
    }

    public static List<OrderItem> genOrderItems(Integer cnt, List<pricebookentry> pbes, List<order> ords){
        List<OrderItem> items = new List<OrderItem>();
        for(Integer j = 0, i = 0; j < cnt; j++){
            OrderItem oi = new OrderItem();
            oi.Quantity = Constants.DEFAULT_ROWS;
            oi.PricebookEntryId = pbes.get(i).Id;
            System.debug('pricebook' + oi.PricebookEntryId + ' ' + pbes.get(i).Id);
            oi.OrderId = ords.get(i).Id;
            oi.UnitPrice = (Decimal)100;
            i++;
            items.add(oi);
        }
        return items;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(updatedProduct.Quantity_Ordered__c, (originalProduct.Quantity_Ordered__c  +  qtyOrdered));
    }
    
}
