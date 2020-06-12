//
//  MainViewController.swift
//  CompanionAnimals
//
//  Created by 맥북 on 25/04/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Nested Type
    private enum ButtonTag: Int {
        case dog = 101
        case cat, rabbit, hedgehog
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Privates
    private func animalInfo(for tag: ButtonTag) -> AnimalInfo? {
        let assetName: String
        
        switch tag {
        case ButtonTag.dog:
            assetName = "Dog"
        case ButtonTag.cat:
            assetName = "Cat"
        case ButtonTag.rabbit:
            assetName = "Rabbit"
        case ButtonTag.hedgehog:
            assetName = "Hedgehog"
        }
        
        return AnimalInfo.decode(from: assetName)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let button: UIButton = sender as? UIButton else { return }
        
        guard let nextViewController: DescriptionViewController = segue.destination as? DescriptionViewController else { return }
        
        guard let tag: ButtonTag = ButtonTag(rawValue: button.tag) else {
            print("버튼의 태그를 enum으로 변경불가")
            return
        }
        
        guard let info: AnimalInfo = self.animalInfo(for: tag) else { return }
        
        nextViewController.animalInfo = info
    }
    

}
