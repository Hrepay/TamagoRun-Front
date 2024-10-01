//
//  ContentView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI
import CoreData
import NMapsMap


struct ContentView: View {
    @State private var sessionID: String? = UserDefaults.standard.string(forKey: "sessionID")
    @State private var isLoggedIn: Bool = false
    @State private var isCheckingSession: Bool = true // 세션 확인 중 여부
    
    // 맵 테스트용
    @State private var coordinates: [NMGLatLng] = []
    @State private var mapView: NMFMapView? = nil
    @ObservedObject private var locationManager = LocationManager()
    @ObservedObject var runningData = RunningData() // RunningData 인스턴스
    
    var body: some View {
        if isCheckingSession {
            // 세션 확인 중일 때 로딩 스피너 표시
            ProgressView("Checking session...")
                .onAppear {
                    checkSession()
                }
        } else {
            if isLoggedIn {
                MainView()
            } else {
                StartView(isLoggedIn: $isLoggedIn)
                    .edgesIgnoringSafeArea(.all)
           }
        }
    }
    
    // 세션 확인을 위한 메서드 추출
    private func checkSession() {
        if let storedSessionID = sessionID {
            UserService().checkSessionID(storedSessionID) { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        self.isLoggedIn = true
                    } else {
                        UserDefaults.standard.removeObject(forKey: "sessionID")
                    }
                    self.isCheckingSession = false // 세션 확인 완료
                }
            }
        } else {
            // 세션 ID가 없으면 바로 로그인 화면으로 이동
            self.isCheckingSession = false
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
