//
//  CustomSegmentedControl.swift
//  UploadImage
//
//  Created by IMACYF0003 on 16/7/20.
//  Copyright © 2016年 IMACYF0003. All rights reserved.
//

import UIKit

// 含糖语法
private extension Selector {
  static var SelectTapAction = #selector(CustomSegmentedControl.selectTapAction(gesture:))
}
// 选中状态改变
typealias SegmentedBlock = (_ selected: String?) -> Void

class CustomSegmentedControl: UIView {
  // 两个标签
  private var labMale: UILabel!
  private var labFemale: UILabel!
  // 覆盖ImageView
  private var coverImage: UIImageView!
  // block
  internal var segmentBlock: SegmentedBlock?
  // 默认选中
  internal var selectedIndex: Int = 0 {
    willSet {
      if newValue == 0 {
        labMale.textColor = UIColor.red
        labFemale.textColor = UIColor.gray
        coverImage.frame = labMale.frame
      } else {
        labMale.textColor = UIColor.gray
        labFemale.textColor = UIColor.red
        coverImage.frame = labFemale.frame
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    // 设置view属性
    backgroundColor = UIColor.white
    self.layer.cornerRadius = 1
    self.layer.masksToBounds = true
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(white: 0.6, alpha: 0.3).cgColor
    // 增加单击事件
    let selectTap = UITapGestureRecognizer(target: self, action: Selector.SelectTapAction)
    self.isUserInteractionEnabled = true
    addGestureRecognizer(selectTap)

    labMale = UILabel()
    labMale.font = UIFont.systemFont(ofSize: 14)
    labMale.textAlignment = .center
    labMale.textColor = UIColor.red
    addSubview(labMale)

    labFemale = UILabel()
    labFemale.font = UIFont.systemFont(ofSize: 14)
    labFemale.textAlignment = .center
    labFemale.textColor = UIColor.gray
    addSubview(labFemale)

    coverImage = UIImageView(image: UIImage(named: "sel.pdf"))
    coverImage.contentMode = .scaleToFill
    addSubview(coverImage)
  }

  override func layoutSubviews() {
    // 获取宽度和高度
    let viewW = self.bounds.width
    let viewH = self.bounds.height
    labMale.frame = CGRect(x: 0, y: 0, width: viewW * 0.5, height: viewH)
    labFemale.frame = CGRect(x: viewW * 0.5, y: 0, width: viewW * 0.5, height: viewH)
    if selectedIndex == 0 {
      coverImage.frame = labMale.frame
    } else {
      coverImage.frame = labFemale.frame
    }
  }

  func setSelectedTags(tags: [String]?) {

    labMale.text = tags?[0]
    labFemale.text = tags?[1]
  }

  internal func selectTapAction(gesture: UITapGestureRecognizer) {
    let pointPos = gesture.location(in: self)
    let viewW = self.frame.size.width
    var currentSelectedIndex = 0
    // 判断单击位置
    if pointPos.x > viewW * 0.5 {
      currentSelectedIndex = 1
    }
    // 判断选中与当前显示状态是否不一致
    if currentSelectedIndex != selectedIndex {
      if currentSelectedIndex == 0 {
        UIView.animate(withDuration: 0.2, animations: {
          self.coverImage.frame = self.labMale.frame
          self.segmentBlock?(self.labMale.text)
        })
      } else {
        UIView.animate(withDuration: 0.2, animations: {
          self.coverImage.frame = self.labFemale.frame
          self.segmentBlock?(self.labFemale.text)
        })
      }
      selectedIndex = currentSelectedIndex
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
