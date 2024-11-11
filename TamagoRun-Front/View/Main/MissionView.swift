//
//  MissionView.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct MissionView: View {
    @StateObject private var viewModel = MissionViewModel()
    @State private var selectedTab = MissionTab.daily
    
    var body: some View {
        VStack(spacing: 16) {
            missionTabs
            
            MissionListView(viewModel: viewModel, missionType: selectedTab)
            
            Spacer()
        }
        .padding(.horizontal)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if selectedTab == .daily {
                viewModel.fetchDailyMissions()
            }
        }
    }
    
    private var missionTabs: some View {
        HStack(spacing: 0) { // spacing을 0으로 설정
            ForEach([MissionTab.daily, .weekly, .achievements], id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    switch tab {
                    case .daily:
                        viewModel.fetchDailyMissions()
                    case .weekly:
                        viewModel.fetchWeeklyMissions()
                    case .achievements:
                        viewModel.fetchAchievements()
                    }
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
                
                // 마지막 탭이 아닌 경우에만 Divider 추가
                if tab != MissionTab.achievements {
                    Text("|")
                        .font(.custom("DungGeunMo", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 5)
                        .padding(.top, 5)
                }
            }
        }
        .padding(.horizontal, 16)
    }


}

#Preview {
    MissionView()
}
