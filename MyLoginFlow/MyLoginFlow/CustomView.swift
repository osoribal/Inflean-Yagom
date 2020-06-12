//
//  CustomView.swift
//  MyLoginFlow
//
//  Created by 맥북 on 06/05/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class CustomView: UIView {

    private func printLocation(of touch: UITouch, prefix: String = "") {
        let location: CGPoint = touch.location(in: self)
        print("\(prefix)\(location)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch: UITouch = touches.first else { return }
        self.printLocation(of: firstTouch, prefix: "touchesBegan ")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch: UITouch = touches.first else { return }
        self.printLocation(of: firstTouch, prefix: "touchesMoved ")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstTouch: UITouch = touches.first else { return }
        self.printLocation(of: firstTouch, prefix: "touchesEnded ")
    }

}
