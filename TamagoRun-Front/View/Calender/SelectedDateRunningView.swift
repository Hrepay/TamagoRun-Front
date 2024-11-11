//
//  SelectedDateRunningView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/10/24.
//

import SwiftUI

struct SelectedDateRunningView: View {
    let date: Date
    let runningData: HealthKitManager.WeeklyRunningData?
    
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("\(dateFormatter.string(from: date)) 기록")
                    .font(.custom("DungGeunMo", size: 15))
                    .padding(.top, 40)
                    .padding(.bottom, 40)
                
                if let data = runningData {
                    // 첫 번째 행: 운동 시간과 평균 페이스
                    HStack {
                        VStack {
                            Text("운동 시간")
                                .font(.custom("DungGeunMo", size: 12))
                                .padding(.bottom, 2)
                            
                            Text(formatDuration(data.duration))
                                .font(.custom("DungGeunMo", size: 20))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                        )
                        .padding(.trailing, 4)
                        
                        VStack {
                            Text("평균 페이스")
                                .font(.custom("DungGeunMo", size: 12))
                                .padding(.bottom, 2)
                            
                            Text(String(format: "%.1f/km", data.pace))
                                .font(.custom("DungGeunMo", size: 20))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                        )
                        .padding(.leading, 4)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                    // 두 번째 행: 칼로리와 거리
                    HStack {
                        VStack(alignment: .leading) {
                            Text("운동 칼로리")
                                .font(.custom("DungGeunMo", size: 12))
                                .padding(.bottom, 2)
                            
                            Text("\(Int(data.calories)) kcal")
                                .font(.custom("DungGeunMo", size: 20))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                        )
                        .padding(.trailing, 4)
                        
                        VStack {
                            Text("거리")
                                .font(.custom("DungGeunMo", size: 12))
                                .padding(.bottom, 2)
                            
                            Text("\(String(format: "%.2f", data.distance)) km")
                                .font(.custom("DungGeunMo", size: 20))
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                        )
                        .padding(.leading, 4)
                    }
                    .padding(.horizontal, 16)
                    
                    // 여기에 나중에 지도를 추가할 수 있는 공간
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 300)
                        .padding()
                } else {
                    Text("러닝 데이터가 없습니다")
                        .font(.custom("DungGeunMo", size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
//            .navigationBarItems(
//                leading: Button(action: {
//                    dismiss()
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("뒤로")
//                            .font(.custom("DungGeunMo", size: 15))
//                    }
//                }
//            )
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // 시간을 "mm:ss" 형식으로 변환하는 헬퍼 함수
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let sampleDate = Date()
    let sampleData = HealthKitManager.WeeklyRunningData(
        date: sampleDate,
        distance: 5.2,  // km
        calories: 450,  // kcal
        duration: 1800, // 30 minutes in seconds
        pace: 5.7      // minutes per km
    )
    
    return SelectedDateRunningView(
        date: sampleDate,
        runningData: sampleData
    )
}