//
//  yearAwardsViewController.swift
//  Calculator
//
//  Created by YC X on 2018/2/11.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class YearAwardsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.resultBtn.layer.masksToBounds = true
//        self.resultBtn.layer.cornerRadius = self.resultBtn.frame.size.height/2
    }

    @IBAction func touchUpInsideBtn(_ sender: UIButton) {
        
        if (self.numberTextField.text?.isEmpty)! {
            XMessageView.messageShow("请输入金额哦")
            return
        }
        if sender.tag == 0 {
            
            let (tax, revenue) = XCalculateString().yearAwardCalculate(award: self.numberTextField.text!)
            self.resultLabel.text = "应缴税款:"+(tax)+"\n税后收入:"+(revenue)
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
