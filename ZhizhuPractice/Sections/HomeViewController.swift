//
//  HomeViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "知筑实习"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        
    }
    
    func addAction() {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
