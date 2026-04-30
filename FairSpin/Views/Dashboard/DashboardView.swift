import SwiftUI
import Charts

struct DashboardView: View {
    @Bindable var viewModel: HouseholdViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    fairnessOverview
                    contributionChart
                    recentActivity
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .background(Color.appBackground)
            .navigationTitle("Dashboard")
        }
    }

    private var fairnessOverview: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Fairness Overview")
                    .font(.headline)
                Spacer()
                Image(systemName: viewModel.isFair ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(viewModel.isFair ? .appSuccess : .appWarning)
                    .font(.title3)
            }

            Text(viewModel.isFair ? "Chores are fairly distributed" : "Distribution could be more balanced")
                .font(.subheadline)
                .foregroundColor(viewModel.isFair ? .appSuccess : .appWarning)

            HStack(spacing: 16) {
                ForEach(viewModel.members) { member in
                    VStack(spacing: 6) {
                        MemberAvatar(member: member, size: 36)
                        Text(member.name)
                            .font(.caption)
                            .lineLimit(1)
                        Text("\(Int(viewModel.fairScoreForMember(member)))")
                            .font(.title3.bold())
                            .foregroundColor(.appPrimary)
                        Text("pts")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appBackground)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private var contributionChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contribution (Last 30 Days)")
                .font(.headline)

            if viewModel.members.isEmpty {
                Text("Add members to see contribution chart")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                Chart(viewModel.members) { member in
                    BarMark(
                        x: .value("Member", member.name),
                        y: .value("Effort", viewModel.fairScoreForMember(member))
                    )
                    .foregroundStyle(Color(hex: member.colorHex))
                    .cornerRadius(6)
                }
                .frame(height: 200)
                .chartYAxisLabel("Effort Points")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)

            let allCompletions = viewModel.chores.flatMap { $0.completions }
                .sorted { $0.completedAt > $1.completedAt }

            if allCompletions.isEmpty {
                Text("No activity yet")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(allCompletions.prefix(10)) { record in
                    HStack(spacing: 10) {
                        if let member = viewModel.memberForId(record.memberId) {
                            Text(member.avatarEmoji)
                        }
                        VStack(alignment: .leading) {
                            Text(record.chore.title)
                                .font(.subheadline)
                            Text(record.completedAt.relativeString)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.appSuccess)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}
