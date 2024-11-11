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
    @Environment(\.dismiss) private var dismiss
    @State private var showFriendsList = false
    
    @State private var showMyPage = false // MyPage 표시 상태
    
    @State private var isAlarmExpanded = false // Alarm 섹션의 확장 상태를 관리하는 변수
    @State private var isRunningAlertEnabled = false // 러닝 닭달 알림 스위치 상태
    @State private var isMissionAlertEnabled = false // 미션 알림 스위치 상태
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // 닫기 버튼
                VStack {
                    Text(characterViewModel.loginId) // 여기에 아이디 표시
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.bottom, 5)
                        .underline() // 텍스트에 밑줄 추가
                        .background(Color.white)
                        .foregroundColor(.black)
                    
                    // MyPage 전체화면 버튼
                    Button(action: {
                        showMyPage = true // 버튼을 누르면 showMyPage를 true로 변경
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
                
                // Friends 버튼 - 전체화면 전환을 위해 수정
                Button(action: {
                    showFriendsList = true
                    dismiss() // 사이드 메뉴 닫기
                }) {
                    Text("Friends")
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
                            Toggle("러닝 닥달 알림 받기", isOn: $isRunningAlertEnabled)
                                .font(.custom("DungGeunMo", size: 15))
                                .padding(.horizontal)
                            
                            Toggle("미션 알림", isOn: $isMissionAlertEnabled)
                                .font(.custom("DungGeunMo", size: 15))
                                .padding(.horizontal)
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 10)
                        .transition(.opacity) // 부드러운 나타남/사라짐 효과
                        .animation(.easeInOut(duration: 0.3), value: isAlarmExpanded) // 애니메이션 적용
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
                NavigationStack {
                    FriendsListView(isPresented: $showFriendsList)
                }
            }
        }
    }
}


#Preview {
    // 미리보기를 위한 가짜 데이터 생성
    let characterViewModel = CharacterViewModel()
    let loginViewModel = LoginViewModel()
    
    // 가짜 데이터 설정
    characterViewModel.loginId = "TestUser123"
    characterViewModel.characterImages = ["character_image_1"] // 실제 에셋에 있는 이미지 이름으로 변경하세요
    
    return SideMenuView(
        characterViewModel: characterViewModel,
        viewModel: loginViewModel,
        isLoggedIn: .constant(true) // Binding<Bool> 값을 .constant()로 생성
    )
}
