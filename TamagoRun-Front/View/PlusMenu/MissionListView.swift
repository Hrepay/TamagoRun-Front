//
//  MissionListView.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct MissionListView: View {
    @ObservedObject var viewModel: MissionViewModel
    let missionType: MissionTab
    
    var missions: [Mission] {
        switch missionType {
        case .daily:
            return viewModel.dailyMissions
        case .weekly:
            return viewModel.weeklyMissions
        case .achievements:
            return viewModel.achievements
        }
    }
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                Text("Loading...")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .padding()
            } else {
                VStack(spacing: 10) {
                    ForEach(missions) { mission in
                        WeeklyMissionCell(
                            mission: mission,
                            canClaim: mission.isCompleted && !mission.hasReceivedReward
                        )
                        .onTapGesture {
                            if mission.isCompleted && !mission.hasReceivedReward {
                                switch missionType {
                                case .daily:
                                    viewModel.claimDailyRewardForMission(mission)
                                case .weekly:
                                    viewModel.claimWeeklyRewardForMission(mission)
                                case .achievements:
                                    viewModel.claimAchievementReward(mission)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 10)
        .onAppear {
            switch missionType {
            case .daily:
                viewModel.fetchDailyMissions()
            case .weekly:
                viewModel.fetchWeeklyMissions()
            case .achievements:
                break
            }
        }
    }
}

//#Preview {
//    MissionListView()
//}
