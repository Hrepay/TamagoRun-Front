//
//  RunningDataFormatter.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/19/24.
//

import Foundation

struct RunningDataFormatter {
    // 러닝 시간을 "HH:mm:ss" 형식으로 변환
    static func formatDuration(_ duration: TimeInterval, includeHours: Bool = true) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if includeHours {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // 페이스를 "mm:ss/km" 형식으로 변환
    static func formatPace(_ paceInSeconds: Int) -> String {
        let minutes = paceInSeconds / 60
        let seconds = paceInSeconds % 60
        return String(format: "%02d:%02d/km", minutes, seconds)
    }
    
    // 거리를 "0.00 km" 형식으로 변환
    static func formatDistance(_ distance: Double) -> String {
        return String(format: "%.2f km", distance)
    }
    
    // 칼로리를 정수형으로 변환
    static func formatCalories(_ calories: Int) -> String {
        return "\(calories) kcal"
    }
}

// RunningData 확장
extension RunningData {
    // 포맷된 러닝 시간
    var formattedDuration: String {
        RunningDataFormatter.formatDuration(elapsedTime)
    }
    
    // 포맷된 페이스
    var formattedPace: String {
        RunningDataFormatter.formatPace(pace)
    }
    
    // 포맷된 거리
    var formattedDistance: String {
        RunningDataFormatter.formatDistance(distance)
    }
    
    // 포맷된 칼로리
    var formattedCalories: String {
        RunningDataFormatter.formatCalories(calories)
    }
    
    // 페이스 계산 (거리와 시간으로부터)
    func calculatePace() {
        if distance > 0 {
            // 페이스 = 시간(초) / 거리(km)
            pace = Int(elapsedTime / distance)
        } else {
            pace = 0
        }
    }
    
    // 칼로리 계산
    func calculateCalories() {
        let standardWeight = 64.0  // 한국 성인 평균 체중 (kg)
        let totalTimeInHours = elapsedTime / 3600.0
        let met = 7.0 // 일반적인 조깅/달리기의 MET 값
        
        // 칼로리 계산: MET * 체중(kg) * 시간(hour)
        let totalCalories = met * standardWeight * totalTimeInHours
        calories = Int(round(totalCalories))
    }
}
