//
//  ATaxCalViewController.swift
//  Calculator
//
//  Created by YC X on 2018/2/11.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class ATaxCalViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var indivePayTextField: UITextField!
    
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
            if ((self.numberTextField.text! as NSString).doubleValue > 3500)
            {
                let (tax, revenue) = XCalculateString().aTaxCalculate(wage: self.numberTextField.text!, indivPay: self.indivePayTextField.text!)
                self.resultLabel.text = "应缴税款:"+(tax)+"\n税后收入:"+(revenue)
            }
            else {
                self.resultLabel.text = "应缴税款:0"
            }
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
