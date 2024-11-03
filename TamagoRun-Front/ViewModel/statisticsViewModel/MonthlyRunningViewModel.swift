//
//  MonthlyRunningViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import Foundation
import SwiftUI

class MonthlyRunningViewModel: ObservableObject {
    @Published private(set) var monthlyData: [MonthRunData] = []
    private let healthKitManager = HealthKitManager()
    
    struct MonthRunData: Identifiable {
        let id = UUID()
        let month: Int
        let distance: Double
        let calories: Double
        let duration: TimeInterval
        let pace: Double
    }
    
    struct ChartData: Identifiable {
        let id: UUID
        let monthName: String
        let distance: Double
    }
    
    private let monthFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
    
    var chartDataItems: [ChartData] {
        // 1-12월 모든 달에 대한 데이터 생성
        (1...12).map { month in
            // 해당 월의 데이터가 있으면 사용, 없으면 거리 0으로 설정
            if let monthData = monthlyData.first(where: { $0.month == month }) {
                return ChartData(
                    id: UUID(),
                    monthName: "\(month)",
                    distance: monthData.distance
                )
            } else {
                return ChartData(
                    id: UUID(),
                    monthName: "\(month)",
                    distance: 0
                )
            }
        }
    }
    
    var totalDistance: String {
        String(format: "%.1f", monthlyData.reduce(0) { $0 + $1.distance })
    }
    
    var totalCalories: String {
        String(format: "%.0f", monthlyData.reduce(0) { $0 + $1.calories })
    }
    
    var averagePace: String {
        let totalPace = monthlyData.reduce(0) { $0 + $1.pace }
        let avgPace = monthlyData.isEmpty ? 0 : totalPace / Double(monthlyData.count)
        let minutes = Int(avgPace)
        let seconds = Int((avgPace - Double(minutes)) * 60)
        return String(format: "%d'%02d\"", minutes, seconds)
    }
    
    var totalTime: String {
        let total = monthlyData.reduce(0) { $0 + $1.duration }
        let hours = Int(total) / 3600
        let minutes = Int(total) / 60 % 60
        let seconds = Int(total) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
    
    func loadMonthlyData() {
        let currentYear = Calendar.current.component(.year, from: Date())
        
        healthKitManager.fetchMonthlyRunningStats(forYear: currentYear) { [weak self] runningData in
            // 월별로 데이터 집계
            let groupedByMonth = Dictionary(grouping: runningData) {
                Calendar.current.component(.month, from: $0.date)
            }
            
            // 각 월의 합계 계산
            let monthlyStats = groupedByMonth.map { (month, data) -> MonthRunData in
                let totalDistance = data.reduce(0) { $0 + $1.distance }
                let totalCalories = data.reduce(0) { $0 + $1.calories }
                let totalDuration = data.reduce(0) { $0 + $1.duration }
                let avgPace = data.reduce(0) { $0 + $1.pace } / Double(data.count)
                
                return MonthRunData(
                    month: month,
                    distance: totalDistance,
                    calories: totalCalories,
                    duration: totalDuration,
                    pace: avgPace
                )
            }
            
            DispatchQueue.main.async {
                self?.monthlyData = monthlyStats
            }
        }
    }
}
