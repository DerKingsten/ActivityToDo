//
//  Activity.swift
//  ToDo
//
//  Created by Kingsten Hausen on 07.01.18.
//  Copyright © 2018 Kingsten Hausen. All rights reserved.
//

import Foundation

class Activity {
    private var id: Int64
    private var activity: String
    private var date: String
    private var startTime: String
    private var endTime: String
    private var position: String
    

    init(id: Int64, activity: String, date: String, startTime: String, endTime: String, position: String) {
        self.id = id
        self.activity = activity
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.position = position
    }
    
    func setId(id: Int64){
        self.id = id
    }
    func getId() -> Int64{
        return self.id
    }
    
    func setActivity(activity: String){
        self.activity = activity
    }
    func getActivity() -> String{
        return self.activity
    }
    
    func setDate(date: String){
        self.date = date
    }
    func getDate() -> String{
        return self.date
    }
    
    func setEndTime(endTime: String){
        self.endTime = endTime
    }
    func getEndTime() -> String{
        return self.endTime
    }
    
    func setStartTime(startTime: String){
        self.startTime = startTime
    }
    func getStartTime() -> String{
        return self.startTime
    }
    
    func setPosition(position: String){
        self.position = position
    }
    func getPosition() -> String{
        return self.position
    }
    
    
    
}
