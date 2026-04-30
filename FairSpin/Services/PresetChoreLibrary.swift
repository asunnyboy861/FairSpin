import Foundation

struct PresetChore: Identifiable {
    let id = UUID()
    let title: String
    let category: ChoreCategory
    let effortWeight: Int
    let frequency: ChoreFrequency
}

final class PresetChoreLibrary {

    static let shared = PresetChoreLibrary()

    let presets: [PresetChore] = [
        PresetChore(title: "Wash dishes", category: .kitchen, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Wipe kitchen counters", category: .kitchen, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Clean stovetop", category: .kitchen, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Empty trash", category: .kitchen, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Load dishwasher", category: .kitchen, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Unload dishwasher", category: .kitchen, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Clean microwave", category: .kitchen, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Mop kitchen floor", category: .kitchen, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Clean refrigerator", category: .kitchen, effortWeight: 2, frequency: .monthly),
        PresetChore(title: "Organize pantry", category: .kitchen, effortWeight: 2, frequency: .monthly),

        PresetChore(title: "Vacuum living room", category: .cleaning, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Dust surfaces", category: .cleaning, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Mop floors", category: .cleaning, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Make beds", category: .cleaning, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Tidy living room", category: .cleaning, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Clean windows", category: .cleaning, effortWeight: 2, frequency: .monthly),
        PresetChore(title: "Dust ceiling fans", category: .cleaning, effortWeight: 1, frequency: .monthly),
        PresetChore(title: "Vacuum bedrooms", category: .cleaning, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Clean light fixtures", category: .cleaning, effortWeight: 1, frequency: .monthly),
        PresetChore(title: "Sweep entryway", category: .cleaning, effortWeight: 1, frequency: .daily),

        PresetChore(title: "Wash clothes", category: .laundry, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Fold laundry", category: .laundry, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Iron clothes", category: .laundry, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Put away clothes", category: .laundry, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Change bed sheets", category: .laundry, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Clean washing machine", category: .laundry, effortWeight: 1, frequency: .monthly),

        PresetChore(title: "Clean toilet", category: .bathroom, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Clean shower/tub", category: .bathroom, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Wipe bathroom mirror", category: .bathroom, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Mop bathroom floor", category: .bathroom, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Restock toilet paper", category: .bathroom, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Clean bathroom sink", category: .bathroom, effortWeight: 1, frequency: .weekly),

        PresetChore(title: "Mow lawn", category: .outdoor, effortWeight: 3, frequency: .weekly),
        PresetChore(title: "Water plants", category: .outdoor, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Weed garden", category: .outdoor, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Rake leaves", category: .outdoor, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Sweep porch", category: .outdoor, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Shovel snow", category: .outdoor, effortWeight: 3, frequency: .daily),
        PresetChore(title: "Trim hedges", category: .outdoor, effortWeight: 2, frequency: .monthly),

        PresetChore(title: "Feed pets", category: .pets, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Walk dog", category: .pets, effortWeight: 2, frequency: .daily),
        PresetChore(title: "Clean litter box", category: .pets, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Brush pet", category: .pets, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Wash pet bowls", category: .pets, effortWeight: 1, frequency: .daily),
        PresetChore(title: "Clean fish tank", category: .pets, effortWeight: 2, frequency: .weekly),

        PresetChore(title: "Grocery shopping", category: .shopping, effortWeight: 2, frequency: .weekly),
        PresetChore(title: "Buy household supplies", category: .shopping, effortWeight: 1, frequency: .monthly),
        PresetChore(title: "Pick up prescriptions", category: .shopping, effortWeight: 1, frequency: .monthly),

        PresetChore(title: "Organize closet", category: .organization, effortWeight: 2, frequency: .monthly),
        PresetChore(title: "Declutter garage", category: .organization, effortWeight: 3, frequency: .monthly),
        PresetChore(title: "Sort mail", category: .organization, effortWeight: 1, frequency: .daily),
        PresetChore(title: "File paperwork", category: .organization, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Organize pantry", category: .organization, effortWeight: 2, frequency: .monthly),

        PresetChore(title: "Check smoke detectors", category: .maintenance, effortWeight: 1, frequency: .monthly),
        PresetChore(title: "Replace air filters", category: .maintenance, effortWeight: 1, frequency: .monthly),
        PresetChore(title: "Fix leaky faucet", category: .maintenance, effortWeight: 2, frequency: .monthly),
        PresetChore(title: "Test carbon monoxide detector", category: .maintenance, effortWeight: 1, frequency: .monthly),

        PresetChore(title: "Take out recycling", category: .other, effortWeight: 1, frequency: .weekly),
        PresetChore(title: "Deep clean house", category: .other, effortWeight: 3, frequency: .monthly),
        PresetChore(title: "Car maintenance", category: .other, effortWeight: 2, frequency: .monthly),
    ]

    func presets(for category: ChoreCategory) -> [PresetChore] {
        presets.filter { $0.category == category }
    }

    func searchPresets(query: String) -> [PresetChore] {
        guard !query.isEmpty else { return presets }
        return presets.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
