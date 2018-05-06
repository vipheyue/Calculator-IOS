//
//  ViewController.swift
//  Calculator
//
//  Created by YC X on 2017/12/24.
//  Copyright © 2017年 YC X. All rights reserved.
//

import UIKit
import AudioToolbox

class MainViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var showLabel: UILabel!
    
    let inset:CGFloat = 1.0
    let heightCell:CGFloat = 26
    
    var dataArray:NSArray?
    var isCalc:Bool = true
    var historyData:NSMutableArray = NSMutableArray.init()
    let historyPlistPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/HistoryData.plist"
    
    var calcComplexStr:String = "0"
    
    var themeColor:UIColor? = UIColor.init(red: 247/255.0, green: 18/255.0, blue: 188/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.7)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        collectionView.dataSource = self
        collectionView.delegate = self
        tabelView.dataSource = self
        tabelView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = !true
        
        self.showLabel.lineBreakMode = NSLineBreakMode.byTruncatingHead
        
        let nib:UINib = UINib(nibName:"TableViewCell", bundle: Bundle.main)
        tabelView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        let diaryList:String = Bundle.main.path(forResource: "Data", ofType:"plist")!
        let data:NSDictionary = NSDictionary(contentsOfFile:diaryList)!
        dataArray = data.object(forKey: "DataArray") as? NSArray
        
        if NSMutableArray(contentsOfFile: historyPlistPath) != nil
        {
            self.historyData = NSMutableArray(contentsOfFile: historyPlistPath)!
        }
        
        let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
        myAppdelegate.blockObj = {(param: String) in
            print(param)
//            self.showLabel.text = self.getExpressionFromStr(str: param)
            
            let allRight:Bool = MSExpressionHelper.helperCheckExpression(param, using: nil)
            if(allRight){
                //计算表达式
                let calcStr:NSString = MSParser.parserComputeExpression(param, error: nil) as! NSString
                if ((calcStr.range(of: ".", options: NSString.CompareOptions.backwards).length != 0) && (calcStr.substring(from: (calcStr.range(of: ".", options: NSString.CompareOptions.backwards)).location)).count > 4)
                {
                    self.calcComplexStr = NSString(format:"%.4f",calcStr.doubleValue) as String
                    while self.calcComplexStr.last == "0"
                    {
                        self.calcComplexStr.remove(at: self.calcComplexStr.index(before: self.calcComplexStr.endIndex))
                    }
                }
                else {
                    self.calcComplexStr = calcStr as String
                }
                
            }
            else {
                self.isCalc = false
//                XMessageView.messageShow("输入的表达式不对哦!")
                return
            }
            
            print(self.calcComplexStr,self.showLabel.text!)
            
            self.showLabel.text = "\(param ?? "")=\(self.calcComplexStr)"
            self.isCalc = true
            // 保存历史数据
            self.historyData.add(self.showLabel.text!)
            self.historyData.write(toFile: self.historyPlistPath, atomically: true)
            print(self.historyData)
            self.tabelView.reloadData()
        } 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let red:CGFloat = CGFloat(UserDefaults.standard.float(forKey: "RED"))
        let green:CGFloat = CGFloat(UserDefaults.standard.float(forKey: "GREEN"))
        let blue:CGFloat = CGFloat(UserDefaults.standard.float(forKey: "BLUE"))

        if red == nil {
            self.themeColor = UIColor.init(red: 247/255.0, green: 18/255.0, blue: 188/255.0, alpha: 1)
        }
        else {
            self.themeColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        }

        self.getHistoryData()
        self.collectionView.reloadData()
    }
    
    // 获取历史记录
    func getHistoryData() {
        let diaryList:String = Bundle.main.path(forResource: "Data", ofType:"plist")!
        let data:NSDictionary = NSDictionary(contentsOfFile:diaryList)!
        self.dataArray = data.object(forKey: "DataArray") as? NSArray
        
        if NSMutableArray(contentsOfFile: historyPlistPath) != nil
        {
            self.historyData = NSMutableArray(contentsOfFile: historyPlistPath)!
        }
        self.tabelView.reloadData()
    }
    
    // 获取剪切板中的表达式
    func getExpressionFromStr(str:String) -> String {
        var tempFirst:Int = -1
        var tempLast:Int = 0
        var tempCount:Int = 0
        for tempStr in str.characters {
            if tempFirst == -1 && (((String(describing: tempStr) as NSString).integerValue > 0 && (String(describing: tempStr) as NSString).integerValue <= 9) || (String(describing: tempStr) as NSString) == "-" || (String(describing: tempStr) as NSString) == "(" || (String(describing: tempStr) as NSString) == "+" || (String(describing: tempStr) as NSString).isEqual(to: "0"))
            {
                tempFirst = tempCount
                tempLast = tempCount
            }
            if tempFirst != -1 && !(((String(describing: tempStr) as NSString).integerValue > 0 && (String(describing: tempStr) as NSString).integerValue <= 9) || (String(describing: tempStr) as NSString) == "-" || (String(describing: tempStr) as NSString) == "(" || (String(describing: tempStr) as NSString) == "+" || (String(describing: tempStr) as NSString) == "=" || (String(describing: tempStr) as NSString) == "*" || (String(describing: tempStr) as NSString) == "/" || (String(describing: tempStr) as NSString) == ")" || (String(describing: tempStr) as NSString).isEqual(to: "0"))
            {
                tempLast = tempCount - 1
                break
            }
            if tempCount == str.count-1 && (((String(describing: tempStr) as NSString).integerValue > 0 && (String(describing: tempStr) as NSString).integerValue <= 9) || (String(describing: tempStr) as NSString) == "-" || (String(describing: tempStr) as NSString) == "(" || (String(describing: tempStr) as NSString) == "+" || (String(describing: tempStr) as NSString) == "=" || (String(describing: tempStr) as NSString) == "*" || (String(describing: tempStr) as NSString) == "/" || (String(describing: tempStr) as NSString) == ")" || (String(describing: tempStr) as NSString).isEqual(to: "0"))
            {
                tempLast = tempCount
            }
            tempCount = tempCount + 1
        }
        print(str, tempLast, tempFirst)
        if tempFirst != -1 {
            return (String(describing: str) as NSString).substring(with: NSMakeRange(tempFirst, tempLast-tempFirst+1))
        }
        return ""
    }
    
    // 长按手势
    @objc func handleLongpressGesture(sender : UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            showLabel.text = ""
            isCalc = false
        }
    }

    // collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (dataArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell:CollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.row == 0 {
            cell.label.font = UIFont.systemFont(ofSize: 20)
            // 添加长按手势
            let longpressGesutre = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongpressGesture(sender:)))
            longpressGesutre.minimumPressDuration = 1
            longpressGesutre.numberOfTouchesRequired = 1
            cell.addGestureRecognizer(longpressGesutre)
        }
        if indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 11 || indexPath.row == 15 || indexPath.row == 18 {
//            cell.backgroundColor = UIColor.init(red: 247/255.0, green: 18/255.0, blue: 188/255.0, alpha: 1)
            cell.backgroundColor = self.themeColor
            cell.label.textColor = UIColor.white
        }
        else {
            cell.backgroundColor =  UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
            cell.label.textColor = UIColor.black
        }
        cell.label.text = dataArray?[indexPath.row] as? String
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 震动
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        // 咚咚咚声音
        let sound:Bool = UserDefaults.standard.bool(forKey: "SOUND")
        if sound != nil
        {
            if sound
            {
                // 咚咚咚 拨号声
//                AudioServicesPlaySystemSound(1201)
                // 塔塔塔 苹果计算器按键声，键盘声
                AudioServicesPlaySystemSound(1104)
            }
        }
        else {
            AudioServicesPlaySystemSound(1104)
        }
        
        if ((showLabel.text?.range(of: "=")) != nil) && indexPath.row == 18{
            return
        }
        // 连续计算
        if ((showLabel.text?.range(of: "=")) != nil) && (indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 11 || indexPath.row == 15) {
            isCalc = false
            showLabel.text = calcComplexStr
        }
        // 删除
        if ((showLabel.text?.range(of: "=")) != nil){
            isCalc = false
            showLabel.text = ""
        }
        if !isCalc && indexPath.row == 0  {
            if showLabel.text?.count == 1 || showLabel.text?.count == 0 {
                showLabel.text = ""
            }
            else {
                showLabel.text?.removeLast()
            }
        }
        // 记录数字键
        if indexPath.row != 0 && indexPath.row != (dataArray?.count)!-1 {
            showLabel.text = "\(showLabel.text ?? "")\(dataArray![indexPath.row])"
        }
        if showLabel.text?.count == 14 || showLabel.text?.count == 18
        {
            showLabel.font = UIFont.systemFont(ofSize: 30)
        }
        if showLabel.text?.count == 20
        {
            showLabel.font = UIFont.systemFont(ofSize: 20)
        }
        if showLabel.text?.count == 12 || showLabel.text?.count == 1
        {
            showLabel.font = UIFont.systemFont(ofSize: 40)
        }
        
        // 运算结果
        if indexPath.row == (dataArray?.count)!-1 {
            let allRight:Bool = MSExpressionHelper.helperCheckExpression(showLabel.text, using: nil)
            if(allRight){
                //计算表达式
                let calcStr:NSString = MSParser.parserComputeExpression(showLabel.text, error: nil)! as NSString
                if ((calcStr.range(of: "e+", options: NSString.CompareOptions.backwards).length == 0) && (calcStr.range(of: ".", options: NSString.CompareOptions.backwards).length != 0) && (calcStr.substring(from: (calcStr.range(of: ".", options: NSString.CompareOptions.backwards)).location)).count > 4)
                {
                    calcComplexStr = NSString(format:"%.4f",calcStr.doubleValue) as String
                    while calcComplexStr.last == "0"
                    {
                        calcComplexStr.remove(at: calcComplexStr.index(before: calcComplexStr.endIndex))
                    }
                }
                else {
                    calcComplexStr = calcStr as String
                }
            }
            else {
                isCalc = false
                XMessageView.messageShow("输入的表达式不对哦!")
                return
            }

            print(calcComplexStr,showLabel.text!)
            
            showLabel.text = "\(showLabel.text ?? "")\(dataArray![indexPath.row])\(calcComplexStr)"
            isCalc = true
            // 保存历史数据
            self.historyData.add(showLabel.text!)
            self.historyData.write(toFile: historyPlistPath, atomically: true)
            print(self.historyData)
            self.tabelView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = self.view.frame.size.width
        let cellHeight:CGFloat = self.view.frame.size.height
        if indexPath.row == 16 {
            return CGSize(width: cellWidth/2-1, height: cellHeight*0.6/5)
        }
        return CGSize(width: (cellWidth-5)/4, height: cellHeight*0.6/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset/2, bottom: inset, right: inset/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    // tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.recordLabel.text = self.historyData[indexPath.row] as? String
        if isCalc {
            isCalc = false
            self.tabelView.scrollToRow(at: NSIndexPath.init(row: self.historyData.count-1, section: 0) as IndexPath, at: UITableViewScrollPosition.top, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TableViewCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        UIPasteboard.general.string = cell.recordLabel.text
        XMessageView.messageShow("成功复制:"+(cell.recordLabel.text)!)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
        self.historyData.removeObject(at: indexPath.row)
        self.historyData.write(toFile: historyPlistPath, atomically: true)
        self.tabelView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
}

