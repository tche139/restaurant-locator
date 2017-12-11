//
//  CategoryTableViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 10/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryList:[NSManagedObject] = []
    var selectedCategory=NSManagedObject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        fetchData()
    }
    
    func fetchData(){
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            //fetching and casting to Category
            categoryList = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(categoryList.count)")
            for category in categoryList {
                print((category as! Category).title!)
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
    //reload tableview when navigating back
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }
    
    //iterate cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        let c : Category = self.categoryList[indexPath.row] as! Category
        cell.categoryTitleText.text = c.title!
        
        if let imageData = c.icon {
            if let image = UIImage(data:imageData as Data) {
                cell.CategoryIconImage?.contentMode = UIViewContentMode.scaleAspectFill;
                cell.CategoryIconImage?.layer.masksToBounds=true;
                cell.CategoryIconImage?.image = image
            }
        }
        
        if let color = c.colorAsHex{
            switch color {
            case "red":
                cell.colorImage.backgroundColor = UIColor.red
            case "yellow":
                cell.colorImage.backgroundColor = UIColor.yellow
            case "blue":
                cell.colorImage.backgroundColor = UIColor.blue
            case "green":
                cell.colorImage.backgroundColor = UIColor.green
            default:
                break;
            }
        }
        
        return cell
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //rerange the orderPosition
        if fromIndexPath.row > to.row
        {
            for i in to.row..<fromIndexPath.row
            {
                categoryList[i].setValue(i+1, forKey: "orderPosition")
            }
            categoryList[fromIndexPath.row].setValue(to.row, forKey: "orderPosition")
        }
        if fromIndexPath.row < to.row
        {
            for i in fromIndexPath.row + 1...to.row
            {
                categoryList[i].setValue(i-1, forKey: "orderPosition")
            }
            categoryList[fromIndexPath.row].setValue(to.row, forKey: "orderPosition")
        }
        DatabaseController.saveContext()
        fetchData()
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    //swipe cell for delete and edit
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //edit button for cell
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action,index in
            print("edit button tapped")
            self.selectedCategory=self.categoryList[editActionsForRowAt.row]
            self.performSegue(withIdentifier: "editCategorySegue", sender: self)}
        edit.backgroundColor = .gray
        //delte button for cell
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            DatabaseController.getContext().delete(self.categoryList[editActionsForRowAt.row])
            self.categoryList.remove(at: editActionsForRowAt.row)
            
            tableView.deleteRows(at: [editActionsForRowAt], with: .fade)
            do{
                try DatabaseController.getContext().save()
            }catch let error{
                print("Could not save: \(error)")
            }
            
        }
        delete.backgroundColor = .red
        return [edit,delete]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategorySegue"{
            let controller:EditCategoryViewController = segue.destination as! EditCategoryViewController
            controller.editCategory = selectedCategory
        }
        if segue.identifier == "addCategotySegue"{
            
        }
        if segue.identifier == "singleCategorySegue"{
            let controller:SingleCategoryTableViewController = segue.destination as! SingleCategoryTableViewController
            controller.currentCategory = selectedCategory
        }
    }
    
    //category is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory=categoryList[indexPath.row]
        self.performSegue(withIdentifier: "singleCategorySegue", sender: self)
    }
    
    
    
}
