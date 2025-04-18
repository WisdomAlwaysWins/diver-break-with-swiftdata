//
//  ParticipantInputView.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import SwiftUI
import SwiftData

struct ParticipantInputView: View {
    
    @Environment(\.modelContext) private var context
    
    @EnvironmentObject var pathModel: PathModel
    
    @StateObject private var viewModel = ParticipantInputViewModel()
    @FocusState private var focusedIndex: Int?
    

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
            
        }
        .navigationBarBackButtonHidden(true)
        .alert("입력 조건이 맞지 않습니다", isPresented: $viewModel.isAlertPresented) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .onChange(of: viewModel.isAlertPresented) { isPresented in
            if isPresented {
                HapticManager.error()
            }
        }
        .onAppear {
            viewModel.setContext(context) // context 주입
        }
    }
    
    
    var backgroundView : some View {
        Color(.customWhite)
            .ignoresSafeArea()
            .onTapGesture {
                focusedIndex = nil
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }

    var contentView : some View {
        // TODO: - custom navbar 만들기
        VStack(alignment: .leading, spacing: 20) {
            
            navgationBar
            
            headerArea
                .padding(.horizontal)
                .padding(.top)

            textFieldList
        }
    }
    
    var navgationBar : some View {
        CustomNavigationBar(
            isDisplayLeftBtn: false,
            isDisplayRightBtn: true,
//            leftBtnAction: { print("도움말 눌림") },
            rightBtnAction: {
                HapticManager.success()
                viewModel.saveParticipant(pathModel : pathModel)
            },
            leftBtnType: nil,
            rightBtnType: .play,
            rightBtnColor: .customBlue
//            rightBtnColor: canProceed ? .diverBlue : .diverIconGray
        )
    }
    
    // MARK: - 설명 섹션
    var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            (
                Text("조커는 딱 ")
                + Text("1").foregroundColor(.customBlue).bold()
                + Text("명입니다.\n역할은 무작위로 정해집니다.")
            )
            .font(.title)
            .fontWeight(.medium)
            .lineSpacing(5)

            (
                Text("팀원은 최소 ")
                + Text("3").foregroundColor(.customBlue).bold()
                + Text("명이 필요합니다.\n아래에 팀원들의 이름을 작성해주세요.")
            )
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .lineSpacing(5)
        }
        .padding(.horizontal)
    }
    
    private func nicknameCell(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField("이름을 입력하세요.", text: $viewModel.nicknames[index])
                    .id(index)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 10)
                    .focused($focusedIndex, equals: index)
                    .onSubmit {
                        viewModel.moveFocus(from: index) { nextIndex in
                            focusedIndex = nextIndex
                        }
                    }

                Button {
                    HapticManager.heavy()
                    viewModel.removeField(at: index)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                }
            }

            if viewModel.isDuplicated(at: index) {
                Text("⚠️ 중복된 이름입니다.")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Divider()
        }
    }
    
    var textFieldList: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("현재 \(viewModel.validCount)명 참여")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        ForEach(viewModel.nicknames.indices, id: \.self) { index in
                            nicknameCell(index: index)
                        }
                        
                        addButtonSection
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: viewModel.scrollTarget) { target in
                        handleScroll(to: target, proxy: proxy)
                    }
                }
            }
        }
    }
    
    
    var addButtonSection : some View {
        HStack {
            Button {
                HapticManager.medium()
                viewModel.addNewField { newIndex in
                    focusedIndex = newIndex
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                    Text("새로운 이름")
                        .fontWeight(.medium)
                }
                .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding(.vertical)
        .padding(.bottom, 10)
    }
    
    private func handleScroll(to target: Int?, proxy: ScrollViewProxy) {
        guard let target = target else { return }
        withAnimation {
            proxy.scrollTo(target, anchor: .bottom)
        }
        viewModel.scrollTarget = nil
    }
}

#Preview {
    ParticipantInputView()
//        .modelContainer(for: Participant.self, inMemory: true)
}



