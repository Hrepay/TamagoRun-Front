//
//  MissionView.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

import SwiftUI

enum MissionTab: String, CaseIterable {
    case daily = "일일"
    case weekly = "주간"
    case achievements = "업적"
}

struct MissionView: View {
    @State private var selectedTab = MissionTab.daily

    var body: some View {
        VStack(spacing: 16) {
            // 일일 / 주간 / 업적 탭
            missionTabs

            // 스크롤 가능한 미션 리스트 뷰
            MissionListView(selectedTab: selectedTab)

            Spacer()
        }
        .padding(.horizontal)
        .background(Color(.white))
        .edgesIgnoringSafeArea(.bottom)
    }

    // 탭 뷰 컴포넌트
    private var missionTabs: some View {
        HStack(spacing: 16) {
            ForEach(MissionTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    Text(tab.rawValue)
                        .font(.custom("DungGeunMo", size: 18))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(selectedTab == tab ? Color.black : Color.clear)
                        .foregroundColor(selectedTab == tab ? .white : .black)
                        .cornerRadius(8)
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MissionView()
}
