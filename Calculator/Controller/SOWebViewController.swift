//
//  SOWebViewController.swift
//  Calculator
//
//  Created by mei chen on 2018/9/5.
//  Copyright © 2018年 YC X. All rights reserved.
//

import UIKit

class SOWebViewController: UIViewController {
    
    // 屏幕的宽，高
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let webView = UIWebView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        let url = NSURL(string: "http://www.baidu.com")
        
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
