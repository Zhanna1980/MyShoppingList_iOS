//
//  EditItemViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 10/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

class EditItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var editItemName: UITextField!;
    var lblQuantity: UILabel!;
    var enterQuantity: UITextField!;
    var enterUnits: UITextField!;
    var btnOpenUnitsDropDown: UIButton!;
    var tblUnitsDropDown: UITableView!;
    var lblCategory: UILabel!;
    var enterCategory: UITextField!;
    var lblNotes: UILabel!;
    var notes: UITextView!;
    var btnAddDeletePhoto: UIButton!;
    var itemPhoto: UIImageView!;
    var btnCancel: UIButton!;
    var btnDone: UIButton!;
    
    var editedItem: Item!;
    var margin: CGFloat = 5;
    var sortedSuggestions: [String] = [String]();
    var tblSuggestionsIsShown: Bool = false;
    var shouldShowSortedSuggestions: Bool = false;
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.green;
        
        btnCancel = UIButton(type: .system);
        btnCancel.frame = CGRect(x: margin, y: 30, width: 70, height: 30);
        btnCancel.setTitle("Cancel", for: .normal);
        btnCancel.titleLabel?.font = UIFont.systemFont(ofSize: 16);
        btnCancel.addTarget(self, action: #selector(EditItemViewController.btnCancelClicked(_:)), for: .touchUpInside);
        view.addSubview(btnCancel);
        
        btnDone = UIButton(type: .system);
        btnDone.frame = CGRect(x: view.frame.width - 70 - margin, y: 30, width: 70, height: 30);
        btnDone.setTitle("Done", for: .normal);
        btnDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16);
        btnDone.addTarget(self, action: #selector(EditItemViewController.btnDoneClicked(_:)), for: .touchUpInside);
        view.addSubview(btnDone);
        
        editItemName = UITextField(frame: CGRect(x: margin, y: btnCancel.frame.maxY + margin, width: view.frame.width - 2*margin, height: 50));
        editItemName.borderStyle = .roundedRect;
        editItemName.backgroundColor = UIColor.lightGray;
        editItemName.delegate = self;
        editItemName.becomeFirstResponder();
        view.addSubview(editItemName);
        
        lblQuantity = UILabel(frame: CGRect(x: margin, y: editItemName.frame.maxY + 30, width: 70, height: 30));
        lblQuantity.text = "Quantity:";
        view.addSubview(lblQuantity);
        
        enterQuantity = UITextField(frame: CGRect(x: lblQuantity.frame.maxX + margin, y: lblQuantity.frame.origin.y, width: 50, height: 30));
        //enterQuantity.borderStyle = .roundedRect;
        enterQuantity.backgroundColor = UIColor.lightGray;
        enterQuantity.delegate = self;
        enterQuantity.keyboardType = .numbersAndPunctuation;
        view.addSubview(enterQuantity);
        
        enterUnits = UITextField(frame: CGRect(x: enterQuantity.frame.maxX + 20, y: enterQuantity.frame.origin.y, width: 100, height: 30));
        //enterUnits.borderStyle = .roundedRect;
        enterUnits.backgroundColor = UIColor.lightGray;
        enterUnits.delegate = self;
        enterUnits.placeholder = "units"
        view.addSubview(enterUnits);
        
        btnOpenUnitsDropDown = UIButton(type: .custom);
        btnOpenUnitsDropDown.frame = CGRect(x: enterUnits.frame.maxX, y: enterUnits.frame.origin.y, width: 30, height: 30);
        btnOpenUnitsDropDown.setImage(#imageLiteral(resourceName: "ic_arrow_drop_down"), for: .normal);
        btnOpenUnitsDropDown.backgroundColor = UIColor.lightGray;
        btnOpenUnitsDropDown.addTarget(self, action: #selector(EditItemViewController.openUnitsDropDown(_:)), for: .touchUpInside);
        view.addSubview(btnOpenUnitsDropDown);
        
        
        lblCategory = UILabel(frame: CGRect(x: margin, y: lblQuantity.frame.maxY + 20, width: 100, height: 30));
        lblCategory.text = "Category:";
        view.addSubview(lblCategory);
        
        enterCategory = UITextField(frame: CGRect(x: lblCategory.frame.maxX + margin, y: lblCategory.frame.origin.y, width: view.frame.width - lblCategory.frame.maxX - 3*margin, height: 30));
        enterCategory.backgroundColor = UIColor.lightGray;
        enterCategory.delegate = self;
        view.addSubview(enterCategory);
        
        lblNotes = UILabel(frame: CGRect(x: margin, y: lblCategory.frame.maxY + 20, width: 70, height: 30));
        lblNotes.text = "Notes:";
        view.addSubview(lblNotes);
        
        notes = UITextView(frame: CGRect(x: margin, y: lblNotes.frame.maxY + margin/2, width: view.frame.width - 2*margin, height: 60));
        view.addSubview(notes);
        
        btnAddDeletePhoto = UIButton(type: .custom);
        btnAddDeletePhoto.frame = CGRect(x: margin, y: notes.frame.maxY + margin, width: 50, height: 50);
        btnAddDeletePhoto.contentMode = .scaleAspectFit;
        btnAddDeletePhoto.backgroundColor = UIColor.lightGray;
        btnAddDeletePhoto.addTarget(self, action: #selector(EditItemViewController.openUnitsDropDown(_:)), for: .touchUpInside);
        view.addSubview(btnAddDeletePhoto);
        
        itemPhoto = UIImageView(frame: CGRect(x: btnAddDeletePhoto.frame.maxX + margin, y: btnAddDeletePhoto.frame.origin.y, width: view.frame.width - btnAddDeletePhoto.frame.maxX - 3*margin, height: view.frame.height - btnAddDeletePhoto.frame.origin.y - margin));
        itemPhoto.contentMode = .scaleAspectFit;
        view.addSubview(itemPhoto);
        
        tblUnitsDropDown = UITableView(frame: CGRect(x: enterUnits.frame.origin.x, y: enterUnits.frame.maxY, width: enterUnits.frame.width + btnOpenUnitsDropDown.frame.width, height: 0), style: .plain);
        tblUnitsDropDown.dataSource = self;
        tblUnitsDropDown.delegate = self;
        view.addSubview(tblUnitsDropDown);
        
        fillDataInViewController();
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (EditItemViewController.handlingTaps(_:)));
        tapGestureRecognizer.cancelsTouchesInView = false;
        view.addGestureRecognizer(tapGestureRecognizer);

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillDataInViewController();
    }
    
    
    //MARK: - Fills data according to the edited item
    func fillDataInViewController(){
        editItemName.text = editedItem.name;
        enterQuantity.text = String(describing: editedItem.calculations.quantity);
        enterUnits.text = editedItem.calculations.unit;
        
        if let theCategory = editedItem.category{
            enterCategory.text = theCategory;
        }
        else{
            enterCategory.text = "";
        }
        if let theNotes = editedItem.notes{
            notes.text = theNotes;
        }
        else{
            notes.text = "";
        }
        if let theImage = editedItem.itemImage{
            itemPhoto.image = theImage;
            btnAddDeletePhoto.setImage(#imageLiteral(resourceName: "ic_delete"), for: .normal);
        }
        else{
            itemPhoto.backgroundColor = UIColor.lightGray;
            btnAddDeletePhoto.setImage(#imageLiteral(resourceName: "ic_add_a_photo"), for: .normal);

        }

        tblSuggestionsIsShown = false;
        shouldShowSortedSuggestions = false;
        tblUnitsDropDown.reloadData();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if textField == enterUnits && tblSuggestionsIsShown{
            hideSuggestions();
            shouldShowSortedSuggestions = false;
        }
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === enterUnits{
            if let text = textField.text{
                let currentText = text as NSString;
                let wholeText = currentText.replacingCharacters(in: range, with: string);
                if !wholeText.isEmpty{
                    sortSuggestions(key: wholeText);
                    if shouldShowSortedSuggestions{
                        tblUnitsDropDown.reloadData();
                        showSuggestions();
                    }
                }
                else
                {
                    
                    if tblSuggestionsIsShown{
                        hideSuggestions();
                        shouldShowSortedSuggestions = false;
                    }
                    tblUnitsDropDown.reloadData();
                }
                
                
            }
        }
        
        return true;
    }
    
    func openUnitsDropDown(_ sender: UIButton){
        if tblSuggestionsIsShown{
            hideSuggestions();
        }
        else{
           showSuggestions();
        }
        
    }
    
    func btnAddDeletePhotoClicked(_ sender: UIButton){
        
    }
    
    func btnCancelClicked(_ sender: UIButton){
        if tblSuggestionsIsShown{
            shouldShowSortedSuggestions = false;
            hideSuggestions();
        }
        dismiss(animated: true, completion: nil);
    }
    
    func btnDoneClicked (_ sender: UIButton){
        if editItemName.hasText{
            editedItem.name = editItemName.text!;
        }
        else{
            showAlertController(message: "You must enter item name");
        }
        if enterQuantity.hasText{
            let enteredQuantity = Float(enterQuantity.text!);
            if let theEnteredQuantity = enteredQuantity {
                editedItem.calculations.quantity = theEnteredQuantity;
            }
            else{
                    showAlertController(message: "Invalid quantity");
            }
        }
        else{
            editedItem.calculations.quantity = 1;
        }
        if enterUnits.hasText{
            let enteredUnits = enterUnits.text!.localizedLowercase;
            editedItem.calculations.unit = enteredUnits;
        }
        else{
            editedItem.calculations.unit = "";
        }
        
        if enterCategory.hasText{
            editedItem.category = enterCategory.text;
        }
        else{
            editedItem.category = nil;
        }
        if notes.hasText{
            editedItem.notes = notes.text;
        }
        else{
            editedItem.notes = nil;
        }
        dismiss(animated: true, completion: nil);
    }
    
    //MARK: -Shows alertController
    func showAlertController(message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert);
        let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alertController.addAction(actionOK);
        present(alertController, animated: true, completion: nil);
    }

    
    //MARK: - Defining a table of unit sugesstions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSortedSuggestions{
            return sortedSuggestions.count;
        }
        else{
            return ItemCalculations.units.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
        }
        if shouldShowSortedSuggestions{
            cell!.textLabel?.text = sortedSuggestions[indexPath.row];
        }else{
            cell!.textLabel?.text = ItemCalculations.units[indexPath.row];
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowSortedSuggestions{
            enterUnits.text = sortedSuggestions[indexPath.row];
        }else{
            enterUnits.text = ItemCalculations.units[indexPath.row];
        }
        shouldShowSortedSuggestions = false;
        hideSuggestions();
    }
    
    
    
    // MARK: showing and hiding dropdown of units suggestions
    
    func showSuggestions(){
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.tblUnitsDropDown.frame = CGRect(x: self.enterUnits.frame.origin.x, y: self.enterUnits.frame.maxY, width: self.enterUnits.frame.width + self.btnOpenUnitsDropDown.frame.width, height: 180) ;
            }, completion: { finished in
              self.tblSuggestionsIsShown = true;
        });
    }
    
    func hideSuggestions(){
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.tblUnitsDropDown.frame = CGRect(x: self.enterUnits.frame.origin.x, y: self.enterUnits.frame.maxY, width: self.enterUnits.frame.width + self.btnOpenUnitsDropDown.frame.width, height: 0) ;
            }, completion: { finished in
                self.tblSuggestionsIsShown = false;
        });
    }
    
    func sortSuggestions(key: String){
        sortedSuggestions.removeAll();
        for var i in 0..<ItemCalculations.units.count{
            if ItemCalculations.units[i].hasPrefix(key.localizedLowercase){
                sortedSuggestions.append(ItemCalculations.units[i]);
            }
        }
        shouldShowSortedSuggestions = sortedSuggestions.count > 0
    }
    
    func handlingTaps (_ sender: UITapGestureRecognizer){
        editItemName.resignFirstResponder();
        enterQuantity.resignFirstResponder();
        enterUnits.resignFirstResponder();
        enterCategory.resignFirstResponder();
        notes.resignFirstResponder();
        /*if tblSuggestionsIsShown{
            shouldShowSortedSuggestions = false;
            hideSuggestions();
        }*/
        
    }
    
    
    
    
    
    
}
