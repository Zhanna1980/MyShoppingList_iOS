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
    
    let margin: CGFloat = 5;
    var listsList: [ShoppingList] = [ShoppingList]();
    let dateFormatter = DateFormatter();
    var selectedRow: Int?;
    var isMenuShown:Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green;
        
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
        return listsList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "identifier");
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CurrentListViewController.handlingLongPressOnRow(_:)));
            cell?.addGestureRecognizer(longPressRecognizer);
        }
        cell!.textLabel?.text = listsList[indexPath.row].name;
        cell!.detailTextLabel?.text = listsList[indexPath.row].date;
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
            listsList.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .left);
            
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
        listsList.insert(newList, at: 0);
        tblLists.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic);
        // I need to reload table in order to keep cell tag up-to-date
        tblLists.reloadSections([0], with: .automatic);
    }
    
    //MARK: - Showing currentListViewController with a specified list
    func showCurrentListViewController(index: Int){
        if currentListViewController == nil{
            currentListViewController = CurrentListViewController();
        }
        currentListViewController.currentList = listsList[index];
        present(currentListViewController, animated: true, completion: nil);
    }
    
    //MARK: - Option from menu was selected:
    
    func optionWasSelected (optionIndex: Int){
        switch optionIndex {
        case 0:
            editSelectedList();
            break;
        case 1:
            shareSelectedList();
            break;
        case 2:
            deleteSelectedList();
            break;
        default:
            break;
        }
        
    }
    
    func editSelectedList(){
        if selectedRow != nil{
            
        }
        hideMenuIfItIsShown();
    }
    
    func shareSelectedList(){
        if selectedRow != nil{
            
        }
        hideMenuIfItIsShown();
    }
    
    func deleteSelectedList(){
        if let theSelectedRow = selectedRow {
            listsList.remove(at: theSelectedRow);
        
            tblLists.deleteRows(at: [IndexPath(row: theSelectedRow, section: 0)], with: .left);
            hideMenuIfItIsShown();
        }
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

