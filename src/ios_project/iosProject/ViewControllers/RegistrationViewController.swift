//
//  RegistrationViewController.swift
//  iosProject
//
//  Created by Patunique on 22.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var registerButton: FancyButton!
    @IBOutlet weak var socialNetworkLabel: UILabel!
    
    
    @IBAction func signUp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let user = PFUser()
        user.username = nameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        //        user["image50x50"] = PFFileObject(
        //        user["image"] = UIImage(named: "anon")
        user["money"] = 0
        user["quests"] = []
        user["phoneNumber"] = " "
        user["notifications"] = true
        user["soundEffects"] = true
        user["score"] = 0
        user["subscriptions"] = []

        let subscribers = PFObject.init(className: "Subscribers")
        subscribers["array"] = []
        subscribers.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                
            } else {
                print(error)
            }
        }
        
        do {
            sleep(2)
        }
        print("AAAAA\(subscribers.objectId)")

        user["subscribersId"] = subscribers.objectId
        
        user.signUpInBackground { (success, error) in
            UIViewController.removeSpinner(spinner: sv)
            if success{
                currentUser = userLogic.initializeUser(user)
                //userLogic.saveCurrentUser()
                self.confirmEmailMessage()
                //self.loadHomeScreen()
            } else {
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
    }
    
    func confirmEmailMessage() {
        let alertView = UIAlertController(title: "Confirmation", message: "Confirm email and login!", preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            
            self.navigationController?.popViewController(animated: true)
            
            
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func loadHomeScreen() {
        let vc: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "TableViewController")
        
        navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.navigationBar.isHidden = true
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        emailLabel.addCharacterSpacing(kernValue: 1)
        usernameLabel.addCharacterSpacing(kernValue: 1)
        passwordLabel.addCharacterSpacing(kernValue: 1)
        registerButton.titleLabel?.addCharacterSpacing(kernValue: 1)
        socialNetworkLabel.addCharacterSpacing(kernValue: 1)
        
        nameTextField.text = ""
        nameTextField.delegate = self
        
        emailTextField.text = ""
        emailTextField.delegate = self
        
        passwordTextField.text = ""
        passwordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func popView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
