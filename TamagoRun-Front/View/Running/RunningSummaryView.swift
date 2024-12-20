//
//  RunningSummaryView.swift
//  TestProject
//
//  Created by 황상환 on 9/22/24.
//

import SwiftUI
import NMapsMap

struct RunningSummaryView: View {
    // 타입 수정
    var totalDistance: Double
    var totalTime: TimeInterval  // String에서 TimeInterval로 변경
    var totalPace: Int
    var totalCalories: Int
    var coordinates: [NMGLatLng]
    
    @State private var isMainViewActive = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: LoginViewModel

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
                    
                    Text(RunningDataFormatter.formatDuration(totalTime))  // 포맷터 사용
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
                    
                    Text(RunningDataFormatter.formatPace(totalPace))  // 포맷터 사용
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
                    
                    Text(RunningDataFormatter.formatCalories(totalCalories))  // 포맷터 사용
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
                    
                    Text(RunningDataFormatter.formatDistance(totalDistance))  // 포맷터 사용
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
            
//            Button(action: {
//            }) {
//                HStack {
//                    Text("통계")
//                        .font(.custom("DungGeunMo", size: 18))
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                }
//                .padding()
//                .background(Color.white)
//                .foregroundColor(.black)
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.black, lineWidth: 1)
//                )
//            }
//            .padding(.horizontal)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // MainView로 직접 이동하는 로직
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = UIHostingController(
                            rootView: MainView(isLoggedIn: $viewModel.isLoggedIn)
                                .environmentObject(viewModel)
                        )
                        window.makeKeyAndVisible()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                            .font(.custom("DungGeunMo", size: 15))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $isMainViewActive) {
            MainView(isLoggedIn: $viewModel.isLoggedIn)
                .environmentObject(viewModel)
        }
    }
}

struct NaverMapView: UIViewRepresentable {
    var coordinates: [NMGLatLng]

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()

        // 첫 번째 좌표를 기준으로 카메라 이동 및 줌 레벨 설정
        if let firstCoordinate = coordinates.first {
            let cameraPosition = NMFCameraPosition(firstCoordinate, zoom: 15.0) // 줌 레벨 15로 설정
            let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
        }

        // 좌표를 이용하여 경로 그리기
        let path = NMGLineString(points: coordinates.map { $0 as AnyObject })
        if let polylineOverlay = NMFPolylineOverlay(path) {
            polylineOverlay.mapView = mapView
        }

        return mapView
    }


    func updateUIView(_ uiView: NMFMapView, context: Context) {
        // 만약 coordinates가 업데이트된다면 여기서 uiView를 갱신할 수 있습니다.
    }
}

#Preview {
    RunningSummaryView(
        totalDistance: 10.03,          // 거리 (km)
        totalTime: 3083,               // 시간 (51분 23초 = 3083초)
        totalPace: 307,                // 페이스 (5분 7초 = 307초)
        totalCalories: 930,            // 칼로리
        coordinates: [NMGLatLng(lat: 37.5665, lng: 126.9780)]
    )
}
