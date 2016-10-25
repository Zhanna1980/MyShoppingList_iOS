//
//  CurrentState.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 18/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation

class CurrentState: NSObject, NSCoding {
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("currentState");
    
    //MARK: Singletone (the only instance of the class that will be responsible for saving data)
    fileprivate static var _instance = CurrentState();
    
    //MARK: Properties
    var listsList: [ShoppingList];
    var units: [String];
    
    fileprivate override init(){
        listsList = [ShoppingList]();
        units = ["bag(s)", "bottle(s)", "box(es)", "bunch(es)", "can(s)", "case(s)", "cm", "dl", "dozen(s)", "g", "gallon(s)", "jar(s)", "kg", "l", "large", "lbs", "m", "medium", "ml", "pack(s)", "pair(s)", "piece(s)", "roll(s)", "small"];
        super.init();
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let listsList = aDecoder.decodeObject(forKey: PropertyKey.listsListKey) as! [ShoppingList];
        let units = aDecoder.decodeObject(forKey: PropertyKey.unitsArrayKey) as! [String];
        
        self.init();
        
        self.listsList.append(contentsOf: listsList);
        if self.units.count != units.count{
            self.units = units;        }
    }
    
    static var instance: CurrentState{
        get{
            return _instance;
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(listsList, forKey: PropertyKey.listsListKey);
        aCoder.encode(units, forKey: PropertyKey.unitsArrayKey);
    }
    
    func saveData() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(CurrentState._instance, toFile: CurrentState.ArchiveURL.path);
        if !isSuccessfulSave {
            print("Failed to save...");
        }
    }
    
    static func loadData() {
        if let loadedState = NSKeyedUnarchiver.unarchiveObject(withFile: CurrentState.ArchiveURL.path) as? CurrentState{
            CurrentState._instance = loadedState;
        }
      
    }
    

    
}
