//
//  MainView.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack(spacing: 48) {
            
            if viewModel.isJokerRevealed {
                customNavigationBar
            }
            
            titleSection

            if viewModel.isJokerRevealed {
                roleSummaryGrid
            } else {
                buttonGrid
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .background(Color.diverBackgroundBlue)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setContext(context)
        }
    }
    
    private var customNavigationBar: some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { pathModel.popToRoot() },
            rightBtnAction: { print("헬프 버튼 눌림") },
            leftBtnType: .home,
            rightBtnType: .help
        )
    }
    
    private var titleSection : some View {
        VStack(spacing: 20) {
            Text("오늘의 조커")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(viewModel.isJokerRevealed ? (viewModel.jokerParticipantName ?? "이름 없음") : "???")
                .font(.largeTitle)
                .foregroundColor(.diverBlack)
                .fontWeight(.bold)

            Text(viewModel.isJokerRevealed ? "회의 끄읕" : "회의에 집중!")
                .font(.subheadline)
                .foregroundColor(.diverBlack)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var buttonGrid : some View {
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
            mainButton(title: "역할 확인하기", icon: "🪪") {
                pathModel.push(.checkMyRole)
            }

            mainButton(title: "회의 삭제하기", icon: "🗑️") {
                pathModel.popToRoot()
            }

            mainButton(title: "조커 공개하기", icon: "🃏") {
                viewModel.isJokerRevealed = true
            }

            mainButton(title: "인원 추가하기", icon: "➕") {
                pathModel.push(.participantSubjoin)
            }
        }
    }
    
    private var roleSummaryGrid : some View {
        VStack {
            
        }
    }
    
    // MARK: - 공통 버튼 스타일
    private func mainButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 40) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.customBlack)
                
                Text(icon)
                    .font(.largeTitle)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 1)
        }
    }
}

#Preview {
    MainView()
}
