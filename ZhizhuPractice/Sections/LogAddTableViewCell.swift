//
//  LogAddTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddCellDelegate: NSObjectProtocol {
    func returnRemindTextCount(count:Int, text: String, tag: Int)
}

class LogAddTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var textView: IQTextView!
    
    @IBOutlet weak var textNumber: UILabel!
    var finalCount = 0
    var callBack: (()->())? = nil
    
    var delegate: AddCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        textView.delegate = self
    }

    // 新增日志
    func updateLogAddData(data: (topString: String, placeHolder: String)) {
        topLabel.text = data.topString
        textView.placeholder = data.placeHolder
        textNumber.text = "\(finalCount)/1500"
    
    }
    
    // 修改日志
    func modifyData(topString: String, model: LogWeekDetailModel, row: Int, descript: String, practice: String, standards: String) {
        topLabel.text = topString
        textView.tag = row
        
            switch row {
            case 0:
                textView.text = descript
                textNumber.text = "\(descript.characters.count)/1500"
            case 1:
                textView.text = practice
                textNumber.text = "\(practice.characters.count)/1500"
            case 2:
                textView.text = standards
                textNumber.text = "\(standards.characters.count)/1500"
            default:
                textView.text = ""
            }
        
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension LogAddTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let finalText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        finalCount = finalText.characters.count
        print(finalText)
        delegate.returnRemindTextCount(count: finalCount, text: finalText, tag: textView.tag)
        return true
    }
}
