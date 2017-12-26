//
//  ViewController.swift
//  Calculator
//
//  Created by YC X on 2017/12/24.
//  Copyright © 2017年 YC X. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var cv: UICollectionView!
    
    private let inset:CGFloat = 1.0
    
    var dataMutaArray:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        cv.dataSource = self
        cv.delegate = self
        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"];
//        self.dataMutDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"ventilator"];
//        var plistPath:NSString =
    }

    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //返回记录数
        return 19;
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell:CollectionViewCell  = cv.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 11 || indexPath.row == 15 || indexPath.row == 18 {
            cell.backgroundColor = UIColor.orange
        }
        if indexPath.row == 0 {
            cell.label.text = "删除"
        }
        if indexPath.row == 1 {
            cell.label.text = "("
        }
        if indexPath.row == 2 {
            cell.label.text = ")"
        }
        if indexPath.row == 3 {
            cell.label.text = "\\"
        }
        if indexPath.row == 7 {
            cell.label.text = "*"
        }
        if indexPath.row == 11 {
            cell.label.text = "-"
        }
        if indexPath.row == 15 {
            cell.label.text = "+"
        }
        if indexPath.row == 17 {
            cell.label.text = "."
        }
        if indexPath.row == 18 {
            cell.label.text = "="
        }
        if indexPath.row >= 4 && indexPath.row <= 6{
            cell.label.text = "\(indexPath.row - 3)"
        }
        if indexPath.row >= 8 && indexPath.row <= 10{
            cell.label.text = "\(indexPath.row - 4)"
        }
        if indexPath.row >= 12 && indexPath.row <= 14{
            cell.label.text = "\(indexPath.row - 5)"
        }
        if indexPath.row == 16 {
            cell.label.text = "0"
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("select %@", indexPath.row)
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
}

