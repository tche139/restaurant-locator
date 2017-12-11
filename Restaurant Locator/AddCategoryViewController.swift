//
//  AddCategoryViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 30/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData
class AddCategoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var categoryList = [NSManagedObject]()
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var categoryTitleTextField: UITextField!
    
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func colorSegmentControlClicked(_ sender: UISegmentedControl) {
        switch colorSegmentedControl.selectedSegmentIndex
        {
        case 0:
            colorImage.backgroundColor = UIColor.red;
        case 1:
            colorImage.backgroundColor = UIColor.yellow;
        case 2:
            colorImage.backgroundColor = UIColor.blue;
        case 3:
            colorImage.backgroundColor = UIColor.green;
        default:
            colorImage.backgroundColor = UIColor.red;
        }
    }
    
    //save button
    @IBAction func saveCategoryButton(_ sender: Any) {
        //data validation
        if (categoryTitleTextField.text == "" || categoryTitleTextField.text == nil){
            let alertController = UIAlertController(title: "Input Error",message: "Please input category title", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if (imageView.image==nil){
            let alertController = UIAlertController(title: "Input Error",message: "Please choose picture", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: DatabaseController.getContext()) as? Category
            newCategory!.title = self.categoryTitleTextField.text
            
            let imageData = UIImagePNGRepresentation(imageView.image!) as NSData?
            newCategory!.icon = imageData
            newCategory!.orderPosition = Int16(categoryList.count)
            
            switch colorSegmentedControl.selectedSegmentIndex
            {
            case 0:
                newCategory!.colorAsHex = "red";
            case 1:
                newCategory!.colorAsHex = "yellow";
            case 2:
                newCategory!.colorAsHex = "blue";
            case 3:
                newCategory!.colorAsHex = "green";
            default:
                newCategory!.colorAsHex = "red";
            }
            
            
            DatabaseController.saveContext()
            _ = navigationController?.popViewController(animated: true)
            
        }
    }
    
    //fetch category data
    func RefreshCoredata()
    {
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
    
    @IBAction func choosePicButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imageView.contentMode = UIViewContentMode.scaleAspectFill;
        imageView.layer.masksToBounds=true;
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = UIViewContentMode.scaleAspectFill;
            imageView.layer.masksToBounds=true;
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        RefreshCoredata()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
