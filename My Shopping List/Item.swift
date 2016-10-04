//
//  Item.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class Item{
    fileprivate var _name: String;
    fileprivate var _inTheCart: Bool = false;
    fileprivate var _calculations: ItemCalculations?;
    fileprivate var _previousPositionInItemList: Int = -1;
    
    init (name: String){
        self._name = name;
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

}
