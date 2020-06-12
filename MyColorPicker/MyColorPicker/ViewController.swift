//
//  ViewController.swift
//  MyColorPicker
//
//  Created by 맥북 on 20/04/2020.
//  Copyright © 2020 kdy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Private Types
    private struct ColorComponent {
        typealias SliderTag = Int
        typealias Component = Int
        
        static let count: Int = 4
        
        static let red: Int = 0
        static let green: Int = 1
        static let blue: Int = 2
        static let alpha: Int = 3
        
        static func tag(`for`: Component) -> Int {
            return `for` + 100
        }
        
        static func component(from:SliderTag) -> Component {
            return from - 100
        }
    }
    
    private struct ViewTag {
        static let sliderRed: Int = 100
        static let sliderGreen: Int = 101
        static let sliderBlue: Int = 102
        static let sliderAlpha: Int = 103
        static let pickerView: Int = 104
        static let colorView: Int = 105
    }
    
    // MARK: - Properties
    // MARK: IBOutlets
    //@IBOutlet weak var colorView: UIView!
    //@IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: Privates
    private let rgbStep: Float = 255.0
    private let numberOfRBStep: Int = 255/5 + 1 // 255 -> 255/5+1
    private let numberOfAlphaStep: Int = 11
    
    // MARK: - Methods
    // MARK: IBAction
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard (ViewTag.sliderRed...ViewTag.sliderAlpha).contains(sender.tag) else {
            print("wrong slider tag")
            return
        }
        
        // picker view with tag
        guard let pickerView: UIPickerView = self.view.viewWithTag(ViewTag.pickerView) as? UIPickerView else {
            return
        }
        
        let component:Int = ColorComponent.component(from: sender.tag)
        let row: Int
        
        if component == ColorComponent.alpha {
            row = Int(sender.value * 10)
        } else {
            row = Int(sender.value)
        }
        
        // slider value to pickerview : row -> row / 5
        pickerView.selectRow(row/5, inComponent: component, animated: false)
        
        self.matchViewColorSithCurrentValue()
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // picker view with tag
        guard let pickerView: UIPickerView = self.view.viewWithTag(ViewTag.pickerView) as? UIPickerView else {
            return
        }
        
        for i in 0..<pickerView.numberOfComponents {
            let numberOfRows: Int = pickerView.numberOfRows(inComponent: i)
            pickerView.selectRow(numberOfRows - 1, inComponent: i, animated: false)
        }
    }

    // MARK: Privates
    private func matchViewColorSithCurrentValue() {
        
        guard let redSlider: UISlider = self.view.viewWithTag(ViewTag.sliderRed) as? UISlider, let greenSlider: UISlider = self.view.viewWithTag(ViewTag.sliderGreen) as? UISlider, let blueSlider: UISlider = self.view.viewWithTag(ViewTag.sliderBlue) as? UISlider, let alphaSlider: UISlider = self.view.viewWithTag(ViewTag.sliderAlpha) as? UISlider
            else {
                return
        }
        
        // color view with tag
        guard let colorView: UIView = self.view.viewWithTag(ViewTag.colorView) else {
            return
        }
        
        // UIColor의 Red, Green, Blue, Alpha 값은 0과 1사이의 실수 값
        let red: CGFloat = CGFloat(redSlider.value / self.rgbStep)
        let green: CGFloat = CGFloat(greenSlider.value / self.rgbStep)
        let blue: CGFloat = CGFloat(blueSlider.value / self.rgbStep)
        let alpha: CGFloat = CGFloat(alphaSlider.value)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        colorView.backgroundColor = color
        
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return ColorComponent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == ColorComponent.alpha {
            return self.numberOfAlphaStep
        } else {
            return self.numberOfRBStep
        }
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == ColorComponent.alpha {
            return String(format: "%1.1lf", Double(row)*0.1)
        } else {
            // set pickerview row value : row -> row * 5
            return "\(row * 5)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sliderTag: Int = ColorComponent.tag(for: component)
        
        guard let slider: UISlider = self.view.viewWithTag(sliderTag) as? UISlider else {
            return
        }
        
        if component == ColorComponent.alpha {
            slider.setValue(Float(row)/10.0, animated: false)
        } else {
            // pickerview to slider value : row -> row * 5
            slider.setValue(Float(row * 5), animated: false)
        }
        
        self.matchViewColorSithCurrentValue()
    }
}
