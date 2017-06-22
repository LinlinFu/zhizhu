//
//  UIColor+Extension.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation

extension UIColor {

    // 16进制颜色(0x)
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    // 16进制颜色(#)
    convenience init(hexString: String, defultColor: Int = 0xffffff, alpha: CGFloat = 1) {
        let newHex = hexString.replacingOccurrences(of: "#", with: "")
        let hexInt = Int(newHex,radix: 16) ?? defultColor
        self.init(hex: hexInt, alpha: alpha)
    }
    
    // 
    class func colorWithCustom(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    
}
