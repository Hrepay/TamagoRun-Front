//
//  FriendService.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/11/24.
//

import Foundation

class FriendService {
    static let shared = FriendService()
    
    let baseURL = "http://54.180.217.101:8080"
    
    // 친구 추가
    func addFriend(friendId: String) async throws -> Bool {
        guard let sessionID = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/friends/add?friendId=\(friendId)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // sessionId를 body에 JSON으로 포함
        let body = ["sessionId": sessionID]
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 400 {
            throw NetworkError.failed(400)
        }
        
        return httpResponse.statusCode == 200
    }
    
    // 친구 리스트 불러오기
    func getFriendList() async throws -> [Friend] {
        guard let sessionID = UserDefaults.standard.string(forKey: "sessionID") else {
            throw NetworkError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)/friends/list") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(sessionID, forHTTPHeaderField: "SessionId")  // 헤더에 sessionId 추가
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode == 400 {
            throw NetworkError.failed(400)
        }
        
        return try JSONDecoder().decode([Friend].self, from: data)
    }
    
    // 친구 삭제
    func deleteFriend(friendId: String, sessionId: String) async throws -> Bool {
       let endpoint = "\(baseURL)/friends/delete"
       let queryItems = [URLQueryItem(name: "friendId", value: friendId)]
       
       guard var urlComponents = URLComponents(string: endpoint) else {
           throw NetworkError.invalidURL
       }
       urlComponents.queryItems = queryItems
       
       guard let url = urlComponents.url else {
           throw NetworkError.invalidURL
       }
       
       var request = URLRequest(url: url)
       request.httpMethod = "DELETE"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
       // Body에 sessionId 추가
       let body = ["sessionId": sessionId]
       let jsonData = try? JSONEncoder().encode(body)
       request.httpBody = jsonData
       
       let (_, response) = try await URLSession.shared.data(for: request)
       
       guard let httpResponse = response as? HTTPURLResponse else {
           throw NetworkError.invalidResponse
       }
       
       guard httpResponse.statusCode == 200 else {
           print("200 오류")
           throw NetworkError.failed(httpResponse.statusCode)
       }
       
       return true
    }
}
