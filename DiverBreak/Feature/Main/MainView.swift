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
    
    @State private var isShowDeleteAlert = false
    @State private var isShowRevealAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            customNavigationBar
            
            titleSection

            ScrollView {
                if viewModel.isJokerRevealed {
                    roleSummaryGrid
                        .padding()
                } else {
                    buttonGrid
                        .padding()
                }
            }
        }
//        .padding(.horizontal, 20)
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
            leftBtnType: .home,
            rightBtnType: nil
        )
        .opacity(viewModel.isJokerRevealed ? 1 : 0)
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
        .padding(.bottom, 24)
    }
    
    private var buttonGrid : some View {
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
            mainButton(title: "역할 확인하기", icon: "🪪") {
                pathModel.push(.checkMyRole)
            }

            mainButton(title: "회의 삭제하기", icon: "🗑️") {
                pathModel.popToRoot()
            }
            .alert("정말 회의를 삭제하시겠어요?", isPresented: $isShowDeleteAlert) {
                Button("예", role: .destructive) {
                    pathModel.popToRoot()
                }
                Button("아니요", role: .cancel) { }
            }

            mainButton(title: "조커 공개하기", icon: "🃏") {
                isShowRevealAlert = true
            }
            .alert("정말 조커를 공개하시겠어요?", isPresented: $isShowRevealAlert) {
                Button("공개하기", role: .destructive) {
                    viewModel.isJokerRevealed = true
                }
                Button("취소", role: .cancel) { }
            }

            mainButton(title: "인원 추가하기", icon: "➕") {
                pathModel.push(.participantSubjoin)
            }
        }
    }
    
    private var roleSummaryGrid : some View {
        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
            ForEach(viewModel.participants) { participant in
                VStack(alignment: .leading, spacing: 8) {
                    Text(participant.name)
                        .font(.headline)

                    if let role = participant.assignedRole {
                        Text(role.name)
                            .font(.subheadline)
                            .foregroundColor(.diverBlue)
                        
                        Text(role.guide)
                            .font(.caption)
                            .foregroundColor(.diverGray2)
                        
                    } else {
                        Text("역할 없음")
                            .font(.subheadline)
                            .foregroundColor(.diverGray0)
                    }

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .aspectRatio(1, contentMode: .fit)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.diverGray0, lineWidth: 1)
                )
            }
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
