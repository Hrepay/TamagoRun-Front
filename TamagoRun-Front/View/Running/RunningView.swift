//
//  RunningView.swift
//  TestProject
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct RunningView: View {
    
    @StateObject var runningData = RunningData()
    
    @State private var coordinates: [NMGLatLng] = []
    @State private var mapView: NMFMapView? = nil
    @State private var startTime: Date? // 러닝 시작 시간
    @State private var timer: Timer? // 타이머
    @State private var runningTime: String = "00:00:00" // 러닝 시간
    @State private var isRunningFinished = false // 러닝 종료 상태
    @State private var offsetY: CGFloat = 0 // 슬라이드 제스처를 위한 offset
    
    @State private var isRunning: Bool = true  // 추가: 러닝 상태를 나타내는 프로퍼티
    
    @StateObject private var viewModel: RunningViewModel
    private let runningService = RunningService()

    
    init() {
        let runningData = RunningData()
        let coordinates: [NMGLatLng] = []
        _viewModel = StateObject(wrappedValue: RunningViewModel(runningData: runningData, coordinates: coordinates))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(coordinates: $coordinates,
                          mapView: $mapView,
                          runningData: runningData,
                          isRunning: isRunning)  // isRunning 프로퍼티 전달
                       .edgesIgnoringSafeArea(.all)
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        VStack {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 3)
                                .padding(.top, 5)
                            
                            VStack(spacing: 20) {
                                Spacer()
                                
                                Text(RunningDataFormatter.formatDuration(runningData.elapsedTime))
                                    .font(.custom("DungGeunMo", size: 33))
                                    .padding(.bottom, 16)
                                
                                HStack(spacing: 40) {
                                    VStack {
                                        Text(RunningDataFormatter.formatDistance(runningData.distance))
                                            .font(.custom("DungGeunMo", size: 25))
                                        Text("거리")
                                            .font(.custom("DungGeunMo", size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack {
                                        Text(RunningDataFormatter.formatCalories(runningData.calories))
                                            .font(.custom("DungGeunMo", size: 23))
                                        Text("칼로리")
                                            .font(.custom("DungGeunMo", size: 13))
                                            .foregroundColor(.gray)

                                    }
                                    
                                    VStack {
                                        Text(RunningDataFormatter.formatPace(runningData.pace))
                                            .font(.custom("DungGeunMo", size: 23))
                                        Text("페이스")
                                            .font(.custom("DungGeunMo", size: 13))
                                            .foregroundColor(.gray)

                                    }
                                }
                                .padding(.bottom, 20)
                                
                                Button(action: {
                                    handleStopRunning()
                                }) {
                                    Text("Stop!")
                                        .font(.custom("DungGeunMo", size: 28))
                                        .padding()
                                        .frame(width: 150, height: 50)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                }
                                .foregroundColor(.black)
                                .padding(.bottom, 20)
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: geometry.size.height * 0.38)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .offset(y: offsetY)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 0 {
                                        offsetY = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        withAnimation {
                                            offsetY = geometry.size.height * 0.25
                                        }
                                    } else {
                                        withAnimation {
                                            offsetY = 0
                                        }
                                    }
                                }
                        )
                        .onTapGesture {
                            withAnimation {
                                offsetY = 0
                            }
                        }
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: offsetY)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
                
                NavigationLink(value: "RunningSummaryView") {
                    EmptyView()
                }
                .navigationDestination(isPresented: $isRunningFinished) {
                    RunningSummaryView(
                        totalDistance: runningData.distance,
                        totalTime: runningData.elapsedTime,
                        totalPace: runningData.pace,
                        totalCalories: runningData.calories,
                        coordinates: coordinates
                    )
                }
            }
            .onAppear {
                requestHealthKitAuthorization()
                startRunning()
            }
            .onDisappear {
                stopRunning() // RunningView가 사라질 때 타이머 및 상태 정리
            }
        }
    }
    
    // HealthKit 권한 요청 함수 수정
    private func requestHealthKitAuthorization() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                print("HealthKit 권한 승인됨")
            } else {
                print("HealthKit 권한 요청 실패: \(String(describing: error?.localizedDescription))")
            }
        }
    }
   
    // Stop 버튼 처리 함수 수정
    private func handleStopRunning() {
        isRunning = false  // 러닝 상태를 false로 변경
        stopRunning()  // 기존 타이머 정지
        
        // HealthKit 저장 및 서버 전송을 비동기로 처리
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                let paceInMinutesPerKm = Double(runningData.pace) / 60.0
                
                HealthKitManager.shared.saveRunningWorkout(
                    distance: runningData.distance * 1000,
                    time: runningData.elapsedTime,
                    calories: Double(runningData.calories),
                    pace: paceInMinutesPerKm
                ) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            print("HealthKit 데이터 저장 성공")
                            sendDataToServer()
                        } else {
                            print("HealthKit 데이터 저장 실패: \(String(describing: error?.localizedDescription))")
                            // 에러가 있더라도 summary 화면으로 이동
                            isRunningFinished = true
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("HealthKit 권한 없음")
                    // 권한이 없더라도 summary 화면으로 이동
                    isRunningFinished = true
                }
            }
        }
    }
   
   // 서버로 데이터 전송하는 함수
   private func sendDataToServer() {
       runningService.uploadRunningData(runningData: runningData, coordinates: coordinates) { success in
           DispatchQueue.main.async {
               if success {
                   print("서버 데이터 전송 성공")
                   isRunningFinished = true  // 성공 후 summary 화면으로 이동
               } else {
                   print("서버 데이터 전송 실패")
                   // 실패 시 사용자에게 알림을 보여줄 수 있습니다
               }
           }
       }
   }
    
    func startRunning() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateRunningTime()  // 화면에 보여질 시간도 업데이트
        }
    }
    
    func stopRunning() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        updateRunningTime()
    }
    
    
    func updateRunningTime() {
        guard let start = startTime, !isRunningFinished else { return }
        let elapsedTime = Date().timeIntervalSince(start)
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        runningTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formatPace(_ paceInSeconds: Int) -> String {
        let minutes = Int(paceInSeconds) / 60
        let seconds = Int(paceInSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


#Preview {
    RunningView()
}
