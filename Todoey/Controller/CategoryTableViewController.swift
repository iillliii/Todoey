//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Home on 9/6/2562 BE.
//  Copyright © 2562 iilllii. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCatagory = categoryArray[indexPath.row]
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // MARK: - Segue event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destination = segue.destination as! TableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.title = categoryArray[indexPath.row].name
                destination.parentCategory = categoryArray[indexPath.row]
            }
        }
//        let destination = TableViewController()
//        destination.title =
    }
    
    // MARK: - Button event

    @IBAction func addItemClicked(_ sender: Any) {
        print("Add item")
        
        var textField = UITextField()
        
        textField.placeholder = "Shopping"
        
        let alert = UIAlertController(title: "Add category", message: "Add new item", preferredStyle: .alert)
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertAction = UIAlertAction(title: "Create new category", style: .default) { (UIAlertAction) in
            if (textField.text?.trimmingCharacters(in: .whitespaces))?.count != 0 {
                let categoryItem = Category(context: self.context)
                categoryItem.name = textField.text
                self.categoryArray.append(categoryItem)
                self.saveItem()
            }
        }
        
        alert.addTextField { (UITextField) in
            textField = UITextField
        }
        
        alert.addAction(alertCancel)
        alert.addAction(alertAction)
        
        present(alert, animated: false, completion: nil)
    }
    
    //MARK: - Persistence Context
    
    func saveItem() {
        do{
            try context.save()
        }catch{
            print("Error save item \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItem() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            try categoryArray = context.fetch(request)
        }catch{
            print("Error save item \(error)")
        }
        tableView.reloadData()
    }
}
