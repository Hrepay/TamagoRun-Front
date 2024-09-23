//
//  EmailView.swift
//  TestProject
//
//  Created by 황상환 on 9/11/24.
//

import SwiftUI

struct EmailView: View {
    
    @Binding var email: String // SignUpView에서 전달된 이메일 상태를 받음
    @State private var inputCode: String = "" // 사용자가 입력한 인증 코드
    @ObservedObject var viewModel: SignUpViewModel // ViewModel을 주입받아 사용
    let btList = ["email_bt", "ok_bt"]

    @Environment(\.presentationMode) var presentationMode // 뒤로가기 동작을 위해 필요
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Sign up")
                .font(.custom("DungGeunMo", size: 40))
                .padding(.bottom, 35)
            
            Text("이메일 인증 코드를 보냈어요!")
                .font(.custom("DungGeunMo", size: 17))
                .padding(.bottom, 15)
            
            TextField("Enter the code sent to your email.", text: $inputCode)
                .customTextFieldStyle()
                .padding(.bottom, 20)
            
            Button(action: {
                // 사용자가 입력한 코드를 서버에 보내어 확인
                viewModel.verifyCode(for: email, code: inputCode) { isValid in
                    if isValid {
                        viewModel.isEmailVerified = true // 인증 완료 상태 변경
                        print("이메일 인증 완료")
                        self.presentationMode.wrappedValue.dismiss() // 뷰 닫기
                    } else {
                        print("이메일 인증 실패")
                        // 인증 실패 메시지 표시
                        viewModel.showError = true
                        viewModel.errorMessage = "Invalid verification code."
                    }
                }
            }) {
                Image(btList[1])
                    .resizable()
                    .frame(width: 130, height: 50)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 현재 화면을 닫고 이전 화면으로 돌아가기
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
