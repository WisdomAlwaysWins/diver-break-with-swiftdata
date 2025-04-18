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
            ContentView()
                .environmentObject(pathModel)
//                .environment(\.font, custom("SFProRounded-Regular", size: 14))
                .modelContainer(modelContainer)
        }

    }
}


