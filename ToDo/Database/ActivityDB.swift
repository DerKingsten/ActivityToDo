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

enum compareDateEnum {
    case firstDateIsBigger
    case secondDateIsBigger
    case datesAreEqual
    case none
}
enum compareTimes {
    case firstIsSmaller
    case secondIsSmaller
    case timesAreEqual
    case none
}

class ActivityDB {
    static let shared:ActivityDB = ActivityDB()
    private let db: Connection?
    // Table
    private let actvityTable = Table("activity")
    // Columns
    private let idColumn = Expression<Int64>("id")
    private let activityColumn = Expression<String>("activity")
    private let dateColumn = Expression<Date>("date")
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
    
    func addActivity(activity: [Activity]) -> Int{
        for activity in activity{
            do {
                let insertQuery = actvityTable.insert(activityColumn <- activity.getActivity(), dateColumn <- activity.getDate(), startTimeColumn <- activity.getStartTime(), endTimeColumn <- activity.getEndTime(), positionColumn <- activity.getPosition())
                let insertStatus = try db!.run(insertQuery)
                print("Insert to ActivityTable was successfully")
            } catch{
                print("Could not insert activities")
            }
        }
        return 0
    }
    func addActivity(activity: Activity) -> Int64{
        do{
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
                let activityVal = Activity(id: activity[idColumn],
                                           activity: activity[activityColumn],
                                           date: activity[dateColumn],
                                           startTime: activity[startTimeColumn],
                                           endTime: activity[endTimeColumn],
                                           position: activity[positionColumn])
                activities.append(activityVal)
            }
        } catch{
            print("Could not extract the activitiy list")
        }
        return activities
    }
    func getActivityByPosition(requestedPostition: String) -> [Activity]{
        var activites = [Activity]()
        let filteredActivityTableByPosition = actvityTable.filter(positionColumn == requestedPostition)
        do{
            for activity in try db!.prepare(filteredActivityTableByPosition){
                let activityVal = Activity(id: activity[idColumn],
                                           activity: activity[activityColumn],
                                           date: activity[dateColumn],
                                           startTime: activity[startTimeColumn],
                                           endTime: activity[endTimeColumn],
                                           position: activity[positionColumn])
                activites.append(activityVal)
            }
        }catch{
            print("Activity with that position could not be extracted \(error)")
        }
        return activites
    }
    func deleteActivities(){
        do {
            try db!.run(actvityTable.drop())
            print("Database deleted sucessfully")
        } catch {
            print("Delete failed")
        }
    }
    func updateActivityById(activity: Activity){
        let filterdActivityTable = actvityTable.filter(idColumn == activity.getId())
        do{
            let updateQuery = filterdActivityTable.update([activityColumn <- activity.getActivity(),dateColumn <- activity.getDate(), startTimeColumn <- activity.getStartTime(), endTimeColumn <- activity.getEndTime(), positionColumn <- activity.getPosition()])
            if try db!.run(updateQuery) > 0{
                print("Activity update was successful")
            }
        }catch{
            print("Activity update failed: \(error)")
        }
    }
    
    func updateActivityByPosition(activity: Activity){
        let filterdActivityTable = actvityTable.filter(positionColumn == activity.getPosition())
        do{
            let updateQuery = filterdActivityTable.update([activityColumn <- activity.getActivity(),dateColumn <- activity.getDate(), startTimeColumn <- activity.getStartTime(), endTimeColumn <- activity.getEndTime(), positionColumn <- activity.getPosition()])
            if try db!.run(updateQuery) > 0{
                print("Activity update was successful")
            }
        }catch{
            print("Activity update failed: \(error)")
        }
    }
    func updateAndSortByPosition(){
        let activitiesFromTheDatabase: [Activity] = getAllActivities()
        deleteActivities()
        createActivityTable()
        var sortedActivities: [Activity] = activitiesFromTheDatabase.sorted(by: {$0.getDate().compare($1.getDate())  == .orderedAscending})
        addActivity(activity: sortedActivities)
    }
    func getSmallerTime(firstTime: String, secondTime: String) -> compareTimes{
        let firstTimeAsInt = Int(firstTime)
        let secondTimeAsInt = Int(secondTime)
        if(firstTimeAsInt == secondTimeAsInt){
            return .timesAreEqual
        }else if(firstTimeAsInt! < secondTimeAsInt!){
            return .firstIsSmaller
        }else if(secondTimeAsInt! < firstTimeAsInt!){
            return .secondIsSmaller
        }else{
            return .none
        }
    }
    func getBiggerDate(firstDate: Date, secondDate: Date) -> compareDateEnum{
        if(firstDate == secondDate){
            return .datesAreEqual
        }else if(firstDate > secondDate){
            return .firstDateIsBigger
        }else if(firstDate < secondDate){
            return .secondDateIsBigger
        }else{
            return .none
        }
        
    }
    
}
