//
//  ViewController.swift
//  ToDoDooo
//
//  Created by Ilya Kokorin on 21.09.2024.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    var defaults = UserDefaults.standard
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        print(dataFilePath!)
        
        if let itemArray = defaults.array(forKey: "ToDoListArray") as? [Item] {
            items = itemArray
     }
            let newItem = Item()
            newItem.title = "Find keys"
            items.append(newItem)
    }

    //TableViewStuff
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        items[indexPath.row].done = !items[indexPath.row].done
        tableView.reloadData()
     
    }

    //AddItems Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil && textField.text != "" {
                let newItem = Item()
                newItem.title = textField.text!
                self.items.append(newItem)
                self.defaults.set(self.items, forKey: "ToDoListArray")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create  new item"
            textField = alertTextfield
        }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
}

