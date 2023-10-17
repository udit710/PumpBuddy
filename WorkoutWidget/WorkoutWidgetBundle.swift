//
//  WorkoutWidgetBundle.swift
//  WorkoutWidget
//
//  Created by udit on 18/10/23.
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
