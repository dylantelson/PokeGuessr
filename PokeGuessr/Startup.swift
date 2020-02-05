//
//  Startup.swift
//  PokeGuessr
//
//  Created by Dylan Telson on 11/5/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class Startup: UIViewController {
    
    @IBOutlet var loginButton : UIButton!
    @IBOutlet var signUpButton : UIButton!
    @IBOutlet weak var anonLoginButton: UIButton!
    @IBOutlet weak var PokeGuessrImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        PokeGuessrImage.frame.origin.y = 142
        PokeGuessrImage.center.x = self.view.center.x
        loginButton.frame.origin.y = self.view.center.y - 100
        loginButton.center.x = self.view.center.x
        signUpButton.frame.origin.y = loginButton.frame.origin.y + 98
        signUpButton.center.x = self.view.center.x
        anonLoginButton.frame.origin.y = signUpButton.frame.origin.y + 98
        anonLoginButton.center.x = self.view.center.x
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "startupToHome", sender: self)
        }
//        self.loginButton.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
//        self.loginButton.layer.cornerRadius = self.loginButton.frame.height/3
//        self.loginButton.layer.shadowColor = UIColor.darkGray.cgColor
//        self.loginButton.layer.shadowRadius = 1
//        self.loginButton.layer.shadowOpacity = 0.5
//        self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//        
//        self.signUpButton.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
//        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height/3
//        self.signUpButton.layer.shadowColor = UIColor.darkGray.cgColor
//        self.signUpButton.layer.shadowRadius = 1
//        self.signUpButton.layer.shadowOpacity = 0.5
//        self.signUpButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    @IBAction func ButtonClicked(_ sender: UIButton!) {
        //if button clicked is Anonymous Login
        if(sender.tag == 2) {
            Auth.auth().signInAnonymously { (user, error) in
                if error == nil {
                    let ref = Database.database().reference()
                    ref.child("users").child((user?.user.uid)!).setValue(["name": (user?.user.uid)!, "score": 0])
                    UserDefaults.standard.set(0, forKey: "UserScore")
                    self.performSegue(withIdentifier: "startupToHome", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)

                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
