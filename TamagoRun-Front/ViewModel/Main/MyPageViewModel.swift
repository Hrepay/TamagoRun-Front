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
    var totalDistanceValue: Double {
        // userRecord에서 Double 값 반환
        Double(userRecord?.totalRunningDistance ?? 0)
    }
    
    var totalCaloriesValue: Double {
        // userRecord에서 Double 값 반환
        Double(userRecord?.totalCalorie ?? 0)
    }
    
    var averagePaceValue: Double {
        // userRecord에서 Double 값 반환
        Double(userRecord?.overallAveragePace ?? 0)
    }
    
    var totalTimeValue: Double {
        // userRecord에서 Double 값 반환
        Double(userRecord?.totalRunningTime ?? 0)
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
