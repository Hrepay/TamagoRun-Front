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
            self.distance = monthlyRunningData.reduce(0) { $0 + $1.distance }
            print("Month \(month) raw data:")
            monthlyRunningData.forEach { data in
                print("  - Date: \(data.date), Distance: \(data.distance)km")
            }
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
    
    // MonthlyRunningViewModel에서
    var chartDataItems: [ChartData] {
        return (1...12).map { month in
            // monthlyData 배열이 비어있을 수 있으므로 안전하게 처리
            if let monthData = monthlyData.first(where: { $0.month == month }) {
                // Optional 바인딩으로 안전하게 처리
                let chartData = ChartData(
                    id: UUID(),
                    monthName: String(month),  // String 초기화를 명시적으로
                    distance: monthData.distance
                )
                print("📊 Month \(month) chart data - Distance: \(monthData.distance)km")
                return chartData
            } else {
                // 데이터가 없는 달은 0으로 처리
                let chartData = ChartData(
                    id: UUID(),
                    monthName: String(month),
                    distance: 0.0
                )
                print("📊 Month \(month) - No data")
                return chartData
            }
        }
    }
    
    // 프로퍼티들 타입 변경
    var totalDistanceValue: Double {
        chartDataItems.reduce(0) { $0 + $1.distance }
    }
    
    var totalCaloriesValue: Int {
        Int(monthlyData.reduce(0) { $0 + $1.calories })
    }
    
    var averagePaceValue: Int {
        let totalPace = monthlyData.reduce(0) { $0 + $1.pace }
        return monthlyData.isEmpty ? 0 : Int(totalPace / Double(monthlyData.count))
    }
    
    var totalTimeValue: TimeInterval {
        monthlyData.reduce(0) { $0 + $1.duration }
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
    var chartYScale: ClosedRange<Double> {
        let maxDistance = chartDataItems.map { $0.distance }.max() ?? 0
        let adjustedMax = maxDistance * 1.2  // 최대값에 20% 추가
        let scaleMax = max(1.0, adjustedMax)  // 최소 스케일 1.0
        print("📈 Adjusted Max distance: \(scaleMax)km")
        return 0...scaleMax
    }
}

