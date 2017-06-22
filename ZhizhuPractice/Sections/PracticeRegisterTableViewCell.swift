//
//  PracticeRegisterTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
protocol RegisterCellDelegate {
    func getTextFieleContent(text: String, tag: Int)
}

class PracticeRegisterTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var rightTextField: UITextField!
    
    var delegate: RegisterCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightTextField.delegate = self
        selectionStyle = .none
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // 填写注册信息
    func updateInfo(indexpath: IndexPath, address: String, startTime: String, endTime: String) {
        let row = indexpath.row
        rightTextField.tag = row
        switch row {
        case 0:
            if startTime == "" {
                rightLabel.text = "请选择实习起始时间"
            } else if endTime == "" {
                rightLabel.text = "\(ZZHelper.timeFormat(timeStamp: startTime, format: "yyyy/MM/dd"))-"
            } else {
                rightLabel.text = "\(ZZHelper.timeFormat(timeStamp: startTime, format: "yyyy/MM/dd"))-" + "\(ZZHelper.timeFormat(timeStamp: endTime, format: "yyyy/MM/dd"))"
            }
            rightTextField.isHidden = true
            rightLabel.isHidden = false
        case 1:
            rightTextField.placeholder = "请填写实习单位"
            rightTextField.isHidden = false
            rightLabel.isHidden = true
        case 2:
            if address != "" {
                rightLabel.text = address
            } else {
                rightLabel.text = "请选择所在地区"
            }
            
            rightTextField.isHidden = true
            rightLabel.isHidden = false
        default:
            rightTextField.placeholder = "请填写详细地址"
            rightTextField.isHidden = false
            rightLabel.isHidden = true
            
        }
    }
    
    // 显示注册信息
    func updateList(model: RegisterModel, indexpath: IndexPath) {
        rightTextField.isHidden = true
        let section = indexpath.section
        let row = indexpath.row
        var rightLabelText = ""
        switch section {
        case 0:
            switch row {
            case 0:
                rightLabelText = "\(ZZHelper.timeFormat(timeStamp: model.startTime, format: "yyyy/MM/dd"))-\(ZZHelper.timeFormat(timeStamp: model.endTime, format: "yyyy/MM/dd"))"
            case 1:
                rightLabelText =  model.company
            case 2:
                rightLabelText = model.area
            case 3:
                rightLabelText = model.address
            default:
                rightLabelText = ""
            }
        case 1:
            if  model.status == 0 {
                switch row {
                case 0:
                    rightLabelText = "审核中"
                default:
                    rightLabelText = "-"
                }
            } else {
                switch row {
                case 0:
                    switch model.auditRecordList[0].status {
                    case 1:
                        rightLabelText = "审核通过"
                    default:
                        rightLabelText = "未确定状态"
                    }
                    break
                case 1:
                    rightLabelText = ZZHelper.timeFormat(timeStamp: model.auditRecordList[0].auditTime, format: "yyyy/MM/dd")
                    break
                default:
                    break
                }
                
            }
        default:
            break
        }
        
        rightLabel.text = rightLabelText
    }
    
}

extension PracticeRegisterTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        print(finalText)
        delegate.getTextFieleContent(text: finalText, tag: textField.tag)
        return true
    }
}
