//
//  SignUpViewModel.swift
//  TestProject
//
//  Created by 황상환 on 9/14/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    enum AlertType {
        case error
        case success
    }
    
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var email: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var isEmailVerified: Bool = false // 이메일 인증 여부 상태 변수
    private var verificationCode: String = "" // 서버에서 받은 인증 코드
    @Published var isSignUpSuccessful: Bool = false // 회원가입 성공 여부를 나타내는 변수

    
    // 추가된 상태 변수
    @Published var showAlert: Bool = false // 알림창 표시 여부
    @Published var alertMessage: String = "" // 알림창 메시지
    var alertType: AlertType? // 알림 타입을 나타내는 변수
        

    // ID 중복 확인 메서드
    func checkLoginId() {
        UserService.shared.checkLoginId(id: id) { [weak self] isAvailable in
            DispatchQueue.main.async {
                if isAvailable {
                    self?.showError = false
                    self?.alertMessage = "사용 가능한 아이디입니다."
                    self?.alertType = .success
                    self?.showAlert = true
                } else {
                    self?.showError = true
                    self?.errorMessage = "사용할 수 없는 아이디입니다."
                }
            }
        }
    }
    
    
    func requestVerificationCode() {
        UserService.shared.sendVerificationCode(to: email) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // 인증 코드 요청 성공
                    self?.alertMessage = "인증 코드를 이메일로 보냈습니다."
                    self?.showAlert = true
                } else {
                    // 인증 코드 요청 실패
                    self?.showError = true
                    self?.errorMessage = "인증 코드를 요청할 수 없습니다."
                }
            }
        }
    }
    
    // 인증 코드 검증 메서드 추가
    func verifyCode(for email: String, code: String, completion: @escaping (Bool) -> Void) {
        UserService.shared.verifyCode(for: email, code: code) { isValid in
            DispatchQueue.main.async {
                if isValid {
                    self.isEmailVerified = true
                } else {
                    self.showError = true
                    self.errorMessage = "Invalid verification code."
                }
                completion(isValid)
            }
        }
    }
    
    func signUp() {
        UserService.shared.signUp(id: id, password: password, email: email) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // 회원가입 성공 처리
                    self?.alertMessage = "회원가입에 성공하였습니다."
                    self?.isSignUpSuccessful = true
                    self?.alertType = .success
                    self?.showAlert = true
                } else {
                    // 회원가입 실패 처리
                    self?.showError = true
                    self?.errorMessage = "회원가입에 실패하였습니다."
                    self?.isSignUpSuccessful = false
                    self?.alertType = .error
                    self?.showAlert = true
                }
            }
        }
    }
}

