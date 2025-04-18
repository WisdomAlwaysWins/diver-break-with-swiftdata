//
//  ParticipantSubjoinViewModel.swift
//  DiverBreak
//
//  Created by J on 4/18/25.
//

import Foundation
import SwiftData

class ParticipantSubjoinViewModel: ObservableObject {
    
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
        
        loadParticipants()
    }
    
    @Published var existingParticipants: [Participant] = []
    @Published var existingNames: [String] = []
    
    @Published var nicknames: [String] = [""]
    
    @Published var scrollTarget: Int? = nil
    @Published var isAlertPresented: Bool = false
    @Published var alertMessage: String = ""
    
    private var newParticipants: [Participant] = []
    
    // MARK: - UI 로직
    
    func isDuplicated(at index: Int) -> Bool {
        let trimmed = nicknames[index].trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        if existingNames.contains(trimmed) { // 기존 이름과 중복되면 무조건 중복 처리
            return true
        }

        let matchingIndices = nicknames.enumerated() // 현재 닉네임 배열에서 동일한 이름이 여러 번 나올 때
            .filter { $0.element.trimmingCharacters(in: .whitespacesAndNewlines) == trimmed }
            .map { $0.offset }

        return matchingIndices.count > 1 && matchingIndices.firstIndex(of: index) != 0
    }
    
    func addNewField(onAdded: @escaping (Int) -> Void) {
        let newIndex = nicknames.count
        nicknames.append("")
        scrollTarget = newIndex
        onAdded(newIndex)
    }
    
    func removeField(at index: Int){
        if nicknames.count > 1 {
            nicknames.remove(at: index)
        } else {
            nicknames[index] = ""
        }
    }
    
    func moveFocus(from index: Int, onMove: @escaping (Int) -> Void) {
        if let nextIndex = nicknames.indices.dropFirst(index + 1).first(where: { nicknames[$0].isEmpty }) {
            scrollTarget = nextIndex
            onMove(nextIndex)
        } else {
            addNewField(onAdded: onMove)
        }
    }
    
    // MARK: - 유효성 검사
    
    private var trimmedNewNames: [String] {
        nicknames.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var enterCount: Int {
        trimmedNewNames.filter { !$0.isEmpty }.count
    }

    var validNewNames: [String] {
        trimmedNewNames.filter { !$0.isEmpty }
    }
    
    func validate() -> Bool {
        guard enterCount >= 1 else {
            alertMessage = "참가자를 1명 이상 추가해주세요."
            isAlertPresented = true
            return false
        }

        let allNames = validNewNames + existingNames
        if Set(allNames).count != allNames.count {
            alertMessage = "중복된 이름이 존재합니다. 이름을 수정해주세요."
            isAlertPresented = true
            return false
        }

        return true
    }
    
    // MARK: - 저장 + 역할 배정
    func saveNewParticipant(pathModel: PathModel) {
        print("👇🏻 추가하기")

        guard validate() else { return }
        guard let context else {
            print("❎ context가 설정되지 않았습니다.")
            return
        }

        newParticipants = validNewNames.map { Participant(name: $0) }
        newParticipants.forEach { context.insert($0) }

        do {
            try context.save()
            print("✅ 새 참가자 저장 성공")
            assignRolesToNewParticipants()
            pathModel.push(.handOutSubjoinCard(participant: newParticipants))
        } catch {
            print("❎ 참가자 저장 실패: \(error)")
        }
    }
    
    private func assignRolesToNewParticipants() {
        guard let context else {
            print("❎ context가 설정되지 않음")
            return
        }

        do {
            let allParticipants = try context.fetch(FetchDescriptor<Participant>())

            let existingParticipants = allParticipants.filter { !newParticipants.contains($0) }
            let existingAssignedNames = existingParticipants.compactMap { $0.assignedRoleName }

            let hasJoker = existingAssignedNames.contains("조커")
            let totalCount = allParticipants.count

            var roles = RoleCardProvider.roles
            guard let joker = roles.first(where: { $0.name == "조커" }) else {
                print("❎ 조커 역할 없음")
                return
            }

            // 기존에 없으면 새 참가자 중 1명에게 조커 배정
            if !hasJoker {
                let shuffled = newParticipants.shuffled()
                shuffled.first?.assignedRoleName = joker.name
            }

            // 롤에서 조커 제외하기
            roles.removeAll { $0.name == "조커" }

            // 이미 부여된 롤에서 제외하기
            let alreadyAssigned = existingAssignedNames.filter { $0 != "조커" }

            // 7명 이하: 중복 안됨
            // 8명 이상: 중복 허용
            let allowDuplicate = totalCount > 7

            var unassignedRoles = roles.filter { !alreadyAssigned.contains($0.name) }

            for participant in newParticipants {
                // 조커 이미 배정된 경우 패스
                guard participant.assignedRoleName == nil else { continue }

                let assignedRole: Role
                if allowDuplicate {
                    assignedRole = roles.randomElement()!
                } else {
                    // 중복 없이 배정
                    guard !unassignedRoles.isEmpty else {
                        print("❌ 역할이 부족합니다.")
                        return
                    }
                    assignedRole = unassignedRoles.removeFirst()
                }

                participant.assignedRoleName = assignedRole.name
            }

            try context.save()
            print("✅ 새 참가자 역할 배정 완료")
            newParticipants.forEach {
                print("🥽 \($0.name): \($0.assignedRoleName ?? "❌")")
            }

        } catch {
            print("❎ 역할 배정 실패: \(error)")
        }
    }
    
    // MARK: - SwiftData에 저장된 기존 참가자 불러오기
    func loadParticipants() {
        guard let context else {
            print("❎ context가 설정되지 않음")
            return
        }

        do {
            let fetchedAll = try context.fetch(FetchDescriptor<Participant>())
                .sorted { $0.name.localizedCompare($1.name) == .orderedAscending } // TODO: - 한글도 고려한 정렬! WOW. 어디에 적어놔야되는데
            self.existingParticipants = fetchedAll
            self.existingNames = fetchedAll.map { $0.name }
            print("✅ 참가자 불러오기 성공: \(fetchedAll.count)명")
        } catch {
            print("❎ 참가자 불러오기 실패: \(error)")
        }
    }
}
