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
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "startupToHome", sender: self)
        }
        self.loginButton.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
        self.loginButton.layer.cornerRadius = self.loginButton.frame.height/3
        self.loginButton.layer.shadowColor = UIColor.darkGray.cgColor
        self.loginButton.layer.shadowRadius = 1
        self.loginButton.layer.shadowOpacity = 0.5
        self.loginButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.signUpButton.backgroundColor = UIColor(red: 0.9317, green: 0.9317, blue: 0.9317, alpha: 1)
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height/3
        self.signUpButton.layer.shadowColor = UIColor.darkGray.cgColor
        self.signUpButton.layer.shadowRadius = 1
        self.signUpButton.layer.shadowOpacity = 0.5
        self.signUpButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    @IBAction func ButtonClicked(_ sender: UIButton!) {
        if(sender.tag == 0) {
            //self.performSegue(withIdentifier: "startToLogin", sender: self)
        } else {
            //self.performSegue(withIdentifier: "startToSignup", sender: self)
        }
    }
}
