import UIKit

/// 코드블록 7-3-1

import UIKit

struct Question: Codable {
    let d: String
    let i: String
    let s: String
    let c: String
}
///


/// 코드블록 7-3-2

extension Question {
    static var all: [Question] = {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "Questions") else {
            return []
        }
        
        let jsonDecoder: JSONDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([Question].self, from: dataAsset.data)
        } catch {
            return []
        }
    }()
}
///

/// 코드블록 7-3-3

import UIKit

struct Result: Codable {
    /// for Singleton design pattern
    static let shared: Result? = Result()
    
    // Instance Properties
    let d: Info
    let i: Info
    let s: Info
    let c: Info
    
    /// Custom Failable Initializer
    private init?() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "Result") else {
            return nil
        }
        
        do {
            let result: Result = try JSONDecoder().decode(Result.self, from: dataAsset.data)
            self = result
        } catch {
            return nil
        }
    }
}

extension Result {
    struct Info: Codable {
        let title: String
        let typeDescription: String
    }
}
///


/// 코드블록 7-3-4

import Foundation

class UserInfo {
    /// for Singleton design pattern
    static let shared: UserInfo = UserInfo()
    
    // Instance Properties
    var name: String!
    let score: Score = Score()
    
    var hightestScoreResult: Result.Info? {
        let hightest: Int = max(self.score.d, self.score.i, self.score.s, self.score.c)
        switch hightest {
        case self.score.d:
            return Result.shared?.d
        case self.score.i:
            return Result.shared?.i
        case self.score.s:
            return Result.shared?.s
        default:
            return Result.shared?.c
        }
    }
    
    var scorePercentageText: String {
        
        let sum: Double = Double(self.score.d + self.score.i + self.score.s + self.score.c)
        let percentageD = Double(self.score.d) / sum * 100
        let percentageI = Double(self.score.i) / sum * 100
        let percentageS = Double(self.score.s) / sum * 100
        let percentageC = Double(self.score.c) / sum * 100
        
        return String(format: "D : %.0lf%%, I : %.0lf%%, S : %.0lf%%, C : %.0lf%%", percentageD, percentageI, percentageS, percentageC)
    }
}

extension UserInfo {
    
    class Score {
        var d: Int = 0
        var i: Int = 0
        var s: Int = 0
        var c: Int = 0
    }
    
    func reset() {
        self.score.d = 0
        self.score.i = 0
        self.score.s = 0
        self.score.c = 0
        self.name = nil
    }
    
    enum ScoreType {
        case d, i, s, c
    }
}
///


/// 코드블록 7-4-1

// MARK: - Methods
// MARK: Life Cycle
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.nameLabel.text = UserInfo.shared.name
    self.percentageLabel.text = UserInfo.shared.scorePercentageText
    
    guard let result: Result.Info = UserInfo.shared.hightestScoreResult else { return }
    
    self.titleLabel.text = result.title
    self.descriptionTextView.text = result.typeDescription
}

// MARK: IBActions
@IBAction func touchUpDismissButton(_ sender: UIButton) {
    self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
}
///


/// 코드블록 7-4-2

// MARK: - Methods
// MARK: Life Cycle
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.nameField.text = nil
}
///


/// 코드블록 7-4-3

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
///


/// 코드블록 7-4-4

/// 인터페이스 빌더에서 설정한 버튼의 tag
enum ButtonTag: Int {
    case d = 101
    case i, s, c
}
///


/// 코드블록 7-4-5

// MARK: - Properties
var questionIndex: Int!
///


/// 코드블록 7-4-6

// MARK: - Methods
// MARK: Life Cycle
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.questionIndex = self.questionIndex ?? 0
    
    if self.questionIndex < 1 {
        self.backButton.isHidden = true
    }
    
    let question: Question = Question.all[questionIndex]
    
    guard let dButton: UIButton = self.view.viewWithTag(ButtonTag.d.rawValue) as? UIButton else { return }
    dButton.setTitle(question.d, for: UIControlState.normal)
    
    guard let iButton: UIButton = self.view.viewWithTag(ButtonTag.i.rawValue) as? UIButton else { return }
    iButton.setTitle(question.i, for: UIControlState.normal)
    
    guard let sButton: UIButton = self.view.viewWithTag(ButtonTag.s.rawValue) as? UIButton else { return }
    sButton.setTitle(question.s, for: UIControlState.normal)
    
    guard let cButton: UIButton = self.view.viewWithTag(ButtonTag.c.rawValue) as? UIButton else { return }
    cButton.setTitle(question.c, for: UIControlState.normal)
}
///


/// 코드블록 7-4-7

@IBAction func touchUpAnswerButton(_ sender: UIButton) {
    
    guard let tag: ButtonTag = ButtonTag(rawValue: sender.tag) else {
        return
    }
    
    switch tag {
    case .d:
        UserInfo.shared.score.d += 1
    case .i:
        UserInfo.shared.score.i += 1
    case .s:
        UserInfo.shared.score.s += 1
    case .c:
        UserInfo.shared.score.c += 1
    }
    
    let nextIndex: Int = self.questionIndex + 1
    
    if Question.all.count > nextIndex,
        let nextViewController: QuestionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController {
        nextViewController.questionIndex = nextIndex
        self.navigationController?.pushViewController(nextViewController, animated: true)
    } else {
        self.performSegue(withIdentifier: "ShowResult", sender: nil)
    }
    
}
///


/// 코드블록 7-4-8

// MARK: IBActions
@IBAction func touchUpBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
}
///

