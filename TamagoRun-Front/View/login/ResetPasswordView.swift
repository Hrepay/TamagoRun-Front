//
//  Reset Password.swift
//  TestProject
//
//  Created by 황상환 on 9/12/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel: LoginViewModel
    let btList = ["email_bt", "ok_bt"]

    @Environment(\.presentationMode) var presentationMode // 현재 뷰를 닫기 위한 상태
    var parentPresentationMode: Binding<PresentationMode> // 부모 뷰를 닫기 위한 바인딩
    
    init(loginId: String, parentPresentationMode: Binding<PresentationMode>) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(loginId: loginId)) // LoginViewModel 초기화 시 loginId 전달
        self.parentPresentationMode = parentPresentationMode
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Reset\nPassword")
                .font(.custom("DungGeunMo", size: 40))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 35)
            
            TextField("Enter a new password.", text: $viewModel.newPassword)
                .customTextFieldStyle()
            
            TextField("Confirm Password", text: $viewModel.confirmPassword)
                .customTextFieldStyle()
                .padding(.bottom, 20)
            
            // 비밀번호 불일치 시 오류 메시지 표시
            if let error = viewModel.passwordResetError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.custom("DungGeunMo", size: 14))
                    .padding(.bottom, 10)
            }
            
            Button(action: {
                // 비밀번호 재설정 요청
                viewModel.resetPassword {
                    // 비밀번호 재설정이 성공하면 창 닫기
                    self.presentationMode.wrappedValue.dismiss() // 현재 뷰를 닫기
                    self.parentPresentationMode.wrappedValue.dismiss() // 부모 뷰(forgotPasswordView) 닫기
                }
            }) {
                Image(btList[1])
                    .resizable()
                    .frame(width: 130, height: 50)
            }
            
            Spacer()
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
    }
}

//#Preview {
//    ResetPasswordView()
//}
