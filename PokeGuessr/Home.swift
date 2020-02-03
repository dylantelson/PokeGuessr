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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var PokeGuessrLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = UIScreen.main.bounds
        logoutButton.frame.origin.y = bounds.height - 90
        leaderboardButton.frame.origin.y = logoutButton.frame.origin.y - 175
        leaderboardButton.frame.origin.y = leaderboardButton.frame.origin.y - 50
        logoutButton.center.x = self.view.center.x
        leaderboardButton.center.x = self.view.center.x
        startButton.frame.origin.y = leaderboardButton.frame.origin.y - 90
        startButton.center.x = self.view.center.x
        
        scoreLabel.center.x = self.view.center.x
        scoreLabel.frame.origin.y = leaderboardButton.frame.origin.y + 80
        
        PokeGuessrLabel.center.x = self.view.center.x
        //PokeGuessrLabel.frame.origin.y = startButton.frame.origin.y - 156
        PokeGuessrLabel.frame.origin.y = 142
        //userLabel.frame.origin.x = bounds.width - 120

        //let email = Auth.auth().currentUser!.email
        //let isAnonymous = Auth.auth().currentUser!.isAnonymous
        
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
