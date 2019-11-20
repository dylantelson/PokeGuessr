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
import FirebaseDatabase

class Home : UIViewController {
    
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = Auth.auth().currentUser!.email
        
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            UserDefaults.standard.set(value?["score"], forKey: "UserScore")
            UserDefaults.standard.set(value?["name"], forKey: "UserName")
            self.userLabel.text = value?["name"] as! String
            self.userLabel.sizeToFit()
            self.scoreLabel.text = "Score: " + String(UserDefaults.standard.integer(forKey: "UserScore"))
        })
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
