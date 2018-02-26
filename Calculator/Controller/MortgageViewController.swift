//
//  MortgageViewController.swift
//  Calculator
//
//  Created by YC X on 2018/2/11.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var indivePayTextField: UITextField!
    @IBOutlet weak var yearRateTextField: UITextField!
    @IBOutlet weak var wayBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureEvent))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureEvent() {
        self.view.endEditing(true)
    }
    
    @IBAction func touchUpInsideBtn(_ sender: UIButton) {
        
        if (sender.tag == 0) && (self.numberTextField.text?.isEmpty)! {
            XMessageView.messageShow("请输入金额哦")
            return
        }
        if sender.tag == 0
        {
            var way:Int = 0
            if self.wayBtn.titleLabel?.text == "等额本金"
            {
                way = 1
            }
            
            let (tax, revenue) = XCalculateString().mortgageCalculate(way: way, money: (self.numberTextField.text! as NSString).doubleValue, year: (self.indivePayTextField.text! as NSString).integerValue, rate: (self.yearRateTextField.text! as NSString).doubleValue)
            self.resultLabel.text = "每月应付:"+(tax)+"元\n每月递减:"+(revenue)+"元\n一共需还:"+(((self.indivePayTextField.text! as NSString).integerValue*12).description)+"个月"
        }
        else
        {
            if self.wayBtn.titleLabel?.text == "等额本金"
            {
                self.wayBtn.setTitle("等额本息", for: UIControlState.normal)
            }
            else {
                self.wayBtn.setTitle("等额本金", for: UIControlState.normal)
            }
        }
    }
    @IBAction func touchUpInsideBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
