//
//  Item.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject, NSCoding{
    fileprivate var _name: String;
    fileprivate var _inTheCart: Bool = false;
    fileprivate var _itemQuantityAndUnits: ItemQuantityAndUnits;
    fileprivate var _previousPositionInItemList: Int = 0;
    fileprivate var _itemImage: UIImage?;
    fileprivate var _category: String?;
    fileprivate var _notes: String?;
    
    init (name: String){
        self._name = name;
        self._itemQuantityAndUnits = ItemQuantityAndUnits(quantity: 1, unit: "");
        super.init();
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String;
        let quantityAndUnits = aDecoder.decodeObject(forKey: PropertyKey.quantityAndUnitsKey) as! ItemQuantityAndUnits;
        let inTheCart = aDecoder.decodeBool(forKey: PropertyKey.inTheCartKey);
        let previousPositionInItemList = aDecoder.decodeInteger(forKey: PropertyKey.previousPositionInItemListKey);
        let itemImage = aDecoder.decodeObject(forKey: PropertyKey.itemImageKey) as? UIImage;
        let category = aDecoder.decodeObject(forKey: PropertyKey.categoryKey) as? String;
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notesKey) as? String;
        self.init(name: name);
        self._itemQuantityAndUnits = quantityAndUnits;
        self._previousPositionInItemList = previousPositionInItemList;
        self._inTheCart = inTheCart;
        self._itemImage = itemImage;
        self._category = category;
        self._notes = notes;
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
    
    var inTheCart: Bool{
        get{
            return _inTheCart;
        }
        set{
            _inTheCart = newValue;
        }
    }
    
    var previousPositionInItemList: Int{
        get{
            return _previousPositionInItemList;
        }
        set{
            if newValue >= 0{
                _previousPositionInItemList = newValue;
            }
        }
    }
    
    var itemQuantityAndUnits: ItemQuantityAndUnits{
        get{
            return _itemQuantityAndUnits;
        }
        set{
            _itemQuantityAndUnits = newValue;
        }
    }
    
    var itemImage: UIImage?{
        get{
            return _itemImage;
        }
        set{
            _itemImage = newValue;
        }
    }
    var category: String?{
        get{
            return _category;
        }
        set{
            _category = newValue;
        }
    }
    
    var notes: String?{
        get{
            return _notes;
        }
        set{
            _notes = newValue;
        }
    }
    
    func describeItem() -> String{
        return (self._name + " " + self._itemQuantityAndUnits.toString());
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: PropertyKey.nameKey);
        aCoder.encode(_inTheCart, forKey: PropertyKey.inTheCartKey);
        aCoder.encode(_previousPositionInItemList, forKey: PropertyKey.previousPositionInItemListKey);
        aCoder.encode(_itemImage, forKey: PropertyKey.itemImageKey);
        aCoder.encode(_notes, forKey: PropertyKey.notesKey);
        aCoder.encode(_category, forKey: PropertyKey.categoryKey);
        aCoder.encode(_itemQuantityAndUnits, forKey: PropertyKey.quantityAndUnitsKey);
    }
}
