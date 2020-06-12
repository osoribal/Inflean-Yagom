//
//  LoginViewController.swift
//  MyLoginFlow
//
//  Created by 맥북 on 05/05/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwardField: UITextField!
    
    // MARK: - Methods
    // MARK: IBActions
    @IBAction func touchUpLoginAction(_ sender: UIButton) {
        guard let email: String = self.emailField.text, email.isEmpty == false else {
            self.showAlert(message: "이메일을 입력해주세요", control: self.emailField)
            return
        }
        
        guard let passward: String = self.passwardField.text, passward.isEmpty == false else {
            self.showAlert(message: "패스워드를 입력해주세요", control: self.passwardField)
            return
        }
        
        guard passward.count >= 4 else {
            self.showAlert(message: "패스워드를 4 자리 이상 입력해주세요", control: self.passwardField)
            return
        }
        
        self.performSegue(withIdentifier: "ShowInfo", sender: sender)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController 객체의 뷰가 메모리에 로드됨")
        self.navigationItem.title = "로그인"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LoginViewController 객체의 뷰가 나타날 예정")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LoginViewController 객체의 뷰가 나타남")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LoginViewController 객체의 뷰가 사라질 예정")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("LoginViewController 객체의 뷰가 사라짐")
    }

    
    // MARK: Privates
    private func showAlert(message: String, control toBeFirstResponder: UIControl?) {
        let alert: UIAlertController = UIAlertController(title: "알림",
                                                         message: message,
                                                         preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "입력하기",
                                                    style: UIAlertAction.Style.default) { [weak toBeFirstResponder] (action: UIAlertAction) in toBeFirstResponder?.becomeFirstResponder()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소",
                                                        style: UIAlertAction.Style.cancel,
                                                        handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {
            print("얼럿 화면에 보여짐")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let email:String = self.emailField.text,
            let passward:String = self.passwardField.text else {
                return
        }
        
        guard let id: String = segue.identifier else { return }
        guard id == "ShowInfo" else {return}
        
        guard let infoViewController = segue.destination as? InfoViewController else { return }
        
        print("LoginViewController 객체의 prepare 호출")
        infoViewController.loginInfo = LoginInfo(email:email, password: passward)
    }
    

}
