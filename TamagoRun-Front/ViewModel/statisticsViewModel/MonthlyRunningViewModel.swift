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
        
        init(month: Int, monthlyRunningData: [HealthKitManager.MonthlyRunningData]) {
            self.month = month
            self.distance = monthlyRunningData.reduce(0) { $0 + $1.distance }  // distance가 이미 km 단위임
            self.calories = monthlyRunningData.reduce(0) { $0 + $1.calories }
            self.duration = monthlyRunningData.reduce(0) { $0 + $1.duration }
            self.pace = monthlyRunningData.isEmpty ? 0 : monthlyRunningData.reduce(0.0) { $0 + $1.pace } / Double(monthlyRunningData.count)
        }
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
        (1...12).map { month in
            if let monthData = monthlyData.first(where: { $0.month == month }) {
                // 디버깅을 위한 출력
                print("Month \(month): Distance = \(monthData.distance)")
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
        // 모든 월의 거리를 합산
        let total = chartDataItems.reduce(0) { $0 + $1.distance }
        return String(format: "%.1f", total)
    }

    var totalCalories: String {
        // 모든 월의 칼로리를 합산
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
        // 모든 월의 시간을 합산
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
            
            // 각 월의 데이터 합산
            let monthlyStats = groupedByMonth.map { (month, data) in
                MonthRunData(month: month, monthlyRunningData: data)
            }
            
            DispatchQueue.main.async {
                self?.monthlyData = monthlyStats.sorted(by: { $0.month < $1.month })
            }
        }
    }
}

// 차트의 최대치를 구하기 위한 메서드
extension MonthlyRunningViewModel {
    // 최대 거리를 기반으로 차트 스케일 계산
    var chartYScale: ClosedRange<Double> {
        // 모든 월의 데이터 중 최대 거리 찾기
        let maxDistance = chartDataItems.map { $0.distance }.max() ?? 0
        
        if maxDistance == 0 {
            return 0...4  // 기본 최대값을 16에서 4로 수정
        }
        
        // 최대값을 올림하여 스케일 설정 (4km 단위 대신 더 작은 단위 사용)
        let scaleMax = ceil(maxDistance * 2) / 2  // 0.5km 단위로 반올림
        let paddedMax = max(scaleMax + 1, 4)  // 여유 공간을 위해 1km 추가하되 최소값은 4km
        
        return 0...paddedMax
    }
    
    // Y축 눈금 간격 계산
    var yAxisStepSize: Double {
        let maxScale = chartYScale.upperBound
        
        // 스케일에 따른 적절한 간격 설정
        if maxScale <= 20 { return 4 }      // 20km 이하: 4km 간격
        else if maxScale <= 40 { return 8 }  // 40km 이하: 8km 간격
        else if maxScale <= 100 { return 20 } // 100km 이하: 20km 간격
        else { return 40 }                    // 100km 초과: 40km 간격
    }
}
