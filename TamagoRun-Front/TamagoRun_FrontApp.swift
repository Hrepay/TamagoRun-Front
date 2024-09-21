//
//  TamagoRun_FrontApp.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/21/24.
//

import SwiftUI

@main
struct TamagoRun_FrontApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
