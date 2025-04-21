//
//  CheckMyRoleView.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import SwiftUI
import SwiftData

struct CheckMyRoleView: View {
    @EnvironmentObject var pathModel: PathModel
    @Query(sort: \Participant.name) private var participants: [Participant]
    
    @StateObject private var viewModel = CheckMyRoleViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $viewModel.selectedRole) { role in
            RoleCardFullscreenView(
                name: role.name,
                fullscreenImageName: role.image,
                onClose: { viewModel.selectedRole = nil }
            )
        }
        .onAppear {
            viewModel.setContext(context)
        }
    }

    private var backgroundView: some View {
        Color(.customBackgroundBlue)
            .ignoresSafeArea()
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            navigationBar
            headerArea

            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                    ForEach(participants) { participant in
                        MyRoleView(
                            name: participant.name,
                            onLongPressCompleted: {
                                viewModel.selectRole(for: participant)
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .padding(.bottom, 20)
    }

    private var navigationBar: some View {
        CustomNavigationBar(
            isDisplayRightBtn: false,
            leftBtnAction: { pathModel.pop() },
            leftBtnType: .back
        )
    }

    private var headerArea: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("내 이름을 길게 눌러\n역할을 확인해보세요.")
                .font(.title)
                .fontWeight(.medium)
                .lineSpacing(5)
            
        
            (
                Text("더 좋은 아이디어가 있을지\n") +
                Text("휴식 경험").foregroundColor(.customBlue).bold() +
                Text("을 떠올려보세요!")
            )
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .lineSpacing(5)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CheckMyRoleView()
}
