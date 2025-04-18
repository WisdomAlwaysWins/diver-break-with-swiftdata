//
//  HandOutCardView.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//
import SwiftUI
import SwiftData

struct HandOutCardView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var viewModel = HandOutCardViewModel()
    
    var body: some View {
        ZStack {
            background

            VStack(spacing: 20) {
                if viewModel.participants.isEmpty {
                    Text("참가자 정보가 없습니다.")
                } else {
                    currentCard
                    confirmButton
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.setContext(context)
        }
    }

//    @ViewBuilder
    private var currentCard: some View {
        Group {
            if let participant = viewModel.currentParticipant(),
               let role = viewModel.currentRole() {
                RoleCardView(
                    name: participant.name,
                    roleName: role.name,
                    imageName: role.imageName,
                    isRevealed: $viewModel.isRevealed
                )
            }
        }
    }
    

    private var confirmButton: some View {
        Group {
            if viewModel.isRevealed {
                Button(action: {
                    HapticManager.success()
                    viewModel.handleConfirm(pathModel: pathModel)
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
                Color.clear.frame(height: 56).padding(.horizontal, 40)
            }
        }
    }

    var background: some View {
        Image("ocean")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    HandOutCardView()
}


