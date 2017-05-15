//
//  TopListenerViewController.swift
//
//
//  Created by Mogulla, Naveen on 4/28/17.
//
//

import UIKit
import Parse

class TopListenerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var musicObject: MusicObject!
    var topListenerObjects: [TopListenerObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let query = PFQuery(className: "topListeners")
        query.whereKey("song_id", equalTo: musicObject.songId!)
        query.order(byDescending: "played_count")
        query.limit = 10
        query.findObjectsInBackground { (topListenerObjects: [PFObject]?, error: Error?) in
            if error == nil {
                let topListenerObjects2 = TopListenerObject.listenerObjectsWithArray(pfObjects: topListenerObjects!)
                self.topListenerObjects = topListenerObjects2
                self.tableView.reloadData()
                
            }
        }
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.topListenerObjects != nil {
            return (self.topListenerObjects?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListenerCell", for: indexPath) as! TopListenerCell
        //print(self.topListenerObjects?[indexPath.row])
        cell.userNameLabel.text = self.topListenerObjects?[indexPath.row].listenerName
        let playedCount = self.topListenerObjects?[indexPath.row].playedCount!
        cell.countLabel.text = String(describing: playedCount!)
        loadListener(userObjectId: (self.topListenerObjects?[indexPath.row].listenerUserId)!, success: { (userObject: UserObject) in
           cell.userObject = userObject
        }) { 
            print("something happened")
        }
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapUserName(tapGesture:)))
//        cell.userNameLabel.isUserInteractionEnabled = true
//        cell.userNameLabel.addGestureRecognizer(tapGesture)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    
    
    func onTapUserName(tapGesture: UITapGestureRecognizer){
        print("i'm tapped")
        let tapLocation = tapGesture.location(in: self.tableView)
        let indexPath =  self.tableView.indexPathForRow(at: tapLocation)
        
        let topListenerObject: TopListenerObject = (self.topListenerObjects?[indexPath!.row])!
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        print("i'm after destination")
        let query: PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: topListenerObject.listenerUserId!)
        print(" user id \(topListenerObject.listenerUserId!)")

        query.getFirstObjectInBackground { (targetUser: PFObject?, error: Error?) in
            if error == nil {
                print("i got something")
                let targetUser: UserObject = UserObject.currentUser(pfObject: targetUser!)
                print("i think so")
                
                detailViewController.userObject = targetUser
                self.present(detailViewController, animated:true, completion:nil)
            }
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let vc = segue.destination as! MatchDetailedViewController
        //        let indexPath = self.tableView.indexPath(for: sender as! MatchCell)
        //        let user = profileMatches?[(indexPath?.row)!]
        //        vc.user = user
        //        vc.likedByUsers = self.likedByUsersDict[(user?.objectId!)!]
        //        vc.delegate = self
        
        print(" Yea me too")
       
        let topListenerCell = sender as! TopListenerCell
        let userObject: UserObject = topListenerCell.userObject!
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.userObject = userObject
        
        
      

        
        
    }
    
    func loadListener(userObjectId: String, success: @escaping (UserObject) -> (), failure: @escaping () -> ()){
        //let topListenerObject: TopListenerObject = (self.topListenerObjects?[indexPath.row])!
        let query: PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: userObjectId)
        
        query.getFirstObjectInBackground { (targetUser: PFObject?, error: Error?) in
            if error == nil {
                print("i got something")
                let targetUser: UserObject = UserObject.currentUser(pfObject: targetUser!)
                print("i think so")
                success(targetUser)
                print("i'm fully exected")
            } else {
                print("error")
            }
            
        }

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
