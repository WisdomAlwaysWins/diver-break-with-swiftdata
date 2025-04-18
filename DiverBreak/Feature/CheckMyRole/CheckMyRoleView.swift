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
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            contentView
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var backgroundView : some View {
        Color(.customWhite)
            .ignoresSafeArea()
    }
    
    var contentView: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            navigationBar
            
            headerArea
                .padding(.horizontal)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                    ForEach(participants.indices, id: \.self) { index in
                        let participant = participants[index]
                        let role = RoleCardProvider.role(named: participant.assignedRoleName ?? "")
                        
                        MyRoleView(name: participant.name, roleName: role?.name ?? "역할 없음", roleGuide: role?.guide ?? "가이드 없음")
                    }
                }
            }
            .padding()

        }
        .padding(.bottom, 20)
    }
    
    
    
    var navigationBar: some View {
        CustomNavigationBar(
            isDisplayRightBtn: false,
            leftBtnAction: { pathModel.pop() },
            leftBtnType: .back
        )
    }
    
    var headerArea: some View {
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
