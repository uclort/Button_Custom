//
//  HmButton.swift
//  Button_Custom
//
//  Created by mfhj-dz-001-059 on 2021/5/6.
//

import UIKit
import SnapKit

enum ControlsType: CaseIterable {
    
    /// 图片左 标题右
    case imageLeftTitleRight, titleRightImageLeft
    /// 图片最左 标题最右
    case imageLeftTitleRight_Best, titleRightImageLeft_Best
    /// 图片右 标题左
    case imageRightTitleLeft, titleLeftImageRight
    /// 图片最右 标题最左
    case imageRightTitleLeft_Best, titleLeftImageRight_Best
    /// 图片上 标题下
    case imageTopTitleBottom, titleBottomImageTop
    /// 图片最上 标题最下
    case imageTopTitleBottom_Best, titleBottomImageTop_Best
    /// 图片下 标题上
    case imageBottomTitleTop, titleTopImageBottom
    /// 图片最下 标题最上
    case imageBottomTitleTop_Best, titleTopImageBottom_Best
    
}

enum HmControlState: String, CaseIterable {
    
    /// 普通状态
    case normal = "normal"
    
    /// 高亮状态
    case highlighted = "highlighted"
    
    /// 选中状态
    case selected = "selected"
    
    /// 禁用状态
    case disabled = "disabled"
    
}


class HmButton: UIControl {
    
    // MARK: 子控件
    private var mainView: UIView = UIView()
    
    private var label: UILabel = UILabel()
    
    private var imageView: UIImageView = UIImageView()
    
    // MARK: 重写控件状态
    /// 高亮状态切换
    override var isHighlighted: Bool {
        didSet {
            guard isEnabled == true else {
                disabledUI()
                return
            }
            if isHighlighted {
                highlightedUI()
            } else {
                if isSelected {
                    selectedUI()
                } else {
                    normalUI()
                }
            }
        }
    }
    
    /// 选中状态切换
    override var isSelected: Bool {
        didSet {
            guard isEnabled == true else {
                disabledUI()
                return
            }
            if isSelected {
                selectedUI()
            } else {
                normalUI()
            }
        }
    }
    
    /// 可用状态切换
    override var isEnabled: Bool {
        didSet {
            guard isEnabled else {
                disabledUI()
                return
            }
            if isSelected {
                selectedUI()
            } else {
                normalUI()
            }
        }
    }
    
    // MARK: 状态数据存储
    private var titleStates: [HmControlState: String] = [:] {
        didSet{
            updateUI()
        }
    }
    
    private var titleColorStates: [HmControlState: UIColor] = [:] {
        didSet{
            updateUI()
        }
    }
    
    private var titleFontColorStates: [HmControlState: UIFont] = [:] {
        didSet{
            updateUI()
        }
    }
    
    private var imageStates: [HmControlState: UIImage] = [:] {
        didSet{
            updateUI()
        }
    }
    
    /// 控件布局类型
    private var controlType: ControlsType = .imageLeftTitleRight
    
    // MARK: Handler Declare
    typealias Handler = (HmButton) -> Void
    /// 按下控件
    private var hm_touchDown: Handler?
    /// 按下控件 在控件内部松手
    private var hm_touchUpInside: Handler?
    /// 按下控件 在控件外部松手
    private var hm_touchUpOutside: Handler?
    /// 重复按下控件
    private var hm_touchDownRepeat: Handler?
    /// 手指首次触摸控件内部 在控件内部进行拖动
    private var hm_touchDragInside: Handler?
    /// 手指首次触摸控件外部 在控件外部进行拖动
    private var hm_touchDragOutside: Handler?
    /// 手指首次触摸控件外部 拖动到控件内部
    private var hm_touchDragEnter: Handler?
    /// 手指首次触摸控件内部 拖动到控件外部
    private var hm_touchDragExit: Handler?
    /// 所有触摸事件取消
    private var hm_touchCancel: Handler?
    
    /// 图片文字间距
    var spacing: CGFloat = 0.0 {
        didSet {
            changeCustomControlConstraint()
        }
    }
    
