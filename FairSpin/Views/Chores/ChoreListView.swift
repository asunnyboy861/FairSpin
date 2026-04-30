import SwiftUI

struct ChoreListView: View {
    @Bindable var viewModel: HouseholdViewModel
    @State private var showingAddChore = false
    @State private var selectedCategory: ChoreCategory?

    var filteredChores: [Chore] {
        if let category = selectedCategory {
            return viewModel.chores.filter { $0.category == category }
        }
        return viewModel.chores
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryFilter

                if filteredChores.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(filteredChores) { chore in
                            ChoreCard(chore: chore, viewModel: viewModel)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.deleteChore(filteredChores[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Chores")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddChore = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddChore) {
                AddChoreView(viewModel: viewModel)
            }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(ChoreCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: "\(category.emoji) \(category.rawValue)",
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color.appBackground)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("📋")
                .font(.system(size: 48))
            Text("No chores yet")
                .font(.title3.bold())
            Text("Add your first chore to get started")
                .foregroundColor(.secondary)
            Button("Add Chore") {
                showingAddChore = true
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.appPrimary : Color.white)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        }
    }
}
