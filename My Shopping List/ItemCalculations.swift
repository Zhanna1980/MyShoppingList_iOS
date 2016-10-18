//
//  ItemCalculations.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class ItemCalculations: NSObject, NSCoding {
    
    // MARK: Properties
    
    
    fileprivate var _unit: String;
    fileprivate var _quantity: Float;
    
    
    init(quantity: Float, unit: String){
        self._quantity = quantity;
        self._unit = unit;
        super.init();
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let quantity = aDecoder.decodeFloat(forKey: PropertyKey.quantityKey);
        let unit = aDecoder.decodeObject(forKey: PropertyKey.unitKey) as! String;
        self.init(quantity: quantity, unit: unit);
        
    }
    
    var unit: String {
        get{
            return _unit;
        }
        set{
            if !newValue.isEmpty && !CurrentState.instance.units.contains(newValue){
                CurrentState.instance.units.append(newValue);
                CurrentState.instance.units = CurrentState.instance.units.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending };
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
    
    func quantityToString() -> String{
        if _quantity.truncatingRemainder(dividingBy: 1) == 0{
            return String(format: "%.0f", _quantity);
        }
        else{
            return String(format: "%.2f", _quantity);
        }
    }
    
    func toString () -> String {
        return quantityToString() + " " + unit;
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_unit, forKey: PropertyKey.unitKey);
        aCoder.encode(_quantity, forKey: PropertyKey.quantityKey);
    }
}
