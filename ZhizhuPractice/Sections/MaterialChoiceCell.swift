//
//  MaterialChoiceCell.swift
//  WindHandOut
//
//  Created by caiqiujun on 16/8/4.
//  Copyright © 2016年 IMACYF0003. All rights reserved.
//

import UIKit

class MaterialChoiceCell: UITableViewCell {
  /// 标签
  private var textLab: UILabel!
  /// 选中状态
  private var selectStatus: UIImageView!

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    textLab = UILabel()
    textLab.textColor = ZZGray
    textLab.textAlignment = .left
    textLab.font = UIFont.systemFont(ofSize: 14)
    contentView.addSubview(textLab)

    selectStatus = UIImageView()
    selectStatus.image = UIImage(named: "icon_acc_sel")
    selectStatus.contentMode = .scaleAspectFit
    selectStatus.isHidden = true
    contentView.addSubview(selectStatus)
  }

  internal func setCellData(text: String?) {
    textLab.text = text
    selectStatus.isHidden = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: true)
    if selected {
      selectStatus.isHidden = false
    } else {
      selectStatus.isHidden = true
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let height = self.bounds.height
    textLab.frame = CGRect(x: ZZScreenWidth * 0.04, y: 0,
                           width: ZZScreenWidth * 0.7, height: height)
    selectStatus.frame = CGRect(x: ZZScreenWidth * 0.96 - height * 0.4, y: height * 0.3,
                           width: height * 0.4, height: height * 0.4)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
