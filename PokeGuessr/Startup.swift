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
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "startupToHome", sender: self)
        }
    }
    @IBAction func ButtonClicked(_ sender: UIButton!) {
        if(sender.tag == 0) {
            //self.performSegue(withIdentifier: "startToLogin", sender: self)
        } else {
            //self.performSegue(withIdentifier: "startToSignup", sender: self)
        }
    }
}
