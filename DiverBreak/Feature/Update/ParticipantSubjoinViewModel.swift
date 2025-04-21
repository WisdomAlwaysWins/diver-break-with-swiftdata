//
//  ParticipantSubjoinViewModel.swift
//  DiverBreak
//
//  Created by J on 4/18/25.
//

import Foundation
import SwiftData

class ParticipantSubjoinViewModel: ObservableObject {

    // MARK: - 내부 구조
    struct NicknameWrapper: Identifiable, Hashable {
        let id = UUID()
        var name: String
    }

    // MARK: - Dependencies
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
        loadParticipants()
    }

    // MARK: - Published States
    @Published var nicknames: [NicknameWrapper] = [NicknameWrapper(name: "")]
    @Published var existingParticipants: [Participant] = []
    @Published var existingNames: [String] = []
    @Published var scrollTarget: UUID? = nil
    @Published var isAlertPresented = false
    @Published var alertMessage = ""

    private var newParticipants: [Participant] = []

    // MARK: - UI 로직
    func isDuplicated(at index: Int) -> Bool {
        let trimmed = nicknames[index].name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        // 중복되는 인덱스들 찾기
        let duplicatedIndices = nicknames.enumerated()
            .filter { $0.element.name.trimmingCharacters(in: .whitespacesAndNewlines) == trimmed }
            .map { $0.offset }

        // 기존 참여자와 중복이면 무조건 마지막에만 표시
        if existingNames.contains(trimmed) {
            return duplicatedIndices.last == index
        }

        // 새로 입력한 항목 중에서 중복이면 마지막 인덱스만 true
        return duplicatedIndices.count > 1 && duplicatedIndices.last == index
    }

    func addNewField(onAdded: (UUID) -> Void) {
        let new = NicknameWrapper(name: "")
        nicknames.append(new)
        scrollTarget = new.id
        onAdded(new.id)
    }

    func removeNickname(at index: Int) {
        guard nicknames.indices.contains(index) else { return }
        if nicknames.count > 1 {
            nicknames.remove(at: index)
        } else {
            nicknames[0].name = ""
        }
    }

    func removeNicknames(at indexSet: IndexSet) {
        for index in indexSet {
            removeNickname(at: index)
        }
    }

    func removeEmptyNickname(for id: UUID) {
        if let index = nicknames.firstIndex(where: { $0.id == id }),
           nicknames[index].name.trimmingCharacters(in: .whitespaces).isEmpty {
            removeNickname(at: index)
        }
    }

    func moveFocusOrAddNext(from index: Int, onMove: (UUID) -> Void) {
        if let nextIndex = nicknames.indices.dropFirst(index + 1).first {
            onMove(nicknames[nextIndex].id)
            scrollTarget = nicknames[nextIndex].id
        } else {
            addNewField(onAdded: onMove)
        }
    }

    // MARK: - 유효성 검사
    private var trimmedNewNames: [String] {
        nicknames.map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) }
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

            if !hasJoker {
                let shuffled = newParticipants.shuffled()
                shuffled.first?.assignedRoleName = joker.name
            }

            roles.removeAll { $0.name == "조커" }

            let alreadyAssigned = existingAssignedNames.filter { $0 != "조커" }
            let allowDuplicate = totalCount > 7
            var unassignedRoles = roles.filter { !alreadyAssigned.contains($0.name) }

            for participant in newParticipants where participant.assignedRoleName == nil {
                let assignedRole: Role
                if allowDuplicate {
                    assignedRole = roles.randomElement()!
                } else {
                    guard !unassignedRoles.isEmpty else {
                        print("❎ 역할이 부족합니다.")
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

    // MARK: - 기존 참가자 불러오기
    func loadParticipants() {
        guard let context else {
            print("❎ context가 설정되지 않음")
            return
        }

        do {
            let fetched = try context.fetch(FetchDescriptor<Participant>())
                .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
            self.existingParticipants = fetched
            self.existingNames = fetched.map { $0.name }
            print("✅ 참가자 불러오기 성공: \(fetched.count)명")
        } catch {
            print("❎ 참가자 불러오기 실패: \(error)")
        }
    }
}
