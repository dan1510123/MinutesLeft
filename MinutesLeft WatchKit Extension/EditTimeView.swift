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
    @State var sun = false
    @State var mon = false
    @State var tue = false
    @State var wed = false
    @State var thu = false
    @State var fri = false
    @State var sat = false
    var time: Time
    
    var body: some View {
        ScrollView {
            Text("Event details")
            ScrollView {
                TextField("Name: \(time.name)", text: $name)
                TextField("Start time: \(time.startTime)", text: $startTime)
                Toggle(isOn: $sun) {
                    Text("Sunday")
                }.onAppear(perform: {
                    self.sun = self.getCurrentWeekdayValue(weekdayNum: 0)
                }).padding()
                Toggle(isOn: $mon) {
                    Text("Monday")
                }.onAppear(perform: {
                    self.mon = self.getCurrentWeekdayValue(weekdayNum: 1)
                }).padding()
                Toggle(isOn: $tue) {
                    Text("Tuesday")
                }.onAppear(perform: {
                    self.tue = self.getCurrentWeekdayValue(weekdayNum: 2)
                }).padding()
                Toggle(isOn: $wed) {
                    Text("Wednesday")
                }.onAppear(perform: {
                    self.wed = self.getCurrentWeekdayValue(weekdayNum: 3)
                }).padding()
                Toggle(isOn: $thu) {
                    Text("Thursday")
                }.onAppear(perform: {
                    self.thu = self.getCurrentWeekdayValue(weekdayNum: 4)
                }).padding()
                Toggle(isOn: $fri) {
                    Text("Friday")
                }.onAppear(perform: {
                    self.fri = self.getCurrentWeekdayValue(weekdayNum: 5)
                }).padding()
                Toggle(isOn: $sat) {
                    Text("Saturday")
                }.onAppear(perform: {
                    self.sat = self.getCurrentWeekdayValue(weekdayNum: 6)
                }).padding()
                Button(action: {
                    do {
                        if(!self.name.isEmpty) {
                            // Validate event name
                            if(self.name.count > 10) {
                                throw MyError.NameTooLong
                            }
                            self.time.name = self.name
                        }
                        
                        if(!self.startTime.isEmpty) {
                            // Validate start time
                            let start: Int16 = Int16(self.startTime)!
                            if(start < 1 || start > 2400) {
                                throw MyError.TimeOutOfBounds
                            }
                            self.time.startTime = start
                        }
                        
                        var newWeekdays: String = ""
                        newWeekdays.append(self.sun ? "1" : "0")
                        newWeekdays.append(self.mon ? "1" : "0")
                        newWeekdays.append(self.tue ? "1" : "0")
                        newWeekdays.append(self.wed ? "1" : "0")
                        newWeekdays.append(self.thu ? "1" : "0")
                        newWeekdays.append(self.fri ? "1" : "0")
                        newWeekdays.append(self.sat ? "1" : "0")
                        self.time.daysOfWeek = newWeekdays
                        
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
    
    func getCurrentWeekdayValue(weekdayNum: Int) -> Bool {
        var i = 0
        for num in self.time.daysOfWeek {
            if i == weekdayNum {
                return num == "1"
            }
            i = i + 1
        }
        return false
    }
}

enum MyError: Error {
    case NameTooLong
    case TimeOutOfBounds
    case InvalidWeekdayInputLength
    case InvalidWeekdayFormat
}
