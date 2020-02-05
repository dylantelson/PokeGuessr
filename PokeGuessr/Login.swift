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
    
    @IBOutlet weak var PokeGuessrImage: UIImageView!
    @IBOutlet var loginButton : UIButton!
    //Learned how to use Firebase from the following article: https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.layer.cornerRadius = 5
        pass.layer.cornerRadius = 5
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: self.email.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: self.pass.frame.height))


        email.leftView = paddingView
        email.leftViewMode = UITextField.ViewMode.always
        pass.leftView = paddingView2
        pass.leftViewMode = UITextField.ViewMode.always
        
        PokeGuessrImage.frame.origin.y = 142
        PokeGuessrImage.center.x = self.view.center.x
        loginButton.frame.origin.y = UIScreen.main.bounds.height - 250
        loginButton.center.x = self.view.center.x
        email.frame.origin.y = self.view.center.y - 75
        pass.frame.origin.y = email.frame.origin.y + 75
        //pass.frame.origin.y = loginButton.frame.origin.y - 106
        pass.center.x = self.view.center.x
        //email.frame.origin.y = pass.frame.origin.y - 80
        email.center.x = self.view.center.x
    }
    
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
