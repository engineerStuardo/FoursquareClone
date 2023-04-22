//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 16/4/23.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        if username.text != "", password.text != "" {
            let user = PFUser()
            user.username = username.text!
            user.password = password.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    AlertModel.shared.alert(title: "Error", message: error?.localizedDescription ?? "Error", view: self)
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            AlertModel.shared.alert(title: "Empty inputs", message: "Please complete username and password", view: self)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        if username.text != "", password.text != nil {
            PFUser.logInWithUsername(inBackground: username.text!, password: password.text!) { user, error in
                if error != nil {
                    AlertModel.shared.alert(title: "Error", message: error?.localizedDescription ?? "Error", view: self)
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            AlertModel.shared.alert(title: "Empty inputs", message: "Please complete username and password", view: self)
        }
    }
}

