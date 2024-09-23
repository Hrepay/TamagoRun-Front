//
//  UserService.swift
//  TestProject
//
//  Created by 황상환 on 9/14/24.
//

import Foundation

class UserService {
    static let shared = UserService() // 싱글톤으로 사용
    let baseURL = "http://54.180.217.101:8080"
    // 54.180.217.101:8080

    // ID 중복 확인 메서드
    func checkLoginId(id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/checkLoginId/\(id)") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                // 200이면 사용 가능, 400 또는 409 등의 코드이면 사용 불가
                completion(httpResponse.statusCode == 200)
            } else {
                completion(false)
            }

        }.resume()
    }
    
    // 이메일 인증 코드를 서버에서 받아오는 메서드
    func sendVerificationCode(to email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/requestEmail") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 생성
        let body: [String: Any] = [
            "email": email
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // 입력한 인증코드 서버로
    func verifyCode(for email: String, code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/emailConfirm") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 생성
        let body: [String: Any] = [
            "email": email,
            "authNum": code
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // 회원가입 메서드 추가
    func signUp(id: String, password: String, email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/confirmSignUp") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 생성
        let body: [String: Any] = [
            "loginId": id,
            "password": password,
            "email": email
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // 로그인 메서드 추가
    func login(id: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/login") else {
            print("Invalid URL")
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 생성
        let body: [String: Any] = [
            "loginId": id,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, "Network error")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true, nil) // 로그인 성공
            } else {
                completion(false, "Login failed") // 로그인 실패
            }
        }.resume()
    }
    
    // 비밀번호 재설정 - 이메일 요청 메서드
    func sendVerificationCodePassword(id: String, email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/requestSetPassword") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 생성
        let body: [String: Any] = [
            "loginId": id,
            "email": email
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    
    // 아이디, 이메일, 인증 코드 검증 메서드
    func verifyCodeForPasswordReset(id: String, email: String, code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/confirmSetPassword") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // JSON 데이터 생성
        let body: [String: Any] = [
            "loginId": id,
            "email": email,
            "authNum": code
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true) // 인증 성공
            } else {
                completion(false) // 인증 실패
            }
        }.resume()
    }
    
    // 비밀번호 재설정 메서드
   func resetPassword(id: String, password: String, completion: @escaping (Bool) -> Void) {
       guard let url = URL(string: "\(baseURL)/user/setPassword") else {
           print("Invalid URL")
           completion(false)
           return
       }

       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")

       // JSON 데이터 생성
       let body: [String: Any] = [
           "loginId": id,
           "password": password
       ]
       request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               print("Error: \(error)")
               completion(false)
               return
           }

           if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
               completion(true) // 비밀번호 재설정 성공
           } else {
               completion(false) // 비밀번호 재설정 실패
           }
       }.resume()
   }
}


//#Preview {
//    UserService()
//}