    // MARK: init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect = .zero, controlType type: ControlsType = .imageLeftTitleRight) {
        super.init(frame: frame)
        // 赋值
        controlType = type
        // 初始化方法
        initializeAttribute()
        addCustomControl()
        changeCustomControlConstraint()
        addHandler()
    }
    
    // MARK: Private
    private func initializeAttribute() {
        
    }
    
    private func addCustomControl() {
        mainView.isUserInteractionEnabled = false
        addSubview(mainView)
        mainView.addSubview(label)
        imageView.contentMode = .scaleAspectFit
        mainView.addSubview(imageView)
    }
    
    private func addHandler() {
        /// 按下控件
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        /// 按下控件 在控件内部松手
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        /// 按下控件 在控件外部松手
        addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        /// 重复按下控件
        addTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat)
        /// 手指首次触摸控件内部 在控件内部进行拖动
        addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
        /// 手指首次触摸控件外部 在控件外部进行拖动
        addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        /// 手指首次触摸控件外部 拖动到控件内部
        addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
        /// 手指首次触摸控件内部 拖动到控件外部
        addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
        /// 所有触摸事件取消
        addTarget(self, action: #selector(touchCancel), for: .touchCancel)
    }
    
}

// MARK: Handler Call
extension HmButton {
    
    /// 按下控件
    @objc
    private func touchDown() {
        hm_touchDown?(self)
    }
    
    @discardableResult
    func hm_touchDown(action: @escaping Handler) -> Self {
        hm_touchDown = action
        return self
    }
    
    /// 按下控件 在控件内部松手
    @objc
    private func touchUpInside() {
        hm_touchUpInside?(self)
    }
    
    @discardableResult
    func hm_touchUpInside(action: @escaping Handler) -> Self {
        hm_touchUpInside = action
        return self
    }
    
    /// 按下控件 在控件外部松手
    @objc
    private func touchUpOutside() {
        hm_touchUpOutside?(self)
    }
    
    @discardableResult
    func hm_touchUpOutside(action: @escaping Handler) -> Self {
        hm_touchUpOutside = action
        return self
    }
    
    /// 重复按下控件
    @objc
    private func touchDownRepeat() {
        hm_touchDownRepeat?(self)
    }
    
    @discardableResult
    func hm_touchDownRepeat(action: @escaping Handler) -> Self {
        hm_touchDownRepeat = action
        return self
    }
    
    /// 手指首次触摸控件内部 在控件内部进行拖动
    @objc
    private func touchDragInside() {
        hm_touchDownRepeat?(self)
    }
    
    @discardableResult
    func hm_touchDragInside(action: @escaping Handler) -> Self {
        hm_touchDragInside = action
        return self
    }
    
    /// 手指首次触摸控件外部 在控件外部进行拖动
    @objc
    private func touchDragOutside() {
        hm_touchDragOutside?(self)
    }
    
    @discardableResult
    func hm_touchDragOutside(action: @escaping Handler) -> Self {
        hm_touchDragOutside = action
        return self
    }
    
    /// 手指首次触摸控件外部 拖动到控件内部
    @objc
    private func touchDragEnter() {
        hm_touchDownRepeat?(self)
    }
    
    @discardableResult
    func hm_touchDragEnter(action: @escaping Handler) -> Self {
        hm_touchDragEnter = action
        return self
    }
    
    /// 手指首次触摸控件内部 拖动到控件外部
    @objc
    private func touchDragExit() {
        hm_touchDragExit?(self)
    }
    
    @discardableResult
    func hm_touchDragExit(action: @escaping Handler) -> Self {
        hm_touchDragExit = action
        return self
    }
    
    /// 所有触摸事件取消
    @objc
    private func touchCancel() {
        hm_touchCancel?(self)
    }
    
    @discardableResult
    func hm_touchCancel(action: @escaping Handler) -> Self {
        hm_touchCancel = action
        return self
    }
    
}

// MARK: Setting UI
extension HmButton {
    
    private func updateUI() {
        if isSelected {
            selectedUI()
        }else if isHighlighted {
            highlightedUI()
        }  else if isEnabled == false {
            disabledUI()
        } else {
            normalUI()
        }
    }
    
    private func normalUI() {
        let state: HmControlState = .normal
        label.text = titleStates[state]
        label.textColor = titleColorStates[state]
        label.font = titleFontColorStates[state]
        imageView.image = imageStates[state]
    }
    
