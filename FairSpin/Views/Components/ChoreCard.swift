import SwiftUI

struct ChoreCard: View {
    let chore: Chore
    @Bindable var viewModel: HouseholdViewModel
    var isOverdue: Bool = false
    @State private var showCompletionPicker = false

    var body: some View {
        HStack(spacing: 12) {
            Text(chore.category.emoji)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text(chore.title)
                    .font(.subheadline.bold())
                    .foregroundColor(isOverdue ? .appDanger : .primary)

                HStack(spacing: 8) {
                    if let member = viewModel.memberForId(chore.assignedMemberId) {
                        HStack(spacing: 2) {
                            Text(member.avatarEmoji)
                                .font(.caption)
                            Text(member.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Text(chore.frequency.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(6)

                    Text("\(chore.effortWeight)⚡")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: { showCompletionPicker = true }) {
                Image(systemName: "checkmark.circle")
                    .font(.title2)
                    .foregroundColor(.appSuccess)
            }
            .confirmationDialog("Who completed this?", isPresented: $showCompletionPicker, titleVisibility: .visible) {
                ForEach(viewModel.members) { member in
                    Button("\(member.avatarEmoji) \(member.name)") {
                        viewModel.completeChore(chore, memberId: member.id)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isOverdue ? Color.appDanger.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
