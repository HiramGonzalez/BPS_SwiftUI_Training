//
//  WormbookApp.swift
//  Wormbook
//
//  Created by BPS.Dev01 on 6/21/23.
//

import SwiftUI

@main
struct WormbookApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
