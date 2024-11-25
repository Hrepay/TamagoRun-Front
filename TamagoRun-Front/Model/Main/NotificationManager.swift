//
//  NotificationManager.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/22/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    // 알림 식별자를 상수로 정의
    private let morningReminderId = "morning_reminder"
    private let eveningReminderId = "evening_reminder"
    
    private init() {
        // 초기화시 기존 알림 모두 제거
        removeAllPendingNotifications()
    }
    
    // 알림 권한 요청
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("알림 권한이 허용되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    // 하루 2번 알림 설정 (오전/오후)
    func setupDailyNotifications() {
        // 기존 알림 모두 제거
        removeAllPendingNotifications()
        
        // 오전 7:30 알림 설정
        setupNotification(hour: 7, minute: 30,
                        title: "모닝 러닝 준비되셨나요?",
                        body: "하루의 시작을 러닝으로!",
                        identifier: morningReminderId)
        
        // 오후 7:30 알림 설정
        setupNotification(hour: 19, minute: 30,
                        title: "오늘의 컨디션은 어떠신가요?",
                        body: "저녁먹고 가볍게 러닝 해보세요!",
                        identifier: eveningReminderId)
    }
    
    private func setupNotification(hour: Int, minute: Int, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 설정 실패: \(error)")
            }
        }
    }
    
    // 예정된 모든 알림 제거
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
