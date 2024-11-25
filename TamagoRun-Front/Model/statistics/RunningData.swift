
//
//  RunningData.swift
//  TestProject
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI
import Combine

class RunningData: ObservableObject {
    @Published var distance: Double = 0.0
    @Published var pace: Int = 0  // 초 단위로 변경
    @Published var calories: Int = 0
    @Published var elapsedTime: TimeInterval = 0.0
    @Published var displayTime: TimeInterval = 0.0
}
