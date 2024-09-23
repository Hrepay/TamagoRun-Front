//
//  LoginViewModel.swift
//  TestProject
//
//  Created by 황상환 on 9/14/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var loginId: String
    @Published var password: String = ""
    @Published var isLoginSuccessful: Bool = false // 로그인 성공 여부를 나타내는 변수
    @Published var errorMessage: String? = nil
    
    // 비밀번호 재설정 관련 상태
    @Published var email: String = ""
    @Published var authCode: String = ""
    @Published var showResetPasswordView: Bool = false // 비밀번호 재설정 뷰 표시 여부
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // 비번 재설정
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var passwordResetError: String? = nil
    
    init(loginId: String = "") {
        self.loginId = loginId
    }
    
    
    // 로그인 메서드
    func login() {
        UserService.shared.login(id: loginId, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isLoginSuccessful = true // 로그인 성공
                    self?.errorMessage = nil
                } else {
                    self?.isLoginSuccessful = false
                    self?.errorMessage = error
                }
            }
        }
    }
    
    // 이메일로 인증 코드 보내기
    func sendVerificationCode() {
        UserService.shared.sendVerificationCode(to: email) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.alertMessage = "인증 코드가 이메일로 발송되었습니다."
                    self?.showAlert = true
                } else {
                    self?.alertMessage = "이메일 전송에 실패했습니다."
                    self?.showAlert = true
                }
            }
        }
    }
    
    // 비밀번호 재설정 - 이메일 인증 코드 보내기
    func sendVerificationCodePassword(id: String, email: String) {
        UserService.shared.sendVerificationCodePassword(id: id, email: email) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.alertMessage = "인증 코드가 이메일로 발송되었습니다."
                    self?.showAlert = true
                } else {
                    self?.alertMessage = "이메일 전송에 실패했습니다."
                    self?.showAlert = true
                }
            }
        }
    }
    
    // 비밀번호 재설정 - 이메일 인증 코드 인증하기
    func verifyCodeForPasswordReset(id: String, email: String, code: String) {
        UserService.shared.verifyCodeForPasswordReset(id: id, email: email, code: code) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.showResetPasswordView = true // 인증 성공 시 비밀번호 재설정 화면 표시
                } else {
                    self?.alertMessage = "인증에 실패했습니다."
                    self?.showAlert = true
                }
            }
        }
    }
    
    // 비밀번호 재설정 메서드
    func resetPassword(completion: @escaping () -> Void) {
        // 비밀번호가 일치하는지 확인
        guard newPassword == confirmPassword else {
            DispatchQueue.main.async {
                self.passwordResetError = "비밀번호가 동일하지 않습니다."
            }
            return
        }
        
        // 서버로 비밀번호 재설정 요청
        UserService.shared.resetPassword(id: loginId, password: newPassword) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // 비밀번호 재설정 성공 시
                    self?.passwordResetError = nil
                    completion() // 창을 닫는 클로저 실행
                } else {
                    self?.passwordResetError = "비밀번호 재설정에 실패했습니다."
                }
            }
        }
    }
}
