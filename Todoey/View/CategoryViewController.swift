//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Арстан on 7/7/22.
//
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories()
        tableView.separatorStyle = .none
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.backgroundColor = UIColor.init(hexString: categories?[indexPath.row].colour ?? "1D9")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    func save(category : Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
        }
    func loadCategories(){
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting category \(error)")
            }
            
        }
    }
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавьте новую категорию", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Добавить новую категорию", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
    
            self.save(category: newCategory)
            
            
    }
    alert.addAction(action)
    alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Создайте новую категорию"
    
        
    }
        present(alert, animated: true, completion: nil)
    

    
}
}
