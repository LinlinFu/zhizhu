//
//  RemindViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

enum RemindType: String {
    case failure = "failure"
    case success = "success"
    case loading = "loading"
}


@objc protocol RemindDelegate: NSObjectProtocol {
    @objc optional func remindDidDismiss(remindVC: RemindViewController)
    
    @objc optional func remindDidAppear(remindVC: RemindViewController)
    
}
class RemindViewController: BaseViewController {

   
    
    @IBOutlet weak var alertLabel: UILabel!
    
    /// 消失的必包
    var dismissHandle: (() -> ())? = nil
    
    /// 提醒的title
    var remindTitle: String = ""
    
    /// 提醒种类
    var remindType: RemindType = .success

    // MARK:- init
    
    init(title: String, type: RemindType = .failure) {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext
        self.definesPresentationContext = true
        self.remindTitle = title
        self.remindType = type
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
         alertLabel.text = self.remindTitle
        alertLabel.layer.masksToBounds = true
        alertLabel.layer.cornerRadius = 4
        self.view.backgroundColor = UIColor.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if self.remindType == .loading {
//            remindImgageViewRotation()
//        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.dismiss(animated: true, completion: nil)
            }
        
            
//        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissHandle?()
    }

//    private func remindImgageViewRotation() {
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAnimation.toValue = M_PI * 2.0
//        rotationAnimation.duration = 1
//        rotationAnimation.repeatCount = FLT_MAX
//        remindImageView.layer.add(rotationAnimation, forKey: "rotation")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   
}
