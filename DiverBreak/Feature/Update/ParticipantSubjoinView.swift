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
    @FocusState private var focusedIndex: Int?
    
    @State var isExpanded = false
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .alert("입력 조건이 맞지 않습니다.", isPresented: $viewModel.isAlertPresented) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.setContext(context)
        }
    }
    
    var backgroundView: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
    
    var contentView: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerArea
                        .padding(.horizontal)
                        .padding(.top)
                        

                    existingList

                    participantList

                    addButtonSection
                }
            }
            .padding()
        }
    }
    
    var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("추가할 닉네임이 있다면\n아래에 입력해주세요.")
                .font(.title)
                .fontWeight(.medium)
                .lineSpacing(5)
        }
    }
    
    var existingList: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {

                    Text("기존 참여자 \(viewModel.existingNames.count)명")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                        .frame(width: 12)
                    
                    
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
            }

            if isExpanded {
                List {
                    ForEach(viewModel.existingNames, id: \.self) { name in
                        Text(name)
                    }
                }
                .frame(height: CGFloat(viewModel.existingNames.count * 44))
                .listStyle(.plain)
                .scrollDisabled(true)
            }
        }
    }
    
    var participantList: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("추가 \(viewModel.enterCount)명")
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
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: viewModel.scrollTarget) { target in
                        handleScroll(to : target, proxy : proxy)
                    }
                }
                
            }
        }
    }
    
    var addButtonSection : some View {
        HStack {
            Button {
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
        .padding(.horizontal)
        .padding(.bottom, 10)
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
    
    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayLeftBtn: true,
            isDisplayRightBtn: true,
            leftBtnAction: { pathModel.pop() },
            rightBtnAction: {
                viewModel.saveNewParticipant(pathModel : pathModel)
            },
            leftBtnType: .back,
            rightBtnType: .play,
            rightBtnColor: .customBlue
        )
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
    ParticipantSubjoinView()
}
