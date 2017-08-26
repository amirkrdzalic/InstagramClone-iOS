/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func singupOrLogin(_ sender: Any) {
        
        if emailTextField.text == "" || passwordTextField.text == ""
        {
            createAlert(title: "Error in form", message: "Please enter an email and password")
        }
        else
        {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode {
                //Sign up Mode
                
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        var displayErrorMsg = "Please try again later."
                        
                        if let errorMsg = (error! as NSError).userInfo["error"] as? String{
                            displayErrorMsg = errorMsg
                        }
                        
                        self.createAlert(title: "Sign up error", message: displayErrorMsg)
                        
                    } else {
                        
                        print("User signed up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
            } else {
                //Log in Mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMsg = "Please try again later."
                        
                        if let errorMsg = (error! as NSError).userInfo["error"] as? String{
                            
                            displayErrorMsg = errorMsg
                        }
                        self.createAlert(title: "Log-in error", message: displayErrorMsg)
                    } else {
                        
                        print ("Log in")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                })
            }
        }
        
    }
    
    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBAction func changeSignupMode(_ sender: Any) {
        if signupMode {
            //change to log in
            
            signupOrLogin.setTitle("Log In", for: [])
            changeSignupMode.setTitle("Sign Up", for: [])
            msgLabel.text = "Dont have an account?"
            
            signupMode = false
            
        } else {
            //change to sign up mode
            
            signupOrLogin.setTitle("Sign Up", for: [])
            changeSignupMode.setTitle("Log In", for: [])
            msgLabel.text = "Already have an acount?"
            
            signupMode = true
        }
    }
    
    @IBOutlet weak var changeSignupMode: UIButton!
    
    @IBOutlet weak var msgLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "showUserTable", sender: self)
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
