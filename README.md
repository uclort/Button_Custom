# Button_Custom
Swift 自定义 Button，多种图文布局，链式调用 Handler

```swift
// 图片和标题 间距
button.spacing = 10

button.set(title: "普通", state: .normal)
button.set(image: UIImage.add, state: .normal)

button.set(title: "高亮", state: .highlighted)
button.set(image: UIImage.add.alpha(0.6), state: .highlighted)
button.set(titleColor: UIColor.black.withAlphaComponent(0.3), state: .highlighted)

button.set(title: "选中", state: .selected)
button.set(titleColor: .red, state: .selected)

button.set(title: "禁用", state: .disabled)
button.set(titleColor: .systemBlue, state: .disabled)

button.hm_touchDown(action: { (_) in
    print("按下控件")
}).hm_touchUpInside { (_) in
    print("按下控件 控件内部松手")
}.hm_touchUpOutside { (_) in
    print("按下控件 控件外部松手")
}.hm_touchDownRepeat { (_) in
    print("重复按下控件")
}.hm_touchDragInside { (_) in
    print("手指首次触摸控件内部 在控件内部进行拖动")
}.hm_touchDragOutside { (_) in
    print("手指首次触摸控件外部 在控件外部进行拖动")
}.hm_touchDragEnter { (_) in
    print("手指首次触摸控件外部 拖动到控件内部")
}.hm_touchDragExit { (_) in
    print("手指首次触摸控件内部 拖动到控件外部")
}.hm_touchCancel { (_) in
    print("所有触摸事件取消")
}
```

