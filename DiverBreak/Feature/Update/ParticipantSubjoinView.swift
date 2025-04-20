//
//  ParticipantSubjoinView.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import SwiftUI

struct ParticipantSubjoinView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var pathModel: PathModel
    @StateObject private var viewModel = ParticipantSubjoinViewModel()
    @FocusState private var focusedId: UUID?
    @State private var lastFocusedId: UUID?
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                isDisplayLeftBtn: true,
                isDisplayRightBtn: true,
                leftBtnAction: { pathModel.pop() },
                rightBtnAction: {
                    HapticManager.success()
                    viewModel.saveNewParticipant(pathModel: pathModel)
                },
                leftBtnType: .back,
                rightBtnType: .play,
                rightBtnColor: .customBlue
            )

            descriptionSection
            existingList

            participantList
        }
        .onAppear {
            viewModel.setContext(context)
        }
        .alert("입력 조건이 맞지 않습니다.", isPresented: $viewModel.isAlertPresented) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .onChange(of: viewModel.isAlertPresented) { isPresented in
            if isPresented { HapticManager.error() }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - 설명 영역
    private var descriptionSection: some View {
        VStack(alignment: .leading) {
            Text("추가할 닉네임이 있다면\n아래에 입력해주세요.")
                .font(.title)
                .fontWeight(.medium)
                .lineSpacing(5)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .padding(.bottom, 20) // TODO: 기억해!!!!
    }

    // MARK: - 기존 사용자 목록
    private var existingList: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("기존 참여자 \(viewModel.existingNames.count)명")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
            }

            if isExpanded {
                ForEach(viewModel.existingNames, id: \.self) { name in
                    Text(name)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - 새로운 참가자 리스트
    private var participantList: some View {
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
        .padding(.horizontal)
    }

    private func nicknameCell(index: Int, nickname: Binding<ParticipantSubjoinViewModel.NicknameWrapper>) -> some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("이름을 입력하세요.", text: nickname.name)
//                    .padding(.vertical)
                    .onSubmit {
                        viewModel.moveFocusOrAddNext(from: index) { newId in
                            focusedId = newId
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
            .padding(.vertical, 8)

            if viewModel.isDuplicated(at: index) {
                Text("⚠️ 중복된 이름입니다.")
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isDuplicated(at: index))
            }
        }
    }

    private var participantCountHeader: some View {
        HStack {
            Spacer()
            Text("추가 \(viewModel.enterCount)명")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        
    }

    private var addButtonSection: some View {
        Button {
            HapticManager.medium()
            viewModel.addNewField {
                focusedId = $0
            }
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("새로운 이름")
            }
            .foregroundColor(.blue)
            .fontWeight(.medium)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    ParticipantSubjoinView()
}
