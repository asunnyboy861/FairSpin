import SwiftUI

struct AddChoreView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: HouseholdViewModel

    @State private var title = ""
    @State private var category: ChoreCategory = .cleaning
    @State private var effortWeight = 1
    @State private var frequency: ChoreFrequency = .weekly
    @State private var isRotationEnabled = true
    @State private var showPresets = true
    @State private var searchText = ""

    var filteredPresets: [PresetChore] {
        PresetChoreLibrary.shared.searchPresets(query: searchText)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Chore Details") {
                    TextField("Chore name", text: $title)

                    Picker("Category", selection: $category) {
                        ForEach(ChoreCategory.allCases, id: \.self) { cat in
                            Text("\(cat.emoji) \(cat.rawValue)").tag(cat)
                        }
                    }

                    Picker("Effort Level", selection: $effortWeight) {
                        Text("Easy (1)").tag(1)
                        Text("Medium (2)").tag(2)
                        Text("Hard (3)").tag(3)
                    }

                    Picker("Frequency", selection: $frequency) {
                        ForEach(ChoreFrequency.allCases, id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }

                    Toggle("Enable Rotation", isOn: $isRotationEnabled)
                }

                Section("Quick Add from Presets") {
                    TextField("Search presets...", text: $searchText)

                    if filteredPresets.isEmpty {
                        Text("No matching presets")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(filteredPresets) { preset in
                            Button(action: {
                                title = preset.title
                                category = preset.category
                                effortWeight = preset.effortWeight
                                frequency = preset.frequency
                            }) {
                                HStack {
                                    Text(preset.category.emoji)
                                    Text(preset.title)
                                    Spacer()
                                    Text("\(preset.effortWeight)⚡")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Chore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addChore(
                            title: title,
                            category: category,
                            effortWeight: effortWeight,
                            frequency: frequency
                        )
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
