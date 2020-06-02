//
//  LoginViewController.swift
//  iosProject
//
//  Created by Patunique on 22.01.2020.
//  Copyright © 2020 Patunique. All rights reserved.
//

import UIKit
import Parse
import CoreData

var container: NSPersistentContainer!

class LoginViewController: UIViewController {
    @IBOutlet fileprivate var loginTextField: UITextField!
    @IBOutlet fileprivate var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var socialNetworkLogin: UILabel!
    @IBOutlet weak var loginButton: FancyButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    
    @IBAction func signIn(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        var email = ""
        
        if !(loginTextField.text?.contains("@") ?? true) {
            let query = PFUser.query()
            do {
                let users = try query?.findObjects()
                if users == nil {
                    return
                }
                
                for user in users! {
                    if user["phoneNumber"] as? String == loginTextField.text {
                        
                    }
                }
            } catch {
                
            }
        }
        
        
        PFUser.logInWithUsername(inBackground: loginTextField.text!, password: passwordTextField.text!) { (user, error) in
            UIViewController.removeSpinner(spinner: sv)
            
            if user != nil {
                user?["emailVerified"] = true
                user?.saveInBackground() {
                    (success: Bool, error: Error?) in
                    if (success) {
                      // The object has been saved.
                    } else {
                        print(error)
                    }
                }
                
                currentUser = userLogic.initializeUser(user!)
                self.loadHomeScreen()
            } else {
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        emailLabel.addCharacterSpacing(kernValue: 1)
        passwordLabel.addCharacterSpacing(kernValue: 1)
        socialNetworkLogin.addCharacterSpacing(kernValue: 1)
        loginButton.titleLabel?.addCharacterSpacing(kernValue: 1)
        forgotPasswordButton.titleLabel?.addCharacterSpacing(kernValue: 1)
        registrationButton.titleLabel?.addCharacterSpacing(kernValue: 1)
        
        loginTextField.text = ""
        loginTextField.delegate = self
        
        passwordTextField.text = ""
        passwordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        if (PFUser.current() != nil) {
            currentUser = userLogic.initializeUser(PFUser.current()!)
        } else {
            loadIntro()
        }
    }
    
    var window: UIWindow?
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func loadHomeScreen() {
        let vc: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "TableViewController") 
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func loadIntro() {
                let vc: IntroViewController = self.storyboard!.instantiateViewController(withIdentifier: "IntroView") as! IntroViewController
        
                navigationController?.present(vc, animated: true)
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
        let currentUser = PFUser.current()
        if currentUser != nil && (currentUser?["emailVerified"] != nil) {
            loadHomeScreen()
        }
        
        if segueLogin == true {
            loadHomeScreen()
        }
        
        super.viewWillAppear(animated)
    }
    
    let permissions = ["public_profile"]
    var segueLogin : Bool = false
    
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        //NOT_IMPLEMENTED_YET
    }
    
    
    @IBAction func loginWithTwitter(_ sender: Any) {
        //NOT_IMPLEMENTED_YET
    }
    
    @IBAction func loginWithVK(_ sender: Any) {
        //NOT_IMPLEMENTED_YET
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
