//
//  MainService.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/4/24.
//

import Foundation

class MainService {
    static let shared = MainService()
    
    let baseURL = "http://54.180.217.101:8080"
    
    
    func fetchUserInfo() async throws -> UserRecord {
        print("Current SessionID:", UserDefaults.standard.string(forKey: "sessionID") ?? "No SessionID found")
        
        // UserDefaults에서 세션 ID 가져오기
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/mypage/info") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Cookie 헤더로 세션 ID 전송
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 디버깅을 위한 응답 데이터 출력
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data:", responseString)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            print("Response Status Code:", httpResponse.statusCode)
            
            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                return try decoder.decode(UserRecord.self, from: data)
            case 401:
                print("Unauthorized access - Session might be invalid")
                throw NetworkError.unauthorized
            default:
                print("Server returned status code: \(httpResponse.statusCode)")
                throw NetworkError.failed(httpResponse.statusCode)
            }
        } catch {
            print("Error details:", error)
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.failed(-1)
        }
    }
    
}


// 네트워크 에러
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case failed(Int)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .unauthorized:
            return "Unauthorized access"
        case .failed(let code):
            return "Request failed with status code: \(code)"
        }
    }
}
