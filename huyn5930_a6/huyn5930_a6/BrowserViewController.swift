//
//  BrowserViewController.swift
//  huyn5930_a6
//
//  Created by Daniel H on 2020-04-06.
//  Copyright © 2020 Daniel H. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate {
    var webURL: String!
    let kHEADERHEIGHT : CGFloat = 44.0
     //let kHEADERHEIGHT : CGFloat = 0.0 // set it to 44.0 if you want a header
     let kFOOTERHEIGHT : CGFloat = 44.0
     
     var webView : WKWebView = WKWebView()
     var headerView : UIView = UIView()
     var footerView : UIView = UIView()
     
    var leftArrowButton = UIButton(type: UIButton.ButtonType.custom)
    var rightArrowButton = UIButton(type: UIButton.ButtonType.custom)
    var listButton = UIButton(type: UIButton.ButtonType.custom)
     
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem. = "Your Text"

        webView.allowsBackForwardNavigationGestures = true
        self.view.backgroundColor = UIColor.white
        self.headerView.backgroundColor = UIColor.gray
        self.footerView.backgroundColor = UIColor.gray
        
        // Image set
        self.leftArrowButton.setImage(UIImage(systemName: "arrow.left" ), for: [])
        // when user presses on the left arrow button, the method back is executed
        self.leftArrowButton.addTarget(self, action:#selector(back(_ : )), for: .touchUpInside)
        
        self.rightArrowButton.setImage(UIImage(systemName: "arrow.right" ), for: [])
        self.rightArrowButton.addTarget(self, action:#selector(forward(_ : )), for: .touchUpInside)
        

        
        self.view.addSubview(self.headerView) // we do not need the header for this example
        self.view.addSubview(self.webView)
        self.view.addSubview(self.footerView)
        self.view.addSubview(self.leftArrowButton)
        self.view.addSubview(self.rightArrowButton)
        
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest(url: NSURL(string: webURL)! as URL))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        self.headerView.frame = CGRect(origin: CGPoint(x:0, y:statusBarHeight), size: CGSize(width: self.view.frame.size.width, height: kHEADERHEIGHT))
        
        self.webView.frame = CGRect(origin: CGPoint(x:0, y:statusBarHeight+kHEADERHEIGHT), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - (statusBarHeight+kHEADERHEIGHT) - kFOOTERHEIGHT))
        
        self.footerView.frame = CGRect(origin: CGPoint(x:0, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: self.view.frame.size.width, height: kFOOTERHEIGHT))
        
        self.leftArrowButton.frame = CGRect(origin: CGPoint(x:5, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: kFOOTERHEIGHT, height: kFOOTERHEIGHT))
        
        
        self.rightArrowButton.frame = CGRect(origin: CGPoint(x:10 + kFOOTERHEIGHT, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: kFOOTERHEIGHT, height: kFOOTERHEIGHT))
        
        self.listButton.frame = CGRect(origin: CGPoint(x:self.view.frame.size.width - 85, y:self.view.frame.size.height - kFOOTERHEIGHT), size: CGSize(width: 80, height: kFOOTERHEIGHT))
    }
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("Start")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog("Failed Navigation %@", error.localizedDescription)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Finish navigation
        print("Finish Navigation")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        print("Title:%@ URL:%@", webView.title!, webView.url!)
    }
    

    
    @objc func back(_ sender: Any) {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        }
    } // back
    
    @objc func forward(_ sender: Any) {
        if (self.webView.canGoForward) {
            self.webView.goForward()
        }
    } // forward
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

         performSegue(withIdentifier: "unwindsegueToRoot", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
