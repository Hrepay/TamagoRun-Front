
//
//  RunningData.swift
//  TestProject
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI
import Combine

class RunningData: ObservableObject {
    @Published var distance: Double = 0
    @Published var calories: Int = 0
    @Published var pace: String = "00:00"
}
