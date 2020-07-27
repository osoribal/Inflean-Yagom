//
//  BestFriendsTableViewController.swift
//  MyFriends
//
//  Created by KDY on 2020/06/21.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class BestFriendsTableViewController: UITableViewController {

    // MARK: - Properties
    // MARK: Privates
    
    private var friends: [Person] = Person.bestFriends
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let cellNib: UINib = UINib.init(nibName: "FriendTableViewCell", bundle: nil)
        
        self.tableView.register(cellNib, forCellReuseIdentifier: "friendCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.friends = Person.bestFriends
        self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.none)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendTableViewCell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell

        cell.delegate = self
        
        guard indexPath.row < self.friends.count else {
            return cell
        }
        
        let friend: Person = self.friends[indexPath.row]
        
        cell.configure(friend: friend, tableView: tableView, indexPath: indexPath)
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Person.removeBestFriend(self.friends[indexPath.row]) { (isSuccess: Bool) in
                if isSuccess {
                    self.friends = Person.bestFriends
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    
    // Override to support rearranging the table view.
    // 1. 절친 목록 테이블뷰의 셀 순서를 변경할 수 있도록 구현
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        Person.rearrangeBestFriend(fromIndexPath.row, to.row) { (isSuccess: Bool) in
            assert(isSuccess)
        }
        
        self.friends = Person.bestFriends

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
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
        
        guard index.row < self.friends.count else { return }
        
        guard let friendViewController: FriendViewController = segue.destination as? FriendViewController else {
            return
        }
        
        let friend: Person = self.friends[index.row]
        friendViewController.friend = friend
        friendViewController.thumbnailImage = cell.profileImageView.image
    }
    

}

// MARK: - Friend Table View Cell Delegate
extension BestFriendsTableViewController: FriendTableViewCellDelegate {
    func friendCellStarredStateChanged(_ sender: FriendTableViewCell) {
        guard let index: IndexPath = self.tableView.indexPath(for: sender) else {
            return
        }
        
        guard index.row < self.friends.count else { return }
        
        let friend: Person = self.friends[index.row]
        
        if sender.starButton.isSelected {
            Person.addBestFriend(friend) { (isSuccess: Bool) in
                assert(isSuccess)
            }
        } else {
            Person.removeBestFriend(friend) { (isSuccess: Bool) in
                assert(isSuccess)
            }
        }
        
        self.friends = Person.bestFriends
        self.tableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.none)
    }
}

// MARK: - Table view delegate
extension BestFriendsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "ShowFriendInfo", sender: cell)
        }
    }
}
