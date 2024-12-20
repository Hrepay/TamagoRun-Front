//
//  MonthlyRunningGraph.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI
import Charts

struct MonthlyRunningGraphView: View {
    @StateObject private var viewModel = MonthlyRunningViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("월별 통계")
                .font(.custom("DungGeunMo", size: 20))
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Chart(viewModel.chartDataItems) { month in
                    BarMark(
                        x: .value("Month", month.monthName),
                        y: .value("Distance", month.distance),
                        width: 12
                    )
                    .foregroundStyle(.black)
                    .cornerRadius(2)
                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .font(.custom("DungGeunMo", size: 14))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        if let doubleValue = value.as(Double.self) { // value를 Double로 변환
                            AxisValueLabel {
                                Text(String(format: "%.1f km", doubleValue))
                                    .font(.custom("DungGeunMo", size: 12))
                            }
                        }
                    }
                }
                .chartYScale(domain: viewModel.chartYScale)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            VStack(alignment: .leading) {
                StatisticRow(
                    title: "총 KM",
                    type: .distance,
                    value: viewModel.totalDistanceValue
                )
                StatisticRow(
                    title: "총 칼로리",
                    type: .calories,
                    value: Double(viewModel.totalCaloriesValue)
                )
                StatisticRow(
                    title: "전체 평균 페이스",
                    type: .pace,
                    value: Double(viewModel.averagePaceValue)
                )
                StatisticRow(
                    title: "총 시간",
                    type: .time,
                    value: viewModel.totalTimeValue
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 50)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .onAppear {
            viewModel.loadMonthlyData()
        }
    }
 }

#Preview {
    MonthlyRunningGraphView()
}
