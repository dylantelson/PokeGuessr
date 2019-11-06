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
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UIViewController
            self.present(home, animated: true, completion: nil)
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
