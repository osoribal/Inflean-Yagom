//
//  MakerViewController.swift
//  CompanionAnimals
//
//  Created by 맥북 on 25/04/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionTextView.text = """
        안녕하세요 야곰입니다.
        제 애플리케이션을 이용해 주셔서 고맙습니다.
        제 블로그 주소는 http://blog.yagom.net 입니다.
        자주자주 놀러오세요 :D
        """

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
    @IBAction func touchUpInsideDismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
