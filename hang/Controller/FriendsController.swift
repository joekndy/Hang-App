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
    let sections = ["Available", "Unavailable"]
    var users = [Users]()
    var availableUsers = [String]()
    var unavailableUsers = [String]()
    var aUser = [Users]()
    var uUser = [Users]()

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
                    let key = child.key
                    let availability = value["available"] as? String ?? "Name not found"
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    user.name = name
                    user.email = email
                    user.availability = availability
                    self.users.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                    print(user.name, user.availability)
                    if(user.availability == "true"){
                        //self.availableUsers.append(key)
                        self.aUser.append(user)
                        print("got that");
                    }else{
                        //self.unavailableUsers.append(key)
                        self.uUser.append(user)

                    }
                    print("availableUsers --")
                    print(self.availableUsers)
                    print("unavailableUsers --")

                    print(self.unavailableUsers)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = self.sections[section]
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return aUser.count

        }
        return uUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //hack for now
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        let user = indexPath.section == 0 ? aUser[indexPath.row] : uUser[indexPath.row]
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

