//
//  ViewController.swift
//  Todoey
//
//  Created by Home on 3/6/2562 BE.
//  Copyright © 2562 iilllii. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var itemArray = [ToDo]()
    var parentCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveContext()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        var inputTextField : UITextField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            //what will happend once the user click the Add Item Buttom on our UIAlert
            if inputTextField.text != "" {
                print("Added new item")
                
                let toDoItem = ToDo(context: self.context)
                
                toDoItem.title = inputTextField.text
                toDoItem.parentCategory = self.parentCategory
                
                self.itemArray.append(toDoItem)
                
                self.saveContext()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            inputTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Persistence Context
    func saveContext(){
        do{
            try context.save()
        }catch{
            print("Error save toDoItem \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<ToDo> = ToDo.fetchRequest(), predicate : NSPredicate? = nil){
        
        let predicateCategory = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCategory, additionalPredicate])
            request.predicate = compoundPredicate
        }else{
            request.predicate = predicateCategory
        }
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error decoding \(error)")
        }
        
        tableView.reloadData()
    }
    
}

extension TableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@ AND title CONTAINS[cd] %@", parentCategory!.name!, searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

