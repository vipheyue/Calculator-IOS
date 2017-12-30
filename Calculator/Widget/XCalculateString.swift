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
}
