//
//  WeeklyRunningViewModel.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import Foundation
import SwiftUI

class WeeklyRunningViewModel: ObservableObject {
    @Published private(set) var runData: [RunData] = []
    private let healthKitManager = HealthKitManager()
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "E"
        return formatter
    }()
    
    // MARK: - Data Models
    struct RunData: Identifiable {
        let id = UUID()
        let date: Date
        let distance: Double
        let calories: Double
        let duration: TimeInterval
        let pace: Double
    }
    
    struct ChartData: Identifiable {
        let id: UUID
        let weekday: String
        let distance: Double
    }
    
    // MARK: - Public Properties
    var chartDataItems: [ChartData] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // 1은 일요일, 2는 월요일
        let today = Date()
        
        // 이번 주 월요일 구하기
        guard let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return []
        }
        
        // 월요일부터 일요일까지 모든 날짜 생성
        return (0..<7).map { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: monday) else {
                return ChartData(id: UUID(), weekday: "", distance: 0)
            }
            
            // 해당 날짜에 러닝 데이터가 있는지 확인
            if let runDataForDay = runData.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                return ChartData(
                    id: UUID(),
                    weekday: weekdayFormatter.string(from: date),
                    distance: runDataForDay.distance
                )
            } else {
                // 러닝 데이터가 없는 날은 거리를 0으로 설정
                return ChartData(
                    id: UUID(),
                    weekday: weekdayFormatter.string(from: date),
                    distance: 0
                )
            }
        }
    }
    
    // 빈 차트 데이터 생성
    private func createEmptyChartData() -> [ChartData] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // 1은 일요일, 2는 월요일
        let today = Date()
        
        // 이번 주 월요일 구하기
        guard let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return []
        }
        
        // 월요일부터 일요일까지 빈 데이터 생성
        return (0..<7).map { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: monday) else {
                return ChartData(id: UUID(), weekday: "", distance: 0)
            }
            return ChartData(
                id: UUID(),
                weekday: weekdayFormatter.string(from: date),
                distance: 0
            )
        }
    }
    
    // 프로퍼티들 타입 변경
    var totalDistanceValue: Double {
        runData.reduce(0) { $0 + $1.distance }
    }
    
    var totalCaloriesValue: Int {
        Int(runData.reduce(0) { $0 + $1.calories })
    }
    
    var averagePaceValue: Int {
        let totalPace = runData.reduce(0) { $0 + $1.pace }
        return runData.isEmpty ? 0 : Int(totalPace / Double(runData.count))
    }
    
    var totalTimeValue: TimeInterval {
        runData.reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - Public Methods
    func loadWeeklyData() {
        healthKitManager.fetchWeeklyRunningStats { [weak self] weeklyData in
            let runData = weeklyData.map { data in
                RunData(
                    date: data.date,
                    distance: data.distance,
                    calories: data.calories,
                    duration: data.duration,
                    pace: data.pace
                )
            }
            self?.runData = runData
        }
    }
}

//    // 샘플 데이터 로드
//    func loadSampleData() {
//        runData = [
//            RunData(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, distance: 1.2),
//            RunData(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, distance: 1.1),
//            RunData(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, distance: 1.5),
//            RunData(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, distance: 2.8),
//            RunData(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, distance: 2.3),
//            RunData(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, distance: 1.4),
//            RunData(date: Date(), distance: 1.2)
//        ]
//    }
//}
