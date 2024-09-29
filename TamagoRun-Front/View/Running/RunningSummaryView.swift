//
//  RunningSummaryView.swift
//  TestProject
//
//  Created by 황상환 on 9/22/24.
//

import SwiftUI
import NMapsMap

struct RunningSummaryView: View {
    var totalDistance: Double
    var totalTime: String
    var totalPace: String
    var totalCalories: Int
    var coordinates: [NMGLatLng]
    
    @State private var isMainViewActive = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()
            Text("오늘 통계")
                .font(.custom("DungGeunMo", size: 15))
                .padding(.top, 20)
                .padding(.bottom, 40)
            
            HStack {
                VStack {
                    Text("운동 시간")
                        .font(.custom("DungGeunMo", size: 12))
                        .padding(.bottom, 2)
                    
                    Text(totalTime)
                        .font(.custom("DungGeunMo", size: 20))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                )
                .padding(.trailing, 4)
                
                VStack {
                    Text("평균 페이스")
                        .font(.custom("DungGeunMo", size: 12))
                        .padding(.bottom, 2)
                    
                    Text("\(totalTime)/km")
                        .font(.custom("DungGeunMo", size: 20))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                )
                .padding(.leading, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            HStack {
                VStack(alignment: .leading) {
                    Text("운동 칼로리")
                        .font(.custom("DungGeunMo", size: 12))
                        .padding(.bottom, 2)
                    
                    Text("\(totalCalories) kcal")
                        .font(.custom("DungGeunMo", size: 20))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                )
                .padding(.trailing, 4)
                
                VStack {
                    Text("거리")
                        .font(.custom("DungGeunMo", size: 12))
                        .padding(.bottom, 2)
                    
                    Text("\(String(format: "%.2f", totalDistance)) km")
                        .font(.custom("DungGeunMo", size: 20))
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                )
                .padding(.leading, 4)
            }
            .padding(.horizontal, 16)
            
            NaverMapView(coordinates: coordinates)
                .frame(height: 300)
                .padding()
            
            Button(action: {
            }) {
                HStack {
                    Text("통계")
                        .font(.custom("DungGeunMo", size: 18))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // MainView로 직접 이동하는 로직
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = UIHostingController(rootView: MainView())
                        window.makeKeyAndVisible()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                            .font(.custom("DungGeunMo", size: 15))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isMainViewActive) {
            MainView() // MainView를 완전히 덮어쓰도록 fullScreenCover를 사용합니다.
        }
    }
}

struct NaverMapView: UIViewRepresentable {
    var coordinates: [NMGLatLng]

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()

        // 첫 번째 좌표를 기준으로 카메라 이동
        if let firstCoordinate = coordinates.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: firstCoordinate)
            mapView.moveCamera(cameraUpdate)
        }

        // 좌표를 이용하여 경로 그리기
        let path = NMGLineString(points: coordinates.map { $0 as AnyObject }) // 좌표 배열을 올바르게 변환
        if let polylineOverlay = NMFPolylineOverlay(path) {
            polylineOverlay.mapView = mapView
        }

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
        // 만약 coordinates가 업데이트된다면 여기서 uiView를 갱신할 수 있습니다.
    }
}


struct StatView: View {
    var label: String
    var value: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.custom("DungGeunMo", size: 14))
            
            Text(value)
                .font(.custom("DungGeunMo", size: 24))
                .padding()
                .frame(width: 120, height: 60) // 크기를 고정하여 딱 맞게 수정
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke()
                )
        }
        .frame(width: 140, height: 100) // 각 StatView의 전체 크기를 고정
    }
}

#Preview {
    RunningSummaryView(
        totalDistance: 10.03, // 예시 거리
        totalTime: "51:23",   // 예시 시간
        totalPace: "05'07''", // 예시 페이스
        totalCalories: 930,   // 예시 칼로리
        coordinates: [NMGLatLng(lat: 37.5665, lng: 126.9780)] // 예시 좌표 (여러 좌표를 넣을 수 있음)
    )
}
