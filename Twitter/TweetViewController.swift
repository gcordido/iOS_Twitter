//
//  TweetViewController.swift
//  Twitter
//
//  Created by Gustavo Cordido on 11/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func sendTweet(_ sender: Any) {
        if(!tweetField.text.isEmpty){
            TwitterAPICaller.client?.postTweet(tweetString: tweetField.text, success:{
                self.dismiss(animated:true, completion: nil)
                
            }, failure: { (error) in
                print("Error posting tweet \(error)")
            })
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
