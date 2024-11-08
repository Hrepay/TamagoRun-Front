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
    
    
    // 내 정보
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
    
    // MARK: - 미션
    
    // 일일 미션
    func fetchDailyMissions() async throws -> DailyMissionResponse {
        print("이 요청은 일일 미션의 상태를 받아오는 fetchDailyMissions 함수임. ")
        print("Current SessionID:", UserDefaults.standard.string(forKey: "sessionID") ?? "No SessionID found")
        
        // UserDefaults에서 세션 ID 가져오기
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/mission/daily") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        // POST 요청을 위한 body 추가
        let body = ["sessionId": sessionId]
        request.httpBody = try? JSONEncoder().encode(body)
        
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
                return try decoder.decode(DailyMissionResponse.self, from: data)
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
    
    // 주간 미션
    func fetchWeeklyMissions() async throws -> WeeklyMissionResponse {
        print("이 요청은 주간 미션의 상태를 받아오는 fetchWeeklyMissions 함수임. ")
        print("Current SessionID:", UserDefaults.standard.string(forKey: "sessionID") ?? "No SessionID found")
        
        // UserDefaults에서 세션 ID 가져오기
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/mission/weekly") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        // POST 요청을 위한 body 추가
        let body = ["sessionId": sessionId]
        request.httpBody = try? JSONEncoder().encode(body)
        
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
                return try decoder.decode(WeeklyMissionResponse.self, from: data)
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
    
    // 일일 미션 클리어 체크
    func claimDailyReward() async throws -> DailyMissionResponse {
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/mission/dailyReward") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        // Request Body 설정
        let body = ["sessionId": sessionId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            return try decoder.decode(DailyMissionResponse.self, from: data)
        default:
            throw NetworkError.failed(httpResponse.statusCode)
        }
    }
    
    // 주간 미션 클리어 체크
    func claimWeeklyReward() async throws -> WeeklyMissionResponse {
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/mission/weeklyReward") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        // Request Body 설정
        let body = ["sessionId": sessionId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            return try decoder.decode(WeeklyMissionResponse.self, from: data)
        default:
            throw NetworkError.failed(httpResponse.statusCode)
        }
    }
    
    // MARK: - 업적
    func fetchAchievements() async throws -> AchievementResponse {
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/achievement/evaluation") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        let body = ["sessionId": sessionId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            return try decoder.decode(AchievementResponse.self, from: data)
        default:
            throw NetworkError.failed(httpResponse.statusCode)
        }
    }
    
    func claimAchievementReward() async throws -> AchievementResponse {
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/achievement/achievementReward") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionId)", forHTTPHeaderField: "Cookie")
        
        let body = ["sessionId": sessionId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            return try decoder.decode(AchievementResponse.self, from: data)
        default:
            throw NetworkError.failed(httpResponse.statusCode)
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
