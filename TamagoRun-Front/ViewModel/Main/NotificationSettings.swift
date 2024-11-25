//
//  NotificationSettings.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/22/24.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationSettings: ObservableObject {
    @AppStorage("isRunningAlertEnabled") var isRunningAlertEnabled: Bool = false {
        didSet {
            if isRunningAlertEnabled {
                NotificationManager.shared.setupDailyNotifications()
            } else {
                NotificationManager.shared.removeAllPendingNotifications()
            }
        }
    }
    
    init() {
        // 앱 실행 시 알림이 활성화되어 있다면 알림 재설정
        if isRunningAlertEnabled {
            NotificationManager.shared.setupDailyNotifications()
        }
    }
}
