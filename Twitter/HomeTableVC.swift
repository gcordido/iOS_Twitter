//
//  HomeTableVC.swift
//  Twitter
//
//  Created by Gustavo Cordido on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableVC: UITableViewController {

    var tweetArray = [NSDictionary]()
    var tweetNum: Int!
    
    let refresh_control = UIRefreshControl()
    
    
    @objc func loadTweets(){
        
        let my_url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let my_params = ["count": 20]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: my_url, parameters: my_params, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.refresh_control.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets.")
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        refresh_control.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = refresh_control
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        UserDefaults.standard.set(false, forKey: "Logged_In")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet_Cell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.timeLabel.text = getRelativeTime(timeString: (tweetArray[indexPath.row]["created_at"] as? String)!)
        
        cell.userName_Label.text = user["name"] as? String
        cell.tweet_Content.text  = tweetArray[indexPath.row]["text"] as? String
        
        let img_url = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: img_url!)
        
        if let imageData = data{
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        cell.setLiked(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)

        
        return cell
    }
    
    func getRelativeTime(timeString: String) -> String {
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
}

    extension Date {
        func timeAgoDisplay() -> String {
            let secondsAgo = Int(Date().timeIntervalSince(self))
            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week = 7 * day
            if secondsAgo < minute {
                return "\(secondsAgo) seconds ago"
            }
            else if secondsAgo < hour {
                return "\(secondsAgo / minute) minutes ago"
        
            }else if secondsAgo < day {
                return "\(secondsAgo / hour) days ago"
        
            } else if secondsAgo < week {
                return "\(secondsAgo / day) days ago"
            }
    
            return "\(secondsAgo / week) weeks ago"
        }
    }
