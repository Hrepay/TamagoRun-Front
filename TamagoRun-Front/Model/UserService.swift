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
    
    // 로그인
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
                // 헤더에서 세션 ID 가져오기
                if let fields = httpResponse.allHeaderFields as? [String: String],
                   let cookie = fields["Set-Cookie"] {
                    // 세션 ID 추출
                    if let sessionID = cookie.split(separator: ";").first(where: { $0.contains("JSESSIONID") }) {
                        let sessionIDValue = String(sessionID.split(separator: "=")[1])
                        // 세션 ID 저장
                        UserDefaults.standard.set(sessionIDValue, forKey: "sessionID")
                        completion(true, sessionIDValue) // 로그인 성공 시 세션 ID 반환
                        return
                    }
                }
                completion(false, "Session ID not found") // 세션 ID가 발견되지 않음
            } else {
                completion(false, "Login failed") // 로그인 실패
            }
        }.resume()
    }

    
    // 세션 ID 확인 메서드 추가
    func checkSessionID(_ sessionID: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/checkSession") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("JSESSIONID=\(sessionID)", forHTTPHeaderField: "Cookie")

        // 서버로 요청을 보내기 전 URL과 세션 ID를 출력
        print("Requesting with URL: \(url)")
        print("Session ID sent: JSESSIONID=\(sessionID)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                if let responseData = data {
                    let responseString = String(data: responseData, encoding: .utf8)
                    print("Response data: \(responseString ?? "No data")")
                }
                completion(httpResponse.statusCode == 200)
            } else {
                completion(false)
            }

        }.resume()
    }
    
    
    // 로그아웃
    func logout(completion: @escaping (Bool) -> Void) {
        guard let sessionID = UserDefaults.standard.string(forKey: "sessionID"),
              let url = URL(string: "\(baseURL)/user/logout") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("JSESSIONID=\(sessionID)", forHTTPHeaderField: "Cookie")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Logout Error: \(error)")
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
    
    
    // 캐릭터 정보 받기
    func fetchCharacterInfo(completion: @escaping (String, Int, Int, Int, Int) -> Void) {
        guard let url = URL(string: "\(baseURL)/mainPage/check") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // UserDefaults에서 세션 ID를 가져옴
        if let sessionID = UserDefaults.standard.string(forKey: "sessionID") {
            request.setValue("JSESSIONID=\(sessionID)", forHTTPHeaderField: "Cookie")
        } else {
            print("세션 ID를 찾을 수 없습니다. 로그인부터 다시 진행하세요.")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // 서버 응답 데이터를 문자열로 변환하여 출력
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
                do {
                    // JSON 데이터를 MainPageDto로 디코딩
                    let mainPageDto = try JSONDecoder().decode(MainPageDto.self, from: data)
                    
                    // 받은 데이터를 print로 출력
                    print("loginId: \(mainPageDto.loginId)")
                    print("experience: \(mainPageDto.experience)")
                    print("species: \(mainPageDto.species)")
                    print("kindOfCharacter: \(mainPageDto.kindOfCharacter)")
                    print("evolutionLevel: \(mainPageDto.evolutionLevel)")
                    
                    DispatchQueue.main.async {
                        completion(mainPageDto.loginId, mainPageDto.experience, mainPageDto.species, mainPageDto.kindOfCharacter, mainPageDto.evolutionLevel)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }


}


//#Preview {
//    UserService()
//}
