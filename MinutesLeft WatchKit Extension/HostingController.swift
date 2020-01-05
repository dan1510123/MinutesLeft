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

class HostingController: WKInterfaceController {
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
        if(getCalendarSecond() <= 1) {
//            let date = Date()
//            let calendar = Calendar.current
//
//            let sec = calendar.component(.second, from: date)
//
//            minutesLeftLabel.setText("\(sec)")
            
            let info = helper.getInfo()
            
            minutesLeftLabel.setText(info[0])
            eventLabel.setText(info[1])
        }
    }
    
    func getCalendarSecond() -> Int16 {
        return Int16(Calendar.current.component(.second, from: Date()))
    }
}

class MinutesLeftHelper {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Time.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)]) var timeList: FetchedResults<Time>
    
    func getInfo() -> [String] {
        for time in self.timeList {
            print(time.name)
        }
        return ["1000", "Epic Event!"]
    }
}
