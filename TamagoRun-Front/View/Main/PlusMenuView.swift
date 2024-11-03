//
//  PlusMenuView.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct PlusMenuView: View {
    @State private var selectedTab = "일일"
    
    var body: some View {
        ScrollView {
            VStack {
                
                VStack {
                    Text("Calender")
                        .font(.custom("DungGeunMo", size: 18))
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    // Custom CalendarView를 삽입
                    CalenderView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                }
                
                // Mission 섹션
                VStack {
                    Text("Mission")
                        .font(.custom("DungGeunMo", size: 18))
                        .padding(.bottom, 10)
                    
                    HStack {
                        MissionView()
                            .frame(height: 270)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
                .cornerRadius(10)
                
                
                // 성공한 미션 보기 버튼
                Button(action: {
                    // 성공한 미션 보기 액션
                }) {
                    HStack {
                        Text("통계")
                            .font(.custom("DungGeunMo", size: 18))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .background(Color(.white))
            .edgesIgnoringSafeArea(.bottom)
            
            Spacer()
            
        }
    }
}

#Preview {
    PlusMenuView()
}
