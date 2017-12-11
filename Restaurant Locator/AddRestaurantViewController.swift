//
//  AddRestaurantViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 30/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class AddRestaurantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var currentCategory = NSManagedObject()
    //name
    @IBOutlet weak var restaurantNameTextField: UITextField!
    //rating
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    //image
    @IBOutlet weak var imgeView: UIImageView!
    //address
    @IBOutlet weak var addressTextField: UITextField!
    //notification
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var radiusText: UILabel!
    @IBOutlet weak var kmText: UILabel!
    @IBAction func switchClicked(_ sender: Any) {
        if notificationSwitch.isOn{
            print("2")
            kilometerLabel.textColor = UIColor.red
            stepper.isEnabled = true
            radiusText.textColor = UIColor.black
            kmText.textColor = UIColor.black
            stepper.tintColor = UIColor.blue
        }else{
            
            print("1")
            kilometerLabel.textColor = UIColor.gray
            stepper.isEnabled = false
            radiusText.textColor = UIColor.gray
            kmText.textColor = UIColor.gray
            stepper.tintColor = UIColor.gray
        }
    }
    //raduis
    @IBOutlet weak var kilometerLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperAction(_ sender: Any) {
        kilometerLabel.text = "\(Int(stepper.value))"
    }
    //choose image file
    @IBAction func chooseFileButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imgeView.contentMode = UIViewContentMode.scaleAspectFill;
        imgeView.layer.masksToBounds=true;
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //save restaurant
    @IBAction func saveRestaurantButton(_ sender: Any) {
        isAddressRight(address: addressTextField.text!)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imgeView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        //set rating control
        cosmosView.settings.fillMode = .half
        //set stepper
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 1000
        stepper.minimumValue = 50
        stepper.stepValue = 50
        
        imgeView.contentMode = UIViewContentMode.scaleAspectFill;
        imgeView.layer.masksToBounds=true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func save(){
        //validation before save restaurant
        if(restaurantNameTextField.text=="" || restaurantNameTextField.text==nil){
            let alertController = UIAlertController(title: "Input Error",message: "Please input category title", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else if(imgeView.image==nil){
            let alertController = UIAlertController(title: "Input Error",message: "Please choose picture", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let newRestaurant = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: DatabaseController.getContext())
            
            newRestaurant.setValue(self.restaurantNameTextField.text, forKey: "name")
            
            newRestaurant.setValue(addressTextField.text, forKey: "address")
            
            // Save the rating here (to a variable, local database, send to the server etc.)
            print(cosmosView.rating)
            newRestaurant.setValue(cosmosView.rating, forKey: "rating")
            
            if let image = imgeView.image{
                let imageData = UIImagePNGRepresentation(image) as NSData?
                newRestaurant.setValue(imageData, forKey: "logo")
            }
            
            
            newRestaurant.setValue(notificationSwitch.isOn, forKey: "notification")
            newRestaurant.setValue(currentCategory.mutableSetValue(forKey: "restaurants").count, forKey: "orderPosition")
            newRestaurant.setValue(Int(stepper.value), forKey: "radius")
            
            
            newRestaurant.setValue(Date(), forKey: "dateAdded")
            
            currentCategory.mutableSetValue(forKey: "restaurants").add(newRestaurant)
            DatabaseController.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
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
