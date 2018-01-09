//
//  ViewController.swift
//  ToDo
//
//  Created by Kingsten Hausen on 07.01.18.
//  Copyright © 2018 Kingsten Hausen. All rights reserved.
//

import UIKit
import SwiftSocket
class ViewController: UIViewController {
    let db = ActivityDB.shared;
    @IBOutlet weak var createActivityButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    db.createActivityTable()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateDatabaseListener(_ sender: UIButton) {
        let activites = ActivityDB.shared.getAllActivities()
        let firstActivity = activites[0]
        let alert = UIAlertController(title: "Edit Activity", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = firstActivity.getActivity() }
        alert.addTextField { (tf) in tf.placeholder = firstActivity.getDate() }
        alert.addTextField { (tf) in tf.placeholder = firstActivity.getStartTime() }
        alert.addTextField { (tf) in tf.placeholder = firstActivity.getEndTime() }
        alert.addTextField { (tf) in tf.placeholder = firstActivity.getPosition() }
        
        let action = UIAlertAction(title: "Update", style: .default) { (_) in
            guard let actvityVal = alert.textFields?.first?.text,
                let dateVal = alert.textFields?[1].text,
                let startTimeVal = alert.textFields?[2].text,
                let endTimeVal = alert.textFields?[3].text,
                let position = alert.textFields?[4].text
                
                
                else { return }
            let newAct = Activity(id: firstActivity.getId(),activity: actvityVal, date: dateVal, startTime: startTimeVal, endTime: endTimeVal, position: position)
            
            _ = ActivityDB.shared.updateActivity(activity: newAct)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func createDatabaseListener(_ sender: UIButton) {
        ActivityDB.shared.createActivityTable()
    }
    @IBAction func deleteDatabaseListener(_ sender: UIButton) {
        ActivityDB.shared.deleteActivities()
    }
    @IBAction func listButtonListener(_ sender: UIButton) {
        var actvities = db.getAllActivities()
        for activity in actvities{
            print(activity.getActivity())
        }
    }
    @IBAction func insertBarListener(_ sender: UIBarButtonItem) {
        print("works")
    }
    
    @IBAction func activityCreatorListener(_ sender: UIButton) {
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Activity" }
        alert.addTextField { (tf) in tf.placeholder = "Date" }
        alert.addTextField { (tf) in tf.placeholder = "Start Time" }
        alert.addTextField { (tf) in tf.placeholder = "End Time" }
        alert.addTextField { (tf) in tf.placeholder = "Position" }
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let actvityVal = alert.textFields?.first?.text,
             let dateVal = alert.textFields?[1].text,
             let startTimeVal = alert.textFields?[2].text,
             let endTimeVal = alert.textFields?[3].text,
            let position = alert.textFields?[4].text
            
            
             else { return }
            
            let newAct = Activity(id: 0,activity: actvityVal, date: dateVal, startTime: startTimeVal, endTime: endTimeVal, position: position)
            _ = ActivityDB.shared.addActivity(activity: newAct)
            }
            alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
    }
    func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.characters.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    



}
