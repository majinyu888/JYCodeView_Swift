//
//  ViewController.swift
//  CodeText_Swift
//
//  Created by hb on 2018/10/2.
//  Copyright © 2018年 hb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let x: CGFloat = 10
        let y: CGFloat = 100
        let w: CGFloat = view.bounds.size.width - 2 * 10
        let h: CGFloat = 50
        
        
        let label1 = UILabel()
        label1.text = "普通版本 - 1"
        label1.textColor = UIColor.red
        label1.font = UIFont.systemFont(ofSize: 14)
        label1.frame = CGRect(x: x, y: y, width: w, height: h)
        view.addSubview(label1)
        
        let codeView1 = JYCodeTextView(count: 5, margin: 10)
        codeView1.frame = CGRect(x: x, y: label1.frame.maxY + 10, width: w, height: h)
        view.addSubview(codeView1)
        
        
        
        let label2 = UILabel()
        label2.text = "普通版本 - 2"
        label2.textColor = UIColor.red
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.frame = CGRect(x: x, y: codeView1.frame.maxY + 10, width: w, height: h)
        view.addSubview(label2)
        
        let codeView2 = JYCodeTextView2(count: 6, margin: 10)
        codeView2.frame = CGRect(x: x, y: label2.frame.maxY + 10, width: w, height: h)
        view.addSubview(codeView2)
        
        
        
        let label3 = UILabel()
        label3.text = "动画版本 - 3"
        label3.textColor = UIColor.red
        label3.font = UIFont.systemFont(ofSize: 14)
        label3.frame = CGRect(x: x, y: codeView2.frame.maxY + 10, width: w, height: h)
        view.addSubview(label3)
        
        let codeView3 = JYCodeTextAnimateView(count: 7, margin: 10)
        codeView3.frame = CGRect(x: x, y: label3.frame.maxY + 10, width: w, height: h)
        view.addSubview(codeView3)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

