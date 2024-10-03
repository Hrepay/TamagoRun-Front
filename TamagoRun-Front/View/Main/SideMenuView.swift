//
//  SideMenuView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/25/24.
//

import SwiftUI

struct SideMenuView: View {
        
    // 캐릭터 정보
    @ObservedObject var characterViewModel: CharacterViewModel
    
    // 로그인 상태를 관리하는 변수 (Binding으로 받음)
    @ObservedObject var viewModel: LoginViewModel // LoginViewModel의 인스턴스를 받음
    @Binding var isLoggedIn: Bool

    @State private var isAlarmExpanded = false // Alarm 섹션의 확장 상태를 관리하는 변수
    @State private var isRunningAlertEnabled = false // 러닝 닭달 알림 스위치 상태
    @State private var isMissionAlertEnabled = false // 미션 알림 스위치 상태

    var body: some View {
        VStack(alignment: .leading) {
            
            // 닫기 버튼
            VStack {
                
                // 메뉴 아이템들
                Button(action: {
                    print("My page clicked")
                    // My page 버튼 클릭 시 동작 추가
                }) {
                    Text(characterViewModel.loginId) // 여기에 아이디 표시
                        .font(.custom("DungGeunMo", size: 20))
                        .padding(.bottom, 5)
                        .underline() // 텍스트에 밑줄 추가
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                // 캐릭터 이미지 표시
                HStack {
                    Spacer()
                    if let characterImage = characterViewModel.characterImages.first {
                        Image(characterImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle()) // 이미지를 동그랗게 클립
                            .padding()
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 2) // 테두리 추가
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
            .padding(.top, 50)
            
            
            
            Button(action: {
                print("Friends clicked")
                // Friends 버튼 클릭 시 동작 추가
            }) {
                Text("Friends")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .font(.custom("DungGeunMo", size: 20))
                    .background(Color.white)
                    .foregroundColor(.black)
            }
            
            Button(action: {
                print("Collection clicked")
            }) {
                Text("Collection")
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
            }
            .padding(.bottom, 34) // 아래 여백 추가

        }
        .background(Color.white) // 메뉴 배경색
        .padding()
    }
}

//#Preview {
//    let mockCharacterViewModel = CharacterViewModel()
//    // 미리보기에서 테스트할 데이터를 설정해줍니다.
//    mockCharacterViewModel.loginId = "Tamago01"
//    mockCharacterViewModel.experience = 5000
//    mockCharacterViewModel.evolutionLevel = 3
//    mockCharacterViewModel.characterImages = ["fire_dragon_1", "fire_dragon_2", "fire_dragon_3", "fire_dragon_4"]
//    
//    return SideMenuView(characterViewModel: mockCharacterViewModel)
//}
