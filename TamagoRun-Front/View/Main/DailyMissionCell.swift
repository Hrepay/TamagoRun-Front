//
//  DailyMissionCell.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/6/24.
//

import SwiftUI

struct DailyMissionCell: View {
    let mission: Mission
    let canClaim: Bool
    
    var body: some View {
        HStack {
            Text(mission.title)
                .font(.custom("DungGeunMo", size: 16))
                // 완료하고 보상까지 받은 경우에만 취소선 표시
                .strikethrough(mission.isCompleted && mission.hasReceivedReward)
            
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
                // 완료하고 보상까지 받은 경우에만 회색 배경
                .fill(mission.isCompleted && mission.hasReceivedReward ? Color.gray.opacity(0.3) : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(canClaim ? Color.black.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}

//#Preview {
//    DailyMissionCell()
//}
