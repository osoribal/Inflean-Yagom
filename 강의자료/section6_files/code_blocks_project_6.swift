import UIKit

/// 코드블록 6-2-1

struct LoginInfo {
    let email: String
    let password: String
}
///


/// 코드블록 6-2-2

// MARK: Privates
private func showAlert(message: String, control toBeFirstResponder: UIControl?) {
    
    let alert: UIAlertController = UIAlertController(title: "알림",
                                                     message: message,
                                                     preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction: UIAlertAction = UIAlertAction(title: "입력하기",
                                                style: UIAlertActionStyle.default) { [weak toBeFirstResponder] (action: UIAlertAction) in
                                                    toBeFirstResponder?.becomeFirstResponder()
    }
    
    let cancelAction: UIAlertAction = UIAlertAction(title: "취소",
                                                    style: UIAlertActionStyle.cancel,
                                                    handler: nil)
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    
    self.present(alert, animated: true) {
        print("얼럿 화면에 보여짐")
    }
}
///

/// 코드블록 6-2-3

// MARK: - Properties
@IBOutlet weak var emailField: UITextField!
@IBOutlet weak var passwordField: UITextField!
///


/// 코드블록 6-2-4

// MARK: - Methods
// MARK: IBActions
@IBAction func touchUpLoginButton(_ sender: UIButton) {
    
    guard let email: String = self.emailField.text,
        email.isEmpty == false else {
            self.showAlert(message: "이메일을 입력주세요", control: self.emailField)
            return
    }
    
    guard let password: String = self.passwordField.text,
        password.isEmpty == false else {
            self.showAlert(message: "패스워드를 입력주세요", control: self.passwordField)
            return
    }
    
    self.performSegue(withIdentifier: "ShowInfo", sender: sender)
}
///


/// 코드블록 6-2-5

// MARK: Life Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = "로그인"
}
///


/// 코드블록 6-2-6

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
}
///



/// 코드블록 6-2-7

// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    guard let email: String = self.emailField.text,
        let password: String = self.passwordField.text else {
            return
    }
    
    guard let id: String = segue.identifier else { return }
    guard id == "ShowInfo" else { return }
    
    guard let infoViewController = segue.destination as? InfoViewController else {
        return
    }
}
///


/// 코드블록 6-3-1

// MARK: - Properties
var loginInfo: LoginInfo?
///


/// 코드블록 6-3-2

infoViewController.loginInfo = LoginInfo(email: email, password: password)
///


/// 코드블록 6-3-3

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    print("InfoViewController 객체의 뷰가 나타날 예정")
    
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    
    guard let info = self.loginInfo else {
        return
    }
    
    print(info)
}
///


/// 코드블록 6-3-4

// MARK: - Methods
// MARK: Life Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    
    print("InfoViewController 객체의 뷰가 메모리에 로드됨")
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = "로그인 정보"
}
///


/// 코드블록 6-3-5

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
    
    print("InfoViewController 객체의 뷰가 사라짐")
}
///


/// 코드블록 6-3-6

print("LoginViewController 객체의 뷰가 메모리에 로드됨")
///


/// 코드블록 6-3-7

print("LoginViewController 객체의 뷰가 나타날 예정")
///


/// 코드블록 6-3-8

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
///
