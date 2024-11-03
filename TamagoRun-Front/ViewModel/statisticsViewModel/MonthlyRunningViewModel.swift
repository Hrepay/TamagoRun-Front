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
   
   struct ChartData: Identifiable {
       let id: UUID
       let monthName: String
       let distance: Double
   }
   
   var chartDataItems: [ChartData] {
       monthlyData.map { data in
           ChartData(
               id: data.id,
               monthName: "\(data.month)",
               distance: data.distance
           )
       }
   }
   
   // 통계 데이터
   var totalDistance: String {
       String(format: "%.1f", monthlyData.reduce(0) { $0 + $1.distance })
   }
   
   var totalCalories: String {
       "0" // 실제 계산 로직 필요
   }
   
   var averagePace: String {
       "0'00''" // 실제 계산 로직 필요
   }
   
   var totalTime: String {
       "0:00:00" // 실제 계산 로직 필요
   }
   
   func loadSampleData() {
       monthlyData = [
           MonthRunData(month: 1, distance: 5.5),
           MonthRunData(month: 2, distance: 4.8),
           MonthRunData(month: 3, distance: 7.2),
           MonthRunData(month: 4, distance: 3.9),
           MonthRunData(month: 5, distance: 1.5),
           MonthRunData(month: 6, distance: 2.1),
           MonthRunData(month: 7, distance: 3.7),
           MonthRunData(month: 8, distance: 2.4),
           MonthRunData(month: 9, distance: 4.9),
           MonthRunData(month: 10, distance: 3.3),
           MonthRunData(month: 11, distance: 5.6),
           MonthRunData(month: 12, distance: 2.2)
       ]
   }
}
