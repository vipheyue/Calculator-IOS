//
//  XCalculateString.swift
//  Calculator
//
//  Created by YC X on 2017/12/27.
//  Copyright © 2017年 YC X. All rights reserved.
//

import UIKit

class XCalculateString: NSObject {

    // 加
    private func add(str1:NSString, str2:NSString) -> NSString {
        return NSString(format:"%f",(str1.floatValue+str2.floatValue))
    }
    // 减
    private func reduce(str1:NSString, str2:NSString) -> NSString {
        return NSString(format:"%f",(str1.floatValue-str2.floatValue))
    }
    // 乘
    private func multiply(str1:NSString, str2:NSString) -> NSString {
        return NSString(format:"%f",(str1.floatValue*str2.floatValue))
    }
    // 除
    private func division(str1:NSString, str2:NSString) -> NSString {
        return NSString(format:"%f",(str1.floatValue/str2.floatValue))
    }
    
    // 只有加，减
    private func calcAddReduce(str:NSString) -> NSString {
        var result:NSString = "0"
        var symbol:NSString = "+"
        let len:NSInteger = str.length
        var numStartPoint:NSInteger = 0
        var i = 0
        for tempStr in String(format:"%@", str).characters
        {
            if (tempStr == "+" || tempStr == "-") {
                let num:NSString = str.substring(with: NSMakeRange(numStartPoint, i-numStartPoint)) as NSString
                switch (symbol) {
                case "+":
                    result = self.add(str1: result, str2: num)
                    break
                case "-":
                    result = self.reduce(str1: result, str2: num)
                    break
                default:
                    break
                }
                symbol = String(tempStr) as NSString
                numStartPoint = i + 1
            }
            i = i + 1
        }
        if (numStartPoint < len) {
            let num:NSString = str.substring(with: NSMakeRange(numStartPoint, len-numStartPoint)) as NSString
            switch (symbol) {
            case "+":
                result = self.add(str1: result, str2: num)
                break
            case "-":
                result = self.reduce(str1: result, str2: num)
                break
            default:
                break
            }
        }
        return result
    }
    
    // 只有乘除
    private func calcMultiplyDivision(str:NSString) -> NSString {
        let mulRange:NSRange = str.range(of: "*", options:NSString.CompareOptions.literal)
        let divRange:NSRange = str.range(of: "/", options:NSString.CompareOptions.literal)
        // 只包含加减的运算
        if (mulRange.length == 0 && divRange.length == 0) {
            return self.calcAddReduce(str: str)
        }
        // 进行乘除运算
        let index:NSInteger = mulRange.length > 0 ? mulRange.location : divRange.location
        // 计算左边表达式
        var left:NSString = str.substring(with: NSMakeRange(0, index)) as NSString
        let num1:NSString = self.getLastStr(str: left)
        left = left.substring(with: NSMakeRange(0, left.length-num1.length)) as NSString
        // 计算右边表达式
        var right:NSString = str.substring(from: index+1) as NSString
        let num2:NSString = self.getFirstStr(str: right)
        right = right.substring(from: num2.length) as NSString
        // 计算一次乘除结果
        var tempResult:NSString = "0"
        if (index == mulRange.location) {
            tempResult = self.multiply(str1: num1, str2: num2)
        }
        else {
            tempResult = self.division(str1: num1, str2: num2)
        }
        // 代入计算得到新的公式
        let newStr:NSString = "\(left)\(tempResult)\(right)" as NSString
        return self.calcMultiplyDivision(str:newStr)
    }
    
    // 复杂计算
    func calcComplexStr(str:NSString) -> NSString {
        // 左括号
        let lRange:NSRange = str.range(of: "(", options:NSString.CompareOptions.backwards)
        // 没有括号进行二步运算(含有乘除加减)
        if (lRange.length == 0) {
            return self.calcMultiplyDivision(str:str)
        }
        // 右括号
        let rRange:NSRange = str.range(of: ")", options: NSString.CompareOptions.literal, range: NSMakeRange(lRange.location, str.length-lRange.location))
        // 获取括号左右边的表达式
        let left:NSString = str.substring(with: NSMakeRange(0, lRange.location)) as NSString
        let right:NSString = str.substring(from: rRange.location+1) as NSString
        // 括号内的表达式
        let middle:NSString = str.substring(with: NSMakeRange(lRange.location+1, rRange.location-lRange.location-1)) as NSString
        // 代入计算新的公式
        let newStr:NSString = "\(left)\(self.calcMultiplyDivision(str: middle))\(right)" as NSString
        return self.calcComplexStr(str:newStr)
    }
    
