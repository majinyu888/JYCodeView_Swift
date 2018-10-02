//
//  JYCodeTextAnimateView.swift
//  CodeText_Swift
//
//  Created by hb on 2018/10/2.
//  Copyright © 2018年 hb. All rights reserved.
//

import UIKit

/**
 * 完善版 - 加入动画 - 下划线
 */

class JYCodeTextAnimateView: UIView {
    
    //MARK: - IBs
    
    //MARK: - Public Propertys
    
    public var code: String? {
        // 只读属性
        get {
            return self.textField.text
        }
    }
    
    //MARK: - Private Propertys
    
    fileprivate var item_count: Int
    fileprivate var item_margin: CGFloat
    fileprivate var textField: UITextField
    fileprivate var mask_view: UIControl
    fileprivate var labels: [UILabel]
    fileprivate var lines: [JYCodeTextLineView]
    
    /// 临时保存上次输入的内容(用于判断 删除 还是 输入)
    fileprivate var tempStr: String? = nil
    
    //MARK: - Public Methods
    
    //MARK: - Life Cycle
    
    init(count: Int, margin: CGFloat) {
        
        /*
         “When you assign a default value to a stored property,
         or set its initial value within an initializer,
         the value of that property is set directly,
         without calling any property observers.”
         摘录来自: Apple Inc. “The Swift Programming Language (Swift 4.2)。” iBooks.
         
         初始化属性 / 默认值 - 不会触发属性监听事件
         
         */
        
        /// Setting Initial Values for Stored Properties
        self.item_count = count
        self.item_margin = margin
        self.textField = UITextField()
        self.mask_view = UIButton()
        self.labels = [UILabel]()
        self.lines = [JYCodeTextLineView]()
        
        /// call super init
        super.init(frame: .zero)
        
        /// 自身默认配置
        self.defaultConfig()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    /// 默认样式配置
    fileprivate func defaultConfig() {
        
        backgroundColor = UIColor.white
        
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(self.tfChanged(tf:)), for: .editingChanged)
        addSubview(textField)
        
        // 小技巧：这个属性为true，可以强制使用系统的数字键盘，缺点是重新输入时，会清空之前的内容
        // clearsOnBeginEditing 属性并不适用于 secureTextEntry = true 时
        // textField.secureTextEntry = true
        
        // 小技巧：通过textField上层覆盖一个maskView，可以去掉textField的长按事件
        
        mask_view.backgroundColor = UIColor.white
        mask_view.addTarget(self, action: #selector(self.clickMaskView), for: .touchUpInside)
        addSubview(mask_view)
        
        for i in 0..<item_count {
            // add label
            let label = UILabel()
            label.tag = i
            label.textAlignment = .center
            label.textColor = UIColor.darkGray
            label.font = UIFont(name: "PingFangSC-Regular", size: 41.5)
            addSubview(label)
            labels.append(label)
            
            // add line
            let line = JYCodeTextLineView()
            line.backgroundColor = UIColor.red
            addSubview(line)
            lines.append(line)
        }
        
    }
    
    
    /// 输入改变
    ///
    /// - Parameter tf: 输入框
    @objc fileprivate func tfChanged(tf: UITextField) {
        
        if let text = tf.text {
            
            // 去掉长度过多部分
            if text.count > item_count {
                tf.text = text.substring(to: item_count)
            }
            
            // 样式 - 每个label, line
            for i in 0..<item_count {
                let label = labels[i]
                let line = lines[i]
                
                if i < text.count {
                    label.text = text.substring(from: i, length: 1)
                    line.backgroundColor = UIColor.green
                } else {
                    label.text = nil
                    line.backgroundColor = UIColor.red
                }
            }
            
            // 动画效果，这里是删除时，不要动画，输入时显示动画
            if let tempStr = tempStr {
                if tempStr.count <= text.count {
                    if text.count > item_count {
                        lines.last?.animation()
                        animation(label: labels.last)
                    } else {
                        lines[text.count - 1].animation()
                        animation(label: labels[text.count - 1])
                    }
                }
            } else {
                // 第一次输入
                lines.first?.animation()
                animation(label: labels.first)
            }
            
            // 记录临时
            tempStr = text
            
            //输入完毕, 隐藏键盘
            if text.count >= item_count {
                textField.resignFirstResponder()
            }
        } else {
            /// 没有文字 -
            for i in 0..<item_count {
                let label = labels[i]
                label.text = nil
            }
        }
        
    }
    
    /// 点击遮挡视图
    @objc fileprivate func clickMaskView() {
        textField.becomeFirstResponder()
    }
    
    /// 自定义label动画
    ///
    /// - Parameter label: 要执行动画的label
    fileprivate func animation(label: UILabel?) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.15
        animation.repeatCount = 1
        animation.fromValue = 0.1
        animation.toValue = 1
        label?.layer.add(animation, forKey: "zoom")
    }
    
    //MARK: - Over ride
    override func endEditing(_ force: Bool) -> Bool {
        textField.endEditing(force)
        return super.endEditing(force)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if labels.count != item_count {
            return
        }
        
        let all_width = bounds.size.width - item_margin * (CGFloat(item_count) - 1)
        let per_width = all_width / CGFloat(item_count)
        var x:CGFloat = 0
        
        for i in 0..<labels.count {
            x = CGFloat(i) * (per_width + item_margin)
            
            // label 位置
            let label = labels[i]
            label.frame = CGRect(x: x, y: 0, width: per_width, height: bounds.size.height)
            
            // line 位置
            let line = lines[i]
            line.frame = CGRect(x: x, y: bounds.size.height - 1, width: per_width, height: 1)
        }
        
        textField.frame = bounds
        mask_view.frame = bounds
        
    }
    
}


/**
 * 完善版 - 下划线
 */

class JYCodeTextLineView: UIView {
    
    //MARK: - Public Propertys
    public var color_view: UIView
    
    //MARK: - Private Propertys
    
    //MARK: - Public Methods
    
    public func animation() {
        color_view.layer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.duration = 0.18
        animation.repeatCount = 1
        animation.fromValue = 1.0
        animation.toValue = 0.1
        color_view.layer.add(animation, forKey: "zoom.scale.x")
    }
    
    //MARK: - Private Methods
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        color_view = UIView()
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        addSubview(color_view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        color_view.frame = bounds
    }
    
}
