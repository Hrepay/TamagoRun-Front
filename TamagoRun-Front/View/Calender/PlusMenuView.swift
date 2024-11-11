//
//  PlusMenuView.swift
//  TestProject
//
//  Created by 황상환 on 9/17/24.
//

import SwiftUI

struct PlusMenuView: View {
    @State private var selectedTab = "일일"
    @State private var showStats = false
    
    // 뒤로가기 커스텀
    @Environment(\.presentationMode) var presentationMode // 추가

    
    var body: some View {
        // 뒤로가기
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                }
            }
            .padding(.leading,20)
            .padding(.bottom, 5)
            
            Spacer()
        }
        .padding(.top)
            
        ScrollView {
            VStack {
                
                VStack {
                    Text("Calender")
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.bottom, 10)
                    
                    // Custom CalendarView를 삽입
                    CalenderView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.horizontal,5)
                    
                }
                
                // Mission 섹션
                VStack {
                    Text("Mission")
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.bottom, 5)
                    
                    HStack {
                        MissionView()
                            .frame(height: 270)
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )                }
                .padding(5)
                .cornerRadius(10)
                
                
                // 통계
                Button(action: {
                    showStats = true
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
//                    .cornerRadius(10)
//                    .shadow(radius: 2)
                }
                .padding(.horizontal, 5)
            }
            .padding(.horizontal)
            .background(Color(.white))
            .edgesIgnoringSafeArea(.bottom)
            
            Spacer()
        }
        .sheet(isPresented: $showStats) {
            RunningStatsContainerView()
        }
        .navigationBarHidden(true)
        
    }
}

#Preview {
    PlusMenuView()
}
