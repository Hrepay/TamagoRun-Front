//
//  MissionCell.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct MissionCell: View {
    var mission: String
    var onComplete: () -> Void // 미션을 완료했을 때의 액션

    var body: some View {
        Button(action: {
            onComplete() // 미션 완료 시 동작 수행
        }) {
            Text(mission)
                .font(.custom("DungGeunMo", size: 15))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle()) // 기본 버튼 스타일을 제거하여 커스텀 스타일 적용
    }
}

#Preview {
    MissionCell(mission: "하루 5000보 달성하기") {
        // 미션 완료 시 실행될 동작 (예: 로그 출력)
        print("미션 완료")
    }
}
