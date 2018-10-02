//
//  JYCodeTextView.swift
//  CodeText_Swift
//
//  Created by hb on 2018/10/2.
//  Copyright © 2018年 hb. All rights reserved.
//

import UIKit


/**
 * 基础版 - 下划线
 */
class JYCodeTextView: UIView {
    
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
    fileprivate var lines: [UIView]
    
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
        self.lines = [UIView]()
        
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
            let line = UIView()
            line.backgroundColor = UIColor.purple
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
            
            // 赋值显示 - 每个label
            for i in 0..<item_count {
                let label = labels[i]
                if i < text.count {
                    label.text = text.substring(from: i, length: 1)
                } else {
                    label.text = nil
                }
            }
            
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










