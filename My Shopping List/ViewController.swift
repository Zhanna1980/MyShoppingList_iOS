//
//  ViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, OptionWasSelectedDelegate {
    
    var lblTitle: UILabel!;
    var enterListName: UITextField!;
    var btnAddList: UIButton!;
    var tblLists: UITableView!;
    var currentListViewController: CurrentListViewController!;
    var optionsMenu: OptionsMenu!;
    var editAlertController: UIAlertController!;
    
    let margin: CGFloat = 5;
    
    let dateFormatter = DateFormatter();
    var selectedRow: Int?;
    var isMenuShown:Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green;
        
        CurrentState.loadData();
        
        dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        dateFormatter.locale = Locale.current;
        
        lblTitle = UILabel(frame: CGRect(x: margin, y: 40, width: view.frame.width - 2*margin, height: 50));
        lblTitle.textAlignment = .center;
        lblTitle.text = "My lists:";
        view.addSubview(lblTitle);
        
        optionsMenu = OptionsMenu(view: view, options: [
            Option(icon: #imageLiteral(resourceName: "ic_mode_edit"), label: "Edit"),
            Option(icon: #imageLiteral(resourceName: "share-variant"), label: "Share"),
            Option(icon: #imageLiteral(resourceName: "ic_delete"), label: "Delete")]);
        optionsMenu.optionWasSelectedDelegate = self;
        
        enterListName = UITextField(frame: CGRect(x: margin, y: lblTitle.frame.maxY + margin, width: view.frame.width - 50 - 3*margin, height: 50));
        enterListName.borderStyle = .roundedRect;
        enterListName.backgroundColor = UIColor.lightGray;
        enterListName.placeholder = "Add a new list";
        enterListName.delegate = self;
        view.addSubview(enterListName);
        
        btnAddList = UIButton(type: .system);
        btnAddList.setTitle("+", for: .normal);
        btnAddList.frame = CGRect(x: enterListName.frame.maxX + margin, y: enterListName.frame.origin.y, width: 50, height: enterListName.frame.height);
        btnAddList.backgroundColor = UIColor.lightGray;
        btnAddList.addTarget(self, action: #selector(ViewController.btnAddListWasClicked(_:)), for: .touchUpInside);
        view.addSubview(btnAddList);
        
        tblLists = UITableView(frame: CGRect(x: margin, y: enterListName.frame.maxY + margin, width:view.frame.width - 2*margin, height: view.frame.height - (enterListName.frame.maxY + margin)), style: .plain);
        tblLists.delegate = self;
        tblLists.dataSource = self;
        view.addSubview(tblLists);
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (ViewController.handlingTaps(_:)));
        tapGestureRecognizer.cancelsTouchesInView = false;
        view.addGestureRecognizer(tapGestureRecognizer);
        
        
    }
    
    
    //MARK: - Defining the tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentState.instance.listsList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CurrentListViewController.handlingLongPressOnRow(_:)));
            cell?.addGestureRecognizer(longPressRecognizer);
        }
        cell!.textLabel?.text = CurrentState.instance.listsList[indexPath.row].name;
        cell!.detailTextLabel?.text = CurrentState.instance.listsList[indexPath.row].date;
        cell!.tag = indexPath.row;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCurrentListViewController(index: indexPath.row);
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            CurrentState.instance.listsList.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .left);
            CurrentState.instance.saveData();
        }
    }

    //MARK: Adding a new list
    func btnAddListWasClicked (_ sender: UIButton){
        processTextFieldData();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processTextFieldData();
        return true;
    }
    
    func processTextFieldData(){
        addListToList();
        enterListName.text = "";
        enterListName.placeholder = "Add a new list";
        showCurrentListViewController(index: 0);
    }
    
    func addListToList(){
        var enteredListName: String;
        if !enterListName.hasText{
           enteredListName = "unnamed";
        }
        else{
            enteredListName = enterListName.text!;
        }
        let date = Date();
        let stringDate = dateFormatter.string(from: date);
        var newList = ShoppingList(name: enteredListName, date: stringDate);
        CurrentState.instance.listsList.insert(newList, at: 0);
        tblLists.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic);
        // I need to reload table in order to keep cell tag up-to-date
        tblLists.reloadSections([0], with: .automatic);
        CurrentState.instance.saveData();

    }
    
    //MARK: - Showing currentListViewController with a specified list
    func showCurrentListViewController(index: Int){
        if currentListViewController == nil{
            currentListViewController = CurrentListViewController();
        }
        currentListViewController.currentList = CurrentState.instance.listsList[index];
        present(currentListViewController, animated: true, completion: nil);
    }
    
    //MARK: - Option from menu was selected:
    
    func optionWasSelected (optionIndex: Int){
        if let theRow = selectedRow{
            switch optionIndex {
            case 0:
                editSelectedList(selectedRow: theRow);
                break;
            case 1:
                shareSelectedList(selectedRow: theRow);
                break;
            case 2:
                deleteSelectedList(selectedRow: theRow);
                break;
            default:
                break;
            }
        }
        hideMenuIfItIsShown();
    }
    //shows alertController for editing the list name:
    func editSelectedList(selectedRow: Int){
        
        editAlertController = UIAlertController(title: "Edit your list name:", message: nil, preferredStyle: .alert);
        editAlertController.addTextField { (textField: UITextField) in
            textField.text = CurrentState.instance.listsList[selectedRow].name;
        }
        let actionDone = UIAlertAction(title: "Done", style: .default, handler: { [weak self](action: UIAlertAction) in
                CurrentState.instance.listsList[selectedRow].name = self!.editAlertController.textFields![0].text!
                self!.tblLists.reloadRows(at: [IndexPath(row: selectedRow, section: 0)], with: .automatic);
                CurrentState.instance.saveData();

                });
        editAlertController.addAction(actionDone);
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        editAlertController.addAction(actionCancel);

        present(editAlertController, animated: true, completion: nil);
    }
    // option of sharing list of items as one string
    func shareSelectedList(selectedRow: Int){
        let contentToShare: String = CurrentState.instance.listsList[selectedRow].describeShoppingList();
        let objectsToShare = [contentToShare] as [Any];
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: []);
            
        activityVC.excludedActivityTypes = [UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.saveToCameraRoll];
            
        activityVC.popoverPresentationController?.sourceView = optionsMenu.options[1];
        self.present(activityVC, animated: true, completion: nil);
       
        
    }
    // option "delete selected list"
    func deleteSelectedList(selectedRow: Int){
        CurrentState.instance.listsList.remove(at: selectedRow);
        tblLists.deleteRows(at: [IndexPath(row: selectedRow, section: 0)], with: .left);
        CurrentState.instance.saveData();

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
        if enterListName.isFirstResponder {
            enterListName.resignFirstResponder();
        }
    }
    
    // showing menu on longPress:
    
    func handlingLongPressOnRow(_ sender: UILongPressGestureRecognizer){
        selectedRow = sender.view?.tag;
        tblLists.selectRow(at: IndexPath(row: selectedRow!, section: 0), animated: false, scrollPosition: .none);
        enterListName.resignFirstResponder();
        if !isMenuShown{
            optionsMenu.show();
            isMenuShown = true;
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enterListName.becomeFirstResponder();
        hideMenuIfItIsShown();
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

