//
//  EditTimeView.swift
//  MinutesLeft WatchKit Extension
//
//  Created by Daniel Luo on 1/5/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import SwiftUI

struct EditTimeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    @State var startTime: String = ""
    @State var weekdays: String = ""
    @State var justEdited: Bool = false
    var time: Time
    
    
    var body: some View {
        ScrollView {
            Text("Event details")
            TextField("Name: \(time.name)", text: $name)
            TextField("Start time: \(time.startTime)", text: $startTime)
            TextField("Weekdays: \(time.daysOfWeek)", text: $weekdays)
            
            Button(action: {
                do {
                    if(!self.name.isEmpty) {
                        // Validate event name
                        if(self.name.count > 10) {
                            throw MyError.runtimeError("Event name too long")
                        }
                        self.time.name = self.name
                    }
                    
                    if(!self.startTime.isEmpty) {
                        // Validate start time
                        let start: Int16 = Int16(self.startTime)!
                        if(start < 0 || start > 2400) {
                            throw MyError.runtimeError("Time out of bounds")
                        }
                        self.time.startTime = start
                    }
                    
                    if(!self.weekdays.isEmpty) {
                        //Validate daysOfWeek
                        if(self.weekdays.count != 7) {
                            throw MyError.runtimeError("Time out of bounds")
                        }
                        for num in self.weekdays {
                            if(num != "0" && num != "1") {
                                throw MyError.runtimeError("Time out of bounds")
                            }
                        }
                        self.time.daysOfWeek = self.weekdays
                    }
                    self.time.objectWillChange.send()
                } catch {
                    print(error)
                }
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }
            .foregroundColor(Color.green)
        }
    }
}
