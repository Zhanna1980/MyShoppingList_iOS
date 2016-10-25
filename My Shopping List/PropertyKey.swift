//
//  PropertyKey.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 15/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

// keys for encoding program data into the file to prevent typos in strings
struct PropertyKey {
    // for Item class:
    static let nameKey = "name";
    static let inTheCartKey = "inTheCart";
    static let previousPositionInItemListKey = "previousPositionInItemList";
    static let itemImageKey = "itemImage";
    static let categoryKey = "category";
    static let notesKey = "notes";
    static let calculationsKey = "calculations";
    // for ItemCalculations class:
    static let unitKey = "unit";
    static let quantityKey = "quantity";
    // for ShoppingList class:
    static let itemListKey = "itemList";
    static let itemsInTheCartKey = "itemsInTheCart";
    static let dateKey = "date";
    // for CurrentState Class:
    static let listsListKey = "listsList";
    static let unitsArrayKey = "units";
}
