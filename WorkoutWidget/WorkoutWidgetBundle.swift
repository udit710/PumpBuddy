//
//  WorkoutWidgetBundle.swift
//  WorkoutWidget
//
//  Created by Chaitanya Bhide on 17/10/2023.
//

import WidgetKit
import SwiftUI

@main
struct WorkoutWidgetBundle: WidgetBundle {
    var body: some Widget {
        WorkoutWidget()
        WorkoutWidgetLiveActivity()
    }
}
