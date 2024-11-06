//
//  MissionListView.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct MissionListView: View {
    let selectedTab: MissionTab
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(missions(for: selectedTab), id: \.self) { mission in
                    MissionCell(title: mission)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
    
    private func missions(for tab: MissionTab) -> [String] {
        switch tab {
        case .daily:
            return ["하루에 3Km 이상 뛰기", "하루에 5Km 이상 뛰기", "30분동안 뛰기", "60분동안 뛰기기"]
        case .weekly:
            return ["주간 15km 달성", "주간 30km 달성", "주간 2번 이상 러닝", "주간 4번 이상 러닝"]
        case .achievements:
            return ["첫 번째 러닝을 완료", "누적 42.195km 달성", "누적 100km 달성", "한달에 반절 이상 러닝", "친구 맺기 10명", "친구 맺기 20명", "친구 맺기 30명"]
        }
    }
}

//#Preview {
//    MissionListView()
//}
