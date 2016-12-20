//
//  TaskService.swift
//  ToDoList
//
//  Created by UncleDrew on 2016/12/20.
//  Copyright © 2016年 UncleDrew. All rights reserved.
//

import Foundation


let TaskServiceDataKey = "TaskServiceData"
public struct TaskService {
    public static let ToDoListGroupName = "group.uncledrew.todolistgroup"
    
    public static func addItem(title:String){
        let userDefault = UserDefaults(suiteName: TaskService.ToDoListGroupName)
        var items = self.getItems()
        items.append(title)
        userDefault?.set(items, forKey: TaskServiceDataKey)
        userDefault?.synchronize()
    }
    
    public static func removeItem(title:String){
        let items = self.getItems()
        let newItems = items.filter { (item) -> Bool in
            item != title
        }
        let userDefault = UserDefaults(suiteName: TaskService.ToDoListGroupName)
        userDefault?.set(newItems, forKey: TaskServiceDataKey)
        userDefault?.synchronize()
    }
    
    public static func getItems() -> [String]{
        let userDefault = UserDefaults(suiteName: TaskService.ToDoListGroupName)
        var tasks = [String]()
        if let array = userDefault?.stringArray(forKey: TaskServiceDataKey) {
            tasks = array
        }
        return tasks
        
    }
}
