//
//  HandOutNewParticipantsView.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct HandOutNewParticipantsView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var viewModel = HandOutNewParticipantsViewModel()
    
    let participants: [Participant]

    var body: some View {
        ZStack {
            background

            VStack(spacing: 20) {
                if viewModel.participants.isEmpty {
                    Text("새 참가자 정보를 불러올 수 없습니다.")
                } else {
                    currentCard
                    confirmButton
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.setParticipants(participants)
        }
    }
    
    @ViewBuilder
    private var currentCard: some View {
        if let participant = viewModel.currentParticipant(),
           let role = viewModel.currentRole() {
            RoleCardView(
                name: participant.name,
                roleName: role.name,
                imageName: role.imageName,
                isRevealed: $viewModel.isRevealed
            )
        } else {
            Text("참가자 없음")
        }
    }

    private var confirmButton: some View {
        Group {
            if viewModel.isRevealed {
                Button(action: {
                    if viewModel.isLastParticipant() {
                        pathModel.resetTo(.main)
                    } else {
                        viewModel.goToNext()
                    }
                    HapticManager.success()
                }) {
                    Text("확인")
                        .font(.headline)
                        .padding(.vertical, 20)
                        .frame(maxWidth: 300)
                        .background(Color.diverWhite)
                        .foregroundColor(Color.diverBlack)
                        .cornerRadius(40)
                }
            } else {
                Color.clear
                    .frame(height: 56)
                    .padding(.horizontal, 40)
            }
        }
    }

    private var background: some View {
        Image("ocean")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    HandOutNewParticipantsPreviewWrapper()
        .environmentObject(PathModel())
        .modelContainer(for: Participant.self, inMemory: true)
}

private struct HandOutNewParticipantsPreviewWrapper: View {
    var body: some View {
        HandOutNewParticipantsView(participants: [
            Participant(name: "HappyJay", assignedRoleName: "에너지 체커"),
            Participant(name: "Gigi", assignedRoleName: "거북목 보안관")
        ])
    }
}
