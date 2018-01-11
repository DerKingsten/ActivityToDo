//
//  ViewController.swift
//  ToDo
//
//  Created by Kingsten Hausen on 07.01.18.
//  Copyright © 2018 Kingsten Hausen. All rights reserved.
//

import UIKit
enum updateFunction {
    case updateById
    case updateByPosition
}
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
        let firstActivity = ActivityDB.shared.getAllActivities()[0]
        updateAlert(activity: firstActivity, updateFunc: .updateById)
    }
    @IBAction func updateDatabaseByPosition(_ sender: UIButton) {
        let alert = UIAlertController(title: "Please choose the position", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "firstActivity.getActivity()" }
        let action = UIAlertAction(title: "Update", style: .default) { (_) in
            let activity = alert.textFields?.first?.text
            let activityByPosition = ActivityDB.shared.getActivityByPosition(requestedPostition: activity!)[0]
            self.updateAlert(activity: activityByPosition, updateFunc: .updateByPosition)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateDatabaseByDate(_ sender: UIButton) {
        ActivityDB.shared.updateAndSortByPosition()
    }
    @IBAction func createDatabaseListener(_ sender: UIButton) {
        ActivityDB.shared.createActivityTable()
    }
    @IBAction func deleteDatabaseListener(_ sender: UIButton) {
        ActivityDB.shared.deleteActivities()
    }
    @IBAction func listButtonListener(_ sender: UIButton) {
        ActivityDB.shared.updateAndSortByPosition()
    }
    @IBAction func insertBarListener(_ sender: UIBarButtonItem) {
        print("works")
    }
    
    @IBAction func activityCreatorListener(_ sender: UIButton) {
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Activity" }
        alert.addTextField { (tf) in tf.placeholder = "Date(yyyy-mm-dd)" }
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
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd-HH:mm"
            format.locale = Locale.init(identifier: "de_DE")
            format.timeZone = TimeZone.init(abbreviation: "GMT")
            let dateWithStartTime = dateVal + "-" + startTimeVal + ":00"
            let date = format.date(from: dateWithStartTime)
            let newAct = Activity(id: 0,activity: actvityVal, date: date!, startTime: startTimeVal, endTime: endTimeVal, position: position)
            _ = ActivityDB.shared.addActivity(activity: newAct)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func updateAlert(activity: Activity, updateFunc: updateFunction){
        let alert = UIAlertController(title: "Edit Activity", message: nil, preferredStyle: .alert)
        let format = DateFormatter()
        format.dateFormat = "yyyy-mm-dd-hh"
        let dateAsString = format.string(from: activity.getDate())
        // Adding Fields to the alert
        alert.addTextField { (tf) in tf.placeholder = activity.getActivity() }
        alert.addTextField { (tf) in tf.placeholder = dateAsString }
        alert.addTextField { (tf) in tf.placeholder = activity.getStartTime() }
        alert.addTextField { (tf) in tf.placeholder = activity.getEndTime() }
        alert.addTextField { (tf) in tf.placeholder = activity.getPosition() }
        // Set the text of the column data
        alert.textFields?.first?.text = activity.getActivity()
        alert.textFields?[1].text = dateAsString
        alert.textFields?[2].text = activity.getStartTime()
            alert.textFields?[3].text = activity.getEndTime()
            alert.textFields?[4].text = activity.getPosition()
        
        let action = UIAlertAction(title: "Update", style: .default) { (_) in
            guard let actvityVal = alert.textFields?.first?.text,
                let dateVal = alert.textFields?[1].text,
                let startTimeVal = alert.textFields?[2].text,
                let endTimeVal = alert.textFields?[3].text,
                let position = alert.textFields?[4].text
                else { return }
            let format = DateFormatter()
            format.dateFormat = "yyyy-mm-dd-hh"
            format.timeZone = TimeZone.init(abbreviation: "GMT")
            let date = format.date(from: dateVal + "-" + startTimeVal)
            let newAct = Activity(id: activity.getId(),activity: actvityVal, date: date!, startTime: startTimeVal, endTime: endTimeVal, position: position)
            
            switch updateFunc{
            case .updateById:
                _ = ActivityDB.shared.updateActivityById(activity: newAct)
            case .updateByPosition:
                _ = ActivityDB.shared.updateActivityByPosition(activity: newAct)
            }
            ActivityDB.shared.updateAndSortByPosition()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

}




}
