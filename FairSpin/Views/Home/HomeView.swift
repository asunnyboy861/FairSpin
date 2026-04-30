import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HouseholdViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    fairnessCard

                    if viewModel.overdueChores.isEmpty && viewModel.dueChores.isEmpty {
                        allDoneCard
                    } else {
                        dueChoresSection
                    }

                    if !viewModel.chores.isEmpty {
                        quickRotationButton
                    }
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .background(Color.appBackground)
            .navigationTitle(viewModel.household?.name ?? "FairSpin")
        }
    }

    private var fairnessCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Fairness Score")
                    .font(.headline)
                Spacer()
                Image(systemName: viewModel.isFair ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(viewModel.isFair ? .appSuccess : .appWarning)
            }

            if viewModel.members.count >= 2 {
                HStack(spacing: 12) {
                    ForEach(viewModel.members) { member in
                        VStack(spacing: 4) {
                            Text(member.avatarEmoji)
                                .font(.title2)
                            Text(member.name)
                                .font(.caption)
                                .lineLimit(1)
                            FairScoreBar(
                                score: viewModel.fairScoreForMember(member),
                                total: max(viewModel.totalFairScore, 1)
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            } else {
                Text("Add more members to see fairness scores")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private var dueChoresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Due Today")
                .font(.headline)
                .padding(.horizontal, 4)

            ForEach(viewModel.dueChores) { chore in
                ChoreCard(chore: chore, viewModel: viewModel)
            }

            if !viewModel.overdueChores.isEmpty {
                Text("Overdue")
                    .font(.headline)
                    .foregroundColor(.appDanger)
                    .padding(.horizontal, 4)
                    .padding(.top, 8)

                ForEach(viewModel.overdueChores) { chore in
                    ChoreCard(chore: chore, viewModel: viewModel, isOverdue: true)
                }
            }
        }
    }

    private var allDoneCard: some View {
        VStack(spacing: 12) {
            Text("🎉")
                .font(.system(size: 48))
            Text("All caught up!")
                .font(.title2.bold())
            Text("No chores due today")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private var quickRotationButton: some View {
        Button(action: { viewModel.runRotation() }) {
            Label("Rotate Chores", systemImage: "arrow.triangle.2.circlepath")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appPrimary)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}
