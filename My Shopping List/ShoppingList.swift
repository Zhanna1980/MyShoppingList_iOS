//
//  Shopping List.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class ShoppingList: NSObject, NSCoding {
    
    
    
    // MARK: Properties:
    var itemList: [Item];
    var itemsInTheCart: [Item];
    fileprivate var _name: String;
    fileprivate var _date: String;
    
    init(name: String, date: String){
        self._name = name;
        self._date = date;
        self.itemList = [Item]();
        self.itemsInTheCart = [Item]();
        super.init();
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String;
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as! String;
        let itemList = aDecoder.decodeObject(forKey: PropertyKey.itemListKey) as! [Item];
        let itemsInTheCart = aDecoder.decodeObject(forKey: PropertyKey.itemsInTheCartKey) as! [Item];
        self.init(name: name, date: date);
        self.itemList.append(contentsOf: itemList);
        self.itemsInTheCart.append(contentsOf: itemsInTheCart);
    }
    
    var name: String{
        get{
            return _name;
        }
        set{
            if !newValue.isEmpty{
                _name = newValue;
            }
        }
    }
    var date: String{
        get{
            return _date;
        }
        set{
            _date = newValue;
        }
    }
    
    func describeShoppingList() -> String{
        var description: String = _name + ": ";
        for var i in 0..<itemList.count{
            let ending = i < itemList.count - 1 ? ", " : ".";
            description = description + itemList[i].describeItem() + ending;
        }
        return description;
    }
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: PropertyKey.nameKey);
        aCoder.encode(_date, forKey: PropertyKey.dateKey);
        aCoder.encode(itemList, forKey: PropertyKey.itemListKey);
        aCoder.encode(itemsInTheCart, forKey: PropertyKey.itemsInTheCartKey);
        
    }

    
}
