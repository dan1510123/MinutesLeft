//
//  ConfigurationController.swift
//  MinutesLeft WatchKit Extension
//
//  Created by Daniel Luo on 1/3/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class ConfigurationController: WKHostingController<TimeConfigurationView> {
    override var body: TimeConfigurationView {
        return TimeConfigurationView()
    }
}
