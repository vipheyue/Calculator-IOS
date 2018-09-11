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
//    let titlesArray = [["换肤", "声音", "个税计算", "大写人民币", "清理历史记录"],["意见反馈"]]
    let titlesArray = [["日常计算器", "个税计算器", "税后计算器", "房贷计算器", "车贷计算器", "其他计算器", "年终奖", "大写人民币", "最新存款利率"],["换肤", "分享", "意见反馈", "开/关 音效", "清理历史记录"]]
    let heightCell:CGFloat = 50
    
    typealias blockObject = () -> ()
    var blockObj:blockObject?
    var isClear:Bool? = !true
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "智能计算器"
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
    }
    
    // MARK: - 方法相关
    // 加载webView
    func loadWebView(urlStr:String) {
        let webVC:SOWebViewController = SOWebViewController.init()
        webVC.urlString = urlStr
        if urlStr == "https://www.rong360.com/calculator" {
            webVC.isOtherCalculator = true
        }
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    // MARK: - tableview相关
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
        let selectStr = titlesArray[indexPath.section][indexPath.row]
        if selectStr == "日常计算器" {
            navigationController?.popViewController(animated: true)
        }
        else if selectStr == "个税计算器" {
            loadWebView(urlStr: "https://www.rong360.com/calculator/gerensuodeshui.html")
        }
        else if selectStr == "税后计算器" {
            loadWebView(urlStr: "https://www.rong360.com/calculator/wuxianyijin.html")
        }
        else if selectStr == "房贷计算器" {
            loadWebView(urlStr: "https://www.rong360.com/calculator/fangdai.html")
        }
        else if selectStr == "车贷计算器" {
            loadWebView(urlStr: "https://www.rong360.com/calculator/quankuanmaiche.html")
        }
        else if selectStr == "其他计算器" {
            loadWebView(urlStr: "https://www.rong360.com/calculator")
        }
        else if selectStr == "年终奖" {
            loadWebView(urlStr: "https://www.rong360.com/calculator/nianzhongjiang.html")
        }
        else if selectStr == "大写人民币" {
            let capitalVC:CapitalViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CapitalViewController") as! CapitalViewController
            navigationController?.pushViewController(capitalVC, animated: true)
        }
        else if selectStr == "最新存款利率" {
            loadWebView(urlStr: "https://www.rong360.com/cunkuanlilv.html")
        }
        else if selectStr == "换肤" {
            let themeColorVC:ThemeColorViewController = ThemeColorViewController.init()
            navigationController?.pushViewController(themeColorVC, animated: true)
        }
        else if selectStr == "分享" {
            // TODO: - 暂未完成
            XMessageView.messageShow("敬请期待")
        }
        else if selectStr == "意见反馈" {
            let alertViewController = UIAlertController(title: "联系方式", message: "邮箱:rumengjijiang@foxmail.com\nQQ群号:469859289", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: {
                action in print("onAction")
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
        else if selectStr == "开/关 音效" {
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
        }
        else if selectStr == "清理历史记录" {
            let historyData:NSMutableArray = NSMutableArray.init()
            let historyPlistPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/HistoryData.plist"
            historyData.write(toFile: historyPlistPath, atomically: true)
            XMessageView.messageShow("清除成功")
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "智能剪切板，复制后自动识别"
        }
        return ""
    }
}

