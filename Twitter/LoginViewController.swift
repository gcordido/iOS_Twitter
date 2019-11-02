//
//  LoginViewController.swift
//  Twitter
//
//  Created by Gustavo Cordido on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "Logged_In") == true {
            
            self.performSegue(withIdentifier: "login_to_home", sender: self)
        }
    
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let my_Url = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: my_Url, success: {
            
            UserDefaults.standard.set(true, forKey: "Logged_In")
            self.performSegue(withIdentifier: "login_to_home", sender: self)
        }, failure: { (Error) in
            print("Could not log in!!")
        })
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
