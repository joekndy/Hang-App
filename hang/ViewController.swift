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
                
        //adds logout item to left of navigation controller
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }

    @objc func handleLogout() {
        //presents login view
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

}

