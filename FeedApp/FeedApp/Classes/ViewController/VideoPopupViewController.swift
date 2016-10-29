//
//  VideoPopupViewController.swift
//  FeedApp
//
//  Created by Malinka S on 9/25/16.
//  Copyright © 2016 Malinka S. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoPopupViewController: UIViewController {

    @IBOutlet var heartCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var shotCard :ShotCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        showAnimate()
        
    }
    
    func setShotCardDataAndPlayVideo(shotCard : ShotCard){
        let videoURL = NSURL(string: shotCard.playMp4)
        
        self.shotCard = shotCard
        print(shotCard.heartCount)
        
        heartCountLabel.text = String(format: "%@ Likes",shotCard.heartCount)
        
        let player = AVPlayer(URL: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        
        playerLayer.bounds = self.view.bounds
        playerLayer.frame = CGRectMake(50, 50, self.view.frame.width-100,     self.view.frame.height-100)
        
        self.view.layer.insertSublayer(playerLayer, atIndex : 0)
        player.play()

        
    }
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        removeAnimate()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        likeButton.hidden = false
    }
    
    func removeAnimate(){
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0
            }, completion: {(finished : Bool) in
                if(finished) {
                    self.view.removeFromSuperview()
                }
        })
    }
    

    @IBAction func likeButtonAction(sender: AnyObject) {

        let alert = UIAlertController(title: "Thank You", message: "Thanks for your vote", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                alert.removeFromParentViewController()
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        likeButton.hidden = true
        self.heartCountLabel.text = String(format: "%@ Likes", NSNumber(integer: (shotCard!.heartCount.integerValue + 1 )))
        
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
