//
//  EditItemViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 10/10/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

// ViewController for editing specific item
class EditItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PhotoWasPickedDelegate{
    
    var editItemName: UITextField!;
    var lblQuantity: UILabel!;
    var enterQuantity: UITextField!;
    var unitsView: UIView!;
    var enterUnits: UITextField!;
    var btnOpenUnitsDropDown: UIButton!;
    var tblUnitsDropDown: UITableView!;
    var lblCategory: UILabel!;
    var enterCategory: UITextField!;
    var lblNotes: UILabel!;
    var notes: UITextView!;
    var btnTakePhoto: UIButton!;
    var btnPickPhoto: UIButton!;
    var btnDeletePhoto: UIButton!;
    var itemPhoto: UIImageView!;
    var btnCancel: UIButton!;
    var btnDone: UIButton!;
    var imagePickerHelper: ImagePickerHelper!;
    
    var editedItem: Item!;
    var margin: CGFloat = 5;
    var sortedSuggestions: [String] = [String]();
    var tblSuggestionsIsShown: Bool = false;
    var shouldShowSortedSuggestions: Bool = false;
    var shouldRefillData: Bool = false;
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "Mix-of-green-vegetables"));
        
        // cancel button
        btnCancel = ViewBuilder.addSimpleSystemButton(frame: CGRect(x: margin, y: 30, width: 70, height: 30), title: "Cancel", addToView: view);
        btnCancel.titleLabel?.font = UIFont.systemFont(ofSize: 16);
        btnCancel.addTarget(self, action: #selector(EditItemViewController.btnCancelClicked(_:)), for: .touchUpInside);
        
        // done button
        btnDone = ViewBuilder.addSimpleSystemButton(frame: CGRect(x: view.frame.width - 70 - margin, y: 30, width: 70, height: 30), title: "Done", addToView: view);
        btnDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16);
        btnDone.addTarget(self, action: #selector(EditItemViewController.btnDoneClicked(_:)), for: .touchUpInside);
        
        editItemName = ViewBuilder.addTextField(frame: CGRect(x: margin, y: btnCancel.frame.maxY + margin, width: view.frame.width - 2*margin, height: 50), addToView: view);
        editItemName.delegate = self;
        editItemName.becomeFirstResponder();
        
        lblQuantity = ViewBuilder.addLabel(frame: CGRect(x: margin, y: editItemName.frame.maxY + 30, width: 70, height: 30), text: "Quantity:", addToView: view);
            
        enterQuantity = ViewBuilder.addTextField(frame: CGRect(x: lblQuantity.frame.maxX + margin, y: lblQuantity.frame.origin.y, width: 50, height: 30), addToView: view);
        enterQuantity.delegate = self;
        enterQuantity.keyboardType = .numbersAndPunctuation;
        
        unitsView = UIView(frame: CGRect(x: enterQuantity.frame.maxX + 20, y: enterQuantity.frame.origin.y, width: 130, height: 30));
        unitsView.setBorder();
        unitsView.backgroundColor = UIColor.clear;
        view.addSubview(unitsView);

        enterUnits = ViewBuilder.addTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30), addToView: unitsView);
        enterUnits.delegate = self;
        enterUnits.layer.cornerRadius = 0;
        enterUnits.placeholder = "units";
        
        btnOpenUnitsDropDown = UIButton(type: .custom);
        btnOpenUnitsDropDown.frame = CGRect(x: enterUnits.frame.maxX, y: enterUnits.frame.origin.y, width: 30, height: 30);
        btnOpenUnitsDropDown.setImage(#imageLiteral(resourceName: "ic_arrow_drop_down"), for: .normal);
        btnOpenUnitsDropDown.backgroundColor = UIColor.white;
        btnOpenUnitsDropDown.alpha = 0.8;
        btnOpenUnitsDropDown.addTarget(self, action: #selector(EditItemViewController.openUnitsDropDown(_:)), for: .touchUpInside);
        unitsView.addSubview(btnOpenUnitsDropDown);
        
        lblCategory = ViewBuilder.addLabel(frame: CGRect(x: margin, y: lblQuantity.frame.maxY + 20, width: 100, height: 30), text: "Category:", addToView: view);
        
        enterCategory = ViewBuilder.addTextField(frame: CGRect(x: lblCategory.frame.maxX + margin, y: lblCategory.frame.origin.y, width: view.frame.width - lblCategory.frame.maxX - 3*margin, height: 30), addToView: view);
        enterCategory.delegate = self;
        
        lblNotes = ViewBuilder.addLabel(frame: CGRect(x: margin, y: lblCategory.frame.maxY + 20, width: 70, height: 30), text: "Notes:", addToView: view);
        
        notes = UITextView(frame: CGRect(x: margin, y: lblNotes.frame.maxY + margin/2, width: view.frame.width - 2*margin, height: 60));
        notes.setBorder();
        notes.alpha = 0.8;
        view.addSubview(notes);
        
        btnTakePhoto = ViewBuilder.addSquareButtonWithIcon(position: CGPoint(x: margin, y: notes.frame.maxY + margin), icon: #imageLiteral(resourceName: "ic_add_a_photo"), addToView: view);
        btnTakePhoto.addTarget(self, action: #selector(EditItemViewController.btnTakePhotoClicked(_:)), for: .touchUpInside);
        
        btnPickPhoto = ViewBuilder.addSquareButtonWithIcon(position: CGPoint(x: btnTakePhoto.frame.origin.x, y: btnTakePhoto.frame.maxY + margin), icon: #imageLiteral(resourceName: "ic_photo_library"), addToView: view);
        btnPickPhoto.addTarget(self, action: #selector(EditItemViewController.btnPickPhotoClicked(_:)), for: .touchUpInside);
        
        btnDeletePhoto = ViewBuilder.addSquareButtonWithIcon(position: CGPoint(x: btnPickPhoto.frame.origin.x, y: btnPickPhoto.frame.maxY + margin), icon: #imageLiteral(resourceName: "ic_delete"), addToView: view);
        btnDeletePhoto.addTarget(self, action: #selector(EditItemViewController.btnDeletePhotoClicked(_:)), for: .touchUpInside);
        
        itemPhoto = UIImageView(frame: CGRect(x: btnTakePhoto.frame.maxX + margin, y: btnTakePhoto.frame.origin.y, width: view.frame.width - btnTakePhoto.frame.maxX - 3*margin, height: view.frame.height - btnTakePhoto.frame.origin.y - margin));
        itemPhoto.contentMode = .scaleAspectFit;
        itemPhoto.backgroundColor = UIColor.white;
        itemPhoto.setBorder();
        itemPhoto.alpha = 0.8;
        view.addSubview(itemPhoto);
        
        tblUnitsDropDown = UITableView(frame: CGRect(x: unitsView.frame.origin.x + 3, y: unitsView.frame.maxY, width: enterUnits.frame.width + btnOpenUnitsDropDown.frame.width - 6, height: 0), style: .plain);
        tblUnitsDropDown.dataSource = self;
        tblUnitsDropDown.delegate = self;
        tblUnitsDropDown.alpha = 0.8;
        view.addSubview(tblUnitsDropDown);
        //initial filling of the fields
        fillDataInViewController();
        
        //taps for hiding keyboard
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (EditItemViewController.handlingTaps(_:)));
        tapGestureRecognizer.cancelsTouchesInView = false;
        view.addGestureRecognizer(tapGestureRecognizer);
        
        imagePickerHelper = ImagePickerHelper(viewController: self);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // The flag is been changed on true while leaving the EditItemViewController with clicking buttons "Done" or "Cancel". So it is false in this function only when the function is called for the first time.
        if shouldRefillData{
            fillDataInViewController();
        }
    }
    
    //MARK: - Fills data according to the edited item
    func fillDataInViewController(){
        editItemName.text = editedItem.name;
        enterQuantity.text = editedItem.itemQuantityAndUnits.quantityToString();
        enterUnits.text = editedItem.itemQuantityAndUnits.unit;
        
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
        }
        else{
            itemPhoto.image = nil;
            itemPhoto.backgroundColor = UIColor.white;
        }

        tblSuggestionsIsShown = false;
        shouldShowSortedSuggestions = false;
        tblUnitsDropDown.reloadData();
        shouldRefillData = false;
    }
    
    // hiding keyboard and suggestions dropdown
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if textField == enterUnits && tblSuggestionsIsShown{
            hideSuggestions();
            shouldShowSortedSuggestions = false;
        }
        return true;
    }
    
    //processing user's input for showing suggestions:
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
    
    //MARK: Editing the photo
    // take a new photo
    func btnTakePhotoClicked(_ sender: UIButton){
        imagePickerHelper.delegate = self;
        imagePickerHelper.pickPhoto(shouldTakeNewPhoto: true);
    }
    
    // pick a photo from Photo Library
    func btnPickPhotoClicked(_ sender: UIButton){
        imagePickerHelper.delegate = self;
        imagePickerHelper.pickPhoto(shouldTakeNewPhoto: false);
    }
    
    //User selected photo
    func photoWasPicked(image: UIImage) {
        
        itemPhoto.image = image;
        imagePickerHelper.delegate = nil;
    }
    
    // deleting the photo
    func btnDeletePhotoClicked(_ sender: UIButton){
            itemPhoto.image = nil;
    }
    
    //MARK: Leaving editViewController
    // cancel changes and return to the shopping list
    func btnCancelClicked(_ sender: UIButton){
        if tblSuggestionsIsShown{
            shouldShowSortedSuggestions = false;
            hideSuggestions();
        }
        shouldRefillData = true;
        dismiss(animated: true, completion: nil);
    }
    
    // save changes and return to the shopping list
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
                editedItem.itemQuantityAndUnits.quantity = theEnteredQuantity;
            }
            else{
                    showAlertController(message: "Invalid quantity");
            }
        }
        else{
            editedItem.itemQuantityAndUnits.quantity = 1;
        }
        if enterUnits.hasText{
            let enteredUnits = enterUnits.text!.localizedLowercase;
            editedItem.itemQuantityAndUnits.unit = enteredUnits;
        }
        else{
            editedItem.itemQuantityAndUnits.unit = "";
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
        if let image = itemPhoto.image{
            editedItem.itemImage = image;
        }
        shouldRefillData = true;
        CurrentState.instance.saveData();
        dismiss(animated: true, completion: nil);
    }
    
    //MARK: Show alertController
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
            return CurrentState.instance.units.count;
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
            cell!.textLabel?.text = CurrentState.instance.units[indexPath.row];
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowSortedSuggestions{
            enterUnits.text = sortedSuggestions[indexPath.row];
        }else{
            enterUnits.text = CurrentState.instance.units[indexPath.row];
        }
        shouldShowSortedSuggestions = false;
        hideSuggestions();
    }
    
    // MARK: showing and hiding dropdown of units suggestions
    func showSuggestions(){
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.tblUnitsDropDown.frame = CGRect(x: self.unitsView.frame.origin.x + 5, y: self.unitsView.frame.maxY, width: self.enterUnits.frame.width + self.btnOpenUnitsDropDown.frame.width - 10, height: 180) ;
            }, completion: { finished in
              self.tblSuggestionsIsShown = true;
              self.btnOpenUnitsDropDown.setImage(#imageLiteral(resourceName: "ic_arrow_drop_up"), for: .normal);
        });
    }
    
    func hideSuggestions(){
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.tblUnitsDropDown.frame = CGRect(x: self.unitsView.frame.origin.x + 5, y: self.unitsView.frame.maxY, width: self.enterUnits.frame.width + self.btnOpenUnitsDropDown.frame.width - 10, height: 0) ;
            }, completion: { finished in
                self.tblSuggestionsIsShown = false;
                self.btnOpenUnitsDropDown.setImage(#imageLiteral(resourceName: "ic_arrow_drop_down"), for: .normal);
        });
    }
    
    //preparing the list of suggestions:
    func sortSuggestions(key: String){
        sortedSuggestions.removeAll();
        for var i in 0..<CurrentState.instance.units.count{
            if CurrentState.instance.units[i].hasPrefix(key.localizedLowercase){
                sortedSuggestions.append(CurrentState.instance.units[i]);
            }
        }
        shouldShowSortedSuggestions = sortedSuggestions.count > 0
    }
    
    // hiding keyboard
    func handlingTaps (_ sender: UITapGestureRecognizer){
        editItemName.resignFirstResponder();
        enterQuantity.resignFirstResponder();
        enterUnits.resignFirstResponder();
        enterCategory.resignFirstResponder();
        notes.resignFirstResponder();
    }
}