    // 获取字符串中的后置数字
    private func getLastStr(str:NSString) -> NSString {
        var numStartPoint:NSInteger = 0
        let tempMutArray:NSMutableArray = NSMutableArray.init()
        for tempStr in String(format:"%@", str).characters {
            tempMutArray.insert(tempStr, at: 0)
        }
        var i = 0
        for tempStr in tempMutArray {
            if ((String(describing: tempStr) as NSString).integerValue < 0 || (String(describing: tempStr) as NSString).integerValue > 9) && (String(describing: tempStr) as NSString) != "."
            {
                numStartPoint = i + 1
                break
            }
            i = i + 1
        }
        return str.substring(from: numStartPoint) as NSString
    }
    
    // 获取字符串中的前置数字
    private func getFirstStr(str:NSString) -> NSString {
        var numStartPoint:NSInteger = 0
        var i = 0
        for tempStr in (str as String).characters {
            if ((String(describing: tempStr) as NSString).integerValue < 0 || (String(describing: tempStr) as NSString).integerValue > 9) && (String(describing: tempStr) as NSString) != "."
            {
                numStartPoint = i
                break
            }
            i = i + 1
        }
        return str.substring(from: numStartPoint) as NSString
    }
    
    // 简单的科学计算
    func scientificComputingStrWithValue(str:String, value:Double) -> String {
        var returnDou:Double = 0
        switch str {
        case "sin":
            returnDou = sin(value)
            break
        case "cos":
            returnDou = cos(value)
            break
        case "tan":
            returnDou = tan(value)
            break
        case "asin":
            returnDou = asin(value)
            break
        case "acos":
            returnDou = acos(value)
            break
        case "atan":
            returnDou = atan(value)
            break
        case "sinh":
            returnDou = sinh(value)
            break
        case "cosh":
            returnDou = cosh(value)
            break
        case "tanh":
            returnDou = tanh(value)
            break
        case "asinh":
            returnDou = asinh(value)
            break
        case "acosh":
            returnDou = acosh(value)
            break
        case "atanh":
            returnDou = atanh(value)
            break
        case "e":
            returnDou = 2.718281828459
            break
        case "pi":
            returnDou = 3.1415926535898
            break
        case "epow"://e^x
            returnDou = pow(2.718281828459, value)
            break
        case "2pow":
            returnDou = pow(2, value)
            break
        case "log":
            returnDou = log(value)
            break
        case "sqrt":
            returnDou = sqrt(value)
            break
        case "cube":
            returnDou = pow(value, 1.0/3)
            break
        case "y^x"://y^x
//            returnDou = 3.1415926535898
            break
        case "˟√y"://˟√y
//            returnDou = 3.1415926535898
            break
        case "y^x"://y^x
//            returnDou = 3.1415926535898
            break
        default:
            break
        }
        return returnDou.description
    }
    
    let speedCalArray = [0.00, 105.00, 555.00, 1005.00, 2755.00, 5505.00, 13505.00]
    let taxRateArray = [0.03, 0.10, 0.20, 0.25, 0.30, 0.35, 0.45]
    let beyondArray = [1500.00, 4500.00, 9000.00, 35000.00, 55000.00, 80000.00]

    // 税率计算
    func taxCalculate(total:Double, section:Double, isTax:Bool) -> (String, String) {
        var tax:Double = 0.00
        var tempTotal = total
        if isTax {
            tempTotal = section
        }
        if section<beyondArray[0] {
            tax = tempTotal*taxRateArray[0]-speedCalArray[0]
        }
        else if section<beyondArray[1] {
            tax = tempTotal*taxRateArray[1]-speedCalArray[1]
        }
        else if section<beyondArray[2] {
            tax = tempTotal*taxRateArray[2]-speedCalArray[2]
        }
        else if section<beyondArray[3] {
            tax = tempTotal*taxRateArray[3]-speedCalArray[3]
        }
        else if section<beyondArray[4] {
            tax = tempTotal*taxRateArray[4]-speedCalArray[4]
        }
        else if section<beyondArray[5] {
            tax = tempTotal*taxRateArray[5]-speedCalArray[5]
        }
        else {
            tax = tempTotal*taxRateArray[6]-speedCalArray[6]
        }
        let revenue = total-tax
        return (tax.description, revenue.description)
    }
    
