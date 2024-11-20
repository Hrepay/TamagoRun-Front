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
    @Published var weeklyMissions: [Mission] = []
    @Published var achievements: [Mission] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let dailyMissionTitles = [
        "하루에 3Km 이상 뛰기",
        "하루에 5Km 이상 뛰기",
        "하루에 30분동안 뛰기",
        "하루에 60분동안 뛰기"
    ]
    
    private let weeklyMissionTitles = [
        "주간 15km 달성",
        "주간 30km 달성",
        "주간 2번 이상 러닝",
        "주간 4번 이상 러닝"
    ]
    
    private let achievementTitles = [
            "첫 번째 러닝을 완료",
            "10번째 러닝 완료",
            "30번째 러닝 완료",
            "50번째 러닝 완료",
            "누적 42.195km 달성",
            "누적 100km 달성",
            "첫 번째 친구 맺기",
            "친구 5명 맺기",
            "친구 10명 맺기",
            "친구 15명 맺기",
            "1000kcal 소모",
            "2000kcal 소모",
            "3000kcal 소모"
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
                
                dailyMissions = zip(zip(0..., dailyMissionTitles), zip(statuses, flags)).map { index_title, status_flag in
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
    
    func claimDailyRewardForMission(_ mission: Mission) {
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
                
                dailyMissions = zip(zip(0..., dailyMissionTitles), zip(statuses, flags)).map { index_title, status_flag in
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
    
    // MARK: - Week
    
    // 주간 미션
    func fetchWeeklyMissions() {
        guard !isLoading else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await MainService.shared.fetchWeeklyMissions()
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
                
                await MainActor.run {
                    weeklyMissions = zip(zip(0..., weeklyMissionTitles), zip(statuses, flags)).map { index_title, status_flag in
                        Mission(
                            id: index_title.0,
                            title: index_title.1,
                            isCompleted: status_flag.0,
                            hasReceivedReward: status_flag.1
                        )
                    }
                    print("Weekly Missions Updated:", weeklyMissions)  // 디버깅용
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    print("Failed to fetch weekly missions:", error)
                    isLoading = false
                }
            }
        }
    }
    
    func claimWeeklyRewardForMission(_ mission: Mission) {
        guard !isLoading else { return }
        guard mission.isCompleted && !mission.hasReceivedReward else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await MainService.shared.claimWeeklyReward()
                await MainActor.run {
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
                    
                    weeklyMissions = zip(zip(0..., weeklyMissionTitles), zip(statuses, flags)).map { index_title, status_flag in
                        Mission(
                            id: index_title.0,
                            title: index_title.1,
                            isCompleted: status_flag.0,
                            hasReceivedReward: status_flag.1
                        )
                    }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    print("Failed to claim weekly reward:", error)
                    isLoading = false
                }
            }
        }
    }
    
    // MARK: - Achievements
    func fetchAchievements() {
        guard !isLoading else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await MainService.shared.fetchAchievements()
                let statuses = [
                    response.missionStatus1,
                    response.missionStatus2,
                    response.missionStatus3,
                    response.missionStatus4,
                    response.missionStatus5,
                    response.missionStatus6,
                    response.missionStatus7,
                    response.missionStatus8,
                    response.missionStatus9,
                    response.missionStatus10,
                    response.missionStatus11,
                    response.missionStatus12,
                    response.missionStatus13
                ]
                let flags = [
                    response.flag1,
                    response.flag2,
                    response.flag3,
                    response.flag4,
                    response.flag5,
                    response.flag6,
                    response.flag7,
                    response.flag8,
                    response.flag9,
                    response.flag10,
                    response.flag11,
                    response.flag12,
                    response.flag13
                ]
                
                achievements = zip(zip(0..., achievementTitles), zip(statuses, flags)).map { index_title, status_flag in
                    Mission(
                        id: index_title.0,
                        title: index_title.1,
                        isCompleted: status_flag.0,
                        hasReceivedReward: status_flag.1
                    )
                }
            } catch {
                self.error = error
                print("Failed to fetch achievements:", error)
            }
            isLoading = false
        }
    }
    
    func claimAchievementReward(_ mission: Mission) {
        guard !isLoading else { return }
        guard mission.isCompleted && !mission.hasReceivedReward else { return }
        
        Task {
            isLoading = true
            do {
                let response = try await MainService.shared.claimAchievementReward()
                let statuses = [
                    response.missionStatus1,
                    response.missionStatus2,
                    response.missionStatus3,
                    response.missionStatus4,
                    response.missionStatus5,
                    response.missionStatus6,
                    response.missionStatus7,
                    response.missionStatus8,
                    response.missionStatus9,
                    response.missionStatus10,
                    response.missionStatus11,
                    response.missionStatus12,
                    response.missionStatus13
                ]
                let flags = [
                    response.flag1,
                    response.flag2,
                    response.flag3,
                    response.flag4,
                    response.flag5,
                    response.flag6,
                    response.flag7,
                    response.flag8,
                    response.flag9,
                    response.flag10,
                    response.flag11,
                    response.flag12,
                    response.flag13
                ]
                
                achievements = zip(zip(0..., achievementTitles), zip(statuses, flags)).map { index_title, status_flag in
                    Mission(
                        id: index_title.0,
                        title: index_title.1,
                        isCompleted: status_flag.0,
                        hasReceivedReward: status_flag.1
                    )
                }
            } catch {
                self.error = error
                print("Failed to claim achievement reward:", error)
            }
            isLoading = false
        }
    }
    
    // MARK: - Helper Properties
    var hasUnclaimedDailyRewards: Bool {
        dailyMissions.contains { $0.isCompleted && !$0.hasReceivedReward }
    }
    
    var hasUnclaimedWeeklyRewards: Bool {
        weeklyMissions.contains { $0.isCompleted && !$0.hasReceivedReward }
    }
    
    var hasUnclaimedAchievements: Bool {
        achievements.contains { $0.isCompleted && !$0.hasReceivedReward }
    }
}
