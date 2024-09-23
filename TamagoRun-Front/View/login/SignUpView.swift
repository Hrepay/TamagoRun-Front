//
//  SignUpView.swift
//  TestProject
//
//  Created by 황상환 on 9/9/24.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var showEmailView: Bool = false
    @StateObject private var viewModel = SignUpViewModel()
    
    @Environment(\.presentationMode) var presentationMode

    let btList = ["email_bt", "IdCheck_bt", "ok_bt"]

    var body: some View {
        VStack {
            Spacer()
            
            Text("Sign up")
                .font(.custom("DungGeunMo", size: 40))
                .padding(.bottom, 35)
            
            HStack {
                TextField("The ID cannot be modified.", text: $viewModel.id)
                    .customTextFieldStyle()
                    .padding(.trailing, -40)
                
                Button(action: {
                    viewModel.checkLoginId()
                }) {
                    Image(btList[1])
                        .resizable()
                        .frame(width: 35, height: 35)
                        .offset(y: -2)
                }
            }
            .padding(.trailing, 40)
            
            SecureField("Password", text: $viewModel.password)
                .customTextFieldStyle()
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .customTextFieldStyle()
            
            HStack {
                TextField("Verify Email", text: $viewModel.email)
                    .customTextFieldStyle()
                    .padding(.trailing, -40)
                
                Button(action: {
                    // 서버에 인증 코드 전송 요청
                    viewModel.requestVerificationCode()
                    showEmailView.toggle() // EmailView 모달을 띄움
                }) {
                    Image(btList[0])
                        .resizable()
                        .frame(width: 35, height: 35)
                        .offset(y: -2)
                }
            }
            .padding(.trailing, 40)
            .padding(.bottom, 30)
            
            if viewModel.showError {
                Text(viewModel.errorMessage)
                    .font(.custom("DungGeunMo", size: 15))
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }

            Button(action: {
                if viewModel.id.isEmpty || viewModel.password.isEmpty || viewModel.confirmPassword.isEmpty || viewModel.email.isEmpty {
                    viewModel.showError = true
                    viewModel.errorMessage = "All fields must be filled in."
                } else if viewModel.password != viewModel.confirmPassword {
                    viewModel.showError = true
                    viewModel.errorMessage = "Passwords do not match."
                } else if !viewModel.isEmailVerified {
                    // 이메일 인증이 완료되지 않았을 경우
                    viewModel.showError = true
                    viewModel.errorMessage = "Email not verified."
                } else {
                    viewModel.showError = false
                    // 회원가입 로직 실행
                    viewModel.signUp()
                    
                }
            }) {
                Image(btList[2])
                    .resizable()
                    .frame(width: 130, height: 50)
            }
            .disabled(!viewModel.isEmailVerified) // 이메일 인증이 완료되지 않으면 버튼 비활성화
            
            Spacer()
            
        }
        .onChange(of: viewModel.isSignUpSuccessful) {
            if viewModel.isSignUpSuccessful {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .sheet(isPresented: $showEmailView) {
            EmailView(email: $viewModel.email, viewModel: viewModel) // EmailView에 viewModel 주입
        }
        .alert(isPresented: $viewModel.showAlert) { // 알림창 띄우기
            Alert(title: Text(viewModel.alertMessage))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                            .font(.custom("DungGeunMo", size: 15))
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}







#Preview {
    SignUpView()
}
