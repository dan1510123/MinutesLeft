//
//  ContentView.swift
//  MinutesLeft WatchKit Extension
//
//  Created by Daniel Luo on 1/3/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    var body: some View {
        TimeList().environment(\.managedObjectContext, managedObjectContext)
    }
}

extension Formatter {
    static let withoutSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        return formatter
    }()
}

extension Numeric {
    var formattedWithoutSeparator: String {
        return Formatter.withoutSeparator.string(for: self) ?? ""
    }
}

struct TimeList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Time.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)]) var timeList: FetchedResults<Time>
    var confirmDelete = false
    
    var body: some View {
        ScrollView {
            ForEach(timeList, id: \.self) { time in
                Text("\(time.name), \(time.startTime.formattedWithoutSeparator), \(time.daysOfWeek.formattedWithoutSeparator)")
            }
            Button(action: {
                var time = Time(context: self.managedObjectContext)
                time.name = "A longer name"
                time.startTime = 1200
                time.daysOfWeek = 1111111
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
            }) {
                Text("Add Time")
            }
            .foregroundColor(Color.blue)
            Button(action: {
                for time in self.timeList {
                    self.managedObjectContext.delete(time)
                }
            }){
                Text("Remove All Times")
            }
            .foregroundColor(Color.red)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


