//
//  MainView.swift
//  TestProject
//
//  Created by 황상환 on 9/8/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var progress: Double = 0.5
    
    // 일주일 러닝 데이터 끌어오기
    let sprout = ["sprout_fill", "sprout_empty"]
    @State private var weeklyRunningData: [Bool] = Array(repeating: false, count: 7)

    // 캐릭터 정보
    @StateObject var characterViewModel = CharacterViewModel()
    // 캐릭터 정보 000일때
    @State private var showCharacterSelection = false

    @State private var currentImageIndex = 0
    @State private var isShowingMenu = false
    @State private var isShowingStartRunning = false // StartRunning
    
    @EnvironmentObject var viewModel: LoginViewModel
    @Binding var isLoggedIn: Bool // isLoggedIn 바인딩
    
    // 진화 모달
    @State private var showEvolutionModal = false
    
    // 메뉴얼 모달
    @State private var showManual = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack {
                    Spacer()
                    // 사이드바
                    HStack {
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.1)) {
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
    
                    
                    UserCharacterInfoView(
                                    characterViewModel: characterViewModel,
                                    showEvolutionModal: $showEvolutionModal
                                )
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
                                    .frame(width: 30, height: 20)
                                    .padding(.horizontal, 3)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        
                        // 두 번째 버튼: Run
                        Button(action: {
                            withAnimation {
                                isShowingStartRunning = true // Run 버튼 클릭 시 StartRunning 뷰 표시
                            }
                        }) {
                            Text("Run")
                                .font(.custom("DungGeunMo", size: 22.5))
                                .padding()
                                .frame(width: 200, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        }
                        .foregroundColor(.black)
                        .padding()
                        
                        NavigationLink(destination: PlusMenuView()) { // NavigationLink로 변경
                            HStack {
                                Text("더보기")
                                    .font(.custom("DungGeunMo", size: 17))

                            }
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
                            withAnimation(.easeInOut(duration: 0.0)) {
                                isShowingMenu.toggle()
                            }
                        }
                }
                
                // 캐릭터 선택 000
                if characterViewModel.shouldShowCharacterSelection {
                    CharacterSelectView(
                        isPresented: $characterViewModel.shouldShowCharacterSelection,
                        onCharacterSelected: { success in
                            if success {
                                characterViewModel.fetchCharacterInfo()
                                
                                // 최초 실행 시에만 메뉴얼 표시
                                if !UserDefaults.standard.bool(forKey: "hasShownManual") {
                                    showManual = true
                                    UserDefaults.standard.set(true, forKey: "hasShownManual")
                                }
                            }
                        }
                    )
                }
                
                // 메뉴얼 뷰
                if showManual {
                    ManualMainView(isPresented: $showManual)
                }
                
                // 진화 모달
                if showEvolutionModal {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            EvolutionModalView(
                                characterViewModel: characterViewModel,
                                isPresented: $showEvolutionModal
                            )
                            .frame(width: 300, height: 400)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .position(
                                x: geometry.size.width / 2,
                                y: geometry.size.height / 2
                            )
                            Spacer()
                        }
                    }
                }
                
                SideMenuView(
                    characterViewModel:
                    characterViewModel,
                    viewModel: viewModel,
                    isLoggedIn: $isLoggedIn,
                    showManual: $showManual,
                    isShowingMenu: $isShowingMenu  // 추가

                )
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
                
                // 캐릭터 정보 불러오기
                characterViewModel.fetchCharacterInfo()
            }
            .fullScreenCover(isPresented: $isShowingStartRunning) {
                StartRunning(isPresented: $isShowingStartRunning)
            }
        }
    }
}

//#Preview {
//    MainView()
//}
