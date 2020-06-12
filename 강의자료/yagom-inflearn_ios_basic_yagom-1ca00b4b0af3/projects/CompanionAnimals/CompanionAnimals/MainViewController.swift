//
//  MainViewController.swift
//  CompanionAnimals
//
//  Created by yagom on 2017
//  Copyright © 2017년 yagom. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
   
    // MARK: - Nested Type
    private enum ButtonTag: Int {
        case dog = 101
        case cat, rabbit, hedgehog
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
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
        
        return self.decodeAnimalInfo(from: assetName)
    }

    private func decodeAnimalInfo(from assetName: String) -> AnimalInfo? {
        guard let asset: NSDataAsset = NSDataAsset(name: assetName) else {
            print("에셋 로드 실패")
            return nil
        }
        
        do {
            let decoder: PropertyListDecoder = PropertyListDecoder()
            return try decoder.decode(AnimalInfo.self, from: asset.data)
        } catch {
            print("데이터 디코딩 실패")
            print(error.localizedDescription)
            return nil
        }
    }
}
