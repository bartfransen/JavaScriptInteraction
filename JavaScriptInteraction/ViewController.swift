//
//  ViewController.swift
//  JavaScriptInteraction
//
//  Created by Bart Fransen on 2016-11-16.
//  Copyright © 2016 Bart Fransen. All rights reserved.
//

import UIKit
// YOU'LL NEED TO ADD THIS IMPORT
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {

  // THIS IS NOW A WKWEBVIEW. UIWEBVIEW HAS BEEN DEPRECATED.
  var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let config = WKWebViewConfiguration()
    
    // THE NAME PARAMETER YOU USE HERE IS THE ONE YOU USE IN THE
    // window.webkit.messageHandlers.scanBarcode.postMessage 
    // CALL ON THE HTML PAGE.
    config.userContentController.add(self, name: "scanBarcode")
    
    // REPLACE WITH ACTUAL URL.
    if let path = Bundle.main.path(forResource: "index", ofType: ".html") {
      let url = URL(fileURLWithPath: path)
      let request = URLRequest(url: url)
      
      // YOU HAVE TO CREATE THE WKWEBVIEW IN CODE TO PASS THE CUSTOM CONFIGURATION.
      // NO MORE STORYBOARD
      self.webView = WKWebView(
        frame: self.view.bounds,
        configuration: config
      )
      self.view = self.webView!
      
      webView.load(request)
    }
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
    if (message.name == "scanBarcode") {
      // IF YOU NEED IT, YOU CAN USE message.body TO PASS STUFF FROM THE HTML PAGE TO THE VC
      print("Trigger to scan received with content: [\(message.body)]")
      
      // SCAN THE BARCODE
      
      // GENERATING CURRENT DATE TO PASS BACK TO THE HTML PAGE
      let scannedBarcode = Date()
      let javascript = "handleBarCodeScanReturn(\"\(scannedBarcode)\");"
      
      print("Executing javascript: [\(javascript)]")
      webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
  }
}