    private func highlightedUI() {
        let state: HmControlState = .highlighted
        label.text = titleStates[state] ?? titleStates[.normal]
        label.textColor = titleColorStates[state] ?? titleColorStates[.normal]
        label.font = titleFontColorStates[state] ?? titleFontColorStates[.normal]
        imageView.image = imageStates[state] ?? imageStates[.normal]
    }
    
    private func selectedUI() {
        let state: HmControlState = .selected
        label.text = titleStates[state] ?? titleStates[.normal]
        label.textColor = titleColorStates[state] ?? titleColorStates[.normal]
        label.font = titleFontColorStates[state] ?? titleFontColorStates[.normal]
        imageView.image = imageStates[state] ?? imageStates[.normal]
    }
    
    private func disabledUI() {
        let state: HmControlState = .disabled
        label.text = titleStates[state] ?? titleStates[.normal]
        label.textColor = titleColorStates[state] ?? titleColorStates[.normal]
        label.font = titleFontColorStates[state] ?? titleFontColorStates[.normal]
        imageView.image = imageStates[state] ?? imageStates[.normal]
    }
    
}

// MARK: Layout
extension HmButton {
    
    /// 图片左 标题右
    private func addConstraint1() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(imageView.snp.right).offset(spacing)
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }
    
    /// 图片最左 标题最右
    private func addConstraint2() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }
    
    /// 图片右 标题左
    private func addConstraint3() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(label.snp.right).offset(spacing)
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }
    
    /// 图片最右 标题最左
    private func addConstraint4() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }
    
    /// 图片上 标题下
    private func addConstraint5() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(spacing)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    /// 图片最上 标题最下
    private func addConstraint6() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    /// 图片下 标题上
    private func addConstraint7() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.bottom).offset(spacing)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    /// 图片最下 标题最上
    private func addConstraint8() {
        mainView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.height.equalToSuperview()
        }
        label.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview()
        }
        imageView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    private func changeCustomControlConstraint() {
        mainView.snp.removeConstraints()
        label.snp.removeConstraints()
        imageView.snp.removeConstraints()
        switch controlType {
        /// 图片左 标题右
        case .imageLeftTitleRight, .titleRightImageLeft:
            addConstraint1()
        /// 图片最左 标题最右
        case .imageLeftTitleRight_Best, .titleRightImageLeft_Best:
            addConstraint2()
        /// 图片右 标题左
        case .imageRightTitleLeft, .titleLeftImageRight:
            addConstraint3()
        /// 图片最右 标题最左
        case .imageRightTitleLeft_Best, .titleLeftImageRight_Best:
            addConstraint4()
        /// 图片上 标题下
        case .imageTopTitleBottom, .titleBottomImageTop:
            addConstraint5()
        /// 图片最上 标题最下
        case .imageTopTitleBottom_Best, .titleBottomImageTop_Best:
            addConstraint6()
        /// 图片下 标题上
        case .imageBottomTitleTop, .titleTopImageBottom:
            addConstraint7()
        /// 图片最下 标题最上
        case .imageBottomTitleTop_Best, .titleTopImageBottom_Best:
            addConstraint8()
            
        }
    }
    
}

// MARK: 控件状态设置
extension HmButton {
    
    // MARK: Set Title
    func set(title: String, state: HmControlState) {
        titleStates[state] = title;
    }
    
    func set(title: String, state: [HmControlState]) {
        state.forEach { (v) in
            titleStates[v] = title;
        }
    }
    
    func set(titleColor: UIColor, state: HmControlState) {
        titleColorStates[state] = titleColor;
    }
    
    func set(titleColor: UIColor, state: [HmControlState]) {
        state.forEach { (v) in
            titleColorStates[v] = titleColor;
        }
    }
    
    func set(titleFont: UIFont, state: HmControlState) {
        titleFontColorStates[state] = titleFont;
    }
    
    func set(titleFont: UIFont, state: [HmControlState]) {
        state.forEach { (v) in
            titleFontColorStates[v] = titleFont;
        }
    }
    
    // MARK: Set Image
    func set(image: UIImage?, state: HmControlState) {
        imageStates[state] = image;
    }
    
    func set(image: UIImage?, state: [HmControlState]) {
        state.forEach { (v) in
            imageStates[v] = image;
        }
    }
    
}
