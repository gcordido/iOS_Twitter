//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Gustavo Cordido on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName_Label: UILabel!
    @IBOutlet weak var tweet_Content: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBAction func likeTweet(_ sender: Any) {
        let possibleLike = !liked
        if (possibleLike){
            TwitterAPICaller.client?.likeTweet(tweetID: tweetId, success: {self.setLiked(true)}, failure: {(error) in
                print("Like did not succeed: \(error)")})
        } else {
            TwitterAPICaller.client?.dislikeTweet(tweetID: tweetId, success: {self.setLiked(false)}, failure: {(error) in
                print("Dislike not possible: \(error)")
            })
        }
    }
    
    @IBAction func reTweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetID: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error in retweeting \(error)")
        })
    }
    
    var liked:Bool = false
    var tweetId: Int = -1

    func setRetweeted(_ isRT:Bool){
        if (isRT){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    func setLiked(_ isLiked:Bool){
        liked = isLiked
        if (liked) {
            likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else{
            likeButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
