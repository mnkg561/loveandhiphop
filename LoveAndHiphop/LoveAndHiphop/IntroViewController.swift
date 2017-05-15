//
//  IntroViewController.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 5/14/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import SwiftyGif
import AVFoundation


class IntroViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!

    
    var player: AVAudioPlayer = AVAudioPlayer()

    @IBOutlet weak var animatedImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

     
        let gifmanager = SwiftyGifManager(memoryLimit:40)
        let gif = UIImage(gifName: "hiphop_gif.gif")
        self.animatedImageView.setGifImage(gif, manager: gifmanager)
        
        
        do{
            let audioPath = Bundle.main.path(forResource: "Hip_Hop_Rap", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!) as URL )
           
        }
        catch {
            print("something happened")
        }
         player.play()

    }

    override func viewWillDisappear(_ animated: Bool) {
        player.stop()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapPauseButton(_ sender: UIButton) {
        
        if player.isPlaying == true {
            
            player.pause()
            
            playButton.setImage(UIImage(named: "Init_play"), for: UIControlState.normal)
            self.animatedImageView.stopAnimatingGif()

        } else {
            
            player.play()
            
            playButton.setImage(UIImage(named: "Init_Pause"), for: UIControlState.normal)
            self.animatedImageView.startAnimatingGif()
        }
        
    }

    
  

    
    @IBAction func onTapNextButton(_ sender: UIButton) {
        
       print("somebody tapped me")
        
    }
    
    
//       // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        let imagesViewController = segue.destination as! MembershipQuizTableViewController
//    }
  
}
