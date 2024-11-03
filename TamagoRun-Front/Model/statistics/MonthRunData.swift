//
//  MonthRunData.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 11/3/24.
//

import SwiftUI
import Combine

struct MonthRunData: Identifiable {
   let id = UUID()
   let month: Int
   let distance: Double
}
