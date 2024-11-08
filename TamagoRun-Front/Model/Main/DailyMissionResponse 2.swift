//
//  DailyMissionResponse.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/6/24.
//

import Foundation

struct DailyMissionResponse: Codable {
    let missionStatus1: Bool
    let missionStatus2: Bool
    let missionStatus3: Bool
    let missionStatus4: Bool
    let flag1: Bool
    let flag2: Bool
    let flag3: Bool
    let flag4: Bool
}
