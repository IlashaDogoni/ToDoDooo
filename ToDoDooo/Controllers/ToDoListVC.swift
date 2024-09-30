//
//  ViewController.swift
//  ToDoDooo
//
//  Created by Ilya Kokorin on 21.09.2024.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Item]()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    //MARK: Table Stuff
    
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                context.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                saveItems()
            }
        }

    //MARK: AddItems Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text != nil && textField.text != "" {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.items.append(newItem)
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create  new item"
            textField = alertTextfield
        }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: CoreData
    
    func saveItems() {
        do {
            try context.save()
            print(context)
        } catch {
         print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), searchText: String? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        var searchPredicate: NSPredicate?
            if let searchText = searchText, !searchText.isEmpty {
                searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            }
        
        if let searchPredicate = searchPredicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
            } else {
                request.predicate = categoryPredicate
            }
    
        
        do{
           items = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        tableView.reloadData()
    }
}

    //MARK: SearchBar

extension ToDoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItems(searchText: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            loadItems(searchText: searchText)
        }
    }
}
