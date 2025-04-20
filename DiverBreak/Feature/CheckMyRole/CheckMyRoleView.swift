//
//  CheckMyRoleView.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import SwiftUI
import SwiftData

struct SelectedRoleData: Identifiable, Equatable {
    var id: UUID = UUID()
    let name: String
    let image: String
}

struct CheckMyRoleView: View {
    @EnvironmentObject var pathModel: PathModel
    @Query(sort: \Participant.name) private var participants: [Participant]

    @State private var selectedRole: SelectedRoleData?

    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedRole) { role in
            RoleCardFullscreenView(
                name: role.name,
                fullscreenImageName: role.image,
                onClose: { selectedRole = nil }
            )
        }
    }

    private var backgroundView: some View {
        Color(.customWhite)
            .ignoresSafeArea()
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            navigationBar

            headerArea
                .padding(.horizontal)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                    ForEach(participants) { participant in
                        MyRoleView(
                            name: participant.name,
                            onLongPressCompleted: {
                                if let role = RoleCardProvider.role(named: participant.assignedRoleName ?? "") {
                                    selectedRole = SelectedRoleData(
                                        name: participant.name,
                                        image: role.fullScreenImageName
                                    )
                                }
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
        }
        .padding(.horizontal)
    }
}

#Preview {
    CheckMyRoleView()
}
