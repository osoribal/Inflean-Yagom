//
//  MakerViewController.swift
//  CompanionAnimals
//
//  Created by yagom on 2017
//  Copyright © 2017년 yagom. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var descriptionTextView: UITextView!

    // MARK: - Methods
    @IBAction func touchUpInsideDismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.descriptionTextView.text = """
        안녕하세요 야곰입니다.
        제 애플리케이션을 이용해 주셔서 고맙습니다.
        제 블로그 주소는 http://blog.yagom.net 입니다.
        자주자주 놀러오세요 :D
        """
    }
}
