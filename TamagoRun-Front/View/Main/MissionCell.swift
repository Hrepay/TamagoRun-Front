//
//  MissionCell.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct MissionCell: View {
    let title: String
    var isCompleted: Bool = false
    var hasReceivedReward: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("DungGeunMo", size: 16))
                .strikethrough(isCompleted)
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(isCompleted ? Color.gray.opacity(0.3) : Color.white)
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 16) {
        MissionCell(title: "하루에 3Km 이상 뛰기", isCompleted: false, hasReceivedReward: false)
        MissionCell(title: "하루에 5Km 이상 뛰기", isCompleted: true, hasReceivedReward: false)
        MissionCell(title: "30분동안 뛰기", isCompleted: true, hasReceivedReward: true)
    }
    .padding()
}
