//
//  DailyRunningRecord.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import Foundation

struct DailyRunningRecord: Codable {
    let coordinates: [RunningLocation]
    
    enum CodingKeys: String, CodingKey {
        case coordinates
    }
}
