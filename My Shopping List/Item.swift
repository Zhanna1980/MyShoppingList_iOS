//
//  Item.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

class Item{
    fileprivate var _name: String;
    fileprivate var _inTheCart: Bool = false;
    fileprivate var _calculations: ItemCalculations;
    fileprivate var _previousPositionInItemList: Int = -1;
    fileprivate var _itemImage: UIImage?;
    fileprivate var _category: String?;
    fileprivate var _notes: String?;
    
    init (name: String){
        self._name = name;
        self._calculations = ItemCalculations(quantity: 1);
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
    
    var calculations: ItemCalculations{
        get{
            return _calculations;
        }
        set{
            _calculations = newValue;
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
    
    

}
