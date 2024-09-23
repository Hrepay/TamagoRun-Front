//
//  LoginView.swift
//  TestProject
//
//  Created by 황상환 on 9/9/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel() // 뷰 모델 사용
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToMainView: Bool = false // MainView로 이동하기 위한 상태 변수
    
    let btList = ["email_bt", "ok_bt"]
    
    var body: some View {
        NavigationStack { // NavigationStack 사용
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.custom("DungGeunMo", size: 40))
                    .padding(.bottom, 40)
                
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
                        // 로그인 성공 시 MainView로 이동하기 위해 상태 변수 변경
                        navigateToMainView = true
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
                    MainView()
                }
            }
            .onChange(of: viewModel.isLoginSuccessful) {
                if viewModel.isLoginSuccessful {
                    navigateToMainView = true
                }
            }
        }
        .navigationBarBackButtonHidden(true) // 이 줄을 추가하여 파란색 "< Back" 버튼을 숨깁니다.
    }
}

#Preview {
    LoginView()
}
