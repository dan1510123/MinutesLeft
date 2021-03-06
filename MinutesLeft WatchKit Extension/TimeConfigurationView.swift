//
//  TimeConfigurationView.swift
//  MinutesLeft WatchKit Extension
//
//  Created by Daniel Luo on 1/3/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import SwiftUI

struct TimeConfigurationView: View {
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    var body: some View {
        TimeListView().environment(\.managedObjectContext, managedObjectContext)
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

struct TimeListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Time.entity(), sortDescriptors: [NSSortDescriptor(key: "startTime", ascending: true)]) var timeList: FetchedResults<Time>

    var body: some View {
        ScrollView {
            ForEach(timeList, id: \.self) { time in
                NavigationLink(destination: EditTimeView(time: time)) {
                    Text("\(time.name), \(time.startTime.formattedWithoutSeparator), \(time.daysOfWeek)")
                }
            }
            Button(action: {
                let time = Time(context: self.managedObjectContext)
                time.name = "Event"
                time.startTime = 2400
                time.daysOfWeek = "0000000"
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
        TimeConfigurationView()
    }
}
