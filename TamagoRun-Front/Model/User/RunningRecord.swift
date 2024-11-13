//
//  RunningRecord.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/12/24.
//

import Foundation

struct RunningRecord: Codable {
    let loginId: String
    let totalRunningTime: Int
    let totalRunningDistance: Double
    let totalCalorie: Int
    let overallAveragePace: Double
}
