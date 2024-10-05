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
    
    @StateObject private var viewModel: RunningViewModel
    
    init() {
        let runningData = RunningData()
        let coordinates: [NMGLatLng] = []
        _viewModel = StateObject(wrappedValue: RunningViewModel(runningData: runningData, coordinates: coordinates))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapView(coordinates: $coordinates, mapView: $mapView, runningData: runningData)

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
                                
                                Text(runningTime)
                                    .font(.custom("DungGeunMo", size: 36))
                                    .padding(.bottom, 10)
                                
                                HStack(spacing: 40) {
                                    VStack {
                                        Text("\(runningData.distance >= 0.01 ? String(format: "%.2f", runningData.distance) : "0.00")")
                                            .font(.custom("DungGeunMo", size: 35))
                                        Text("(Km)")
                                            .font(.custom("DungGeunMo", size: 14))
                                    }
                                    
                                    VStack {
                                        Text("\(runningData.calories > 0 ? "\(runningData.calories)" : "0")")
                                            .font(.custom("DungGeunMo", size: 35))
                                        Text("(kcal)")
                                            .font(.custom("DungGeunMo", size: 14))
                                    }
                                    
                                    VStack {
                                        Text(runningData.pace)
                                            .font(.custom("DungGeunMo", size: 35))
                                        Text("(/km)")
                                            .font(.custom("DungGeunMo", size: 14))
                                    }
                                }
                                .padding(.bottom, 20)
                                
                                Button(action: {
                                    stopRunning()  // 타이머를 먼저 멈추고 데이터를 업데이트한 후
                                    
                                    // ViewModel 업데이트
                                    viewModel.updateRunningData(runningData)
                                    viewModel.updateCoordinates(coordinates)
                                    
                                    // HealthKit에 데이터 저장
                                    let paceComponents = runningData.pace.split(separator: ":")
                                    let paceMinutes = Double(paceComponents[0]) ?? 0
                                    let paceSeconds = Double(paceComponents[1]) ?? 0
                                    let paceInMinutesPerKm = paceMinutes + (paceSeconds / 60.0)
                                    
                                    HealthKitManager.shared.saveRunningWorkout(
                                        distance: runningData.distance * 1000, // km를 m로 변환
                                        time: runningData.elapsedTime * 60, // 분을 초로 변환
                                        calories: Double(runningData.calories),
                                        pace: paceInMinutesPerKm
                                    ) { success, error in
                                        if success {
                                            print("러닝 데이터가 성공적으로 HealthKit에 저장되었습니다.")
                                        } else {
                                            print("HealthKit 데이터 저장 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                                        }
                                    }
                                    
                                    isRunningFinished = true
                                    viewModel.uploadRunningData()
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
                        totalTime: runningTime,
                        totalPace: runningData.pace,
                        totalCalories: runningData.calories,
                        coordinates: coordinates
                    )
                }
            }
            .onAppear {
                startRunning()
            }
            .onDisappear {
                stopRunning() // RunningView가 사라질 때 타이머 및 상태 정리
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
        timer?.invalidate() // 타이머 정지
        timer = nil
        startTime = nil
        updateRunningTime() // 러닝 시간 최종 업데이트
    }
    
    func updateRunningTime() {
        guard let start = startTime, !isRunningFinished else { return }
        let elapsedTime = Date().timeIntervalSince(start)
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        runningTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


#Preview {
    RunningView()
}
