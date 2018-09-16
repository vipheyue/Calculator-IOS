//
//  SOWebViewController.swift
//  Calculator
//
//  Created by mei chen on 2018/9/5.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class SOWebViewController: UIViewController, UIWebViewDelegate {
    
    // 屏幕的宽，高
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    var urlString:String?
    var isOtherCalculator:Bool = false
    
    let myWebView = UIWebView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setStatusBarBackgroundColor(color: .black)

        navigationController?.isNavigationBarHidden = true
        
        myWebView.delegate = self
        
        let url = NSURL(string: urlString!)
        
        myWebView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        self.view.addSubview(myWebView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        setStatusBarBackgroundColor(color: .clear)
    }
    
    // MARK: - 方法相关
    // 设置状态栏背景色
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    // MARK: - webView相关
    // webView请求方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (!isOtherCalculator && (request.mainDocumentURL?.relativeString.range(of: ".html")) == nil) {
            navigationController?.popViewController(animated: true)
        }
        if (isOtherCalculator && (request.mainDocumentURL?.relativeString.range(of: "https://m.rong360.com/calculator/")) != nil) {
            isOtherCalculator = false
        }
        return true;
    }

}
