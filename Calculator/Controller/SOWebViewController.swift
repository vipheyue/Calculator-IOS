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
    let myWebView = UIWebView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = true
        
        myWebView.delegate = self
        
        let url = NSURL(string: urlString!)
        
        myWebView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        self.view.addSubview(myWebView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if ((request.mainDocumentURL?.relativePath.range(of: ".html")) == nil) {
            navigationController?.popViewController(animated: true)
        }
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
