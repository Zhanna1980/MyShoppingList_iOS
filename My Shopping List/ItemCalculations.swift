//
//  ItemCalculations.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class ItemCalculations{
    static var units: [String] = ["bag", "bottle", "box", "bunch", "can", "case", "cm", "dl", "dozen", "g", "gallon", "jar", "kg", "l", "large", "lbs", "m", "medium", "ml", "pack", "pair", "piece", "roll", "small"];
    fileprivate var _unit: String;
    fileprivate var _quantity: Float;
    
    
    init(quantity: Float){
        self._quantity = quantity;
        self._unit = "";
    }
    
    var unit: String {
        get{
            return _unit;
        }
        set{
            if !newValue.isEmpty && !ItemCalculations.units.contains(newValue){
                ItemCalculations.units.append(newValue);
                ItemCalculations.units = ItemCalculations.units.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending };
            }
            _unit = newValue;
        }
    }
    
    var quantity: Float{
        get{
            return _quantity;
        }
        set{
            if newValue > 0{
                _quantity = newValue;
            }
        }
    }
    
    func toString () -> String {
        return "\(_quantity) \(_unit)";
        
    }
    
    
}
