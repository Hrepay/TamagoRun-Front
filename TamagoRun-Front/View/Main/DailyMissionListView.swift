//
//  DailyMissionListView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/6/24.
//

import SwiftUI

struct DailyMissionListView: View {
    @ObservedObject var viewModel: MissionViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.dailyMissions) { mission in
                        DailyMissionCell(
                            mission: mission,
                            canClaim: mission.isCompleted && !mission.hasReceivedReward
                        )
                        .onTapGesture {
                            if mission.isCompleted && !mission.hasReceivedReward {
                                viewModel.claimRewardForMission(mission)
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
            viewModel.fetchDailyMissions()
        }
    }
}

//#Preview {
//    DailyMissionListView()
//}
