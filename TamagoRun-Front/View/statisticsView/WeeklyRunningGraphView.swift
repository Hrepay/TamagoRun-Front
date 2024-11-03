//
//  WeeklyRunningGraphView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI
import Charts

struct WeeklyRunningGraphView: View {
    @StateObject private var viewModel = WeeklyRunningViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("일주일 통계")
                .font(.custom("DungGeunMo", size: 20))
            
            VStack(alignment: .leading, spacing: 10) {
                Chart(viewModel.chartDataItems) { day in
                    BarMark(
                        x: .value("Day", day.weekday),
                        y: .value("Distance", day.distance),
                        width: 20
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
                        AxisValueLabel {
                            Text("\(value.index * 4) km")
                                .font(.custom("DungGeunMo", size: 12))
                        }
                        AxisGridLine(stroke: StrokeStyle(dash: [5]))
                            .foregroundStyle(.gray.opacity(0.3))
                    }
                }
                .chartYScale(domain: 0...5)
            }
            .padding(.horizontal, 10)
            
            Spacer()
            
            VStack(alignment: .leading) {
                StatisticRow(title: "총 KM", value: viewModel.totalDistance)
                StatisticRow(title: "총 칼로리", value: viewModel.totalCalories)
                StatisticRow(title: "전체 평균 페이스", value: viewModel.averagePace)
                StatisticRow(title: "총 시간", value: viewModel.totalTime)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 50)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .onAppear {
            viewModel.loadWeeklyData()
        }
    }
}


#Preview {
    WeeklyRunningGraphView()
}
