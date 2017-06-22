//
//  ExaminationViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/8.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ExaminationViewController: BaseViewController {
    
    
    var tableView: UITableView!
    var isRefreshing = false
    var offset = 0
    // 是否加载
    var isFetching = false
    
    var dataArray:[ExamSubjectModel] = []
    var answerArray: [JSON] = []
    
    var isSave: Int = 0
    //是否是第一次加载数据
    var isFirst = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftView = self.navigationItem.leftBarButtonItem?.customView
        let leftBtn = leftView?.subviews.first as? UIButton
        leftBtn?.removeTarget(self.navigationController, action: #selector(BaseNavigationController.backAction), for: .touchUpInside)
        leftBtn?.addTarget(self, action: #selector(ExaminationViewController.back), for: .touchUpInside)
        let leftLabel = leftView?.subviews.last as? UILabel
        let tap = leftLabel?.gestureRecognizers?.first as! UITapGestureRecognizer?
        tap?.removeTarget(self.navigationController, action: #selector(BaseNavigationController.backAction))
        tap?.addTarget(self, action: #selector(ExaminationViewController.back))
        
        self.title = AppKeys.getPlanName()
        print("\(AppKeys.getPlanName)==========")
        buildRightButton()
        buildTableView()
        getCurrentExamSubject()
        
    }
    
    func back() {
        var message = ""
        if answerArray.count < 50 {
            message = "当前您还未答完所有题目,您的答题将自动保存进行, 下次进入可继续答题!"
        } else {
            message = "您已答完所有题目但还未提交,您的答题将自动保存进行,下次进入可直接提交!"
        }
        let alertV = YHAlertView(title: "确定退出?", message: message, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: ["确定"])
        alertV.tag = 100
        alertV.visual = false
        alertV.show()
        
    }
    
    func buildRightButton() {
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        but.setTitle("提交", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
        
    }
    
    func submitAction() {
        isSave = 0
        saveAnswer()
    }
    
    //AMRK: 提交/保存
    func saveAnswer() {
        let param: [String: AnyObject] = ["isSave": isSave as AnyObject ,
                                          "subjectList": "\(answerArray)" as AnyObject]
        print("param\(param)")
        ServerProvider<ReportServer>().requestReturnDictionary(target: .answerSubject(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                switch self.isSave {
                case 0:
                    if JSON(info)["resultObject"].intValue < 10 {
                        let alertV = YHAlertView(title: "考试未通过!", message: "很遗憾,您未通过这次的安全考试,请重新答题", delegate: self, cancelButtonTitle: nil, otherButtonTitles: ["确定"])
                        alertV.tag = 200
                        alertV.visual = false
                        alertV.show()
                        
                    } else {
                        
                        let vc = PrepareDetailViewController()
                        vc.pageType = .COMMITMENT
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case 1:
                    self.navigationController?.popViewController(animated: true)
                    break
                default:
                    break
                }
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    
    //MARK: tableView
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ExamTableViewCell", bundle: nil), forCellReuseIdentifier: "ExamTableViewCell")
        tableView.register(ExamHeaderView.self, forHeaderFooterViewReuseIdentifier: "ExamHeaderView")
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
        
        //        tableView.mj_header = ZZRefreshHeader(refreshingBlock: {
        //            if self.isFetching {
        //                return
        //            }
        //            self.offset = 0
        //            self.isRefreshing = true
        //            self.getCurrentExamSubject()
        //
        //        })
        tableView.mj_footer = ZZRefreshFooter(refreshingBlock: {
            if self.isFetching {
                return
            }
            self.offset += 10
            self.getCurrentExamSubject()
            self.isRefreshing = false
        })
    }
    
    //MARK: 获取题目
    func getCurrentExamSubject() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCurrentExamSubject(pageSize: 10, offset: offset)) { (success, info) in
            if self.isRefreshing {
                //                if self.tableView != nil {
                //                    self.tableView.mj_header.endRefreshing()
                //                }
            } else {
                if self.tableView != nil {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            guard let info = info else {
                
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                //                if self.offset == 0 {
                //                    self.dataArray.removeAll()
                //                }
                
                
                
                
                for data in JSON(info)["resultObject"]["items"].arrayValue {
                    let model = ExamSubjectModel(json: data)
                    self.dataArray.append(model)
                    
                    if model.selectedOptionIds != "" {
                        let fileJson: JSON = ["subjectId":model.id! as AnyObject,"selectOptionId": [model.selectedOptionIds!] as Array]
                        self.answerArray.append(fileJson)
                        
                    }
                    
                    
                    
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


//MARK: TableViewDelegate, TableViewDataSource
extension ExaminationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExamTableViewCell") as! ExamTableViewCell
        let model = dataArray[indexPath.section].list[indexPath.row]
        cell.optionLabel.text = "\(model.item!)." +  model.content
        if isFirst {
            // 显示之前保存的数据
            if model.id == dataArray[indexPath.section].selectedOptionIds {
                cell.selectedImageView.image = UIImage(named: "selected_right")
                cell.bottomView.backgroundColor = ZZLightGrayBg_F7F7F7
            } else {
                cell.selectedImageView.image = UIImage()
                cell.bottomView.backgroundColor = ZZWhiteBackground
            }
        } else {
            // 显示选中选项
            if (dataArray[indexPath.section].flag == 10 && model.id == dataArray[indexPath.section].selectedOptionIds) || dataArray[indexPath.section].flag == indexPath.row{
                cell.selectedImageView.image = UIImage(named: "selected_right")
                cell.bottomView.backgroundColor = ZZLightGrayBg_F7F7F7
                
            } else {
                cell.selectedImageView.image = UIImage()
                cell.bottomView.backgroundColor = ZZWhiteBackground
            }
            //            if dataArray[indexPath.section].flag == indexPath.row  {
            //                    cell.selectedImageView.image = UIImage(named: "selected_right")
            //                    cell.bottomView.backgroundColor = ZZLightGrayBg_F7F7F7
            //                } else {
            //                    cell.selectedImageView.image = UIImage()
            //                    cell.bottomView.backgroundColor = ZZWhiteBackground
            //                }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UILabel.heightForLabel(text: "\(section + 1)." + "[单选题]\(dataArray[section].title)" as NSString, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 20) + 20
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: ExamHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExamHeaderView") as! ExamHeaderView
        header.label.text = "\(section + 1)." + "【单选】\(dataArray[section].title!)"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UILabel.heightForLabel(text: dataArray[indexPath.section].list[indexPath.row].content as NSString, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 20) + 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isFirst = false
        let model = dataArray[indexPath.section]
        model.flag = indexPath.row
        print(model.flag)
        // 选中的答案
        let listArray = dataArray[indexPath.section].list
        let fileJson: JSON = ["subjectId":listArray[indexPath.row].subjectId! as AnyObject,"selectOptionId": [listArray[indexPath.row].id!] as Array]
        
        
        // 更换单选答案 整理最终答案数据
        //        for subData in listArray {
        //            if subData.subjectId == fileJson["subjectId"].stringValue {
        //                print(subData.subjectId)
        //                print(fileJson["subjectId"].stringValue)
        //                print(answerArray)
        //                for i in 0..<answerArray.count {
        //                    print(i)
        //                    let origin = answerArray[i]["subjectId"].stringValue
        //                    if origin == fileJson["subjectId"].stringValue {
        //                        answerArray.remove(at: i)
        //                    }
        //                }
        //
        //            }
        //        }
        
        for i in 0..<answerArray.count {
            if answerArray[i]["subjectId"].stringValue == listArray[indexPath.row].subjectId {
                answerArray.remove(at: i)
                break
            }
        }
        
        self.answerArray.append(fileJson)
        print(answerArray)
        tableView.reloadData()
        
        
        
        
    }
    
    
    
}

extension ExaminationViewController: YHAlertViewDelegate {
    
    func alertView(alertView: YHAlertView, clickedButtonAtIndex: Int) {
        switch alertView.tag {
        case 100:
            if clickedButtonAtIndex == 1 {
                isSave = 1
                saveAnswer()
            }
        case 200:
            break
        default:
            break
        }
    }
}
