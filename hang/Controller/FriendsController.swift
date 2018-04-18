//
//  ViewController.swift
//  hang
//
//  Created by Joe Kennedy on 4/15/18.
//  Copyright © 2018 Joe Kennedy. All rights reserved.
//

import UIKit
import Firebase

class
FriendsController: UITableViewController {
    
    let cellid = "cellid"
    var users = [Users]()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        //adds logout item to left of navigation controller
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"logout", style: .plain, target: self, action: #selector(handleLogout))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        fetchUser()
    }
    
    func fetchUser() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = Users()
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    user.name = name
                    user.email = email
                    self.users.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //hack for now
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    class UserCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkIfUserIsLogeedIn()
    }
    
    func checkIfUserIsLogeedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]  {
                    
                    self.navigationItem.title = dictionary["name"] as? String

                }
                
            }, withCancel: nil)
        }
        
    }

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        //presents login view
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
        perform(#selector(removeNavigationText), with: nil, afterDelay: 1)

    }
    
    @objc func removeNavigationText() {
        self.navigationItem.title = " "
    }

}

