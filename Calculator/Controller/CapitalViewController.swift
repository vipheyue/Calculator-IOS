//
//  CapitalViewController.swift
//  Calculator
//
//  Created by YC X on 2018/1/22.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class CapitalViewController: UIViewController {

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
            XMessageView.messageShow("请输入金额哦")
            return
        }
        if sender.tag == 0 {
            self.resultLabel.text = XUppercase().uppercase(withNumber:self.numberTextField.text)
        }
        else {
            self.numberTextField.text = ""
            self.numberTextField.placeholder = "请输入金额"
        }
    }
    @IBAction func touchUpInsideBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
