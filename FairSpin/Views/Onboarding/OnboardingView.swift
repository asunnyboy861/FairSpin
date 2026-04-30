import SwiftUI
import SwiftData

struct OnboardingView: View {
    @State private var step = 0
    @State private var householdName = ""
    @State private var memberName = ""
    @State private var memberEmoji = "👤"
    @State private var members: [(name: String, emoji: String)] = []
    @State private var selectedPresets: Set<UUID> = []
    @Binding var isOnboarded: Bool

    let dataManager: DataManager
    let onComplete: (Household) -> Void

    private let emojis = ["👤", "👩", "👨", "👧", "👦", "🧑", "👵", "👴", "🧒", "👶"]

    var body: some View {
        VStack(spacing: 0) {
            ProgressBar(current: step, total: 3)

            TabView(selection: $step) {
                step1.tag(0)
                step2.tag(1)
                step3.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: step)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private var step1: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("🏠")
                .font(.system(size: 72))

            Text("Name Your Household")
                .font(.title.bold())

            Text("Give your home a name to get started")
                .foregroundColor(.secondary)

            TextField("e.g. The Smiths", text: $householdName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 40)

            Spacer()

            Button("Next") {
                withAnimation { step = 1 }
            }
            .buttonStyle(.borderedProminent)
            .disabled(householdName.isEmpty)
            .padding(.bottom, 40)
        }
    }

    private var step2: some View {
        VStack(spacing: 20) {
            Text("👥")
                .font(.system(size: 48))
            Text("Add Members")
                .font(.title2.bold())

            HStack(spacing: 12) {
                Picker("Emoji", selection: $memberEmoji) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji).tag(emoji)
                    }
                }
                .frame(width: 70)

                TextField("Name", text: $memberName)
                    .textFieldStyle(.roundedBorder)

                Button(action: addMember) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.appPrimary)
                }
                .disabled(memberName.isEmpty)
            }
            .padding(.horizontal, 24)

            List {
                ForEach(members, id: \.name) { member in
                    HStack {
                        Text(member.emoji)
                            .font(.title2)
                        Text(member.name)
                        Spacer()
                        Button(action: { removeMember(member) }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .frame(maxHeight: 300)

            Button("Next") {
                withAnimation { step = 2 }
            }
            .buttonStyle(.borderedProminent)
            .disabled(members.isEmpty)
            .padding(.bottom, 40)
        }
    }

    private var step3: some View {
        VStack(spacing: 16) {
            Text("📋")
                .font(.system(size: 48))
            Text("Pick Your Chores")
                .font(.title2.bold())
            Text("Select from presets or add your own later")
                .foregroundColor(.secondary)
                .font(.subheadline)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(ChoreCategory.allCases, id: \.self) { category in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(category.emoji)
                                Text(category.rawValue)
                                    .font(.headline)
                            }

                            let categoryPresets = PresetChoreLibrary.shared.presets(for: category)
                            ForEach(categoryPresets) { preset in
                                Button(action: { togglePreset(preset) }) {
                                    HStack {
                                        Image(systemName: selectedPresets.contains(preset.id) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedPresets.contains(preset.id) ? .appPrimary : .gray)
                                        Text(preset.title)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text("\(preset.effortWeight)⚡")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            Button("Start FairSpin!") {
                finishOnboarding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
    }

    private func addMember() {
        guard !memberName.isEmpty else { return }
        members.append((name: memberName, emoji: memberEmoji))
        memberName = ""
        memberEmoji = "👤"
    }

    private func removeMember(_ member: (name: String, emoji: String)) {
        members.removeAll { $0.name == member.name }
    }

    private func togglePreset(_ preset: PresetChore) {
        if selectedPresets.contains(preset.id) {
            selectedPresets.remove(preset.id)
        } else {
            selectedPresets.insert(preset.id)
        }
    }

    private func finishOnboarding() {
        let household = dataManager.createHousehold(name: householdName)

        for memberInfo in members {
            _ = dataManager.addMember(name: memberInfo.name, avatarEmoji: memberInfo.emoji, to: household)
        }

        let allPresets = PresetChoreLibrary.shared.presets
        for presetId in selectedPresets {
            if let preset = allPresets.first(where: { $0.id == presetId }) {
                _ = dataManager.addChore(
                    title: preset.title,
                    category: preset.category,
                    effortWeight: preset.effortWeight,
                    frequency: preset.frequency,
                    to: household
                )
            }
        }

        household.isOnboarded = true
        try? dataManager.mainContext.save()
        isOnboarded = true
        onComplete(household)
    }
}

struct ProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index <= current ? Color.appPrimary : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}
