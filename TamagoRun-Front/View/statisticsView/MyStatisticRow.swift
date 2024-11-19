//
//  StatisticRow.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI

struct MyStatisticRow: View {
    let title: String
    let type: StatisticType
    let value: Double
    
    enum StatisticType {
        case distance
        case calories
        case pace
        case time
    }
    
    var formattedValue: String {
        switch type {
        case .distance:
            return RunningDataFormatter.formatDistance(value)
        case .calories:
            return RunningDataFormatter.formatCalories(Int(value))
        case .pace:
            return RunningDataFormatter.formatPace(Int(value))
        case .time:
            return RunningDataFormatter.formatDuration(value)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.custom("DungGeunMo", size: 18))
                .foregroundColor(.gray)
            Text(formattedValue)
                .font(.custom("DungGeunMo", size: 40))
                .foregroundColor(.black)
                .padding(.bottom, 10)
        }
    }
}
