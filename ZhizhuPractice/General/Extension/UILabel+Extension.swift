//
//  UILabel+Extension.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation

extension UILabel {
    
    /**
     根据字符串的的内容来计算UILabel的宽度
     
     - parameter text:      文字
     - parameter font:      字体大小
     - returns:             计算出来的宽度
     */
    
    internal class func weightForLabel(text: String?, font: UIFont) -> CGFloat {
        if text == nil {
            return 0
        }
        // 获取文字
        let text = NSString(format: "%@", text!)
        let attrbute = [NSFontAttributeName: font]
        let size = text.boundingRect(with: CGSize(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)),
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     attributes: attrbute, context: nil).size
        return size.width
    }

    
    /**
     根据字符串的的长度来计算UILabel的高度
     
     - parameter text:      文字
     - parameter font:  字体大小
     - parameter width:     UILabel的宽度
     - returns:             段落文字的高度
     */
    internal class func heightForLabel(text: NSString?,
                                       font: UIFont,
                                       width: CGFloat) -> CGFloat {
        // 设置文字的属性
        let attributes = [NSFontAttributeName: font]
        // 计算文字的高度
        let size = text?.boundingRect(with: CGSize(width: width, height: CGFloat(FLT_MAX)),
                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                      attributes: attributes, context: nil).size
        if size == nil {
            return 0.0
        }
        return size!.height
    }
    
    /**
     根据内容绘制文本标签
     
     - parameter vertex:     起点坐标
     - parameter font:       字体风格
     - parameter texts:      文本数组
     - parameter colors:     颜色数组
     - parameter textColors: 文字颜色数组
     - parameter spacing:    文本间距
     - parameter superView:    要放置的视图
     */
    internal class func drawTextLabel(vertex: CGPoint, font: UIFont,
                                      texts: [String], colors: [UIColor],
                                      textColors: [UIColor],
                                      spacing: CGFloat, superView: UIView) {
        var currentX: CGFloat = vertex.x
        let widthAdd: CGFloat = 8.0
        let heigthAdd: CGFloat = 4.0
        for index in 0..<texts.count {
            guard index < 3 else {
                return
            }
            // 获取文字
            let text = NSString(format: "%@", texts[index])
            let attrbute = [NSFontAttributeName: font]
            let size = text.boundingRect(with: CGSize(width: CGFloat(FLT_MAX), height: CGFloat(FLT_MAX)),
                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                         attributes: attrbute, context: nil).size
            let label = UILabel()
            label.tag = index + 1
            label.frame = CGRect(x: currentX, y: vertex.y,
                                 width: size.width + widthAdd, height: size.height + heigthAdd)
            label.text = texts[index]
            label.textColor = textColors[index]
            //      label.JMCornerRadiusWith(2, backgroundColor: colors[index])
            label.font = font
            label.textAlignment = .center
            superView.addSubview(label)
            
            currentX = currentX + size.width + spacing + widthAdd
        }
    }
    
}
