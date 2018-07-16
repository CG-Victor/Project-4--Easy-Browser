//
//  ViewController.swift
//  project4
//
//  Created by Chris Gonzaga on 3/21/18.
//  Copyright © 2018 Chris Gonzaga324243. All rights reserved.
//

import WebKit
import UIKit

class ViewController: UIViewController,  WKNavigationDelegate {
    var webView: WKWebView! // these are properties
    var progressView: UIProgressView!
    
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() { // so loadView is part of UIView// or webKit
        webView = WKWebView()//creating new instance of WKWebview component
        webView.navigationDelegate = self // and assign it to the WebView property
        view = webView // making our view, root view of VC, that web view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped)) // it's a title here instead of a symbol.
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        progressView = UIProgressView(progressViewStyle: .default) //progressview, declared outside. same like equal sign the "default base."
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView) // UIPro being wrappedinto UIBarButton. now prog will be put in toolbarItems // BULT IN, THE PROGRESSVIEW. All it odes is shows the progressview. But is isn't active// **Again, needs to be wrapped up
        
        // flexible space, no need action really, or webview. just wants space...spacers cant be tapped.
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        // calling method on its webview, rather than on our own.
        
        toolbarItems = [progressButton, spacer, refresh] // all vc's have this
        navigationController?.isToolbarHidden = false // so tool bar can be shown
        // last
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        //we're observer, self. what property we want to observe(estimated progress), which value we want to set: the one that's just set, and context. // estimatedProgress will be used at bot.
        
        // remember, progressView is we created
    }
   
    @objc func openTapped() { // we don't need a message, so nil
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        // adds a action button for every website it has
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel)) // no handler needed
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    // UIAlertAction, is opening from the handler.
    func openPage(action: UIAlertAction) { // parameter, that was selected by the user, powerful. it's a class.
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // a delegate?
        title = webView.title // this still scomes from the constant, let webView: WKWebView
        // updates vc's title property to be title of the webview, sets the page title of the web page that is recently loaded
        
        // this reminds of a "Nuetral" func. like table view. we are just putting the title on it
    }
    
    // tells you when an observed value has changed. necessary.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" { // set here, and remember it's above(on viewDidLoad)
            progressView.progress = Float(webView.estimatedProgress) // a data type we declared, progressview.
        }
        
        // all we care is whether keyPath parameter is set to estimated Progress, if estiamtedProgress value of the web has changed.
        // if it has, set the progress property of our progress iew to the new estimatedProgress value
    }

    
    // this one's a delegate! // decision handler, cal parameter, calls the func?..
    // this also filters out nonsafe website. Only useful for websites that are narrowly listed.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url // navigation comes from the parameter
        // making the url constant to URL of navigation
        
        if let host = url!.host { // un wrap the value of optional url.host. URL does alot of work for you in parsing url's properly. If this is a host for this URL, pul it outt. host like website domain, apple.com. Unwrap b/c not all urls have hosts.
            for website in websites { // 3, we loop through lal sites, placing name of site in website varible.
                if host.range(of: website) != nil { // 4 use range of, to see whether each safe site exists in host name
                    decisionHandler(.allow) // further more, if site was found, if range is not nil(means, it exists) then we call the decision handler with positive response. allow loading
                    return // if we site found after calling decision handler, return, aka exit method now
                }
            }
        }
        decisionHandler(.cancel) // Last, if there is no host set, or** if we've gone through all the loop and found nothing, we call the decision handler with a negative response: cancel loading.
    } // notice the 2 if's.
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


























