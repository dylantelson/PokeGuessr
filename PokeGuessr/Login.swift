//
//  Login.swift
//  PokeGuessr
//
//  Created by Dylan Telson on 11/5/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class Login: UIViewController {
    @IBOutlet var email : UITextField!
    @IBOutlet var pass : UITextField!
    //Learned how to use Firebase from the following article: https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
    
    @IBAction func loginClicked(_sender: UIButton!) {
        Auth.auth().signIn(withEmail: email.text!, password: pass.text!) { (user, error) in
            if error == nil{
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
