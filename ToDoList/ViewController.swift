//
//  ViewController.swift
//  ToDoList
//
//  Created by UncleDrew on 2016/12/19.
//  Copyright © 2016年 UncleDrew. All rights reserved.
//

import UIKit
import ToDoListKit


private let SCREEN_WIDTH = UIScreen.main.bounds.size.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

private let reusedCellStr = "UITableViewCell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.setup()
    }
    
    func loadData() {
        self.data = TaskService.getItems()
    }
    
    func setup() {
        
        self.title = "ToDoList"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBtnClick))
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func rightBtnClick() {
        
        self.alertVC = UIAlertController(title: "Task Name", message: nil, preferredStyle: .alert)
        let alertActionComfirm = UIAlertAction(title: "Comfirm", style: .default) { (alertAction) in
            
            let textField = (self.alertVC.textFields?.first)! as UITextField
            
            self.data.append(textField.text!)
            TaskService.addItem(title: textField.text!)
            
            self.tableView.reloadData()
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            
        }
        self.alertVC.addTextField { (textField) in
            
        }
        self.alertVC.addAction(alertActionComfirm)
        self.alertVC.addAction(alertActionCancel)
        self.present(self.alertVC, animated: true, completion: nil)
    }
    
    //MARK: - UITableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusedCellStr)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reusedCellStr)
        }
        
        cell.imageView?.image = UIImage(named: "calendar")
        cell.textLabel?.text = self.data[indexPath.row]
        
//        let date = Date()
//        let formatter: DateFormatter = DateFormatter()
//        formatter.dateFormat = "yy-MM-dd HH:mm"
//        let dateStr = formatter.string(from: date)
        
        cell.detailTextLabel?.text = "Date & Time"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            TaskService.removeItem(title: self.data[indexPath.row])
            self.data!.remove(at: indexPath.row)
            self.tableView!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }

    
    var tableView: UITableView!
    var data: [String]!
    public var alertVC: UIAlertController!
}

