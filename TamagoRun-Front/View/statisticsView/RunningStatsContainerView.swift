//
//  RunningStatsView.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI

struct RunningStatsContainerView: View {
    @State private var selectedTab = 0
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black 
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
    }
    
    var body: some View {
        VStack(spacing: 0) {
//            Picker("통계 기간", selection: $selectedTab) {
//                Text("주간").tag(0)
//                Text("월간").tag(1)
//            }
//            .pickerStyle(.segmented)
//            .padding()
            
            TabView(selection: $selectedTab) {
                WeeklyRunningGraphView()
                    .tag(0)
                
                MonthlyRunningGraphView()
                    .tag(1)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

#Preview {
    RunningStatsContainerView()
}
