//
//  forgotPasswordView.swift
//  TestProject
//
//  Created by 황상환 on 9/12/24.
//

import SwiftUI

struct forgotPasswordView: View {
    
    @StateObject private var viewModel = LoginViewModel(loginId: "")
    let btList = ["email_bt", "ok_bt"]
    @State private var showEmailView: Bool = false // 이메일 인증창을 띄우기 위한 상태

    @Environment(\.presentationMode) var presentationMode // 뒤로가기 동작을 위해 필요
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("forgot\nPassword")
                .font(.custom("DungGeunMo", size: 40))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 35)
            
            Text("회원가입할 때 작성했던 이메일로 인증 코드를 보내드려요.")
                .font(.custom("DungGeunMo", size: 11))
                .padding(.bottom, 15)
            
            TextField("ID", text: $viewModel.loginId) // ViewModel의 loginId에 바인딩
                .customTextFieldStyle()
            
            HStack {
                TextField("Verify Email", text: $viewModel.email) // ViewModel의 email에 바인딩
                    .customTextFieldStyle()
                    .padding(.trailing, -40)
                
                Button(action: {
                    viewModel.sendVerificationCodePassword(id: viewModel.loginId, email: viewModel.email) // 이메일로 인증 코드 전송
                }) {
                    Image(btList[0])
                        .resizable()
                        .frame(width: 35, height: 35)
                        .offset(y: -2)
                }
            }
            .padding(.trailing, 40)
            .padding(.bottom, 10)
            
            TextField("Enter the code sent to your email.", text: $viewModel.authCode) // ViewModel의 authCode에 바인딩
                .customTextFieldStyle()
                .padding(.top, -10)
            
            Button(action: {
                // 아이디, 이메일, 인증 코드 검증
                viewModel.verifyCodeForPasswordReset(id: viewModel.loginId, email: viewModel.email, code: viewModel.authCode)
            }) {
                Image(btList[1])
                    .resizable()
                    .frame(width: 130, height: 50)
            }
            .padding(.bottom, 50)
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.showResetPasswordView) { // showResetPasswordView에 바인딩
            // ResetPasswordView 생성 시, forgotPasswordView의 presentationMode를 전달
            ResetPasswordView(loginId: viewModel.loginId, parentPresentationMode: presentationMode) // loginId와 presentationMode를 전달
        }
        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 뒤로가기 동작
                    self.presentationMode.wrappedValue.dismiss() // 현재 화면을 닫고 이전 화면으로 돌아가기
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // 왼쪽 화살표 아이콘
                        Text("뒤로") // 텍스트 추가
                            .font(.custom("DungGeunMo", size: 15))
                    }
                    .foregroundColor(.black) // 버튼 색상 설정
                }
            }
        }
        .alert(isPresented: $viewModel.showAlert) { // ViewModel의 showAlert에 바인딩
            Alert(title: Text("알림"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("확인")))
        }
    }
}

#Preview {
    forgotPasswordView()
}
