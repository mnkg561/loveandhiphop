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
        cell.userNameLabel.text = self.topListenerObjects?[indexPath.row].userId
        let playedCount = self.topListenerObjects?[indexPath.row].playedCount!
        cell.countLabel.text = String(describing: playedCount!)
        
        return cell
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
