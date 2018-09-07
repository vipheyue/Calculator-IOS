//
//  MenuViewController.swift
//  hangge_1028
//
//  Created by hangge on 16/1/19.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var settingTableView: UITableView!
    
//    let titlesArray = [["换肤", "声音", "年终奖", "个税计算", "房贷计算器", "万能表达式", "大写人民币", "清理历史记录"],["意见反馈"]]
    let titlesArray = [["换肤", "声音", "个税计算", "大写人民币", "清理历史记录"],["意见反馈"]]
    let heightCell:CGFloat = 50
    
    typealias blockObject = () -> ()
    var blockObj:blockObject?
    var isClear:Bool? = !true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = titlesArray[indexPath.section][indexPath.row]
        cell.selectedBackgroundView = UIView.init(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(titlesArray[indexPath.section][indexPath.row])
        if (self.blockObj != nil) {
            self.blockObj!()
        }
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                // 换肤
                let themeColorVC:ThemeColorViewController = ThemeColorViewController.init()
                self.present(themeColorVC, animated: true, completion: nil)
                break
            case 1:
                // 声音
                let sound:Bool = UserDefaults.standard.bool(forKey: "SOUND")
                if sound != nil
                {
                    UserDefaults.standard.setValue(!sound, forKey: "SOUND")
                    if sound
                    {
                        XMessageView.messageShow("按键声关闭")
                    }
                    else {
                        XMessageView.messageShow("按键声打开")
                    }
                }
                else {
                    UserDefaults.standard.setValue(!true, forKey: "SOUND")
                }
                
                break
//            case 2:
//                // 年终奖
//                let yearAwardsVC:YearAwardsViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YearAwardsViewController") as! YearAwardsViewController
//                self.navigationController?.pushViewController(yearAwardsVC, animated: true)
////                self.present(yearAwardsVC, animated: true, completion: nil)
//                break
            case 2:
                // 个税计算
//                let aTaxCalVC:ATaxCalViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ATaxCalViewController") as! ATaxCalViewController
//                self.present(aTaxCalVC, animated: true, completion: nil)
                let webVC:SOWebViewController = SOWebViewController.init()
                webVC.urlString = "https://www.rong360.com/calculator/gerensuodeshui.html"
                self.navigationController?.pushViewController(webVC, animated: true)
                break
//            case 4:
//                // 房贷计算器
//                let mortagageVC:MortgageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MortgageViewController") as! MortgageViewController
//                self.present(mortagageVC, animated: true, completion: nil)
//                break
//            case 5:
//                // 万能表达式
//                let uniExpVC:UniExpressionViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UniExpressionViewController") as! UniExpressionViewController
//                self.present(uniExpVC, animated: true, completion: nil)
//                break
            case 3:
                // 大写人民币
                let capitalVC:CapitalViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CapitalViewController") as! CapitalViewController
                self.present(capitalVC, animated: true, completion: nil)
                break
            case 4:
                // 清空历史记录
                let historyData:NSMutableArray = NSMutableArray.init()
                let historyPlistPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/HistoryData.plist"
                historyData.write(toFile: historyPlistPath, atomically: true)
                XMessageView.messageShow("清除成功")
                self.isClear = true
                break
            default:
                break
            }
        }
        else if indexPath.section == 1
        {
            let alertViewController = UIAlertController(title: "联系方式", message: "邮箱:rumengjijiang@foxmail.com\nQQ群号:469859289", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: {
                action in print("onAction")
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "智能剪切板，复制后自动识别"
        }
        return ""
    }
    
}

//其他计算器:https://www.rong360.com/calculator/
//房贷:https://www.rong360.com/calculator/fangdai.html
//最新存款利率:https://www.rong360.com/cunkuanlilv.html
//车贷:https://www.rong360.com/calculator/quankuanmaiche.html
//五险一金:https://www.rong360.com/calculator/wuxianyijin.html
//年终奖:https://www.rong360.com/calculator/nianzhongjiang.html

