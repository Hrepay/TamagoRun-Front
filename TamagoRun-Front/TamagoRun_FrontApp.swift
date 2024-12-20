//
//  TamagoRun_FrontApp.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI
import NMapsMap

@main
struct TamagoRun_FrontApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isAuthorized = false // 권한 상태를 추적하는 State 변수
    @Environment(\.scenePhase) private var scenePhase // ScenePhase 모니터링을 위한 환경 변수
    
    // loginViewModel 전역에서 관리
    @StateObject private var loginViewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthorized {
                    ContentView()
                        .ignoresSafeArea() // 여기에 추가
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(loginViewModel) // 로그인 상태를 전역으로 공유
                    
                } else {
                    HealthPermissionView() // 권한 허용을 위한 뷰
                }
            }
            .onAppear {
                
                // config.plist에서 NMFClientId 가져오기
                if let path = Bundle.main.path(forResource: "config", ofType: "plist"),
                   let config = NSDictionary(contentsOfFile: path) as? [String: Any],
                   let clientId = config["NMFClientId"] as? String {
                    NMFAuthManager.shared().clientId = clientId
                }
                
                checkHealthKitAuthorization()
                
                // 알림 권한 요청 추가
                NotificationManager.shared.requestAuthorization()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    // 앱이 활성화될 때마다 권한 상태를 확인
                    isAuthorized = HealthKitManager.shared.checkAuthorizationStatus()
                }
            }
        }
    }
    
    // HealthKit 권한을 확인하고 요청하는 메서드
    private func checkHealthKitAuthorization() {
        // checkAuthorizationStatus()가 항상 최신 상태를 반환하도록 만듦
        let currentStatus = HealthKitManager.shared.checkAuthorizationStatus()
        if currentStatus {
            isAuthorized = true
        } else {
            isAuthorized = false
            // 권한이 없을 때 HealthPermissionView를 유지
            HealthKitManager.shared.requestAuthorization { success, error in
                DispatchQueue.main.async {
                    isAuthorized = success
                }
            }
        }
    }
}
