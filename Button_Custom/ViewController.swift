//
//  ViewController.swift
//  Button_Custom
//
//  Created by mfhj-dz-001-059 on 2021/5/6.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let mainScrollView = HmScrollView()
    private let mainView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(mainView)
        mainScrollView.snp.makeConstraints { (maker) in
            maker.edges.width.equalToSuperview()
        }
        mainView.snp.makeConstraints { (maker) in
            maker.edges.width.equalToSuperview()
        }
        
        var lastButton: HmButton?
        for i in 0..<ControlsType.allCases.count {
            let type = ControlsType.allCases[i]
            let button = HmButton(controlType: type)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
            button.layer.cornerRadius = 3
            button.spacing = 10
            button.set(title: "普通", state: .normal)
            button.set(image: UIImage.add, state: .normal)
            button.set(image: UIImage.add.alpha(0.6), state: .highlighted)
            button.set(title: "普通", state: .highlighted)
            button.set(titleColor: UIColor.black.withAlphaComponent(0.3), state: .highlighted)
            button.set(title: "普通", state: .selected)
            button.set(titleColor: .red, state: .selected)
            button.set(title: "禁用", state: .disabled)
            button.set(titleColor: .systemBlue, state: .disabled)
            button.hm_touchDown(action: { (sender) in
                print(sender)
            }).hm_touchUpInside { (sender) in
                sender.isSelected = !sender.isSelected
            }.hm_touchUpOutside { (sender) in
                sender.isEnabled = false
            }.hm_touchDownRepeat { (sender) in
                print("重复点击")
            }
            mainView.addSubview(button)
            button.snp.makeConstraints { (maker) in
                maker.centerX.equalToSuperview()
                if let lastButton = lastButton {
                    maker.top.equalTo(lastButton.snp.bottom).offset(5)
                } else {
                    maker.top.equalToSuperview().inset(10)
                }
                maker.width.equalTo(200)
                maker.height.equalTo(100)
                if i == ControlsType.allCases.count - 1 {
                    maker.bottom.equalToSuperview().inset(10)
                }
            }
            lastButton = button
        }
        
    }
}


extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
