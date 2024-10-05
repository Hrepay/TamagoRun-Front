//
//  RunningService.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 10/5/24.
//

import Foundation
import NMapsMap

class RunningService {
    
    let baseURL = "http://54.180.217.101:8080"
    
    func uploadRunningData(runningData: RunningData, coordinates: [NMGLatLng], completion: @escaping (Bool) -> Void) {
        guard let sessionId = UserDefaults.standard.string(forKey: "sessionID") else {
            print("세션 아이디가 없습니다.")
            completion(false)
            return
        }
                
        let data: [String: Any] = [
            "sessionId": sessionId,
            "dailyRunningTime": runningData.elapsedTime,
            "dailyAveragePace": runningData.pace,
            "dailyCalorie": runningData.calories,
            "dailyDistance": runningData.distance,
            "coordinates": coordinates.map { ["x": $0.lat, "y": $0.lng] }
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            print("데이터 변환에 실패했습니다.")
            completion(false)
            return
        }
        
        guard let url = URL(string: "\(baseURL)/running/record") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print("전송 데이터: \(data)")

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("서버 요청 오류: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("응답 형식이 올바르지 않습니다.")
                completion(false)
                return
            }
            
            // 성공 상태 코드 확인
            if (200...299).contains(httpResponse.statusCode) {
                print("러닝 데이터 업로드 성공")
                completion(true)
            } else {
                // 오류 상태 코드 처리
                print("서버 응답 오류. 상태 코드: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("서버 응답 내용: \(responseString)")
                }
                completion(false)
            }
        }
        task.resume()
    }
}
