//
//  ActivityDB.swift
//  ToDo
//
//  Created by Kingsten Hausen on 07.01.18.
//  Copyright © 2018 Kingsten Hausen. All rights reserved.
//

import Foundation
import SQLite3
import SQLite
class ActivityDB {
    static let shared:ActivityDB = ActivityDB()
    private let db: Connection?
    // Table
    private let actvityTable = Table("activity")
    // Columns
    private let idColumn = Expression<Int64>("id")
    private let activityColumn = Expression<String>("activity")
    private let dateColumn = Expression<String>("date")
    private let startTimeColumn = Expression<String>("startTime")
    private let endTimeColumn = Expression<String>("endTime")
    private let positionColumn = Expression<String>("position")
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/activityTable.sqlite3")
            createActivityTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createActivityTable() {
        do {
            try db!.run(actvityTable.create(ifNotExists: true) { table in
                table.column(idColumn, primaryKey: true)
                table.column(activityColumn)
                table.column(dateColumn)
                table.column(startTimeColumn)
                table.column(endTimeColumn)
                table.column(positionColumn)
                print("create table successfully")
            })
        } catch {
            print("Unable to create table")
        }
    }
    func addActivity(activity: Activity) -> Int64{
        do{
            var activits = activity.getActivity()
            var date = activity.getDate()
            let insertQuery = actvityTable.insert(activityColumn <- activity.getActivity(), dateColumn <- activity.getDate(), startTimeColumn <- activity.getStartTime(), endTimeColumn <- activity.getEndTime(), positionColumn <- activity.getPosition())
            let insertStatus = try db!.run(insertQuery)
            print("Insert to ActivityTable was successfully")
            return insertStatus
        } catch {
            print("Activity could not be inserted into the database")
            return 111
        }
    
    }
    func getAllActivities() -> [Activity]{
        var activities = [Activity]()
        do{
            for activity in try db!.prepare(self.actvityTable){
                let activitS = activity[idColumn]
                let date = activity[dateColumn]
                let startTime = activity[startTimeColumn]
                let activitVal = Activity(id: activity[idColumn],
                                          activity: activity[activityColumn],
                                          date: activity[dateColumn],
                                          startTime: activity[startTimeColumn],
                                          endTime: activity[endTimeColumn],
                                          position: activity[positionColumn])
                activities.append(activitVal)
            }
        } catch{
            print("Could not extract the activitiy list")
        }
        return activities
    }
    func deleteActivities(){
        do {
            try db!.run(actvityTable.drop())
            print("Database deleted sucessfully")
        } catch {
            print("Delete failed")
        }
    }
    
    
    /*func queryAllProduct() -> [Product] {
        var products = [Product]()
        
        do {
            for product in try db!.prepare(self.tblProduct) {
                let newProduct = Product(id: product[id],
                                         name: product[name] ?? "",
                                         imageName: product[imageName])
                products.append(newProduct)
            }
        } catch {
            print("Cannot get list of product")
        }
        for product in products {
            print("each product = \(product)")
        }
        return products
    }*/
    func updateActivity(activity: Activity){
        let filterdActivityTable = actvityTable.filter(idColumn == activity.getId())
        do{
            let updateQuery = filterdActivityTable.update([activityColumn <- activity.getActivity()])
            if try db!.run(updateQuery) > 0{
                print("Activity update was successful")
            }
        }catch{
            print("Activity update failed: \(error)")
            }
    }
    
   /* func updateContact(productId:Int64, newProduct: Product) -> Bool {
        let tblFilterProduct = tblProduct.filter(id == productId)
        do {
            let update = tblFilterProduct.update([
                name <- newProduct.name,
                imageName <- newProduct.imageName
                ])
            if try db!.run(update) > 0 {
                print("Update contact successfully: \(error)")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }*/
    
    
    
}
