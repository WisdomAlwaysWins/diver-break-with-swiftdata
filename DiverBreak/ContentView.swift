//
//  ContentView.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pathModel : PathModel
    @Environment(\.modelContext) private var context
//    let modelContainer : ModelContainer
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            ParticipantInputView() // 첫 시작 화면
                .navigationDestination(for: PathType.self) { path in
                    switch path {
                    case .participantInput :
                        ParticipantInputView()
                    case .handOutCard :
                        HandOutCardView()
                            .modelContext(context)
                    case .main :
                        MainView()
                            .modelContext(context)
                    case .checkMyRole :
                        CheckMyRoleView()
                    case .participantSubjoin :
                        ParticipantSubjoinView()
                            .modelContext(context)
                    case .handOutSubjoinCard(let participants) :
                        HandOutNewParticipantsView(participants : participants)
                            .modelContext(context)
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
        .environmentObject(PathModel())
}
