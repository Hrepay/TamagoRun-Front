//
//  MyPageViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/4/24.
//

import Foundation

@MainActor 
class MyPageViewModel: ObservableObject {
    @Published private(set) var userRecord: UserRecord?
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false

    private let mainService = MainService.shared

    // Formatted values for view
    var totalDistance: String {
        String(format: "%.1f", userRecord?.totalRunningDistance ?? 0.0)
    }

    var totalCalories: String {
        String(format: "%.0f", userRecord?.totalCalorie ?? 0.0)
    }

    var averagePace: String {
        let pace = userRecord?.overallAveragePace ?? 0
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d'%02d\"", minutes, seconds)
    }

    var totalTime: String {
        let time = userRecord?.totalRunningTime ?? 0
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    var userId: String {
        userRecord?.loginId ?? "Unknown"
    }

    func fetchUserRecord() {
        Task {
            await MainActor.run { // 메인 스레드에서 실행
                isLoading = true
            }
            do {
                let record = try await mainService.fetchUserInfo()
                await MainActor.run { // 메인 스레드에서 실행
                    userRecord = record
                    errorMessage = nil
                }
            } catch {
                await MainActor.run { // 메인 스레드에서 실행
                    errorMessage = (error as? NetworkError)?.message ?? error.localizedDescription
                }
            }
            await MainActor.run { // 메인 스레드에서 실행
                isLoading = false
            }
        }
    }
}
