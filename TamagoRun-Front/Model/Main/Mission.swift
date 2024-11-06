//
//  Mission.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/6/24.
//

import Foundation

struct Mission: Identifiable, Hashable {
    let id: Int
    let title: String
    var isCompleted: Bool
    var hasReceivedReward: Bool
}
