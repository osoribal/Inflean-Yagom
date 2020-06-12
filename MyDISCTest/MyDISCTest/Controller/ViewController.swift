//
//  ViewController.swift
//  MyDISCTest
//
//  Created by KDY on 2020/05/08.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    // MARK: IBOutlet
    @IBOutlet weak var nameField: UITextField!
    
    // MARK: - Methods
    // MARK: IBAction
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        guard let name: String = self.nameField.text, name.isEmpty == false else {
            let alert: UIAlertController
            alert = UIAlertController(title: "알림", message: "이름을 입력해주세요", preferredStyle: .alert)
            
            let okAction: UIAlertAction
            okAction = UIAlertAction(title: "확인", style: .cancel){ (action: UIAlertAction) in self.nameField?.becomeFirstResponder()
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        UserInfo.shared.name = self.nameField.text
        
        self.performSegue(withIdentifier: "PresentTest", sender: nil)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        
        guard let userName = userDefaults.object(forKey: "userName") as! String? else {
            self.nameField.text = nil
            return
        }
        
        self.nameField.text = userName
    }
}

