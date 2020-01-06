//
//  HostingController.swift
//  MinutesLeft WatchKit Extension
//
//  Created by Daniel Luo on 1/3/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import CoreData

class MinutesLeftController: WKInterfaceController {
    @IBOutlet var minutesLeftLabel: WKInterfaceLabel!
    @IBOutlet var eventLabel: WKInterfaceLabel!
    
    var helper: MinutesLeftHelper = MinutesLeftHelper()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.refreshPerMinute()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.refreshPerMinute()
        })
    }
    
    func refreshPerMinute() {
            let info = helper.getInfo()
            
            minutesLeftLabel.setText(info[0])
            eventLabel.setText("until \(info[1])")
    }
    
    func getCalendarSecond() -> Int16 {
        return Int16(Calendar.current.component(.second, from: Date()))
    }
}

class MinutesLeftHelper {
    let calendar = Calendar.current
    let managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    func getInfo1() -> [String] {
        print(getMinuteFormattedTime())
        return ["1","none"]
    }
    
    func getInfo() -> [String] {
        do {
            // Make request and fetch the list of [Time]
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
                   fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
            let timeList = try self.managedObjectContext.fetch(fetchRequest) as! [Time]
            
            // Get weekday
            let weekday = getWeekday()
            
            // Get current time
            let minuteTime = getMinuteFormattedTime()
            
            return processTimes(timeList: timeList, weekday: weekday, minuteTime: minuteTime)
        } catch {
            print(error)
        }
        return ["---", "tomorrow"]
    }
    
    func processTimes(timeList: [Time], weekday: Int, minuteTime: Int) -> [String] {
        var validTimes: [Time] = []
        timeList.forEach( { time in
            if(Array(time.daysOfWeek)[weekday - 1] == "1") {
                validTimes.append(time)
            }
        })
        
        var i = 0
        while(i < validTimes.count) {
            if(validTimes[i].startTime > minuteTime) {
                break;
            }
            i = i + 1
        }
        
        if(i != validTimes.count) {
            let hourDiff = Int(validTimes[i].startTime / 100) - Int(minuteTime / 100)
            let minDiff = Int(validTimes[i].startTime % 100) - (minuteTime % 100)
            let min = hourDiff * 60 + minDiff
            
            return ["\(min)", "\(validTimes[i].name)"]
        }
        else {
            return ["---", "tomorrow"]
        }
    }
    
    /**
     Returns the current weekday (1 for Sunday, 7 for Saturday)
     */
    func getWeekday() -> Int {
        let currentDate = Date()
        // Get current weekday
        
        let weekDay = self.calendar.component(.weekday, from: currentDate)
        
        return weekDay
    }
    
    /**
    Returns the time in minutes in military format
    */
    func getMinuteFormattedTime() -> Int {
        let currentDate = Date()
        // Get current weekday
        
        let hour = self.calendar.component(.hour, from: currentDate)
        let min = self.calendar.component(.minute, from: currentDate)
        
        return hour * 100 + min
    }
}
