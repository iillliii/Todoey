//
//  ViewController.swift
//  Todoey
//
//  Created by Home on 3/6/2562 BE.
//  Copyright © 2562 iilllii. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var itemArray = [ToDo]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDo.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Initialize table view cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].check ? .checkmark : .none

        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].check = !itemArray[indexPath.row].check
        
        persist()
        
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
                self.itemArray.append(ToDo.init(title: inputTextField.text!))
                self.persist()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            inputTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func persist(){
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error enconding item array. \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            print(data)
            do{
                itemArray = try decoder.decode([ToDo].self, from: data)
                
            }catch{
                print("Error decoding \(error)")
            }
        }
    }
}

