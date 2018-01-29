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
    
    let titlesDictionary = [["换肤", "万能表达式", "大写人民币", "清理历史记录"],["分享", "意见反馈"]]
    let heightCell:CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titlesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesDictionary[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel!.text = titlesDictionary[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(titlesDictionary[indexPath.section][indexPath.row])
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // 换肤
                let themeColorVC:ThemeColorViewController = ThemeColorViewController.init()
                self.present(themeColorVC, animated: true, completion: nil)
            }
            if indexPath.row == 1 {
                // 万能表达式
                let uniExpVC:UniExpressionViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UniExpressionViewController") as! UniExpressionViewController
                self.present(uniExpVC, animated: true, completion: nil)
            }
            if indexPath.row == 2 {
                // 大写人民币
                let capitalVC:CapitalViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CapitalViewController") as! CapitalViewController
                self.present(capitalVC, animated: true, completion: nil)
                //            self.navigationController?.pushViewController(capitalVC, animated: true)
            }
            if indexPath.row == 3 {
                // 清空历史记录
                let historyData:NSMutableArray = NSMutableArray.init()
                let historyPlistPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/HistoryData.plist"
                historyData.write(toFile: historyPlistPath, atomically: true)
                XMessageView.messageShow("清除成功")
//                ViewController.animateMainView(true)
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "智能剪切板，复制后自动识别"
        }
        return ""
    }
    
}

