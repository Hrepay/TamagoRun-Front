//
//  StartRunning.swift
//  TestProject
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI
import NMapsMap

struct StartRunning: View {
    @Binding var isPresented: Bool // 뷰 표시 여부를 제어하는 바인딩 변수
    @State private var isCountingDown = false
    @State private var countdown = 3
    @State private var showNextView = false // 다음 뷰로 넘어갈지 여부
    
    @State private var coordinates: [NMGLatLng] = []
    @State private var mapView: NMFMapView? // mapView를 관리하는 변수 추가
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isPresented = false // "X" 버튼을 누르면 뷰를 닫음
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            Spacer()

            if isCountingDown {
                Text("\(countdown)")
                    .font(.custom("DungGeunMo", size: 150))
                    .transition(.opacity)
                    .onAppear {
                        startCountdown()
                    }
            } else {
                Text("Running with me?")
                    .font(.custom("DungGeunMo", size: 30))
                    .padding(.bottom, 40)
                
                Image("egg_1")
                    .resizable()
                    .frame(width: 120, height: 160)
                    .padding(.bottom, 40)
                
                Button(action: {
                    withAnimation {
                        isCountingDown = true
                    }
                }) {
                    Image("startRun_bt")
                        .resizable()
                        .frame(width: 120, height: 55)
                }
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $showNextView) {
//            MapView(coordinates: $coordinates, mapView: $mapView) // mapView를 바인딩으로 전달
//                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                withAnimation {
                    showNextView = true
                }
            }
        }
    }
}

#Preview {
    @State var isPresented = true
    StartRunning(isPresented: $isPresented)
}


