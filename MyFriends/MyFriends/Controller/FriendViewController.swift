//
//  FriendViewController.swift
//  MyFriends
//
//  Created by KDY on 2020/06/21.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController {
    
    // MARK: - Properties
    var thumbnailImage: UIImage?
    
    // MARK: IBOutlets
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    
    
    // MARK: Stored Properties
    var friend: Person! {
        didSet {
            self.navigationItem.title = friend.name.first.uppercased()
            self.correctBarButtonState()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


// MARK: - Button States
extension FriendViewController {
    private func correctBarButtonState() {
        self.navigationItem.rightBarButtonItems = nil
        
        if Person.bestFriends.contains(self.friend) {
            self.starButton.image = UIImage(named: "button_star")
        } else {
            self.starButton.image = UIImage(named: "button_unstar")
        }
        
        self.navigationItem.rightBarButtonItems = [self.starButton]
    }
}

// MARK: - IBActions
extension FriendViewController {
    @IBAction func touchUpStarButton(_ sender: UIBarButtonItem) {
        if Person.bestFriends.contains(self.friend) {
            Person.removeBestFriend(self.friend) { (isSuccess: Bool) in
                if isSuccess {
                    self.correctBarButtonState()
                }
            }
        } else {
            Person.addBestFriend(self.friend) { (isSuccess: Bool) in
                if isSuccess {
                    self.correctBarButtonState()
                }
            }
        }
    }
}

// MARK: - Life Cycle
extension FriendViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let friend: Person = self.friend else {
            return
        }
        
        self.correctBarButtonState()
        
        self.nameLabel.text = friend.name.full
        self.cellLabel.text = friend.cell
        self.nationalityLabel.text = friend.nationality
        self.imageView.image = self.thumbnailImage ?? placeHolderImage
        
        Request.image(friend.pictureURL.large) { (image: UIImage?) in
            self.imageView?.image = image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if friend == nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
