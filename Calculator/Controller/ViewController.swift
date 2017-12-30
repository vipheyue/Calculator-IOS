//
//  ViewController.swift
//  Calculator
//
//  Created by YC X on 2017/12/24.
//  Copyright © 2017年 YC X. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var showLabel: UILabel!
    
    let inset:CGFloat = 1.0
    let heightCell:CGFloat = 30
    
    var dataArray:NSArray?
    var isCalc:Bool = true
    var historyData:NSMutableArray = NSMutableArray.init()
    let historyPlistPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/HistoryData.plist"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        collectionView.dataSource = self
        collectionView.delegate = self
        tabelView.dataSource = self
        tabelView.delegate = self
        
        let nib:UINib = UINib(nibName:"TableViewCell", bundle: Bundle.main)
        tabelView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        let diaryList:String = Bundle.main.path(forResource: "Data", ofType:"plist")!
        let data:NSDictionary = NSDictionary(contentsOfFile:diaryList)!
        dataArray = data.object(forKey: "DataArray") as? NSArray
        
        if NSMutableArray(contentsOfFile: historyPlistPath) != nil
        {
            self.historyData = NSMutableArray(contentsOfFile: historyPlistPath)!
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
        if indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 11 || indexPath.row == 15 || indexPath.row == 18 {
            cell.backgroundColor = UIColor.orange
        }
        cell.label.text = dataArray?[indexPath.row] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 删除
        if isCalc || ((showLabel.text?.range(of: "=")) != nil){
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
        // 运算结果
        if indexPath.row == (dataArray?.count)!-1 {
            showLabel.text = "\(showLabel.text ?? "")\(dataArray![indexPath.row])\(XCalculateString().calcComplexStr(str:showLabel.text! as NSString))"
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
        if indexPath.row == 16 {
            return CGSize(width: cellWidth/2-1, height: cellWidth/4.0/1.5)
        }
        return CGSize(width: (cellWidth-5)/4, height: cellWidth/4.0/1.5)
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
        return heightCell;
    }
}

