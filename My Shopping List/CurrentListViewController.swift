//
//  CurrentListViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 22/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit
import Speech

class CurrentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckboxWasCheckedDelegate, OptionWasSelectedDelegate, UITextFieldDelegate, PhotoWasPickedDelegate {
    
    var lblTitle: UILabel!;
    var btnBack: UIButton!;
    var enterItemName: UITextField!;
    var btnAddItem: UIButton!;
    var btnVoiceAdding: UIButton!;
    var tblItemsInList: UITableView!;
    var optionsMenu: OptionsMenu!;
    var currentList: ShoppingList!;
    var editItemViewController: EditItemViewController!;
    var imagePickerHelper: ImagePickerHelper!;
    
    let margin: CGFloat = 5;
    
    var selectedRow: IndexPath!;
    var isMenuShown:Bool = false;
    var shouldReloadData: Bool = false;
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        view.backgroundColor = UIColor.green;
        
        imagePickerHelper = ImagePickerHelper(viewController: self);
        
        btnBack = UIButton(type: .system);
        btnBack.frame = CGRect(x: margin, y: 30, width: 100, height: 30);
        btnBack.setTitle("<<Back", for: .normal);
        btnBack.addTarget(self, action: #selector(CurrentListViewController.btnBackClicked(_:)), for: .touchUpInside);
        view.addSubview(btnBack);
        
        
        
        lblTitle = UILabel(frame: CGRect(x: margin, y: btnBack.frame.maxY + margin, width: view.frame.width - 2*margin, height: 30));
        lblTitle.textColor = UIColor.red;
        lblTitle.textAlignment = .center;
        lblTitle.font = UIFont.boldSystemFont(ofSize: 14);
        lblTitle.text = currentList.name;
        view.addSubview(lblTitle);
        
        optionsMenu = OptionsMenu(view: view, options: [
                        Option(icon: #imageLiteral(resourceName: "ic_mode_edit"), label: "Edit"),
                        Option(icon: #imageLiteral(resourceName: "ic_add_a_photo"), label: "Add a photo"),
                        Option(icon: #imageLiteral(resourceName: "ic_photo"), label: "Pick a photo"),
                        Option(icon: #imageLiteral(resourceName: "ic_delete"), label: "Delete")]);
        optionsMenu.optionWasSelectedDelegate = self;
        
        enterItemName = UITextField(frame: CGRect(x: margin, y: lblTitle.frame.maxY + 5, width: view.frame.width - 4*margin - 100, height: 50));
        enterItemName.borderStyle = .roundedRect;
        enterItemName.placeholder = "Enter an item name";
        //enterItemName.backgroundColor = UIColor.lightGray;
        enterItemName.layer.cornerRadius = 9;
        enterItemName.layer.borderWidth = 3;
        enterItemName.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        enterItemName.delegate = self;
        view.addSubview(enterItemName);
        
        btnAddItem = UIButton(type: .system);
        btnAddItem.frame = CGRect(x: enterItemName.frame.maxX + margin, y: enterItemName.frame.origin.y, width: 50, height: 50);
        btnAddItem.setTitle("+", for: .normal);
        btnAddItem.backgroundColor = UIColor.white;
        btnAddItem.layer.cornerRadius = 9;
        btnAddItem.layer.borderWidth = 3;
        btnAddItem.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        btnAddItem.addTarget(self, action: #selector(CurrentListViewController.btnAddItemClicked(_:)), for: .touchUpInside);
        view.addSubview(btnAddItem);
        
        btnVoiceAdding = UIButton(type: .custom);
        btnVoiceAdding.frame = CGRect(x: btnAddItem.frame.maxX + margin, y: enterItemName.frame.origin.y, width: 50, height: 50);
        btnVoiceAdding.setImage(#imageLiteral(resourceName: "ic_mic"), for: .normal);
        btnVoiceAdding.backgroundColor = UIColor.white;
        btnVoiceAdding.layer.cornerRadius = 9;
        btnVoiceAdding.layer.borderWidth = 3;
        btnVoiceAdding.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        btnVoiceAdding.addTarget(self, action: #selector(CurrentListViewController.btnVoiceAddingClicked(_:)), for: .touchUpInside);
        view.addSubview(btnVoiceAdding);
        
        tblItemsInList = UITableView(frame: CGRect(x: margin, y: enterItemName.frame.maxY + margin, width: view.frame.width - 2*margin, height: view.frame.height - enterItemName.frame.maxY - 2*margin), style: .grouped);
        tblItemsInList.layer.cornerRadius = 9;
        tblItemsInList.layer.borderWidth = 3;
        tblItemsInList.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        tblItemsInList.dataSource = self;
        tblItemsInList.delegate = self;
        view.addSubview(tblItemsInList);
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (CurrentListViewController.handlingTaps(_:)));
        tapGestureRecognizer.cancelsTouchesInView = false;
        view.addGestureRecognizer(tapGestureRecognizer);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldReloadData{
            lblTitle.text = currentList.name;
            tblItemsInList.reloadData();
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
        processTextFieldData();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processTextFieldData();
        return true;
    }
    
    
    func btnVoiceAddingClicked(_ sender: UIButton){
        
    }
    
    func processTextFieldData(){
        if enterItemName.hasText{
            let itemName = enterItemName.text;
            addToListItem(itemName: itemName!);
        }
        enterItemName.text = "";
        enterItemName.placeholder = "Enter an item name";
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
            CurrentState.instance.usedItems.append(itemName);
            CurrentState.instance.saveData();
            tblItemsInList.reloadSections([0], with: .automatic);
        }
        else{
            showAlertController();
        }
    }
    
    // MARK: - function that shows alert while adding an item that already exists
    
    func showAlertController(){
        let alertController = UIAlertController(title: nil, message: "There is such item in the list", preferredStyle: .alert);
        let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil);
        alertController.addAction(actionOK);
        present(alertController, animated: true, completion: nil);
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
    
    // defining a cell:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        
        if cell == nil{
            cell = UITableViewCell(style: .value1, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
            //cell!.contentView.backgroundColor = UIColor.yellow;
            
            let checkbox = Checkbox(position: CGPoint(x: 5, y: 0));
            checkbox.center.y = cell!.contentView.center.y;
            checkbox.delegate = self;
            cell!.contentView.addSubview(checkbox);

            let lblItemName = UILabel(frame: CGRect(x: checkbox.frame.maxX + 5, y: 0, width: cell!.contentView.frame.width - 150, height: 30));
            lblItemName.center.y = cell!.contentView.center.y;
            //lblItemName.backgroundColor = UIColor.cyan;
            cell!.contentView.addSubview(lblItemName);
            
            
            let btnPhoto = UIButton(type: .custom);
            btnPhoto.frame = CGRect(x: lblItemName.frame.maxX, y: 0, width: 30, height: 30);
            btnPhoto.center.y = cell!.contentView.center.y;
            btnPhoto.contentMode = .scaleAspectFit;
            //btnPhoto.backgroundColor = UIColor.green;
            btnPhoto.isEnabled = false;
            btnPhoto.addTarget(self, action: #selector(CurrentListViewController.btnPhotoClicked(_:)), for: .touchUpInside);
            cell!.contentView.addSubview(btnPhoto);
            
            let lblItemCalculations = UILabel(frame: CGRect(x: cell!.contentView.frame.width - 90, y: 0, width: 90, height: 30));
            lblItemCalculations.center.y = cell!.contentView.center.y;
            lblItemCalculations.textColor = UIColor.blue;
            //lblItemCalculations.backgroundColor = UIColor.lightGray;
            lblItemCalculations.font = UIFont.systemFont(ofSize: 14);
            lblItemCalculations.textAlignment = .right;
            cell!.contentView.addSubview(lblItemCalculations);

            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CurrentListViewController.handlingLongPressOnRow(_:)));
            cell?.addGestureRecognizer(longPressRecognizer);
            //print(cell!.contentView.frame.width);

        }
        let checkbox = cell!.contentView.subviews[0] as! Checkbox;
        let lblItemName = cell!.contentView.subviews[1] as! UILabel;
        let btnPhoto = cell!.contentView.subviews[2] as! UIButton;
        let lblItemCalculations = cell!.contentView.subviews[3] as! UILabel;
        
        if indexPath.section == 0{
            
            lblItemName.text = currentList.itemList[indexPath.row].name;
            lblItemCalculations.text = currentList.itemList[indexPath.row].calculations.toString();
            checkbox.setChecked(checked: false);
            checkbox.tag = indexPath.row;
            // photo button
            if currentList.itemList[indexPath.row].itemImage != nil {
                btnPhoto.setImage(#imageLiteral(resourceName: "ic_photo"), for: .normal);
                btnPhoto.isEnabled = true;
            }
            else{
                btnPhoto.setImage(nil, for: .normal);
                btnPhoto.isEnabled = false;
            }

        }
        else{
            lblItemName.text = currentList.itemsInTheCart[indexPath.row].name;
            lblItemCalculations.text = currentList.itemsInTheCart[indexPath.row].calculations.toString();
            checkbox.setChecked(checked: true);
            checkbox.tag = indexPath.row;
            // photo button
            if currentList.itemsInTheCart[indexPath.row].itemImage != nil {
                btnPhoto.setImage(#imageLiteral(resourceName: "ic_photo"), for: .normal);
                btnPhoto.isEnabled = true;
            }
            else{
                btnPhoto.setImage(nil, for: .normal);
                btnPhoto.isEnabled = false;
            }
            }

        return cell!;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            if indexPath.section == 0{
            currentList.itemList.remove(at: indexPath.row);
            }
            else{
                currentList.itemsInTheCart.remove(at: indexPath.row);
            }
            CurrentState.instance.saveData();
            tableView.deleteRows(at: [indexPath], with: .left);
            tblItemsInList.reloadSections([indexPath.section], with: .automatic);
        }
    }
    // MARK: Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (section == 0 ? 0 : 50);
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewContainer = UIView();
        viewContainer.sizeToFit();
        viewContainer.layer.borderWidth = 3;
        viewContainer.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        
        let headerTitle = UILabel(frame: CGRect(x: 15, y: 10, width: 150, height: 30));
        headerTitle.text = section == 1 ? "Items in the cart: " : "";
        //headerTitle.backgroundColor = UIColor.blue;
        //headerTitle.textColor = UIColor.blue;
        headerTitle.font = UIFont.boldSystemFont(ofSize: 16);
        viewContainer.addSubview(headerTitle);
        return viewContainer;
        
    }
    
    
    //MARK: footer and its functions
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        var count = 0;
        if section == 0{
            count = currentList.itemList.count;
        }
        else{
            count = currentList.itemsInTheCart.count;
        }
        let labelText = (count != 1 ? "\(count) items" : "\(count) item");

 
        let viewContainer = UIView();
        viewContainer.sizeToFit();
        viewContainer.layer.borderWidth = 3;
        viewContainer.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        
        let footerLabel = UILabel(frame: CGRect(x: 5, y: 10, width: 100, height: 30));
        footerLabel.text = labelText;
        viewContainer.addSubview(footerLabel);
        
        let btnCheckUncheckAll = UIButton(type: .system);
        btnCheckUncheckAll.frame = CGRect(x: footerLabel.frame.maxX + margin, y: footerLabel.frame.origin.y, width: 90, height: 30);
        btnCheckUncheckAll.setTitle(section == 0 ? "Check all" : "Uncheck all", for: .normal);
        btnCheckUncheckAll.backgroundColor = UIColor.white;
        btnCheckUncheckAll.layer.cornerRadius = 9;
        btnCheckUncheckAll.layer.borderWidth = 3;
        btnCheckUncheckAll.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        btnCheckUncheckAll.addTarget(self, action: #selector(CurrentListViewController.checkUncheckAll(_:)), for: .touchUpInside);
        btnCheckUncheckAll.tag = section;
        viewContainer.addSubview(btnCheckUncheckAll);
        
        let btnDeleteAll = UIButton(type: .system);
        btnDeleteAll.frame = CGRect(x: btnCheckUncheckAll.frame.maxX + margin, y: btnCheckUncheckAll.frame.origin.y, width: 90, height: 30);
        btnDeleteAll.setTitle("Delete all", for: .normal);
        btnDeleteAll.backgroundColor = UIColor.white;
        btnDeleteAll.layer.cornerRadius = 9;
        btnDeleteAll.layer.borderWidth = 3;
        btnDeleteAll.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        btnDeleteAll.addTarget(self, action: #selector(CurrentListViewController.deleteAll(_:)), for: .touchUpInside);
        btnDeleteAll.tag = section;
        viewContainer.addSubview(btnDeleteAll);

        return viewContainer;
        
    }
    
    func checkUncheckAll(_ sender: UIButton){
        hideMenuIfItIsShown();
        let section = sender.tag;
        let listIsEmpty = section == 0 ? currentList.itemList.isEmpty : currentList.itemsInTheCart.isEmpty;
        if !listIsEmpty{
            if section == 0{
                for item in currentList.itemList{
                    item.inTheCart = true;
                    item.previousPositionInItemList = 0;
                }
                currentList.itemsInTheCart.append(contentsOf: currentList.itemList);
                currentList.itemList.removeAll();
            }
            else{
                for item in currentList.itemsInTheCart{
                    item.inTheCart = false;
                    item.previousPositionInItemList = 0;
                }
                currentList.itemList.append(contentsOf: currentList.itemsInTheCart);
                currentList.itemsInTheCart.removeAll();
            }
            CurrentState.instance.saveData();
            tblItemsInList.reloadData();
        }
    }
    
    func deleteAll(_ sender: UIButton){
        hideMenuIfItIsShown();
        let section = sender.tag;
        let listIsEmpty = section == 0 ? currentList.itemList.isEmpty : currentList.itemsInTheCart.isEmpty;
        if !listIsEmpty{
            if section == 0{
                currentList.itemList.removeAll();
            }
            else{
                currentList.itemsInTheCart.removeAll();
            }
                CurrentState.instance.saveData();
                tblItemsInList.reloadSections([section], with: .automatic);
        }
    }
    
    
    // MARK: - Handling checked checkbox event
    func checkboxWasChecked(checkbox: Checkbox){
        let index = checkbox.tag;
        hideMenuIfItIsShown();
        enterItemName.resignFirstResponder();
        if checkbox.isChecked{
            //moving item from the itemList to the cart
            currentList.itemList[index].previousPositionInItemList = index;
            currentList.itemsInTheCart.insert(currentList.itemList[index], at: 0);
            currentList.itemList.remove(at: index);
        }
        else{
            // returning item from the cart to the itemList
            let previousIndex: Int = currentList.itemsInTheCart[index].previousPositionInItemList;
            let indexToBeReturnedAt: Int = previousIndex < currentList.itemList.count ? previousIndex : currentList.itemList.count;
            currentList.itemList.insert(currentList.itemsInTheCart[index], at: indexToBeReturnedAt);
            currentList.itemsInTheCart.remove(at: index);
        }
        CurrentState.instance.saveData();
        tblItemsInList.reloadData();
    }
    
    
    //MARK: - Option from menu was selected:
    
    func optionWasSelected (optionIndex: Int){
        if let theRow = selectedRow{
            switch optionIndex {
            case 0:
                editSelectedItem(selectedRow: theRow);
                break;
            case 1:
                addPhotoToSelectedItem(selectedRow: theRow);
                break;
            case 2:
                addPhotoToSelectedItem(selectedRow: theRow);
                break;
            case 3:
                deleteSelectedItem(selectedRow: theRow);
                break;
            default:
                break;
            }
        }
        hideMenuIfItIsShown();
    }
    
    func editSelectedItem(selectedRow: IndexPath){
        
        if editItemViewController == nil{
            editItemViewController = EditItemViewController();
        }
        editItemViewController.editedItem = selectedRow.section == 0 ? currentList.itemList[selectedRow.row] : currentList.itemsInTheCart[selectedRow.row];
        present(editItemViewController, animated: true, completion: nil);
       
    }
    
    
    
    func addPhotoToSelectedItem(selectedRow: IndexPath){
        imagePickerHelper.delegate = self;
        imagePickerHelper.pickPhoto(shouldTakeNewPhoto: true);
    }
    
    func pickPhotoFromPhotoLibrary(selectedRow: IndexPath){
        imagePickerHelper.delegate = self;
        imagePickerHelper.pickPhoto(shouldTakeNewPhoto: false);
    }
    
    func photoWasPicked(image: UIImage) {
        imagePickerHelper.delegate = nil;
    }
    
    func deleteSelectedItem(selectedRow: IndexPath){
        
        if selectedRow.section == 0{
            currentList.itemList.remove(at: selectedRow.row);
        }
        else{
            currentList.itemsInTheCart.remove(at: selectedRow.row);
        }
        CurrentState.instance.saveData();
        tblItemsInList.deleteRows(at: [selectedRow], with: .left);
        tblItemsInList.reloadSections([selectedRow.section], with: .automatic);
        
    }
    
    
    //MARK: Showing and hiding optionsMenu
    
    // hiding menu if it is shown 
    
    func hideMenuIfItIsShown(){
        if isMenuShown {
            optionsMenu.hide();
            selectedRow = nil;
            isMenuShown = false;
        }
    }
    
    func handlingTaps(_ sender: UITapGestureRecognizer){
        hideMenuIfItIsShown();
        if enterItemName.isFirstResponder {
            enterItemName.resignFirstResponder();
        }
    }
    
    // showing menu on longPress:
    
    func handlingLongPressOnRow(_ sender: UILongPressGestureRecognizer){
        let row = (sender.view as! UITableViewCell).contentView.subviews[0].tag;
        let section = ((sender.view as! UITableViewCell).contentView.subviews[0] as! Checkbox).isChecked ? 1 : 0;
        selectedRow = IndexPath(row: row, section: section);
        tblItemsInList.selectRow(at: selectedRow, animated: false, scrollPosition: .none);
        enterItemName.resignFirstResponder();
        if !isMenuShown{
            optionsMenu.show();
            isMenuShown = true;
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enterItemName.becomeFirstResponder();
        hideMenuIfItIsShown();
    }
    
    func btnPhotoClicked(_ sender: UIButton){
        
    }

    
    

}
