//
//  CharacterService.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/14/24.
//

import Foundation

class CharacterService {
    static let shared = CharacterService()
    private let baseURL = "http://54.180.217.101:8080"
    
    // 알에서 첫 번째 형태로 진화
    func selectCharacter(completion: @escaping (Result<EvolutionDto, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/character/selectCharacter"),
              let sessionID = UserDefaults.standard.string(forKey: "sessionID") else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionID)", forHTTPHeaderField: "Cookie")
        
        let requestBody = ["sessionId": sessionID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            print("📦 Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            
            do {
                let evolutionDto = try JSONDecoder().decode(EvolutionDto.self, from: data)
                completion(.success(evolutionDto))
            } catch {
                print("JSON Decoding Error: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("this is revolution -> Response Data: \(responseString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
    
    // 일반 진화
    func evolutionCharacter(completion: @escaping (Result<EvolutionDto, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/character/evolutionCharacter"),
              let sessionID = UserDefaults.standard.string(forKey: "sessionID") else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JSESSIONID=\(sessionID)", forHTTPHeaderField: "Cookie")
        
        let requestBody = ["sessionId": sessionID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            do {
                let evolutionDto = try JSONDecoder().decode(EvolutionDto.self, from: data)
                completion(.success(evolutionDto))
            } catch {
                print("JSON Decoding Error: \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
                completion(.failure(error))
            }
        }.resume()
    }
}
