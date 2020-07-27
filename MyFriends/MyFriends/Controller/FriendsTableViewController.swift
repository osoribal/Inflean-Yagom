//
//  FriendsTableViewController.swift
//  MyFriends
//
//  Created by KDY on 2020/06/21.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    // MARK: - Properties
    // MARK: Privates
    
    //private var friends: [Person] = []
    private var friends = [[Person]](repeating: [Person](), count: 2)         // 0 : womans, 1 : mans
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.backgroundColor = UIColor.lightGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib: UINib = UINib.init(nibName: "FriendTableViewCell", bundle: nil)
        
        self.tableView.register(cellNib, forCellReuseIdentifier: "friendCell")
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.requestFriends), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.blue
        
        self.tableView.refreshControl = refreshControl
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.friends[0].isEmpty || self.friends[1].isEmpty {
            self.requestFriends()
        } else {
            // section 수만큼 reload 하지 않으면 오류!!
            self.tableView.reloadSections(IndexSet(0...1), with: UITableView.RowAnimation.none)
        }
        
    }

    // MARK: - Table view data source
    // 5. 성별 섹션 만들기
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.friends.count
        //return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends[section].count
        //return self.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell

        cell.delegate = self
        
        let friend: Person = self.friends[indexPath.section][indexPath.row]
        //let friend: Person = self.friends[indexPath.row]

        cell.configure(friend: friend, tableView: tableView, indexPath: indexPath)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Woman"
        } else if section == 1 {
            return "Man"
        } else {
            return ""
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ShowFriendInfo" else { return }
        
        guard let cell: FriendTableViewCell = sender as? FriendTableViewCell else {
            return
        }
        
        guard let index: IndexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        
        //guard index.row < self.friends.count else { return }
        
        guard let friendViewController: FriendViewController = segue.destination as? FriendViewController else {
            return
        }
        
        let friend: Person = self.friends[index.section][index.row]
        friendViewController.friend = friend
        friendViewController.thumbnailImage = cell.profileImageView.image
    }
    

}

// MARK: - Friend Table View Cell Delegate
extension FriendsTableViewController: FriendTableViewCellDelegate {
    func friendCellStarredStateChanged(_ sender: FriendTableViewCell) {
        guard let index: IndexPath = self.tableView.indexPath(for: sender) else {
            return
        }
        
        //guard index.row < self.friends.count else { return }
        
        let friend: Person = self.friends[index.section][index.row]
        
        if sender.starButton.isSelected {
            Person.addBestFriend(friend) { (isSuccess: Bool) in
                assert(isSuccess)
            }
        } else {
            Person.removeBestFriend(friend) { (isSuccess: Bool) in
                assert(isSuccess)
            }
        }
    }
}

// MARK: - Table view delegate
extension FriendsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "ShowFriendInfo", sender: cell)
        }
    }
}

// MARK: - Activity Indicator
extension FriendsTableViewController {
    private func showActivityIndicator() {
        self.view.addSubview(self.indicator)
        
        let safeAreaLayoutGuide: UILayoutGuide = self.view.safeAreaLayoutGuide
        
        self.indicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.indicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        indicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
    }
}

// MARK: - Request
extension FriendsTableViewController {
    @objc private func requestFriends() {
        if let isRefreshing: Bool = self.tableView.refreshControl?.isRefreshing, isRefreshing == false {
            self.showActivityIndicator()
        }
        
        Request.friends{(friends: [Person]?) in
            if let friends = friends {
                /*self.friends = friends
                
                // 4. 친구목록을 이름 내림차순으로 자동정렬
                self.friends.sort(by: {($0.name.last == $1.name.last) ? ($0.name.first < $1.name.first) : ($0.name.last < $1.name.last)})
                */
                
                // 5. 성별 섹션 만들기
                var mans: [Person] = []
                var womans: [Person] = []
                
                for person in friends {
                    switch(person.name.title.uppercased()) {
                    case "MR":
                        mans.append(person)
                    case "MONSIEUR":
                        mans.append(person)
                    case "MRS":
                        womans.append(person)
                    case "MISS":
                        womans.append(person)
                    case "MADEMOISELLE":
                        womans.append(person)
                    default:
                        assert(true, "Unkwon type : " + person.name.title)
                    }
                }
                
                self.friends[0] = womans
                self.friends[1] = mans
                
                // 4. 친구목록을 이름 내림차순으로 자동정렬
                self.friends[0].sort(by: {($0.name.last == $1.name.last) ? ($0.name.first < $1.name.first) : ($0.name.last < $1.name.last)})
                self.friends[1].sort(by: {($0.name.last == $1.name.last) ? ($0.name.first < $1.name.first) : ($0.name.last < $1.name.last)})
                
                //print("Frieneds list : \(friends.description)")
                
                // section 수만큼 reload 하지 않으면 오류!!
                self.tableView.reloadSections(IndexSet(0...1), with: UITableView.RowAnimation.automatic)
            }
            
            if let refreshControl: UIRefreshControl = self.tableView.refreshControl, refreshControl.isRefreshing == true {
                refreshControl.endRefreshing()
            } else {
                self.hideActivityIndicator()
            }
        }
    }
}
