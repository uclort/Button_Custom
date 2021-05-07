//
//  HmScrollView.swift
//  Button_Custom
//
//  Created by mfhj-dz-001-059 on 2021/5/7.
//

import UIKit

class HmScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delaysContentTouches = false
        keyboardDismissMode = .onDrag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: HmButton.self) || view.isKind(of: UITextField.self) {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
}
