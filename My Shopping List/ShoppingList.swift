//
//  Shopping List.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class ShoppingList {
    
    var itemList: [Item];
    var itemsInTheCart: [Item];
    fileprivate var _name: String;
    fileprivate var _date: String;
    
    init(name: String, date: String){
        self._name = name;
        self._date = date;
        self.itemList = [Item]();
        self.itemsInTheCart = [Item]();
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
    
}
