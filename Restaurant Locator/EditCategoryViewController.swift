//
//  Ed/Users/qingyunhe/Desktop/Restaurant Locator/Restaurant Locator/EditCategoryViewController.swiftitCategoryViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 04/09/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData

class EditCategoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var editCategory=NSManagedObject()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editCategoryTitle: UITextField!
    
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    
    @IBAction func colorSegmentedControlClicked(_ sender: UISegmentedControl) {
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
    
    @IBOutlet weak var colorImage: UIImageView!
    
    //save button clicked
    @IBAction func saveButton(_ sender: Any) {
        //vaildation
        if (editCategoryTitle.text == "" || editCategoryTitle.text == nil){
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
            editCategory.setValue(editCategoryTitle.text, forKey: "title")
            let imageData = UIImagePNGRepresentation(imageView.image!) as NSData?
            editCategory.setValue(imageData, forKey: "icon")
            
            switch colorSegmentedControl.selectedSegmentIndex
            {
            case 0:
                editCategory.setValue("red", forKey: "colorAsHex");
            case 1:
                editCategory.setValue("yellow", forKey: "colorAsHex");
            case 2:
                editCategory.setValue("blue", forKey: "colorAsHex");
            case 3:
                editCategory.setValue("green", forKey: "colorAsHex");
            default:
                editCategory.setValue("red", forKey: "colorAsHex");
            }
            
            DatabaseController.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
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
        imageView.contentMode = UIViewContentMode.scaleAspectFill;
        imageView.layer.masksToBounds=true;
        imagePicker.delegate = self
        editCategoryTitle.text = editCategory.value(forKey: "title") as? String
        if let imageData = editCategory.value(forKey: "icon"){
            if let image = UIImage(data:imageData as! Data){
                imageView.contentMode = .scaleAspectFill
                imageView.image = image
            }
        }
        if let color = editCategory.value(forKey: "colorAsHex"){
            switch color as! String {
            case "red":
                colorImage.backgroundColor = UIColor.red
                colorSegmentedControl.selectedSegmentIndex = 0;
            case "yellow":
                colorImage.backgroundColor = UIColor.yellow
                colorSegmentedControl.selectedSegmentIndex = 1;
            case "blue":
                colorImage.backgroundColor = UIColor.blue
                colorSegmentedControl.selectedSegmentIndex = 2;
            case "green":
                colorImage.backgroundColor = UIColor.green
                colorSegmentedControl.selectedSegmentIndex = 3;
            default:
                colorImage.backgroundColor = UIColor.red
                colorSegmentedControl.selectedSegmentIndex = 0;
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseFileButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}
