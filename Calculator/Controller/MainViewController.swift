//
//  ViewController.swift
//  Calculator
//
//  Created by YC X on 2017/12/24.
//  Copyright © 2017年 YC X. All rights reserved.
//

import UIKit
import AudioToolbox
import StoreKit

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

    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 状态栏字体颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        // 导航栏标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        // 导航栏左右两边字体颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // 导航栏透明背景
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        // 导航栏和状态栏背景颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 46/255.0, green: 178/255.0, blue: 151/255.0, alpha: 1)
        
        self.loadLeftBtnView()
        
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
        
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - 加载视图相关
    // 加载左上角按钮
    func loadLeftBtnView() {
        let leftBtn:UIButton = UIButton(frame: CGRect(x: 20, y: 20, width: 36, height: 36))
        leftBtn.setBackgroundImage(UIImage.init(named: "More1"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(leftBtnEvent), for: .touchUpInside)
        self.view.addSubview(leftBtn)
    }
    
    // 加载弹窗视图
    func loadAlertView() {
        var titleStr = "家境贫寒,靠写代码为生,软件无广告无盈利,只求5星鼓励"
        if UserDefaults.standard.bool(forKey: "GOTOMENU") {
            titleStr = "请书写评论，如果不想书写，返回即可，只求鼓励"
        }
        let alertController = UIAlertController(title: titleStr,
                                                message: nil, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "暂不评价", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "去评价", style: .default,
                                     handler: {
                                        action in
                                        self.storeReview()
        })
//        if UserDefaults.standard.bool(forKey: "GOTOMENU") {
//            alertController.addAction(cancelAction)
//        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // 跳转到应用的AppStore页页面
    func gotoAppStore() {
        
        let urlString = "itms-apps://itunes.apple.com/app/id1352912463?action=write-review"
        let url = NSURL(string: urlString)
        let success = UIApplication.shared.openURL(url! as URL)
        if success {
            UserDefaults.standard.set(true, forKey: "GOTOAPPSTORE")
        }
    }
    
    // 应用内评分
    func storeReview() {
        if #available(iOS 10.3, *) {
            
            if !UserDefaults.standard.bool(forKey: "GOTOMENU"){
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: "GOTOAPPSTORE")
            }
            else {
                gotoAppStore()
            }
        } else {
            // Fallback on earlier versions
            gotoAppStore()
        }
    }
    
    // MARK: - 获取数据相关
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
    
    // MARK: - 事件相关方法
    // 左上角按钮点击
    @objc func leftBtnEvent() {
        print("leftBtnEvent")
        if XTimer.compareNowTime("2018-09-21 23:00:00") {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
            let mainVC:MenuViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuView") as! MenuViewController
            self.navigationController?.pushViewController(mainVC, animated: true)
            return
        }
        if UserDefaults.standard.bool(forKey: "GOTOAPPSTORE")
        {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
            let mainVC:MenuViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuView") as! MenuViewController
            self.navigationController?.pushViewController(mainVC, animated: true)
            if !UserDefaults.standard.bool(forKey: "GOTOMENU") {
                UserDefaults.standard.set(false, forKey: "GOTOAPPSTORE")
                UserDefaults.standard.set(true, forKey: "GOTOMENU")
            }
        }
        else {
            loadAlertView()
        }
    }
    
    // 长按手势
    @objc func handleLongpressGesture(sender : UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            showLabel.text = ""
            isCalc = false
        }
    }

    // MARK: - collectionView相关
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
            return CGSize(width: cellWidth/2-0.5, height: cellHeight*0.6/5)
        }
        return CGSize(width: (cellWidth-3)/4, height: cellHeight*0.6/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return inset
    }
    
    // MARK: - tableView相关
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

