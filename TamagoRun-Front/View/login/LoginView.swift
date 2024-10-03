//
//  LoginView.swift
//  TestProject
//
//  Created by 황상환 on 9/9/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var isLoggedIn: Bool // 로그인 상태 바인딩
    
    @State private var navigateToMainView = false // 네비게이션 상태 관리 변수 추가
    
    let btList = ["email_bt", "ok_bt"]
    
    var body: some View {
        NavigationStack { // NavigationStack 사용
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.custom("DungGeunMo", size: 40))
                    .padding(.bottom, 20)
                
                // 로그인 입력 필드
                TextField("ID", text: $viewModel.loginId)
                    .customTextFieldStyle()
                
                SecureField("Password", text: $viewModel.password)
                    .customTextFieldStyle()
                
                HStack {
                    Spacer()
                    NavigationLink(destination: forgotPasswordView()) {
                        Text("forgot password?")
                            .font(.custom("DungGeunMo", size: 15)) // 글씨 크기 조정
                            .foregroundColor(.black)
                    }
                }
                .padding(.trailing, 40)
                .padding(.bottom, 40)
                
                // 로그인 버튼
                Button(action: {
                    viewModel.login() // 로그인 함수 호출
                    if viewModel.isLoginSuccessful {
                        // 로그인 성공 시 로그인 상태 변경
                        isLoggedIn = true
                        UserDefaults.standard.set(viewModel.sessionID, forKey: "sessionID") // 세션 저장
                        navigateToMainView = true // 네비게이션 상태 변경
                    }
                }) {
                    Image(btList[1])
                        .resizable()
                        .frame(width: 130, height: 40)
                }
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.custom("DungGeunMo", size: 15))
                        .padding()
                }
            }
            .navigationBarHidden(true) // 기본 네비게이션 바 숨기기
            .overlay(alignment: .topLeading) { // 커스텀 버튼을 원하는 위치에 배치
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                            .font(.custom("DungGeunMo", size: 15))
                    }
                    .foregroundColor(.black)
                    .padding()
                }
            }
            // MainView로의 네비게이션 설정
            .fullScreenCover(isPresented: $navigateToMainView) {
                NavigationStack {
                    MainView(isLoggedIn: $isLoggedIn)
                        .environmentObject(viewModel) // 환경 객체로 넘겨줌
                }
            }
            .onChange(of: viewModel.isLoginSuccessful) {
                navigateToMainView = true
            }
        }
        .navigationBarBackButtonHidden(true) // 이 줄을 추가하여 파란색 "< Back" 버튼을 숨깁니다.
    }
}


#Preview {
    LoginView(isLoggedIn: .constant(false))
}

