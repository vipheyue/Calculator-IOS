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
    
    let titlesDictionary = [["换肤", "按键声", "万能表达式", "大小写转换"],["亲戚计算器", "意见反馈"]]
    
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
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(titlesDictionary[indexPath.section][indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "特色服务"
        }
        return ""
    }
    
}

