import SwiftUI

struct MemberListView: View {
    @Bindable var viewModel: HouseholdViewModel
    @State private var showingAddMember = false
    @State private var newName = ""
    @State private var newEmoji = "👤"

    private let emojis = ["👤", "👩", "👨", "👧", "👦", "🧑", "👵", "👴", "🧒", "👶", "🐱", "🐶"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.members) { member in
                    HStack(spacing: 12) {
                        MemberAvatar(member: member, size: 44)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(member.name)
                                    .font(.headline)
                                if member.isOwner {
                                    Text("Owner")
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.appPrimary.opacity(0.15))
                                        .foregroundColor(.appPrimary)
                                        .cornerRadius(4)
                                }
                            }

                            let score = viewModel.fairScoreForMember(member)
                            Text("Effort score: \(Int(score))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if viewModel.members.count >= 2 {
                            let memberScore = viewModel.fairScoreForMember(member)
                            let total = max(viewModel.totalFairScore, 1)
                            let pct = memberScore / total * 100
                            Text("\(Int(pct))%")
                                .font(.caption.bold())
                                .foregroundColor(pct > 50 ? .appWarning : .appSuccess)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteMember(viewModel.members[index])
                    }
                }
            }
            .navigationTitle("Members")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddMember = true }) {
                        Image(systemName: "person.badge.plus")
                    }
                }
            }
            .alert("Add Member", isPresented: $showingAddMember) {
                TextField("Name", text: $newName)
                Button("Add") {
                    if !newName.isEmpty {
                        viewModel.addMember(name: newName, avatarEmoji: newEmoji)
                        newName = ""
                        newEmoji = "👤"
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter the new member's name")
            }
        }
    }
}
