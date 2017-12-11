//
//  EditRestaurantViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 05/09/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class EditRestaurantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var editRestaurant = NSManagedObject()
    
    
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    //radius notification switch
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: Any) {
        if notificationSwitch.isOn{
            print("2")
            kilometerText.textColor = UIColor.red
            stepper.isEnabled = true
            radiusText.textColor = UIColor.black
            kmText.textColor = UIColor.black
            stepper.tintColor = UIColor.blue
        }else{
            
            print("1")
            kilometerText.textColor = UIColor.gray
            stepper.isEnabled = false
            radiusText.textColor = UIColor.gray
            kmText.textColor = UIColor.gray
            stepper.tintColor = UIColor.gray
        }
        
    }
    @IBOutlet weak var radiusText: UILabel!
    @IBOutlet weak var kilometerText: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperChanged(_ sender: Any) {
        kilometerText.text = "\(Int(stepper.value))"
    }
    
    @IBOutlet weak var EditRestaurantImageView: UIImageView!
    @IBOutlet weak var kmText: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cosmosView: CosmosView!
    
    //set the edit page
    override func viewDidLoad() {
        super.viewDidLoad()
        EditRestaurantImageView.contentMode = UIViewContentMode.scaleAspectFill
        EditRestaurantImageView.layer.masksToBounds=true
        imagePicker.delegate = self
        //set cosmos
        cosmosView.settings.fillMode = .half
        //set stepper
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 1000
        stepper.minimumValue = 50
        stepper.stepValue = 50
        
        
        //set the value
        restaurantNameTextField.text = editRestaurant.value(forKey: "name") as? String
        addressTextField.text = editRestaurant.value(forKey: "address") as? String
        cosmosView.rating = editRestaurant.value(forKey: "rating") as! Double
        notificationSwitch.isOn = (editRestaurant.value(forKey: "notification") as! Bool)
        
        if notificationSwitch.isOn{
            print("2")
            kilometerText.textColor = UIColor.red
            stepper.isEnabled = true
            radiusText.textColor = UIColor.black
            kmText.textColor = UIColor.black
            stepper.tintColor = UIColor.blue
        }else{
            
            print("1")
            kilometerText.textColor = UIColor.gray
            stepper.isEnabled = false
            radiusText.textColor = UIColor.gray
            kmText.textColor = UIColor.gray
            stepper.tintColor = UIColor.gray
        }
        
        
        kilometerText.text = "\(Int(editRestaurant.value(forKey: "radius") as! Double))"
        stepper.value = editRestaurant.value(forKey: "radius") as! Double
        
        if let imageData = editRestaurant.value(forKey: "logo"){
            if let image = UIImage(data:imageData as! Data){
                EditRestaurantImageView.image = image
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        isAddressRight(address: addressTextField.text!)
    }
    
    func save(){
        if(restaurantNameTextField.text=="" || restaurantNameTextField.text==nil){
            let alertController = UIAlertController(title: "Input Error",message: "Please input category title", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if(EditRestaurantImageView.image==nil){
            let alertController = UIAlertController(title: "Input Error",message: "Please choose picture", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            editRestaurant.setValue(self.restaurantNameTextField.text, forKey: "name")
            
            editRestaurant.setValue(addressTextField.text, forKey: "address")
            
            // Save the rating here (to a variable, local database, send to the server etc.)
            print(cosmosView.rating)
            editRestaurant.setValue(cosmosView.rating, forKey: "rating")
            
            if let image = EditRestaurantImageView.image{
                let imageData = UIImagePNGRepresentation(image) as NSData?
                editRestaurant.setValue(imageData, forKey: "logo")
            }
            
            
            editRestaurant.setValue(notificationSwitch.isOn, forKey: "notification")
            
            editRestaurant.setValue(Int(stepper.value), forKey: "radius")
            
            DatabaseController.saveContext()
            _ = navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func chooseFile(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            EditRestaurantImageView.contentMode = UIViewContentMode.scaleAspectFill;
            EditRestaurantImageView.layer.masksToBounds=true;
            EditRestaurantImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //check validation of address, try to converse address to location, if fail, return false, otherwise treu
    func isAddressRight(address:String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address , completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            if (placemarks?[0]) != nil{
                self.save()
            } else {
                let alertController = UIAlertController(title: "Input Error",message: "Please input a real address", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
            if error != nil {
                print("error")
                let alertController = UIAlertController(title: "Input Error",message: "Please input a real address", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
    }
    
    
}
