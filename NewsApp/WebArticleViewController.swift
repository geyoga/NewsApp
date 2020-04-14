//
//  WebArticleViewController.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 14/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit


class WebArticleViewController: UIViewController {

    var url : String?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
        // Do any additional setup after loading the view.
    }
    

}
