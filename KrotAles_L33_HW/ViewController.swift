//
//  ViewController.swift
//  KrotAles_L33_HW
//
//  Created by Ales Krot on 13.02.22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var redSliderLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSliderLabel: UILabel!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSliderLabel: UILabel!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let info1 = nameTextField.rx.text
            .map { text in text?.uppercased()
            }
        
        let colorTextInfo1 = nameTextField.rx.text
            .map { text in (text?.count ?? 0 < 4) }
        
//        TASK 1.
//        info1.bind(to: fullNameLabel.rx.text)
        
        let info2 = surnameTextField.rx.text.asObservable()
        let colorTextInfo2 = surnameTextField.rx.text
            .map { text in (text?.count ?? 0 < 4) }
        
        Observable
            .combineLatest(info1, info2, colorTextInfo1, colorTextInfo2)
            .map { info1, info2, colorTextInfo1, colorTextInfo2 -> String in
                if colorTextInfo1 { self.nameTextField.textColor = .red }
                if !colorTextInfo1 { self.nameTextField.textColor = .black }
                if colorTextInfo2 { self.surnameTextField.textColor = .red }
                if !colorTextInfo2 { self.surnameTextField.textColor = .black }
                return "\(info1 ?? "") \(info2 ?? "")"
            }
            .bind(to: fullNameLabel.rx.text)
            .disposed(by: bag)
        
        prepareSliders()
        
        let rSlider = redSlider.rx.value.asObservable()
        let gSlider = greenSlider.rx.value.asObservable()
        let bSlider = blueSlider.rx.value.asObservable()
        
        Observable
            .combineLatest(rSlider, gSlider, bSlider)
            .map {(value1, value2, value3) -> UIColor in
                print(value1, value2, value3)
                return UIColor(red: CGFloat(value1), green: CGFloat(value2), blue: CGFloat(value3), alpha: 1)
            }
            .bind(to: fullNameLabel.rx.backgroundColor)
            .disposed(by: bag)
    }
    
    private func prepareSliders() {
        redSliderLabel.text = "Red"
        redSliderLabel.textColor = .red
        redSlider.tintColor = .red
        redSlider.value = 1
        greenSliderLabel.text = "Green"
        greenSliderLabel.textColor = .green
        greenSlider.tintColor = .green
        greenSlider.value = 1
        blueSliderLabel.text = "Blue"
        blueSliderLabel.textColor = .blue
        blueSlider.tintColor = .blue
        blueSlider.value = 1
    }
}
