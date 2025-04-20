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
    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?

    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                isDisplayLeftBtn: false,
                isDisplayRightBtn: true,
                rightBtnAction: {
                    HapticManager.success()
                    viewModel.saveParticipant(pathModel: pathModel)
                },
                leftBtnType: nil,
                rightBtnType: .play,
                rightBtnColor: .customBlue
            )

            headerArea
            nicknameList
        }
        .background(Color.customWhite.ignoresSafeArea())
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
            viewModel.setContext(context)
        }
    }

    private var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            (
                Text("조커는 딱 ") +
                Text("1").foregroundColor(.customBlue).bold() +
                Text("명입니다.\n역할은 무작위로 정해집니다.")
            )
            .font(.title)
            .fontWeight(.medium)
            .lineSpacing(5)

            (
                Text("팀원은 최소 ") +
                Text("3").foregroundColor(.customBlue).bold() +
                Text("명이 필요합니다.\n아래에 팀원들의 이름을 작성해주세요.")
            )
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .lineSpacing(5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    private var nicknameList: some View {
        ScrollViewReader { proxy in
            List {
                Section(header: participantCountHeader) {
                    ForEach(Array(zip(viewModel.nicknames.indices, $viewModel.nicknames)), id: \.1.id) { index, $nickname in
                        nicknameCell(index: index, nickname: $nickname)
                            .id(nickname.id)
                            .focused($focusedId, equals: nickname.id)
                            .listRowBackground(Color.clear)
                    }

                    addButtonSection
                        .listRowBackground(Color.clear)
                        .id("AddButton")
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .onChange(of: viewModel.scrollTarget) { target in
                if let id = target {
                    withAnimation {
                        proxy.scrollTo(id, anchor: .center)
                    }
                    viewModel.scrollTarget = nil
                }
            }
            .onChange(of: focusedId) { newValue in
                if newValue == nil, let lastId = lastFocusedId {
                    viewModel.removeEmptyNickname(for: lastId)
                }
                lastFocusedId = newValue
            }
        }
        .padding(.horizontal, 20)
    }

    private var participantCountHeader: some View {
        HStack {
            Spacer()
            Text("현재 \(viewModel.validCount)명 참여")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    private func nicknameCell(index: Int, nickname: Binding<ParticipantInputViewModel.NicknameWrapper>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField("이름을 입력하세요.", text: nickname.name)
                    .onSubmit {
                        viewModel.moveFocusOrAddNext(from: index) { nextId in
                            focusedId = nextId
                        }
                    }

                Button {
                    HapticManager.heavy()
                    viewModel.removeNickname(at: index)
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
        }
    }

    private var addButtonSection: some View {
        Button {
            HapticManager.medium()
            viewModel.addNewField {
                focusedId = $0
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "plus.circle.fill")
                Text("새로운 이름")
            }
            .foregroundColor(.blue)
            .fontWeight(.medium)
        }
    }
}

#Preview {
    ParticipantInputView()
}
