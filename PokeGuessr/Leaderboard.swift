//
//  Leaderboard.swift
//  PokeGuessr
//
//  Created by Dylan Telson on 11/21/19.
//  Copyright © 2019 Dylan Telson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Scores {
    var name = ""
    var score = 0
    init(userName: String, userScore: Int) {
        self.name = userName
        self.score = userScore
    }
}

class myCell: UITableViewCell {
    
    // Define label, textField etc
    var aMap: UILabel!
    var aVal : UILabel!
    
    // Setup your objects
    func setUpCell() {
        aMap = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 50))
        aMap.textAlignment = .left
        self.contentView.addSubview(aMap)
        
        aVal = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 208, y: 0, width: 200, height: 50))
        aVal.textAlignment = .right
        self.contentView.addSubview(aVal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

class Leaderboard: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var PokeGuessrImage: UIImageView!
    @IBOutlet weak var LeaderboardText: UILabel!
    
    @IBOutlet var myTableView : UITableView!
    var scoresArray = [Scores]()
    
    override func viewDidLoad() {
        //learned how to use DispatchGroups from https://stackoverflow.com/questions/42484281/waiting-until-the-task-finishes
        let group = DispatchGroup()
        group.enter()
        
        let ref = Database.database().reference()
        let postsRef = ref.child("users")
        //learned how to sort and access data from Firebase database from https://stackoverflow.com/questions/53572518/accessing-the-top-scores-from-a-firebase-database-query-using-swift
        let query = postsRef.queryOrdered(byChild: "score").queryLimited(toLast: 20)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            query.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    let name = dict["name"] as! String
                    let score = dict["score"] as! Int
                    let aScore = Scores(userName: name, userScore: score)
                    self.scoresArray.insert(aScore, at: 0)
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            super.viewDidLoad()
            self.PokeGuessrImage.frame.origin.y = 40
            self.LeaderboardText.frame.origin.y = self.PokeGuessrImage.frame.origin.y + 65
            self.myTableView.dataSource = self
            self.myTableView.delegate = self
            self.myTableView.reloadData()
            self.myTableView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.myTableView.frame.origin.y)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:myCell? = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? myCell
        
        //if cell == nil {
            cell = myCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        //}
        let cellName = scoresArray[indexPath.row].name
        let cellValue = scoresArray[indexPath.row].score
        cell?.setUpCell()
        cell!.aMap.text = cellName
        cell!.aVal.text = String(cellValue)
        if(cellName == UserDefaults.standard.string(forKey: "UserName")) {
            cell!.aMap.textColor = UIColor.blue
            cell!.aVal.textColor = UIColor.blue
        }
        return cell!
        //var sortedDict = (Array(data).sorted {$0.1 > $1.1})
//        let cellName = sortedDict[indexPath.row].0
//        let cellValue = sortedDict[indexPath.row].1
//        cell?.setUpCell()
//        cell!.aMap.text = cellName
//        cell!.aVal.text = String(cellValue)
//        if(cellName == "You") {
//            cell!.aMap.textColor = UIColor.blue
//            cell!.aVal.textColor = UIColor.blue
//        }
//        return cell!
    }
}
