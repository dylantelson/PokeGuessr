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
import FirebaseDatabase

class SignUp: UIViewController {
    @IBOutlet weak var email : UITextField!
    @IBOutlet var pass : UITextField!
    @IBOutlet var confirmpass : UITextField!
    
    @IBOutlet var name : UITextField!
    @IBOutlet weak var PokeGuessrImage: UIImageView!
    
    @IBOutlet var signUpButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PokeGuessrImage.frame.origin.y = 142
        PokeGuessrImage.center.x = self.view.center.x
        signUpButton.frame.origin.y = UIScreen.main.bounds.height - 170
        signUpButton.center.x = self.view.center.x
        confirmpass.frame.origin.y = signUpButton.frame.origin.y - 75
        confirmpass.center.x = self.view.center.x
        pass.frame.origin.y = confirmpass.frame.origin.y - 55
        pass.center.x = self.view.center.x
        name.frame.origin.y = pass.frame.origin.y - 55
        name.center.x = self.view.center.x
        email.frame.origin.y = name.frame.origin.y - 55
        email.center.x = self.view.center.x
    }
//    override func viewDidLoad() {
//        self.signUpButton.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
//        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height/3
//        self.signUpButton.layer.shadowColor = UIColor.darkGray.cgColor
//        self.signUpButton.layer.shadowRadius = 1
//        self.signUpButton.layer.shadowOpacity = 0.5
//        self.signUpButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//    }
    
    @IBAction func SignupClicked(_ sender: UIButton!) {
        if(pass.text != confirmpass.text) {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else{
            Auth.auth().createUser(withEmail: email.text!, password: pass.text!){ (authData, error) in
                if error == nil {
                    let ref = Database.database().reference()
                    ref.child("users").child((authData?.user.uid)!).setValue(["name": self.name.text!, "score": 0])
                    UserDefaults.standard.set(0, forKey: "UserScore")
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
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
