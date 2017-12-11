//
//  SingleCategoryTableViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 10/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData


class SingleCategoryTableViewController: UITableViewController {
    var currentCategory=NSManagedObject()
    var restaurantList = [NSManagedObject]()
    var selectedRestaurant=NSManagedObject()
    var currentSortDescriptor = NSSortDescriptor()
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    @IBAction func sortSegmentChanged(_ sender: Any) {
        switch sortSegmentedControl.selectedSegmentIndex
        {
        case 0:
            currentSortDescriptor = NSSortDescriptor(key: "name", ascending: true);
        case 1:
            currentSortDescriptor = NSSortDescriptor(key: "rating", ascending: true);
        case 2:
            currentSortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true);
        default:
            currentSortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true);
        }
        fetchRestaurant()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //defual order sort
        currentSortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
        fetchRestaurant()
        tableView.reloadData()
        //add navigation bar button
        let editButton = UIBarButtonItem(title:"Edit",style: .plain, target: self, action:#selector(SingleCategoryTableViewController.editButtonPressed))
        let addButton = UIBarButtonItem(title:"Add",style: .plain, target: self, action:#selector(SingleCategoryTableViewController.didTapAddButton))
        self.navigationItem.setRightBarButtonItems([addButton,editButton], animated: true)
    }
    
    //edit button clicked
    func editButtonPressed()
    {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing == true{
            navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SingleCategoryTableViewController.editButtonPressed))
        }else{
            navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SingleCategoryTableViewController.editButtonPressed))
        }
    }
    
    //add button clicked
    func didTapAddButton(){
        performSegue(withIdentifier: "addRestaurantSegue", sender: self)
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //rerange the orderPosition
        if fromIndexPath.row > to.row
        {
            for i in to.row..<fromIndexPath.row
            {
                (restaurantList[i] ).setValue(i+1, forKey: "orderPosition")
            }
            (restaurantList[fromIndexPath.row] ).setValue(to.row, forKey: "orderPosition")
        }
        if fromIndexPath.row < to.row
        {
            for i in fromIndexPath.row + 1...to.row
            {
                (restaurantList[i] ).setValue(i-1, forKey: "orderPosition")
            }
            (restaurantList[fromIndexPath.row] ).setValue(to.row, forKey: "orderPosition")
        }
        DatabaseController.saveContext()
        currentSortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
        sortSegmentedControl.selectedSegmentIndex = -1
        fetchRestaurant()
    }
    
    //fetch according to sort segmented Controller
    func fetchRestaurant(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        // Create Predicate
        let predicate = NSPredicate(format: "%K == %@", "category", currentCategory as! Category)
        fetchRequest.predicate = predicate
        // Add Sort Descriptor
        fetchRequest.sortDescriptors = [currentSortDescriptor]
        do{
            restaurantList = try DatabaseController.getContext().fetch(fetchRequest) as! [NSManagedObject]
            
        }catch{
            print("Error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //reload tableview when navigating back
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRestaurant()
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
        return restaurantList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
        let r : Restaurnt = self.restaurantList[indexPath.row] as! Restaurnt
        cell.restaurantName.text = r.name
        cell.cosmosView.settings.updateOnTouch = false
        cell.cosmosView.settings.fillMode = .half
        print(r.rating)
        cell.cosmosView.rating = r.rating
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        cell.dateLabel.text = formatter.string(from: r.dateAdded! as Date)
        
        if let imageData = r.logo {
            if let image = UIImage(data:imageData as Data) {
                cell.restaurantCellImage?.contentMode = UIViewContentMode.scaleAspectFill;
                cell.restaurantCellImage?.layer.masksToBounds=true;
                cell.restaurantCellImage?.image = image
            }
        }
        cell.cosmosView.rating = r.rating
        
        return cell
    }
    
    //swipe cell for delete and edit
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //edit button for cell
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action,index in
            print("edit button tapped")
            self.selectedRestaurant=self.restaurantList[editActionsForRowAt.row] 
            self.performSegue(withIdentifier: "editRestaurantSegue", sender: self)}
        edit.backgroundColor = .gray
        //delte button for cell
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            DatabaseController.getContext().delete(self.restaurantList[editActionsForRowAt.row])
            self.restaurantList.remove(at: editActionsForRowAt.row)
            
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
    
    //send value to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRestaurantSegue"{
            let controller:EditRestaurantViewController = segue.destination as! EditRestaurantViewController
            controller.editRestaurant = selectedRestaurant
        }
        if segue.identifier == "addRestaurantSegue"{
            let controller:AddRestaurantViewController = segue.destination as! AddRestaurantViewController
            controller.currentCategory = currentCategory
        }
        if segue.identifier == "restaurantSegue"{
            let controller:RestaurantController = segue.destination as! RestaurantController
            controller.currentRestaurant = selectedRestaurant
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = restaurantList[indexPath.row]
        performSegue(withIdentifier: "restaurantSegue", sender: self)
    }
    
}
