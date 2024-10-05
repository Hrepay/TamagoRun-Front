//
//  MapViewController.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/26/24.
//

import SwiftUI
import NMapsMap
import CoreLocation

// 사실은 컨트롤러..
struct MapView: UIViewControllerRepresentable {
    @Binding var coordinates: [NMGLatLng]
    @Binding var mapView: NMFMapView?
    @ObservedObject var runningData: RunningData // RunningData를 전달받음
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let naverMapView = NMFNaverMapView(frame: UIScreen.main.bounds)
        naverMapView.showLocationButton = true
        naverMapView.showScaleBar = true
        naverMapView.mapView.positionMode = .direction
        viewController.view.addSubview(naverMapView)
        
        let initialCameraUpdate = NMFCameraUpdate(zoomTo: 15.0)
        naverMapView.mapView.moveCamera(initialCameraUpdate)
        
        DispatchQueue.main.async {
            self.mapView = naverMapView.mapView
        }
        
        context.coordinator.mapView = naverMapView.mapView
        context.coordinator.locationManager.delegate = context.coordinator
        context.coordinator.locationManager.startUpdatingLocation()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.updatePathOverlay(coordinates: coordinates)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapView
        var mapView: NMFMapView?
        var pathOverlay: NMFPath?
        var locationManager = CLLocationManager()
        var lastLocation: CLLocation? // 이전 위치 저장
        var lastUpdateTime: Date? // 마지막으로 위치를 업데이트한 시간
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 백그라운드 위치 업데이트 설정
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
        
        func updatePathOverlay(coordinates: [NMGLatLng]) {
            guard coordinates.count >= 2 else { return }
            
            if pathOverlay == nil {
                pathOverlay = NMFPath()
                pathOverlay?.color = .green
                pathOverlay?.outlineColor = .white
                pathOverlay?.width = 5
                pathOverlay?.mapView = mapView
            }
            
            pathOverlay?.path = NMGLineString(points: coordinates)
            pathOverlay?.mapView = mapView
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }

            // 3초마다 위치를 업데이트
            let now = Date()
            if let lastTime = lastUpdateTime, now.timeIntervalSince(lastTime) < 3 {
                return
            }
            lastUpdateTime = now

            // 현재 위치
            let currentLatLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)

            // 사용자의 현재 위치로 카메라 이동
            let cameraUpdate = NMFCameraUpdate(position: NMFCameraPosition(currentLatLng, zoom: 17.0))
            cameraUpdate.animation = .easeIn
            mapView?.moveCamera(cameraUpdate)

            parent.coordinates.append(currentLatLng)
            updatePathOverlay(coordinates: parent.coordinates)

            // 이전 위치가 있는 경우에만 거리 계산
            if let lastLocation = lastLocation {
                let distanceDelta = location.distance(from: lastLocation) / 1000.0 // m -> km 변환

                // distanceDelta가 너무 작거나 0일 경우 계산을 하지 않음
                guard distanceDelta > 0.001 else {
                    self.lastLocation = location
                    return
                }

                // 페이스 계산
                let elapsedTime = now.timeIntervalSince(lastLocation.timestamp) / 60.0 // 분 단위
                let paceInMinutesPerKm = elapsedTime / distanceDelta
                let minutes = Int(paceInMinutesPerKm)
                let seconds = Int((paceInMinutesPerKm - Double(minutes)) * 60)

                // 칼로리 계산 개선
                let weight = 70.0 // 사용자 체중 (kg) - 실제로는 사용자 입력값을 사용해야 함
                let met = 7.0 // 달리기의 MET 값 (보통 6-10 사이, 속도에 따라 다름)
                let timeInHours = parent.runningData.elapsedTime / 60.0 // 누적 시간을 시간 단위로 변환
                let caloriesBurned = met * weight * timeInHours

                DispatchQueue.main.async {
                    self.parent.runningData.objectWillChange.send()
                    self.parent.runningData.distance += distanceDelta
                    self.parent.runningData.pace = String(format: "%02d:%02d", minutes, seconds)
                    self.parent.runningData.calories = Int(caloriesBurned)
                    self.parent.runningData.elapsedTime += elapsedTime

                    // 로그 출력
                    print("현재 이동 거리 (km): \(self.parent.runningData.distance)")
                    print("현재 페이스 (분/킬로미터): \(self.parent.runningData.pace)")
                    print("현재 칼로리 소모량 (kcal): \(self.parent.runningData.calories)")
                    print("누적 경과 시간 (분): \(self.parent.runningData.elapsedTime)")
                }
            }

            self.lastLocation = location
        }

    }
}
