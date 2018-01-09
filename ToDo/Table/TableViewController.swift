//
//  TableViewController.swift
//  ToDo
//
//  Created by Kingsten Hausen on 08.01.18.
//  Copyright © 2018 Kingsten Hausen. All rights reserved.
//

import UIKit
struct cellData {
    let cell: Int!
    let activityText: String!
    let dateText: String!
    let startTimeText: String!
    let endTimeText: String!
}
class TableViewController: UITableViewController {
    var arrayOfCellData = [Activity]()
    var activities = ActivityDB.shared.getAllActivities()
    @IBOutlet var activityTableView: UITableView!
    
    @IBOutlet weak var insertBarButton: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //arrayOfCellData = [activities]
        
    }
    @IBAction func insetBarButtonListener(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Activity" }
        alert.addTextField { (tf) in tf.placeholder = "Date" }
        alert.addTextField { (tf) in tf.placeholder = "Start Time" }
        alert.addTextField { (tf) in tf.placeholder = "End Time" }
        alert.addTextField { (tf) in tf.placeholder = "Postion" }
        
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let activityVal = alert.textFields?.first?.text,
                let dateVal = alert.textFields?[1].text,
                let startTimeVal = alert.textFields?[2].text,
                let endTimeVal = alert.textFields?[3].text,
                let postion = alert.textFields?[4].text

                else { return }
            
            let newAct = Activity(id: 0,activity: activityVal, date: dateVal, startTime: startTimeVal, endTime: endTimeVal, position: postion)
            _ = ActivityDB.shared.addActivity(activity: newAct)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ActivityTableViewCell", owner: self, options: nil)?.first as! ActivityTableViewCell
        cell.activityLabel.text! = activities[indexPath.row].getActivity()
        cell.dateLabel.text! = activities[indexPath.row].getDate()
        cell.startTimeLabel.text = activities[indexPath.row].getStartTime()
        cell.endTimeLabel.text = activities[indexPath.row].getEndTime()
    
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
