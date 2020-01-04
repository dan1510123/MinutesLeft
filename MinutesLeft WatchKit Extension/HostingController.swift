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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
            
            
        }
    }
    
    func getCalendarSecond() -> Int16 {
        let date = Date()
        let calendar = Calendar.current

        return Int16(calendar.component(.second, from: date))
    }
}

class MinutesLeftHelper {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Time.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)]) var timeList: FetchedResults<Time>
    
    func x() {
        let x = 0
    }
}
