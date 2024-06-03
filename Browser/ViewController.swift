// Last Updated: 2 June 2024, 3:42PM.
// Copyright © 2024 Gedeon Koh All rights reserved.
// No part of this publication may be reproduced, distributed, or transmitted in any form or by any means, including photocopying, recording, or other electronic or mechanical methods, without the prior written permission of the publisher, except in the case of brief quotations embodied in reviews and certain other non-commercial uses permitted by copyright law.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// Use of this program for pranks or any malicious activities is strictly prohibited. Any unauthorized use or dissemination of the results produced by this program is unethical and may result in legal consequences.
// This code have been tested throughly. Please inform the operator or author if there is any mistake or error in the code.
// Any damage, disciplinary actions or death from this material is not the publisher's or owner's fault.
// Run and use this program this AT YOUR OWN RISK.
// Version 0.1

// This Space is for you to experiment your codes
// Start Typing Below :) ↓↓↓

import UIKit
import WebKit

class ViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var barView: UIView!
  @IBOutlet weak var urlField: UITextField!
  @IBOutlet weak var backButton: UIBarButtonItem!
  @IBOutlet weak var forwardButton: UIBarButtonItem!
  @IBOutlet weak var reloadButton: UIBarButtonItem!
  
  // MARK: - Parameters
  var urlStr: String = "https://www.apple.com"
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    urlField.delegate = self
    
    backButton.isEnabled = false
    forwardButton.isEnabled = false
    
    webView.navigationDelegate = self
    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
    webView.load(urlStr)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "loading" {
      backButton.isEnabled = webView.canGoBack
      forwardButton.isEnabled = webView.canGoForward
    } else if keyPath == "estimatedProgress" {
      progressBar.isHidden = webView.estimatedProgress == 1
      progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
    }
  }
  
  // MARK: - Actions
  @IBAction func back(_ sender: Any) {
    webView.goBack()
  }
  
  @IBAction func forward(_ sender: Any) {
    webView.goForward()
  }
  
  @IBAction func reload(_ sender: Any) {
    webView.reload()
  }
}

// MARK: - WKNavigationDelegate
extension ViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
    urlField.text = webView.url?.absoluteString
    
    progressBar.setProgress(0.0, animated: false)
  }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    urlField.resignFirstResponder()
    if let str = textField.text {
      urlStr = "https://" + str
      webView.load(urlStr)
    }
    
    return false
  }
}

// MARK: - WKWebView Extension
extension WKWebView {
  func load(_ urlString: String) {
    
    if let url = URL(string: urlString) {
      let request = URLRequest(url: url)
      load(request)
    }
  }
}
