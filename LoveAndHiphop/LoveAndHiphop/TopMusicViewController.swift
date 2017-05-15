//
//  TopMusicViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/25/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class TopMusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var musicObjects: [MusicObject]?
    var playItem: AVPlayerItem?
    var quePlayer: AVQueuePlayer = AVQueuePlayer()
    var presentSongId: String?
    
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var audioPlayerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentUserObjectId: String?
    var currentUserFullName: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayerView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        let query = PFQuery(className: "topMusic")
        query.order(byAscending: "top_song_order")
        query.findObjectsInBackground { (musicObjects: [PFObject]?, error: Error?) in
            if error == nil {
                let musicObjects2 = MusicObject.musicObjectWithArray(pfObjects: musicObjects!)
                self.musicObjects = musicObjects2
                self.tableView.reloadData()
            }
        }
        
        self.tableView.tableFooterView = UIView()
        
        self.currentUserObjectId = (PFUser.current()?.objectId)!
        
        
        let query2: PFQuery = PFUser.query()!
        query2.whereKey("objectId", equalTo: currentUserObjectId! )
        
        query2.getFirstObjectInBackground { (currentUser: PFObject?, error: Error?) in
            if error == nil {
                let currentUser: UserObject = UserObject.currentUser(pfObject: currentUser!)
                self.currentUserFullName = currentUser.fullName
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:  #selector(finishedPlaying(myNotification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playItem)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.musicObjects != nil {
            return (self.musicObjects?.count)!
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.musicObject = musicObjects?[indexPath.row]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let songUrl: URL = (musicObjects?[indexPath.row].songUrl)!
        playSong(url: songUrl)
        songNameLabel.text = musicObjects?[indexPath.row].songName
        presentSongId = musicObjects?[indexPath.row].songId
        increasePlayedCountForUser()
        audioPlayerView.isHidden = false
        
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    @IBAction func onTapPlayButton(_ sender: UIButton) {
        if self.quePlayer.rate == 0
        {
            self.quePlayer.play()
            playButton.setImage(UIImage(named: "Pause Filled-50"), for: UIControlState.normal)
        } else {
            self.quePlayer.pause()
            playButton.setImage(UIImage(named: "Play Filled-50"), for: UIControlState.normal)
        }
    }
    
    func playSong(url: URL) {
        
        self.playItem = AVPlayerItem(url: url)
        self.quePlayer.replaceCurrentItem(with: self.playItem)
        let playerLayer=AVPlayerLayer(player: quePlayer)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 10, height: 20)
        self.view.layer.addSublayer(playerLayer)
        
        
        self.quePlayer.play()
        
        playButton.setImage(UIImage(named: "Pause Filled-50"), for: UIControlState.normal)
        
        
        
        
    }
    
    func finishedPlaying(myNotification: Notification) {
        print("it reached end")
        playButton.setImage(UIImage(named: "Play Filled-50"), for: UIControlState.normal
        )
        
        //increasePlayedCountForUser()
        
        
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: kCMTimeZero)
        
    }
    
    func increasePlayedCountForUser() {
        print("i got the call")
        
        let query = PFQuery(className: "topListeners")
        query.whereKey("userId", equalTo: "admin")
        query.whereKey("listener_userid", equalTo: self.currentUserObjectId!)
        query.whereKey("listener_name", equalTo: self.currentUserFullName!)
        query.whereKey("song_id", equalTo: self.presentSongId!)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if((objects?.count)! > 0 ){
                    for object in objects! {
                        print("calling Parse to incremenet the value")
                        object.incrementKey("played_count")
                        object.saveInBackground(block: { (success: Bool, error: Error?) in
                            if(success){
                                print("count increased successfully")
                            }
                        })
                    }   
                }
                else if (objects?.count == 0) {
                let listenerObject = PFObject(className:"topListeners")
                    listenerObject["userId"] = "admin"
                    listenerObject["listener_userid"] = self.currentUserObjectId!
                    listenerObject["listener_name"] = self.currentUserFullName!
                    listenerObject["song_id"] = self.presentSongId!
                    listenerObject["played_count"] = 1
                    listenerObject.saveInBackground()
                    print("This is the first time user listening to this song")
                    
                }
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath: IndexPath!
        
        let topListenerButton = sender as! UIButton
        
        if let superview = topListenerButton.superview {
            if let cell = superview.superview as? SongCell {
                indexPath = tableView.indexPath(for: cell)
            }
        }
        
        
        
        print(indexPath.row)
        
        let musicObject = self.musicObjects?[indexPath!.row]
        
        let TopListenerViewController = segue.destination as! TopListenerViewController
        TopListenerViewController.musicObject = musicObject
        
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
