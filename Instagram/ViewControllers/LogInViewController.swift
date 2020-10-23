//
//  LogInViewController.swift
//  Instagram
//
//  Created by Sanzida Sultana on 10/21/20.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
     @IBAction func userSignIn(_ sender: Any) {
       let username = userName.text!
       let passwords = password.text!
        
        PFUser.logInWithUsername(inBackground: username, password: passwords) {
            (user: PFUser?, Error) -> Void in
            if user != nil {
                // user credientails are correct and is a user for our app
                print("User logged in")
                self.performSegue(withIdentifier: "UserLoginSegue", sender: nil)
            } else {
                // Logging in failed
                print("Error: \(Error?.localizedDescription)")
            }
            
        }
     }
    

    @IBAction func userSignUp(_ sender: Any) {
        
        // what we are storing in our backend server, the user's username and password
        let user = PFUser()
        user.username = userName.text!
        user.password = password.text!
        
        
        user.signUpInBackground { (success, error) in
            if success {
                // user signed in successfullly
                self.performSegue(withIdentifier: "UserLoginSegue", sender: nil)
            }
            else {
                // can not log in
                print("Error: \(error?.localizedDescription)")
            }
            
        }
    }
}
