//
//  InfoViewController.swift
//  MyLoginFlow
//
//  Created by 맥북 on 05/05/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - Properties
    var loginInfo: LoginInfo?

    // MARK: - Methods
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("InfoViewController 객체의 뷰가 메모리에 로드됨")
        
        print(self.loginInfo)
        
        self.navigationItem.title = "로그인 정보"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("InfoViewController 객체의 뷰가 나타날 예정")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard let info = self.loginInfo else {
            return
        }
        
        print(info)
        self.infoLabel.text = "Email : " + info.email + "\nPassword : " + info.password
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("InfoViewController 객체의 뷰가 나타남")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("InfoViewController 객체의 뷰가 사라질 예정")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("InforViewController 객체의 뷰가 사라짐")
    }

}
