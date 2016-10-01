//
//  ItemCalculations.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class ItemCalculations{
    static var units: [String] = [String]();
    fileprivate var _unit: String?;
    fileprivate var _quantity: Float;
    fileprivate var _price: Float?;
    fileprivate var _sum: Float?;
    
    init(quantity: Float){
        self._quantity = quantity;
    }
    
    var unit: String {
        get{
            if let theUnit = _unit{
                return theUnit
            }
            else{
                return "nil";
            }
        }
    }
    
}
