//
//  Home.swift
//  PokeGuessr
//
//  Created by Dylan Telson on 11/6/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class Home : UIViewController {
    
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = Auth.auth().currentUser!.email
        userLabel.text = email
        userLabel.sizeToFit()
        
        if(UserDefaults.standard.integer(forKey: "UserScore") == nil) {
            UserDefaults.standard.set(0, forKey: "UserScore")
        }
        scoreLabel.text = "Score: " + String(UserDefaults.standard.integer(forKey: "UserScore"))
    }
    
    @IBAction func logout(sender: UIButton!) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let startup = storyboard!.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = startup
    }
}
