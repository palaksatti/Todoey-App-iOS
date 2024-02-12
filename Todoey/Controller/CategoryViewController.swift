//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Palak Satti on 12/02/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
    //MARK: - TableView dataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
        
    }
    //MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           guard editingStyle == .delete else { return }
           
           let deletedItem = categoryArray[indexPath.row]
           
           do {
               context.delete(deletedItem)
               try context.save()
               
               categoryArray.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           } catch {
               print("Error deleting item: \(error.localizedDescription)")
           }
       }
    //MARK: - data manipulation menthods
    
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("error occ")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        let request: NSFetchRequest <Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error")
        }
        tableView.reloadData()
    }
    
//MARK: - add category button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text
            self.categoryArray.append(newCategory )
            self.saveCategory()
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert, animated: true)
        
    }
    
}
