//
//  ViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/15/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ref = Database.database().reference(fromURL: "https://hang-8b734.firebaseio.com/")
//
//        ref.updateChildValues(["someValue": 123123])
        
        //adds logout item to left of navigation controller
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }

    @objc func handleLogout() {
        //presents login view
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

}

