//
//  DiverBreakApp.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import SwiftUI
import SwiftData

@main
struct DiverBreakApp: App {
    
    @StateObject var pathModel = PathModel()
    @State private var showSplash = true
    
    var modelContainer: ModelContainer = {
        let schema = Schema([Participant.self])
        
        let configuration = ModelConfiguration(schema : schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("❎ ModelContainer 생성 실패! : \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(isActive: $showSplash)
                    .environmentObject(pathModel)
                    .modelContainer(modelContainer)
            } else {
                ContentView()
                    .environmentObject(pathModel)
                    .modelContainer(modelContainer)
            }
            
        }

    }
}


