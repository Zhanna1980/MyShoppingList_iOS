//
//  CurrentListViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 22/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import Foundation
import UIKit

//Presents the specific shopping list
class CurrentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckboxWasCheckedDelegate, OptionWasSelectedDelegate, UITextFieldDelegate {
    
    var lblTitle: UILabel!;
    var btnBack: UIButton!;
    var enterItemName: UITextField!;
    var btnAddItem: UIButton!;
    var tblItemsInList: UITableView!;
    var optionsMenu: OptionsMenu!;
    var currentList: ShoppingList!;
    var editItemViewController: EditItemViewController!;
    var imagePickerHelper: ImagePickerHelper!;
    var displayImageViewController: DisplayImageViewController!;
    
    let margin: CGFloat = 5;
    
    var selectedRow: IndexPath!;
    var isMenuShown:Bool = false;
    var shouldReloadData: Bool = false;
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "Mix-of-green-vegetables"));
        
        imagePickerHelper = ImagePickerHelper(viewController: self);
        
        let header = UIView(frame: CGRect(x: margin, y: 30, width: view.frame.width - 2*margin, height: 65));
        header.tag = OptionsMenu.viewToBeHiddenTag;
        view.addSubview(header);
    
        btnBack = UIButton(type: .system);
        btnBack.frame = CGRect(x: 0, y: 0, width: 100, height: 30);
        btnBack.setTitle("<<Back", for: .normal);
        btnBack.addTarget(self, action: #selector(CurrentListViewController.btnBackClicked(_:)), for: .touchUpInside);
        header.addSubview(btnBack);
        
        
        
        lblTitle = UILabel(frame: CGRect(x: 0, y: btnBack.frame.maxY + margin, width: header.frame.width, height: 30));
        lblTitle.textAlignment = .center;
        lblTitle.font = UIFont.systemFont(ofSize: 18);
        lblTitle.text = currentList.name;
        header.addSubview(lblTitle);
        
        optionsMenu = OptionsMenu(view: view, options: [
                        Option(icon: #imageLiteral(resourceName: "ic_mode_edit"), label: "Edit"),
                        Option(icon: #imageLiteral(resourceName: "ic_forward"), label: "Move"),
                        Option(icon: #imageLiteral(resourceName: "ic_content_copy"), label: "Copy"),
                        Option(icon: #imageLiteral(resourceName: "ic_delete"), label: "Delete")]);
        optionsMenu.optionWasSelectedDelegate = self;
        
        enterItemName = UITextField(frame: CGRect(x: margin, y: header.frame.maxY + margin, width: view.frame.width - 3*margin - 50, height: 50));
        enterItemName.borderStyle = .roundedRect;
        enterItemName.placeholder = "Enter an item name";
        enterItemName.layer.cornerRadius = 9;
        enterItemName.layer.borderWidth = 3;
        enterItemName.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        enterItemName.layer.masksToBounds = true;
        enterItemName.alpha = 0.8;
        enterItemName.delegate = self;
        view.addSubview(enterItemName);
        
        btnAddItem = UIButton(type: .system);
        btnAddItem.frame = CGRect(x: enterItemName.frame.maxX + margin, y: enterItemName.frame.origin.y, width: 50, height: 50);
        btnAddItem.setTitle("+", for: .normal);
        btnAddItem.backgroundColor = UIColor.white;
        btnAddItem.alpha = 0.8;
        btnAddItem.layer.cornerRadius = 9;
        btnAddItem.layer.borderWidth = 3;
        btnAddItem.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        btnAddItem.addTarget(self, action: #selector(CurrentListViewController.btnAddItemClicked(_:)), for: .touchUpInside);
        view.addSubview(btnAddItem);
        
        
        tblItemsInList = UITableView(frame: CGRect(x: margin, y: enterItemName.frame.maxY + margin, width: view.frame.width - 2*margin, height: view.frame.height - enterItemName.frame.maxY - 2*margin), style: .grouped);
        tblItemsInList.layer.cornerRadius = 9;
        tblItemsInList.layer.borderWidth = 3;
        tblItemsInList.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        tblItemsInList.alpha = 0.8;
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
        
        //setting displayImageViewController to nil in order to release memory from rarely used viewController:
        displayImageViewController = nil;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        shouldReloadData = true;
    }
    
    // back to the list of shopping lists
    func btnBackClicked(_ sender: UIButton){
        dismiss(animated: true, completion: nil);
    }
    
    // MARK: - Adding an item to list
    func btnAddItemClicked(_ sender: UIButton){
        processTextFieldData();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processTextFieldData();
        return true;
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
        for i in 0..<currentList.itemList.count{
            if currentList.itemList[i].name == itemName{
                isAlreadyInTheList = true;
                break;
            }
        }
        if !isAlreadyInTheList{
            let newItem = Item(name: itemName);
            currentList.itemList.insert(newItem, at: 0);
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
    
    // MARK: - Defining a tableView
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
    
    // defining a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        
        if cell == nil{
            cell = UITableViewCell(style: .value1, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
            
            let checkbox = Checkbox(position: CGPoint(x: 5, y: 0));
            checkbox.center.y = cell!.contentView.center.y;
            checkbox.delegate = self;
            cell!.contentView.addSubview(checkbox);

            let lblItemName = UILabel(frame: CGRect(x: checkbox.frame.maxX + 5, y: 0, width: cell!.contentView.frame.width - 150, height: 30));
            lblItemName.center.y = cell!.contentView.center.y;
            cell!.contentView.addSubview(lblItemName);
            
            
            let btnPhoto = UIButton(type: .custom);
            btnPhoto.frame = CGRect(x: lblItemName.frame.maxX, y: 0, width: 30, height: 30);
            btnPhoto.center.y = cell!.contentView.center.y;
            btnPhoto.contentMode = .scaleAspectFit;
            btnPhoto.addTarget(self, action: #selector(CurrentListViewController.btnPhotoClicked(_:)), for: .touchUpInside);
            btnPhoto.setImage(#imageLiteral(resourceName: "ic_photo"), for: .normal);
            btnPhoto.isHidden = true;
            cell!.contentView.addSubview(btnPhoto);
            
            let lblItemCalculations = UILabel(frame: CGRect(x: cell!.contentView.frame.width - 90, y: 0, width: 90, height: 30));
            lblItemCalculations.center.y = cell!.contentView.center.y;
            lblItemCalculations.textColor = UIColor.blue;
            lblItemCalculations.font = UIFont.systemFont(ofSize: 14);
            lblItemCalculations.textAlignment = .right;
            cell!.contentView.addSubview(lblItemCalculations);

            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CurrentListViewController.handlingLongPressOnRow(_:)));
            cell?.addGestureRecognizer(longPressRecognizer);
            

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
                btnPhoto.isHidden = false;
                // tag displays table as a matix:
                btnPhoto.tag = indexPath.row * 2 + indexPath.section;
            }
            else{
                btnPhoto.isHidden = true;
                btnPhoto.tag = -1;
            }

        }
        else{
            lblItemName.text = currentList.itemsInTheCart[indexPath.row].name;
            lblItemCalculations.text = currentList.itemsInTheCart[indexPath.row].calculations.toString();
            checkbox.setChecked(checked: true);
            checkbox.tag = indexPath.row;
            // photo button
            if currentList.itemsInTheCart[indexPath.row].itemImage != nil {
                btnPhoto.isHidden = false;
                // tag displays table as a matix:
                btnPhoto.tag = indexPath.row * 2 + indexPath.section;
            }
            else{
                btnPhoto.isHidden = true;
                btnPhoto.tag = -1;
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
    
    // MARK: Header of the section "Items in the cart"
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (section == 0 ? 0.1 : 50);
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewContainer = UIView();
        viewContainer.layer.borderWidth = 3;
        viewContainer.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        
        let headerTitle = UILabel(frame: CGRect(x: 15, y: 10, width: 150, height: 30));
        headerTitle.text = section == 1 ? "Items in the cart: " : "";
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
                copyOrMoveSelectedItemToOtherList(selectedRow: theRow, shouldCopyItem: false);
                break;
            case 2:
                copyOrMoveSelectedItemToOtherList(selectedRow: theRow, shouldCopyItem: true);
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
    
    // move to editItemViewController when selected edit item option
    func editSelectedItem(selectedRow: IndexPath){
        
        if editItemViewController == nil{
            editItemViewController = EditItemViewController();
        }
        editItemViewController.editedItem = selectedRow.section == 0 ? currentList.itemList[selectedRow.row] : currentList.itemsInTheCart[selectedRow.row];
        present(editItemViewController, animated: true, completion: nil);
       
    }
    
    //copy or move selected item to other list
    func copyOrMoveSelectedItemToOtherList(selectedRow: IndexPath, shouldCopyItem: Bool){
        if CurrentState.instance.listsList.count <= 1{
            return;
        }
        let item: Item = selectedRow.section == 0 ? currentList.itemList[selectedRow.row] : currentList.itemsInTheCart[selectedRow.row];
        let title = item.name;
        let message = shouldCopyItem ? "Copy to the list:" : "Move to the list:";
        //actionSheet with the possible lists to copy or to move the item to
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        for i in 0..<CurrentState.instance.listsList.count{
            if CurrentState.instance.listsList[i].name == currentList.name {
                continue;
            }
            else{
                let action = UIAlertAction(title: CurrentState.instance.listsList[i].name, style: .default) { (action: UIAlertAction) in
                        CurrentState.instance.listsList[i].itemList.append(item);
                        if !shouldCopyItem{
                            if selectedRow.section == 0{
                                self.currentList.itemList.remove(at: selectedRow.row);
                            }
                            else{
                                self.currentList.itemsInTheCart.remove(at: selectedRow.row);
                            }
                        }
                        CurrentState.instance.saveData();
                        self.tblItemsInList.reloadSections([selectedRow.section], with: .automatic);
                }
                alertController.addAction(action);
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertController.addAction(actionCancel);
        present(alertController, animated: true, completion: nil);
    }
    
    // delete item when "delete" option was selected
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
    
    //hiding options menu and keyboard
    func handlingTaps(_ sender: UITapGestureRecognizer){
        hideMenuIfItIsShown();
        if enterItemName.isFirstResponder {
            enterItemName.resignFirstResponder();
        }
    }
    
    // showing menu on longPress
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
    
    // MARK: presenting displayImageViewController.
    func btnPhotoClicked(_ sender: UIButton){
        hideMenuIfItIsShown();
        //in order to release memory from rare used viewController, displayImageViewController is created every time it is needed and afterwards is set to nil;
        displayImageViewController = DisplayImageViewController();
        let tag = sender.tag;
        
        if tag != -1 {
            let section: Int = tag % 2;
            let row: Int = tag/2;
        
            if let image = section == 0 ? currentList.itemList[row].itemImage : currentList.itemsInTheCart[row].itemImage {
            
                displayImageViewController.itemImage = image;
                present(displayImageViewController, animated: true, completion: nil);
            }
        }
    }
}
