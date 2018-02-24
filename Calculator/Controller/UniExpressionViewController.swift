//
//  UniExpressionViewController.swift
//  Calculator
//
//  Created by YC X on 2018/1/23.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class UniExpressionViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var emptiedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchUpInsideBtn(_ sender: UIButton) {
        
        if (self.numberTextField.text?.isEmpty)! {
            XMessageView.messageShow("请输入表达式")
            return
        }
        switch sender.tag {
        case 0:
            // (
            break
        case 1:
            // )
            break
        case 2:
            // 清空
            self.numberTextField.text = ""
            self.numberTextField.placeholder = "请输入表达式"
            break
        case 3:
            // 确认
            if ((self.numberTextField.text?.range(of: "(")) == nil)
            {
                self.resultLabel.text = "输入的表达式不对哦!"
//                XMessageView.messageShow("输入的表达式不对哦!")
                return
            }
            let tempStr:NSString = self.numberTextField.text! as NSString
            let lRange:NSRange = tempStr.range(of: "(", options:NSString.CompareOptions.backwards)
            let rRange:NSRange = tempStr.range(of: ")", options: NSString.CompareOptions.literal, range: NSMakeRange(lRange.location, tempStr.length-lRange.location))
            // 获取括号左右边的表达式
            let left = tempStr.substring(with: NSMakeRange(0, lRange.location))
//            let right:NSString = tempStr.substring(from: rRange.location+1) as NSString
            // 括号内的表达式
            let middle:NSString = tempStr.substring(with: NSMakeRange(lRange.location+1, rRange.location-lRange.location-1)) as NSString
            // 代入计算新的公式
            let allRight:Bool = MSExpressionHelper.helperCheckExpression(middle as String!, using: nil)
            if(allRight){
                //计算表达式
                let newStr:NSString = MSParser.parserComputeExpression(middle as String!, error: nil) as NSString
                self.resultLabel.text = XCalculateString().scientificComputingStrWithValue(str: left, value: newStr.doubleValue)
            }
            else {
                self.resultLabel.text = "输入的表达式不对哦!"
//                XMessageView.messageShow("输入的表达式不对哦!")
                return
            }
            
            break
        default:
            break
        }
    }
    @IBAction func touchUpInsideBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
