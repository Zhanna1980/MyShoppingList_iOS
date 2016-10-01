//
//  CurrentListViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 22/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

class CurrentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var lblTitle: UILabel!;
    var btnBack: UIButton!;
    var enterItemName: UITextField!;
    var btnAddItem: UIButton!;
    var btnVoiceAdding: UIButton!;
    var tblItemsInList: UITableView!;
    
    let margin: CGFloat = 5;
    
    var currentList: ShoppingList!;
    var shouldReloadData: Bool = false;
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        view.backgroundColor = UIColor.green;
        
        
        btnBack = UIButton(type: .system);
        btnBack.frame = CGRect(x: margin, y: 30, width: 100, height: 50);
        btnBack.setTitle("<<Back", for: .normal);
        btnBack.addTarget(self, action: #selector(CurrentListViewController.btnBackClicked(_:)), for: .touchUpInside);
        view.addSubview(btnBack);
        
        lblTitle = UILabel(frame: CGRect(x: margin, y: btnBack.frame.maxY + margin, width: view.frame.width - 2*margin, height: 50));
        lblTitle.textColor = UIColor.red;
        lblTitle.textAlignment = .center;
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14);
        lblTitle.text = currentList.name;
        view.addSubview(lblTitle);
        
        enterItemName = UITextField(frame: CGRect(x: margin, y: lblTitle.frame.maxY + 5, width: view.frame.width - 4*margin - 100, height: 50));
        enterItemName.borderStyle = .roundedRect;
        enterItemName.placeholder = "Enter an item name";
        enterItemName.backgroundColor = UIColor.lightGray;
        view.addSubview(enterItemName);
        
        btnAddItem = UIButton(type: .system);
        btnAddItem.frame = CGRect(x: enterItemName.frame.maxX + margin, y: enterItemName.frame.origin.y, width: 50, height: 50);
        btnAddItem.setTitle("+", for: .normal);
        btnAddItem.backgroundColor = UIColor.lightGray;
        btnAddItem.addTarget(self, action: #selector(CurrentListViewController.btnAddItemClicked(_:)), for: .touchUpInside);
        view.addSubview(btnAddItem);
        
        btnVoiceAdding = UIButton(type: .custom);
        btnVoiceAdding.frame = CGRect(x: btnAddItem.frame.maxX + margin, y: enterItemName.frame.origin.y, width: 50, height: 50);
        btnVoiceAdding.setImage(#imageLiteral(resourceName: "ic_mic"), for: .normal);
        btnVoiceAdding.backgroundColor = UIColor.lightGray;
        btnVoiceAdding.addTarget(self, action: #selector(CurrentListViewController.btnVoiceAddingClicked(_:)), for: .touchUpInside);
        view.addSubview(btnVoiceAdding);
        
        tblItemsInList = UITableView(frame: CGRect(x: margin, y: enterItemName.frame.maxY + margin, width: view.frame.width - 2*margin, height: view.frame.height - enterItemName.frame.maxY - 2*margin), style: .grouped);
        tblItemsInList.dataSource = self;
        tblItemsInList.delegate = self;
        view.addSubview(tblItemsInList);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldReloadData{
           lblTitle.text = currentList.name;
        }
        shouldReloadData = false;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        shouldReloadData = true;
    }
    
    func btnBackClicked(_ sender: UIButton){
        dismiss(animated: true, completion: nil);
    }
    // MARK: - Adding an item to list;
    
    func btnAddItemClicked(_ sender: UIButton){
        if enterItemName.hasText{
            let itemName = enterItemName.text;
            addToListItem(itemName: itemName!);
        }
        enterItemName.text = "";
        enterItemName.placeholder = "Enter an item name";
    }
    
    func btnVoiceAddingClicked(_ sender: UIButton){
        
    }
    
    func addToListItem (itemName: String){
        var isAlreadyInTheList: Bool = false;
        for var i in 0..<currentList.itemList.count{
            if currentList.itemList[i].name == itemName{
                isAlreadyInTheList = true;
                break;
            }
        }
        if !isAlreadyInTheList{
            var newItem = Item(name: itemName);
            currentList.itemList.insert(newItem, at: 0);
            UsedItem.usedItems.append(itemName);
            tblItemsInList.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic);
        }
        else{
            
        }
    }
    
    // MARK: - Defining a tableView;
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return currentList.itemList.count;
        }
        else{
            return currentList.itemsInTheCart.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        
        if cell == nil{
            cell = UITableViewCell(style: .value1, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
        }
        cell?.textLabel?.text = currentList.itemList[indexPath.row].name;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            currentList.itemList.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .left);
            
        }
    }

    
    

}
