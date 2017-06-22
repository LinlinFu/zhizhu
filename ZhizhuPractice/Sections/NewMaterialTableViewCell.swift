//
//  NewMaterialTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/15.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

public protocol NewMaterialCellDelegate: NSObjectProtocol {
    func materialValueChange(value: String, indexPath: NSIndexPath, isParse: Bool)
}

class NewMaterialTableViewCell: UITableViewCell {
    /// 左边标签
    internal var leftLab: UILabel!
    /// 右边标签
    private var rightLab: UILabel!
    /// next箭头
    private var nextArrow: UIImageView!
    /// 输入框
    internal var inputText: UITextField!
    /// 输入区域
    private var textView: IQTextView!
    /// 选择
    private var segmentedControl: CustomSegmentedControl!
    /// 当前cell的位置
    var indexPath = NSIndexPath(row: 0, section: 0)
    // delegate
    weak var delegate: NewMaterialCellDelegate?
    // data
    private var dataDict: [String: AnyObject]?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 选中风格无
        selectionStyle = .none
        buildSelectTypeView()
        buildInputTypeView()
        buildInputTextTypeView()
        buildTwoItemSelectedView()
    }
    // MARK: - 构建视图
    private func buildSelectTypeView() {
        leftLab = UILabel()
        leftLab.textColor = UIColor(hex: 0xb2bac4)
        leftLab.textAlignment = .left
        leftLab.font = UIFont.systemFont(ofSize: 14)
        leftLab.isHidden = true
        contentView.addSubview(leftLab)
        
        rightLab = UILabel()
        rightLab.textColor = ZZGray
        rightLab.textAlignment = .left
        rightLab.font = UIFont.systemFont(ofSize: 14)
        rightLab.isHidden = true
        contentView.addSubview(rightLab)
        
        nextArrow = UIImageView()
        nextArrow.image = UIImage(named: "next_arrow")
        nextArrow.isHidden = true
        contentView.addSubview(nextArrow)
    }
    
    private func buildInputTypeView() {
        inputText = UITextField()
        inputText.textAlignment = .left
        inputText.textColor = ZZGray
        inputText.font = UIFont.systemFont(ofSize: 14)
        inputText.isHidden = true
        inputText.delegate = self
        contentView.addSubview(inputText)
    }
    
    private func buildInputTextTypeView() {
        textView = IQTextView()
        textView.delegate = self
        textView.backgroundColor = UIColor.clear
        textView.textColor = ZZGray
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = true
        textView.isHidden = true
        contentView.addSubview(textView)
    }
    
    private func buildTwoItemSelectedView() {
        segmentedControl = CustomSegmentedControl()
        segmentedControl.segmentBlock = { (selected) in
            if let text = selected {
                var isParse = true
                if text == "男" || text == "女" {
                    isParse = false
                }
                self.delegate?.materialValueChange(value: text, indexPath: self.indexPath, isParse: isParse)
            }
        }
        segmentedControl.isHidden = true
        contentView.addSubview(segmentedControl)
    }
    // MARK: - frame调整
    override func layoutSubviews() {
        super.layoutSubviews()
        let fixHeight = CGFloat(Int(ZZScreenWidth * 0.13))
        let height = self.bounds.height
        leftLab.frame = CGRect(x: fixHeight * 0.5, y: 0,
                               width: ZZScreenWidth * 0.3, height: height)
        nextArrow.frame = CGRect(x: ZZScreenWidth - fixHeight * 0.9,
                                 y: (height - fixHeight * 0.4) * 0.5,
                                 width: fixHeight * 0.4,
                                 height: fixHeight * 0.4)
        inputText.frame = CGRect(x: fixHeight * 0.5 + ZZScreenWidth * 0.3, y: 0,
                                 width: ZZScreenWidth * 0.5, height: height)
        textView.frame = CGRect(x: fixHeight * 0.5, y: 0,
                                width: ZZScreenWidth - fixHeight, height: height)
        rightLab.frame = CGRect(x: fixHeight * 0.5 + ZZScreenWidth * 0.3, y: 0,
                                width: ZZScreenWidth * 0.48, height: height)
        segmentedControl.frame = CGRect(x: ZZScreenWidth * 0.63, y: height * 0.18,
                                        width: height * 2.48, height: height * 0.64)
    }
    // MARK: - 控制显示与隐藏
    // 选择模式
    private func showZeroType(text: String?, value: String?) {
        print("时间\(String(describing: text))  \(String(describing: value))")
        leftLab.isHidden = false
        rightLab.isHidden = false
        nextArrow.isHidden = false
        inputText.isHidden = true
        textView.isHidden = true
        segmentedControl.isHidden = true
        leftLab.text = text
        rightLab.text = value
    }
    // 输入框模式
    private func showOneType(text: String?, value: String?) {
        leftLab.isHidden = false
        rightLab.isHidden = true
        nextArrow.isHidden = true
        inputText.isHidden = false
        textView.isHidden = true
        segmentedControl.isHidden = true
        inputText.placeholder = "请输入"
        leftLab.text = text
        inputText.text = value
    }
    // 两项选择模式
    private func showTwoType(text: String?, tags: [String]?, value: String?) {
        leftLab.isHidden = false
        rightLab.isHidden = true
        nextArrow.isHidden = true
        inputText.isHidden = true
        textView.isHidden = true
        segmentedControl.isHidden = false
        leftLab.text = text
        segmentedControl.setSelectedTags(tags: tags)
        // 设置选中项
        var selectedIndex = 0
        if tags != nil {
            for (index, tag) in tags!.enumerated() {
                if tag == value {
                    selectedIndex = index
                    break
                }
            }
        }
        segmentedControl.selectedIndex = selectedIndex
    }
    // 提示文字模式
    private func showFourType(text: String?) {
        leftLab.isHidden = false
        rightLab.isHidden = true
        nextArrow.isHidden = true
        inputText.isHidden = true
        textView.isHidden = true
        segmentedControl.isHidden = true
        leftLab.text = text
    }
    // 输入区域模式
    private func showFiveType(text: String?, value: String?) {
        leftLab.isHidden = true
        rightLab.isHidden = true
        nextArrow.isHidden = true
        inputText.isHidden = true
        textView.isHidden = false
        segmentedControl.isHidden = true
        textView.placeholder = text!
        textView.text = value
    }
    internal func setCellRightLabValue(value: String) {
        rightLab.text = value
        rightLab.isHidden = false
    }
    
    internal func setCellData(data: [String: AnyObject], indexPath: NSIndexPath) {
        
        self.indexPath = indexPath
        guard let styleType = data["StyleType"] as? Int else {
            return
        }
        let text = data["TextName"] as? String
        let value = data["Value"] as? String
        switch styleType {
        case 0:
            print("拿到的data\(data)")
            showZeroType(text: text, value: value)
        case 1:
            showOneType(text: text, value: value)
        case 2:
            let tags = data["Options"] as? [String]
            showTwoType(text: text, tags: tags, value: value)
        case 4:
            showFourType(text: text)
        case 5:
            showFiveType(text: text, value: value)
        default:
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension NewMaterialTableViewCell: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 当输入的数据有内容，并且不为空
        guard let editText = textField.text else {
            return
        }
        guard editText.characters.count > 0 else {
            return
        }
        delegate?.materialValueChange(value: editText, indexPath: indexPath, isParse: false)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        // 当输入的数据有内容，并且不为空
        guard let editText = textView.text else {
            return
        }
        guard editText.characters.count > 0 else {
            return
        }
        delegate?.materialValueChange(value: editText, indexPath: indexPath, isParse: false)
    }
}

