//
//  MaterialChoiceViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

public protocol MaterialChoiceDelegate: NSObjectProtocol {
    func selectValue(value: String, preIndexPath: NSIndexPath, superSection: Int?)
}

class MaterialChoiceViewController: BaseViewController {
    // delegate
    weak var delegate: MaterialChoiceDelegate?
    // cellId
    let materialChoiceCellId = "MaterialChoiceCellId"
    // UITableView
    private var tableView: UITableView!
    // 上一个tableview的NSIndexPath
    internal var preIndexPath: NSIndexPath!
    // 如果当UITableView嵌套UItableView，生出父视图section
    internal var superSection: Int?
    // 选择类型
    var selectType: SelectJumpType = .Date
    // 选择类型数据
    var selectItems: NSArray?
    // 标题名称
    internal var naviTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏标题
        navigationItem.title = naviTitle
        buildTableView()
        getSelectedData()
    }
    private func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0,
                                              width: ZZScreenWidth, height: ZZScreenHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = ZZWhiteBackground
        tableView.separatorColor = ZZMainLineGray
        if selectType != .NativePlace {
            tableView.contentInset = UIEdgeInsets(top: 2,
                                                  left: 0, bottom: 0, right: 0)
        }
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    // MARK: - 获取选择数据
    private func getSelectedData() {
        let selectData = MaterialJumpType.getselectedData(jumpType: selectType)
        if selectData != nil {
            selectItems = selectData! as NSArray
            return
        } else {
            switch selectType {
            case .NativePlace:
                readJSONFile()
            case .ApplyPost:
                getApplyPostList()
            case .Concern:
                getConcernPointList()
            default:
                break
            }
        }
        tableView.reloadData()
    }
    func getApplyPostList() {
//        server.alamofireRequest(ServerManager.AcquirePostList()) { (success, info) in
//            if info?["message"] as? String == "成功" {
//                guard let types = info?["list"] as? [[String: AnyObject]] else {
//                    let vc = RemindViewController(title: "岗位查询失败")
//                    self.presentViewController(vc, animated: true, completion: nil)
//                    return
//                }
//                // 使用map剥离数据
//                let posts = types.map({ (type) -> String in
//                    guard let postName = type["station_name"] as? String else {
//                        return ""
//                    }
//                    return postName
//                })
//                // 重新加载数据
//                self.selectItems = posts
//                self.tableView.reloadData()
//            } else {
//                let vc = RemindViewController(title: "岗位查询失败")
//                self.presentViewController(vc, animated: true, completion: nil)
//            }
//        }
    }
    // 获取关注点列表
    func getConcernPointList() {
//        server.requestReturnArray(ServerManager.ConcernPointList()) { (success, info) in
//            guard let points = info else {
//                return
//            }
//            // 重新加载数据
//            self.selectItems = points
//            self.tableView.reloadData()
//        }
    }
    /// 省份选择文件
    func readJSONFile() {
        // 获取路径
        let filePath = Bundle.main.path(forResource: "NationalCity", ofType: "json")
        guard let path = filePath else {
            return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        do {
            let provinceArray = try JSONSerialization
                .jsonObject(with: data as Data, options: .mutableLeaves) as? NSArray
            guard let provinces = provinceArray else {
                return
            }
            self.selectItems = provinces
        } catch let errer as NSError {
            print(errer)
        }
    }
    
     func getSingleItem(indexPath: NSIndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        guard let provinces = selectItems else {
            return ""
        }
        guard let province = provinces.object(at: section) as? [String: AnyObject] else {
            return ""
        }
        guard let cities = province["cities"] as? [String] else {
            return ""
        }
        
        let cityName = cities[row]
        
        return cityName
    }
    
     func getHeaderTitle(section: Int) -> String? {
        guard let provinces = selectItems else {
            return nil
        }
        guard let province = provinces.object(at: section) as? [String: AnyObject] else {
            return nil
        }
        guard let provinceName = province["name"] as? String else {
            return nil
        }
        return provinceName
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension MaterialChoiceViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if selectType == .NativePlace && selectItems != nil {
            return selectItems!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 当状态为籍贯选择时
        if selectType == .NativePlace {
            guard let provinces = selectItems else {
                return 0
            }
            guard let province = provinces.object(at: section) as? [String: AnyObject] else {
                return 0
            }
            guard let cities = province["cities"] as? [String] else {
                return 0
            }
            return cities.count
        }
        // 状态为非籍贯选择时
        guard let items = selectItems else {
            return 0
        }
        return items.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell = tableView.dequeueReusableCell(withIdentifier: materialChoiceCellId) as? MaterialChoiceCell
        if cell == nil {
            cell = MaterialChoiceCell(style: .default, reuseIdentifier: materialChoiceCellId)
        }
        // 数据传递
        var text: String?
        if selectType == .NativePlace {
            text = getSingleItem(indexPath: indexPath as NSIndexPath)
        } else {
            text = selectItems?.object(at: row) as? String
        }
        cell?.setCellData(text: text)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectType == .NativePlace {
            return getHeaderTitle(section: section)
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 获取选中结果
        guard let items = selectItems else {
            return
        }
        let row = indexPath.row
        let section = indexPath.section
        // 当状态为籍贯选择时
        if selectType == .NativePlace {
            let provinceName = getHeaderTitle(section: section)
            let cityName = getSingleItem(indexPath: indexPath as NSIndexPath)
            if provinceName == nil && cityName.characters.count == 0 {
                return
            }
            let value = provinceName! + "-" + cityName
            delegate?.selectValue(value: value, preIndexPath: preIndexPath, superSection: superSection)
        } else {
            guard let value = items.object(at: row) as? String else {
                return
            }
            delegate?.selectValue(value: value, preIndexPath: preIndexPath, superSection: superSection)
        }
        
        navigationController?.popViewController(animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Int(ZZScreenWidth * 0.13))
    }
    
    
}
