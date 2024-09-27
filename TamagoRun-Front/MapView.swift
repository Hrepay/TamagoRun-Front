//
//  MapViewController.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/26/24.
//

import SwiftUI
import UIKit
import NMapsMap

// Naver MapView를 SwiftUI에서 사용하기 위해 UIViewControllerRepresentable 사용
struct MapView: UIViewControllerRepresentable {
    @Binding var coordinates: [NMGLatLng]
    @Binding var mapView: NMFMapView?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // NMFMapView 생성
        let mapView = NMFMapView(frame: viewController.view.bounds)
        self.mapView = mapView // 바로 여기에서 바인딩 설정
        
        viewController.view.addSubview(mapView)
        
        // 레이아웃 설정
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        // 초기 좌표 설정
        if let firstCoordinate = coordinates.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: firstCoordinate)
            mapView.moveCamera(cameraUpdate)
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 필요한 경우 업데이트 로직 추가
        if let mapView = self.mapView, let firstCoordinate = coordinates.first {
            let cameraUpdate = NMFCameraUpdate(scrollTo: firstCoordinate)
            mapView.moveCamera(cameraUpdate)
        }
    }
}


// SwiftUI 프리뷰에서 지도 표시
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            coordinates: .constant([NMGLatLng(lat: 37.5665, lng: 126.9780)]), // 서울의 위도, 경도
            mapView: .constant(nil)
        )
        .edgesIgnoringSafeArea(.all)
    }
}
