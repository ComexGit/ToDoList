//
//  TodayViewController.swift
//  ToDoListTodayExtension02
//
//  Created by UncleDrew on 2016/12/20.
//  Copyright © 2016年 UncleDrew. All rights reserved.
//

import UIKit
import NotificationCenter
import ToDoListKit

private let TodayViewControllerMaxCellCount = 2
private let TodayViewControllerCellHeight:CGFloat = 44.0
private let TodayViewControllerTableViewCellKey = "TodayViewControllerTableViewCell"

class TodayViewController: UIViewController, NCWidgetProviding,UITableViewDataSource,UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
    }
    
    func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.loadData()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return .zero
    }
    
    // MARK: - UITableView数据源和代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: TodayViewControllerTableViewCellKey)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: TodayViewControllerTableViewCellKey)
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
        }
        let item = self.data[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "calendar")
        cell.textLabel?.text = item
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.text = "Date & Time"
        cell.detailTextLabel?.textColor = UIColor.black
        return cell
    }
    
    // MARK: - 事件响应
    @IBAction func addButtonClick(sender: UIButton) {
        let url = NSURL(string: "todolist://action=add")
        self.extensionContext?.open(url! as URL, completionHandler: nil)
    }
    
    // MARK: - 私有方法
    private func setup(){
        
        self.preferredContentSize = CGSize.init(width: 0, height: 44)
        self.addButton.layer.cornerRadius = 3.0
        self.tableView.rowHeight = TodayViewControllerCellHeight
    }
    
    private func loadData(){
        self.data = [String]()
        let items = TaskService.getItems()
        // 控制最多显示条数
        for i in 0..<items.count {
            self.data.append(items[i])
            if i >= TodayViewControllerMaxCellCount {
                break
            }
        }
        self.layoutUI()
        self.tableView.reloadData()
    }
    
    private func layoutUI(){
        
        if self.data.count > 0 {
            self.addButton.isHidden = true
            self.tableView.isHidden = false
            self.preferredContentSize = CGSize.init(width: 0, height: CGFloat(self.data.count) * TodayViewControllerCellHeight)
        } else {
            self.addButton.isHidden = false
            self.tableView.isHidden = true
            self.preferredContentSize = CGSize.init(width: 0, height: TodayViewControllerCellHeight)
            
        }
        
    }
    
    // MARK: - 私有属性
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private var data:[String]!
}






