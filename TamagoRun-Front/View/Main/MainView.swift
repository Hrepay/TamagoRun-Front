//
//  MainView.swift
//  TestProject
//
//  Created by 황상환 on 9/8/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var progress: Double = 0.5
    let eggImg = ["egg_1", "egg_2", "egg_3", "egg_4","egg_5"]

    // 일주일 러닝 데이터 끌어오기
    let sprout = ["sprout_fill", "sprout_empty"]
    @State private var weeklyRunningData: [Bool] = Array(repeating: false, count: 7)

    
    let TestImage = ["mangna", "jiwo"]
    
    let running = ["run_1", "run_2", "run_3", "run_4"]

    @State private var currentImageIndex = 0
    @State private var isShowingMenu = false
    
    @State private var isShowingStartRunning = false // StartRunning

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                // 상단 메뉴 (필요 시 추가)
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingMenu.toggle()
                        }
                    }) {
                        Image("side_bar")
                            .resizable()
                            .frame(width: 30, height: 25)
                            .padding()
                    }
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Text("Tamago01")
                        .font(.custom("DungGeunMo", size: 30))
                        .padding()
                    
                    HStack {
                        
                        Text("0 / 10000000m")
                            .font(.custom("DungGeunMo", size: 20))
                            .padding(.leading, 25)
                        
                        Image("more_info_bt")
                            .resizable()
                            .frame(width: 20, height: 20)
                        

                    }
                    HStack(alignment: .center) {
                        Text("[")
                            .font(.custom("DungGeunMo", size: 24))
                        
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .black))
                            .frame(width: 200, height: 10)
                            .padding(.top, 5)
                        
                        Text("]")
                            .font(.custom("DungGeunMo", size: 24))
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Image(running[currentImageIndex])
                            .resizable()
                            .frame(width: 100, height: 100)
                            .onAppear {
                                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                                    currentImageIndex = (currentImageIndex + 1) % running.count
                                }
                            }
                            .padding()
                            .padding(.top, 30)
                    }
                    
                    Text("level.0")
                        .font(.custom("DungGeunMo", size: 20))
                        .foregroundColor(.gray)
                }
                .padding(.bottom)
                
                Spacer()
                
                VStack {
                    Text("이번주 기록")
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        // 일주일 데이터를 기반으로 sprout_fill 또는 sprout_empty를 표시
                        ForEach(0..<7, id: \.self) { index in
                            Image(weeklyRunningData[index] ? sprout[0] : sprout[1])
                                .resizable()
                                .frame(width: 40, height: 30)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Button(action: {
                        print("캘린더 보기 버튼 클릭")
                    }) {
                        HStack {
                            Text("캘린더 보기")
                                .font(.custom("DungGeunMo", size: 17))
                            Image(systemName: "chevron.up")
                                .font(.system(size: 20))
                        }
                        .padding()
                        .frame(width: 200, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    }
                    .foregroundColor(.black)
                    .padding()
                    
                    // 두 번째 버튼: Run
                    Button(action: {
                        withAnimation {
                            isShowingStartRunning = true // Run 버튼 클릭 시 StartRunning 뷰 표시
                        }
                    }) {
                        Text("Run")
                            .font(.custom("DungGeunMo", size: 20))
                            .padding()
                            .frame(width: 200, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()
            if isShowingMenu {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingMenu.toggle()
                        }
                    }
            }
            
            SideMenuView()
                .frame(width: UIScreen.main.bounds.width * 0.7)
                .background(Color.white)
                .offset(x: isShowingMenu ? 0 : -UIScreen.main.bounds.width * 0.7)
        }
        .onAppear {
            // 주간 러닝 데이터 불러오기
            HealthKitManager.shared.fetchWeeklyRunningData { data in
                DispatchQueue.main.async {
                    self.weeklyRunningData = data
                }
            }
        }
//        .fullScreenCover(isPresented: $isShowingStartRunning) {
//            StartRunning(isPresented: $isShowingStartRunning)
//        }
    }
}

#Preview {
    MainView()
}
