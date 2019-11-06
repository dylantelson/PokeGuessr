//
//  SignUp.swift
//  PokeGuessr
//
//  Created by Dylan Telson on 11/5/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignUp: UIViewController {
    @IBOutlet weak var email : UITextField!
    @IBOutlet var pass : UITextField!
    @IBOutlet var confirmpass : UITextField!
    
    @IBAction func SignupClicked(_ sender: UIButton!) {
        if(pass.text != confirmpass.text) {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            Auth.auth().createUser(withEmail: email.text!, password: pass.text!){ (user, error) in
                if error == nil {
                    let languageSelect = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UIViewController
                    self.present(languageSelect, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
