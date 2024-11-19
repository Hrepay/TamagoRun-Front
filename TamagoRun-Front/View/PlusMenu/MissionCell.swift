//
//  MissionCell.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct MissionCell: View {
    let mission: Mission
    let canClaim: Bool
    var body: some View {
        HStack {
            Text(mission.title)
                .font(.custom("DungGeunMo", size: 16))
            
            Spacer()
            
            if mission.isCompleted {
                if mission.hasReceivedReward {
                    // 미션 완료 & 보상 수령 완료
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.black)
                } else {
                    // 미션 완료했지만 보상 미수령
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(mission.isCompleted && mission.hasReceivedReward ? Color.gray.opacity(0.3) : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(canClaim ? Color.black.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}

//#Preview {
//    VStack(spacing: 16) {
//        MissionCell(title: "하루에 3Km 이상 뛰기", isCompleted: false, hasReceivedReward: false)
//        MissionCell(title: "하루에 5Km 이상 뛰기", isCompleted: true, hasReceivedReward: false)
//        MissionCell(title: "30분동안 뛰기", isCompleted: true, hasReceivedReward: true)
//    }
//    .padding()
//}
