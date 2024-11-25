//
//  SideMenuView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/25/24.
//

import SwiftUI

struct SideMenuView: View {
    
    @ObservedObject var characterViewModel: CharacterViewModel
    @ObservedObject var viewModel: LoginViewModel
    @Binding var isLoggedIn: Bool
    @Binding var showManual: Bool
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowingMenu: Bool  // 추가

    
    @State private var showFriendsList = false // 친구 리스트
    @State private var showMyPage = false // MyPage 표시 상태
    @State private var isAlarmExpanded = false // Alarm 섹션의 확장 상태를 관리하는 변수
    @AppStorage("isRunningAlertEnabled") private var isRunningAlertEnabled = false
    @State private var isMissionAlertEnabled = false // 미션 알림 스위치 상태
    @State private var isQnA = false
    
    @StateObject private var notificationSettings = NotificationSettings() // 알람
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // 아이디 표시
                VStack {
                    Text(characterViewModel.loginId) // 여기에 아이디 표시
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.bottom, 5)
//                        .underline() // 텍스트에 밑줄 추가
                        .background(Color.white)
                        .foregroundColor(.black)
                    
                    // MyPage 전체화면 버튼
                    Button(action: {
                        showMyPage = true
                    }) {
                        HStack {
                            Spacer()
                            if let characterImage = characterViewModel.characterImages.first {
                                Image(characterImage)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding()
                                    .overlay(
                                        Circle().stroke(Color.black, lineWidth: 1)
                                    )
                                    .padding()
                            } else {
                                Text("캐릭터 이미지 로딩 중...")
                                    .font(.custom("DungGeunMo", size: 10))
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                    .accentColor(.black)
                    .fullScreenCover(isPresented: $showMyPage) {
                        MyPageView() // MyPageView를 전체 화면으로 표시
                    }
                }
                .padding(.top, 50)
                
                // Manual 버튼 추가 (Friends 버튼 위에)
                Button(action: {
                    showManual = true
                    isShowingMenu = false
                    
                }) {
                    Text("Manual")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .font(.custom("DungGeunMo", size: 20))
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                
                // Friends 버튼 - 전체화면 전환을 위해 수정
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showFriendsList = true
                    }
                    dismiss() // 사이드 메뉴 닫기
                }) {
                    Text("Friends")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .font(.custom("DungGeunMo", size: 20))
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    isQnA = true
                    dismiss() // 사이드 메뉴 닫기
                }) {
                    Text("Support")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .font(.custom("DungGeunMo", size: 20))
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                
                
                // Alarm 섹션
                VStack(alignment: .leading) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isAlarmExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text("Alarm")
                                .font(.custom("DungGeunMo", size: 20))
                            Spacer()
                            Image(systemName: isAlarmExpanded ? "chevron.down" : "chevron.up")
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                    }
                    
                    // 터치 시 나타났다 없어지는 효과로 수정
                    if isAlarmExpanded {
                        VStack(alignment: .leading) {
                            Toggle("러닝 알림 받기", isOn: $notificationSettings.isRunningAlertEnabled)
                                .font(.custom("DungGeunMo", size: 15))
                                .padding(.horizontal)
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: isAlarmExpanded)
                    }
                }
                
                
                // 로그아웃 버튼
                Spacer()
                Button(action: {
                    print("Logout clicked")
                    // 로그아웃 처리 메서드 호출
                    viewModel.logout { success in
                        if success {
                            DispatchQueue.main.async {
                                isLoggedIn = false
                                viewModel.resetState()
                            }
                            print("로그아웃 되었습니다.")
                        } else {
                            print("로그아웃 실패")
                        }
                    }
                }) {
                    HStack {
                        Text("Logout")
                            .font(.custom("DungGeunMo", size: 20))
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)
                    )
                    .padding()
                }
                .padding(.bottom, 34) // 아래 여백 추가
                
            }
            .background(Color.white)
            .padding()
            .fullScreenCover(isPresented: $showFriendsList) {
                // NavigationStack 제거
                FriendsListView(isPresented: $showFriendsList)
            }
            .fullScreenCover(isPresented: $isQnA) {
                ContactDeveloper()
            }
        }
    }
}


//#Preview {
//    // 미리보기를 위한 가짜 데이터 생성
//    let characterViewModel = CharacterViewModel()
//    let loginViewModel = LoginViewModel()
//    
//    // 가짜 데이터 설정
//    characterViewModel.loginId = "TestUser123"
//    characterViewModel.characterImages = ["character_image_1"] // 실제 에셋에 있는 이미지 이름으로 변경하세요
//    
//    return SideMenuView(
//        characterViewModel: characterViewModel,
//        viewModel: loginViewModel,
//        isLoggedIn: .constant(true),
//        showManual: .constant(false)  // Preview용 showManual 바인딩 추가
//    )
//}
