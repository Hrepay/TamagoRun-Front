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
    @Published var sessionID: String? = nil // 세션 ID를 저장할 변수 추가
    
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
    
    // 로그 아웃 관리
    @Published var isCheckingSession: Bool = true  // 세션을 확인 중인 상태를 관리
    @Published var isLoggedIn: Bool = false        // 로그인 상태를 관리
    
    // 로그아웃 시 호출할 초기화 메서드
    func resetState() {
        DispatchQueue.main.async {
            self.loginId = ""
            self.password = ""
            self.isLoginSuccessful = false
            self.errorMessage = nil
            self.sessionID = nil
            self.isCheckingSession = false  // 추가
            self.isLoggedIn = false        // 추가
            
            // UserDefaults 완전 초기화
            UserDefaults.standard.removeObject(forKey: "sessionID")
            UserDefaults.standard.synchronize()
        }
    }


    let userService = UserService()
    
    init(loginId: String = "") {
        self.loginId = loginId
    }
    
    func checkSession() {
        if let storedSessionID = UserDefaults.standard.string(forKey: "sessionID") {
            // 서버와의 통신으로 세션 확인
            userService.checkSessionID(storedSessionID) { isValid in
                DispatchQueue.main.async {
                    self.isCheckingSession = false
                    if isValid {
                        self.isLoggedIn = true
                    } else {
                        UserDefaults.standard.removeObject(forKey: "sessionID")
                        self.isLoggedIn = false
                    }
                }
            }
        } else {
            // 세션이 없으면 바로 확인 완료
            DispatchQueue.main.async {
                self.isCheckingSession = false
                self.isLoggedIn = false
            }
        }
    }
    
    // 로그인 메서드
    func login(completion: @escaping (Bool) -> Void) {
        UserService.shared.login(id: loginId, password: password) { [weak self] success, sessionID in
            DispatchQueue.main.async {
                if success {
                    self?.isLoginSuccessful = true
                    self?.isLoggedIn = true
                    self?.sessionID = sessionID
                    if let sessionID = sessionID {
                        UserDefaults.standard.set(sessionID, forKey: "sessionID")
                    }
                    self?.errorMessage = nil
                    completion(true)  // 성공 시 completion 호출
                } else {
                    self?.isLoginSuccessful = false
                    self?.errorMessage = sessionID ?? "로그인에 실패했습니다."
                    completion(false)  // 실패 시 completion 호출
                }
            }
        }
    }
    
    // 로그아웃 처리 메서드
    func logout(completion: @escaping (Bool) -> Void) {
        UserService.shared.logout { success in
            if success {
                // 로그아웃 성공 시 세션 ID 제거
                UserDefaults.standard.removeObject(forKey: "sessionID")
                // 상태 초기화
                self.resetState()
                completion(true)
            } else {
                print("Logout failed")
                completion(false)
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
