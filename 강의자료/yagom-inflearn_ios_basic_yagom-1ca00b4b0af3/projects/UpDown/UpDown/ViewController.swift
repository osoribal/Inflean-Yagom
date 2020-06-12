//
//  ViewController.swift
//  UpDown
//
//  Created by yagom on 2017
//  Copyright © 2017년 yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- Properties
    // MARK: IBOutlets
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var turnCountLabel: UILabel!
    @IBOutlet var inputField: UITextField!
    
    // MARK: Stored Properties
    var randomNumber: UInt32 = 0
    var turnCount: Int = 0
    
    // MARK:- Methods
    // MARK: IBActions
    @IBAction func touchUpSubmitButton(_ sender: UIButton) {
        
        guard let inputText = self.inputField.text,
            inputText.isEmpty == false else {
                print("입력값 없음")
                return
        }
        
        guard let inputNumber: UInt32 = UInt32(inputText) else {
            print("입력값이 잘못 되었음")
            return
        }
        
        turnCount += 1
        self.turnCountLabel.text = "\(turnCount)"
        
        if inputNumber > randomNumber {
            self.resultLabel.text = "UP!"
        } else if inputNumber < randomNumber {
            self.resultLabel.text = "DOWN!"
        } else {
            self.resultLabel.text = "정답입니다!"
        }
    }
    
    @IBAction func touchUpResetButton(_ sender: UIButton) {
        self.initializeGame()
    }
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        //        self.view.endEditing(true)
        //        self.inputField.resignFirstResponder()
        //        self.inputField.endEditing(true)
    }
    
    // MARK: Custom Methods
    func initializeGame() {
        
        self.randomNumber = arc4random() % 25
        self.turnCount = 0
        
        self.resultLabel.text = "Start!"
        self.turnCountLabel.text = "\(turnCount)"
        self.inputField.text = nil
        
        print("임의의 숫자 \(self.randomNumber)")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initializeGame()
    }
}
