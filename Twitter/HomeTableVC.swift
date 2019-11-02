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

    }
    
    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        UserDefaults.standard.set(false, forKey: "Logged_In")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet_Cell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userName_Label.text = user["name"] as? String
        cell.tweet_Content.text  = tweetArray[indexPath.row]["text"] as? String
        
        let img_url = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: img_url!)
        
        if let imageData = data{
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        return cell
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
