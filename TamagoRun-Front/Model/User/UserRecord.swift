//
//  UserRecord.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/4/24.
//

import Foundation
import UIKit

struct UserRecord: Codable {
    let loginId: String
    let totalRunningTime: Double
    let totalRunningDistance: Double
    let totalCalorie: Double
    let overallAveragePace: Double
}
