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
