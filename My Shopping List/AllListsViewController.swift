//
//  ViewController.swift
//  My Shopping List
//
//  Created by Zhanna Libman on 20/09/2016.
//  Copyright © 2016 Zhanna Libman. All rights reserved.
//

import UIKit

// function for setting one style custom border to different views
extension UIView{
    func setBorder(){
        self.layer.cornerRadius = 9;
        self.layer.borderWidth = 3;
        self.layer.borderColor = UIColor(colorLiteralRed: 71/255, green: 186/255, blue: 193/255, alpha: 1).cgColor;
        self.layer.masksToBounds = true;
    }
}


// Represents the list of shopping lists
class AllListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, OptionWasSelectedDelegate {
    
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
        view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "Mix-of-green-vegetables"));
        
        // load application data: lists, items, etc.
        CurrentState.loadData();
        
        dateFormatter.dateFormat = "dd/MM/yy HH:mm"
        dateFormatter.locale = Locale.current;
        
        // title label
        lblTitle = ViewBuilder.addLabel(frame: CGRect(x: margin, y: 40, width: view.frame.width - 2*margin, height: 50), text: "My lists", addToView: view);
        lblTitle.textAlignment = .center;
        //lblTitle will be hidden when options menu is shown
        lblTitle.tag = OptionsMenu.viewToBeHiddenTag;
        lblTitle.font = UIFont.systemFont(ofSize: 18);
        
        optionsMenu = OptionsMenu(view: view, options: [
            Option(icon: #imageLiteral(resourceName: "ic_mode_edit"), label: "Edit"),
            Option(icon: #imageLiteral(resourceName: "share-variant"), label: "Share"),
            Option(icon: #imageLiteral(resourceName: "ic_delete"), label: "Delete")]);
        optionsMenu.optionWasSelectedDelegate = self;
        
        //list name text box
        enterListName = ViewBuilder.addTextField(frame: CGRect(x: margin, y: lblTitle.frame.maxY + margin, width: view.frame.width - 50 - 3*margin, height: 50), addToView: view);
        enterListName.placeholder = "Add a new list";
        enterListName.delegate = self;
        
        //add button
        btnAddList = ViewBuilder.addSquareSystemButton(position: CGPoint(x: enterListName.frame.maxX + margin, y: enterListName.frame.origin.y), title: "+", addToView: view);
        btnAddList.addTarget(self, action: #selector(AllListsViewController.btnAddListWasClicked(_:)), for: .touchUpInside);
        
        // table that show all lists
        tblLists = UITableView(frame: CGRect(x: margin, y: enterListName.frame.maxY + margin, width:view.frame.width - 2*margin, height: view.frame.height - (enterListName.frame.maxY + margin)), style: .plain);
        tblLists.setBorder();
        tblLists.delegate = self;
        tblLists.dataSource = self;
        tblLists.alpha = 0.8;
        view.addSubview(tblLists);
        
        //taps for hiding options menu and keyboard
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (AllListsViewController.handlingTaps(_:)));
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
        
        //create cell if not reused
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier");
            cell?.showsReorderControl = true;
            //on long press will be shown options menu
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CurrentListViewController.handlingLongPressOnRow(_:)));
            cell?.addGestureRecognizer(longPressRecognizer);
        }
        // fill cell data
        cell!.textLabel?.text = CurrentState.instance.listsList[indexPath.row].name;
        cell!.detailTextLabel?.text = CurrentState.instance.listsList[indexPath.row].date;
        cell!.tag = indexPath.row;
        return cell!;
    }
    
    // go to the selected list
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCurrentListViewController(index: indexPath.row);
    }
    
    // delete list with swipe
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete;
    }
    
    //delete list with swipe
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
    
    //user pressed enter on the keyboard
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
           enteredListName = "Unnamed";
        }
        else{
            enteredListName = enterListName.text!;
        }
        let date = Date();
        let stringDate = dateFormatter.string(from: date);
        let newList = ShoppingList(name: enteredListName, date: stringDate);
        CurrentState.instance.listsList.insert(newList, at: 0);
        tblLists.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic);
        // The table is needed to be reloaded in order to keep cell tag up-to-date
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
    
    //shows alertController for editing the list name
    func editSelectedList(selectedRow: Int){
        
        editAlertController = UIAlertController(title: "Edit your list name:", message: nil, preferredStyle: .alert);
        editAlertController.addTextField { (textField: UITextField) in
            textField.text = CurrentState.instance.listsList[selectedRow].name;
        }
        let actionDone = UIAlertAction(title: "Done", style: .default, handler: { [weak self](action: UIAlertAction) in
            CurrentState.instance.listsList[selectedRow].name = self!.editAlertController.textFields![0].text!;
                self!.tblLists.reloadRows(at: [IndexPath(row: selectedRow, section: 0)], with: .automatic);
                CurrentState.instance.saveData();

                });
        editAlertController.addAction(actionDone);
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        editAlertController.addAction(actionCancel);

        present(editAlertController, animated: true, completion: nil);
    }
    
    // handles option "share" - sharing list of items as one string
    func shareSelectedList(selectedRow: Int){
        let contentToShare: String = CurrentState.instance.listsList[selectedRow].describeShoppingList();
        let objectsToShare = [contentToShare] as [Any];
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: []);
            
        activityVC.excludedActivityTypes = [UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.saveToCameraRoll];
            
        activityVC.popoverPresentationController?.sourceView = optionsMenu.options[1];
        self.present(activityVC, animated: true, completion: nil);
       
        
    }
    
    // handles option "delete selected list"
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
    
    // hiding options menu and keyboard
    func handlingTaps(_ sender: UITapGestureRecognizer){
        hideMenuIfItIsShown();
        if enterListName.isFirstResponder {
            enterListName.resignFirstResponder();
        }
    }
    
    // showing menu on long press
    func handlingLongPressOnRow(_ sender: UILongPressGestureRecognizer){
        selectedRow = sender.view?.tag;
        tblLists.selectRow(at: IndexPath(row: selectedRow!, section: 0), animated: false, scrollPosition: .none);
        enterListName.resignFirstResponder();
        if !isMenuShown{
            optionsMenu.show();
            isMenuShown = true;
        }
    }
    
    // restore the keyboard and hide options menu
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enterListName.becomeFirstResponder();
        hideMenuIfItIsShown();
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

