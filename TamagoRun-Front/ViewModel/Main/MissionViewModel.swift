//
//  MissionViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/6/24.
//

import SwiftUI


// MARK: - MissionViewModel.swift
@MainActor
class MissionViewModel: ObservableObject {
    @Published var dailyMissions: [Mission] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let missionTitles = [
        "하루에 3Km 이상 뛰기",
        "하루에 5Km 이상 뛰기",
        "30분동안 뛰기",
        "60분동안 뛰기"
    ]
    
    func fetchDailyMissions() {
        guard !isLoading else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await MainService.shared.fetchDailyMissions()
                
                let statuses = [
                    response.missionStatus1,
                    response.missionStatus2,
                    response.missionStatus3,
                    response.missionStatus4
                ]
                let flags = [
                    response.flag1,
                    response.flag2,
                    response.flag3,
                    response.flag4
                ]
                
                dailyMissions = zip(zip(0..., missionTitles), zip(statuses, flags)).map { index_title, status_flag in
                    Mission(
                        id: index_title.0,
                        title: index_title.1,
                        isCompleted: status_flag.0,
                        hasReceivedReward: status_flag.1
                    )
                }
            } catch {
                self.error = error
                print("Failed to fetch missions:", error)
            }
            isLoading = false
        }
    }
    
    func claimRewardForMission(_ mission: Mission) {
        guard !isLoading else { return }
        guard mission.isCompleted && !mission.hasReceivedReward else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await MainService.shared.claimDailyReward()
                
                let statuses = [
                    response.missionStatus1,
                    response.missionStatus2,
                    response.missionStatus3,
                    response.missionStatus4
                ]
                let flags = [
                    response.flag1,
                    response.flag2,
                    response.flag3,
                    response.flag4
                ]
                
                dailyMissions = zip(zip(0..., missionTitles), zip(statuses, flags)).map { index_title, status_flag in
                    Mission(
                        id: index_title.0,
                        title: index_title.1,
                        isCompleted: status_flag.0,
                        hasReceivedReward: status_flag.1
                    )
                }
            } catch {
                self.error = error
                print("Failed to claim reward:", error)
            }
            isLoading = false
        }
    }
    
    var hasUnclaimedRewards: Bool {
        dailyMissions.contains { mission in
            mission.isCompleted && !mission.hasReceivedReward
        }
    }
}

