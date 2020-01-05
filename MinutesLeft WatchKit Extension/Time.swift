//
//  Time.swift
//  MinutesLeft WatchKit Extension
//
//  Created by Daniel Luo on 1/3/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import CoreData

class Time: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var startTime: Int16
    @NSManaged var daysOfWeek: String
}
