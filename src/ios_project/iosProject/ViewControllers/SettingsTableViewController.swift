//
//  SettingsTableViewController.swift
//  iosProject
//
//  Created by Patunique on 09.02.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    
    @IBAction func btnClicked() {
        ImagePickerManager().pickImage(self){ image in
            self.settingsImageView.image = image
            
            let imageData = image.pngData()!
            let imageFile = PFFileObject(name:"image.png", data:imageData)
            currentUser.image = imageFile
            userLogic.saveCurrentUser()
        }
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func nameChanged(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want change name?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            currentUser.username = self.nameTextField.text
            userLogic.saveCurrentUser()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.nameTextField.text = (currentUser.username)
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func passwordChanged(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want change password?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //userLogic.password = self.passwordTextField.text
            userLogic.saveCurrentUser()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            //self.passwordTextField.text = (userLogic.password!)
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func emailChanged(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want change email?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            currentUser.email = self.emailTextField.text
            userLogic.saveCurrentUser()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.emailTextField.text = (currentUser.email)
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBAction func phoneChanged(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want change phone number?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            currentUser.phoneNumber = self.phoneTextField.text
            userLogic.saveCurrentUser()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.phoneTextField.text = (currentUser.phoneNumber)
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBOutlet weak var notifications: UISwitch!
    @IBAction func notificationsSlider(_ sender: Any) {
        currentUser.notifications = notifications.isOn
        userLogic.saveCurrentUser()
    }
    
    @IBOutlet weak var soundEffects: UISwitch!
    @IBAction func soundEffectsSlider(_ sender: Any) {
        currentUser.soundEffects = soundEffects.isOn
        userLogic.saveCurrentUser()
    }
    
    @IBAction func logoutOfApp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            } else {
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                } else {
                    self.displayErrorMessage(message: "error logging out")
                }
                
            }
        }
    }
    
    func loadLoginScreen() {
        //        let vc: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        //
        
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
    func initData() {
        if let featuredImage = currentUser.image {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let profileImageData = imageData {
                    self.settingsImageView.image = UIImage(data: profileImageData)
                }
            })
        }
        settingsImageView.layer.cornerRadius = 22
        
        nameTextField.text = currentUser.username
        //passwordTextField.text = userLogic.password
        emailTextField.text = currentUser.email
        phoneTextField.text = currentUser.phoneNumber
        
        notifications.isOn = currentUser.notifications ?? true
        soundEffects.isOn = currentUser.soundEffects ?? true
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        initData()
    }
    
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
}
