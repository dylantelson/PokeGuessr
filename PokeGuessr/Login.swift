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
    
    @IBOutlet var loginButton : UIButton!
    //Learned how to use Firebase from the following article: https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
    
//    override func viewDidLoad() {
//        self.loginButton.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
//        self.loginButton.layer.cornerRadius = self.loginButton.frame.height/3
//        self.loginButton.layer.shadowColor = UIColor.darkGray.cgColor
//        self.loginButton.layer.shadowRadius = 1
//        self.loginButton.layer.shadowOpacity = 0.5
//        self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//    }
    
    @IBAction func loginClicked(_sender: UIButton!) {
        Auth.auth().signIn(withEmail: email.text!, password: pass.text!) { (user, error) in
            if error == nil{
                self.performSegue(withIdentifier: "loginToHome", sender: self)
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
