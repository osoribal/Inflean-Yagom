//
//  ViewController.swift
//  DISCTest
//
//  Created by yagom
//  Copyright © 2017년 yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    // MARK: IBOutlets
    @IBOutlet var nameField: UITextField!
    
    // MARK: - Methods
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.nameField.text = nil
    }

    // MARK: IBActions
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        
        guard let name: String = self.nameField.text,
            name.isEmpty == false else {
                let alert: UIAlertController
                alert = UIAlertController(title: "알림", message: "이름을 입력해주세요", preferredStyle: .alert)
                
                let okAction: UIAlertAction
                okAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        UserInfo.shared.name = self.nameField.text
        
        self.performSegue(withIdentifier: "PresentTest", sender: nil)
    }
    
}

