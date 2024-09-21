//
//  ViewController.swift
//  ToDoDooo
//
//  Created by Ilya Kokorin on 21.09.2024.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    var items = ["Find Keys", "Call the police", "Smoke some..."]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //TableViewStuff
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
      /* if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
       */
        //^^^^^^ refactored
        tableView.cellForRow(at: indexPath)?.accessoryType =
            (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) ? .none : .checkmark
    }

    //AddItems Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil || textField.text != "" {
                self.items.append(textField.text!)
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

