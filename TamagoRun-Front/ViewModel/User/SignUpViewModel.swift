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
    
    // 이메일 형식 검증 함수
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // 인증코드
    func requestVerificationCode(completion: @escaping (Bool) -> Void) {
        // 이메일 형식만 검증
        guard isValidEmail(email) else {
            DispatchQueue.main.async {
                self.showError = true
                self.errorMessage = "올바른 이메일 형식이 아닙니다."
                self.alertMessage = "올바른 이메일 형식이 아닙니다."
                self.showAlert = true
                completion(false)
            }
            return
        }
        
        // 이메일 형식이 맞으면 바로 성공 반환
        DispatchQueue.main.async {
            completion(true)
        }
        
        // 백그라운드에서 서버 요청 처리
        UserService.shared.sendVerificationCode(to: email) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.alertMessage = "인증 코드를 이메일로 보냈습니다."
                } else {
                    self?.errorMessage = "인증 코드를 요청할 수 없습니다."
                    self?.alertMessage = "인증 코드를 요청할 수 없습니다."
                }
                self?.showAlert = true
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
    
    // 회원가입
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