    // 年终奖
    func yearAwardCalculate(award:String) -> (String, String) {
        let total:Double = (award as NSString).doubleValue
        return self.taxCalculate(total: total, section: total/12, isTax: !true)
    }
    
    // 个税计算
    func aTaxCalculate(wage:String, indivPay:String) -> (String, String) {
        let total = (wage as NSString).doubleValue
        let section = total - (indivPay as NSString).doubleValue - 3500.0
        let (tax, revenue) = self.taxCalculate(total: total, section: section, isTax: true)
        return (tax, ((revenue as NSString).doubleValue-(indivPay as NSString).doubleValue).description)
    }
    
    // 房贷计算
    func mortgageCalculate(way:Int, money:Double, year:Int, rate:Double) -> (String, String) {
        var monthMoney:Double = 0
        var reduceMoney:Double = 0
        let moneyTemp = money*10000
        let rateTemp = rate/100.0/12.0
        switch way {
        case 0:
            // 等额本息
            monthMoney = moneyTemp*rateTemp*pow((1+rateTemp), Double(year)*12.0)/(pow((1+rateTemp), Double(year)*12.0)-1)
            break
        case 1:
            // 等额本金
            monthMoney = (moneyTemp/(Double(year)*12))+(moneyTemp-0)*rateTemp  // 首月已归还本金累计额为0
            reduceMoney = moneyTemp/(Double(year)*12)*rateTemp
            break
        default:
            break
        }
        return (NSString(format:"%.2f", monthMoney) as String, NSString(format:"%.2f", reduceMoney) as String)
    }

}


/*
        房贷计算公式说明
 
 　　　　根据还款方式一般房贷计算公式分为两种：
 
 　　　　一、等额本息计算公式
 
 　　　　每月月供额=〔贷款本金×月利率×(1＋月利率)＾还款月数〕÷〔(1＋月利率)＾还款月数-1〕
 
 　　　　每月应还利息=贷款本金×月利率×〔(1+月利率)^还款月数-(1+月利率)^(还款月序号-1)〕÷〔(1+月利率)^还款月数-1〕
 
 　　　　每月应还本金=贷款本金×月利率×(1+月利率)^(还款月序号-1)÷〔(1+月利率)^还款月数-1〕
 
 　　　　总利息=还款月数×每月月供额-贷款本金
 
 　　　　计算原则：银行从每月月供款中，先收剩余本金利息，后收本金；利息在月供款中的比例中随剩余本金的减少而降低，本金在月供款中的比例因而升高，但月供总额保持不变。
 
 
 　　　　二、等额本金计算公式
 
 　　　　每月月供额=(贷款本金÷还款月数)+(贷款本金-已归还本金累计额)×月利率
 
 　　　　每月应还本金=贷款本金÷还款月数
 
 　　　　每月应还利息=剩余本金×月利率=(贷款本金-已归还本金累计额)×月利率
 
 　　　　每月月供递减额=每月应还本金×月利率=贷款本金÷还款月数×月利率
 
 　　　　总利息=还款月数×(总贷款额×月利率-月利率×(总贷款额÷还款月数)*(还款月数-1)÷2+总贷款额÷还款月数)
 
 　　　　月利率=年利率÷12
 
 　　　　15^4=15×15×15×15(15的4次方,即4个15相乘的意思)
 
 　　　　计算原则：每月归还的本金额始终不变，利息随剩余本金的减少而减少。
 
 
 　　　　计算公式说明：
 
 　　　　以上算式中本金：贷款总额
 
 　　　　还款月数：贷款年限X12。例如贷款10年还款月数就是10X12=120个月
 
 　　　　月利率：月利率=年利率/12
 
 　　　　年利率：也就是现在讨论房贷热点里，基础利率打7折，85折后得出数字。
 
 　　　　累计还款总额：等额本金还款方式第一个月的累积还款总额为0。
 */
