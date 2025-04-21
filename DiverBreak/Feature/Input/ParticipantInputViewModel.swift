//
//  ParticipantInputViewModel.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class ParticipantInputViewModel: ObservableObject {

    // MARK: - 내부 구조
    struct NicknameWrapper: Identifiable, Hashable {
        let id = UUID()
        var name: String
    }

    // MARK: - Dependencies
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    // MARK: - Published States
    @Published var nicknames: [NicknameWrapper] = (0..<3).map { _ in NicknameWrapper(name: "") }
    @Published var scrollTarget: UUID? = nil
    @Published var isAlertPresented: Bool = false
    @Published var alertMessage: String = ""

    // MARK: - UI 로직
    func isDuplicated(at index: Int) -> Bool {
        let trimmed = nicknames[index].name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        // 같은 이름이 있는 인덱스들 찾기
        let duplicatedIndices = nicknames.enumerated()
            .filter { $0.element.name.trimmingCharacters(in: .whitespacesAndNewlines) == trimmed }
            .map { $0.offset }

        // 중복이 두 개 이상일 경우, 가장 먼저 등장한 인덱스만 OK
        return duplicatedIndices.count > 1 && duplicatedIndices.firstIndex(of: index) != 0
    }

    func addNewField(onAdded: (UUID) -> Void) {
        let new = NicknameWrapper(name: "")
        nicknames.append(new)
        scrollTarget = new.id
        onAdded(new.id)
    }

    func removeNickname(at index: Int) {
        if nicknames.count > 3 {
            nicknames.remove(at: index)
        } else {
            nicknames[index].name = ""
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
            let nextId = nicknames[nextIndex].id
            scrollTarget = nextId
            onMove(nextId)
        } else {
            addNewField(onAdded: onMove)
        }
    }

    // MARK: - 유효성 검사
    private var validNames: [String] {
        nicknames.map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var validCount: Int {
        validNames.count
    }

    func validate() -> Bool {
        guard validCount >= 3 else {
            alertMessage = "참가자는 최소 3명 이상이어야 합니다."
            isAlertPresented = true
            return false
        }
        guard Set(validNames).count == validNames.count else {
            alertMessage = "중복된 이름이 존재합니다. 이름을 수정해주세요."
            isAlertPresented = true
            return false
        }
        return true
    }

    // MARK: - 저장 + 역할 배정
    func saveParticipant(pathModel: PathModel) {
        guard validate() else { return }
        guard let context else {
            print("❎ context가 설정되지 않았습니다.")
            return
        }

        do {
            try deleteAllParticipants(in: context)

            for name in validNames {
                context.insert(Participant(name: name))
            }

            try context.save()
            print("✅ 참가자 저장 성공")

            assignRoles()
            pathModel.push(.handOutCard)

        } catch {
            print("❎ 참가자 저장 실패: \(error)")
        }
    }

    private func deleteAllParticipants(in context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<Participant>())
        for p in existing {
            context.delete(p)
        }
    }

    private func assignRoles() {
        guard let context else {
            print("❎ context가 설정되지 않음")
            return
        }

        do {
            var participants = try context.fetch(FetchDescriptor<Participant>())

            guard participants.count >= 3 else {
                print("❗ 최소 3명 필요")
                return
            }

            var roles = RoleCardProvider.roles
            guard let joker = roles.first(where: { $0.name == "조커" }) else {
                print("❌ 조커 역할 없음")
                return
            }

            participants.shuffle()
            participants[0].assignedRoleName = joker.name

            let others = Array(participants.dropFirst())
            roles.removeAll { $0.name == "조커" }

            if others.count <= roles.count {
                let shuffled = roles.shuffled().prefix(others.count)
                for (index, participant) in others.enumerated() {
                    participant.assignedRoleName = Array(shuffled)[index].name
                }
            } else {
                for participant in others {
                    participant.assignedRoleName = roles.randomElement()?.name
                }
            }

            try context.save()
            print("✅ 역할 배정 완료:")
            participants.forEach {
                print("• \($0.name): \($0.assignedRoleName ?? "❌")")
            }

        } catch {
            print("❌ 역할 배정 실패: \(error)")
        }
    }
}
