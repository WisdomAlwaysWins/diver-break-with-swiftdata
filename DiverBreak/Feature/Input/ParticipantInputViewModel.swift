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
    private var context: ModelContext?

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    @Published var nicknames: [String] = (0..<3).map { _ in "" }
    @Published var scrollTarget: Int? = nil
    @Published var isAlertPresented: Bool = false
    @Published var alertMessage: String = ""

    // MARK: - UI 로직
    
    func isDuplicated(at index: Int) -> Bool {
        var set = Set<String>()

        for (i, name) in validNames.enumerated() {
            if set.contains(name) {
                if index == i { return true }
            } else {
                set.insert(name)
            }
        }

        return false
    }

    func addNewField(onAdded: @escaping (Int) -> Void) {
        let newIndex = nicknames.count
        nicknames.append("")
        scrollTarget = newIndex
        onAdded(newIndex)
    }

    func removeField(at index: Int) {
        if nicknames.count > 3 {
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

    private var validNames: [String] {
        nicknames.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                 .filter { !$0.isEmpty }
    }

    var validCount: Int {
        validNames.count
    }

    func validate() -> Bool {
        guard validNames.count >= 3 else {
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
        print("👇🏻 시작하기")

        guard validate() else { return }
        guard let context = context else {
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
