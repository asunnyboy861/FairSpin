import SwiftUI

struct RotationCalendarView: View {
    @Bindable var viewModel: HouseholdViewModel
    @State private var selectedWeek = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    weekSelector

                    if viewModel.chores.isEmpty {
                        emptyState
                    } else {
                        rotationGrid
                    }
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .background(Color.appBackground)
            .navigationTitle("Rotation")
        }
    }

    private var weekSelector: some View {
        HStack {
            Button(action: { changeWeek(-1) }) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(weekString)
                .font(.headline)

            Spacer()

            Button(action: { changeWeek(1) }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }

    private var rotationGrid: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.chores.filter { $0.isRotationEnabled }) { chore in
                HStack(spacing: 12) {
                    Text(chore.category.emoji)
                        .font(.title3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(chore.title)
                            .font(.subheadline.bold())

                        if let member = viewModel.memberForId(chore.assignedMemberId) {
                            HStack(spacing: 4) {
                                Text(member.avatarEmoji)
                                    .font(.caption)
                                Text(member.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Text("Unassigned")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    Text(chore.frequency.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("🔄")
                .font(.system(size: 48))
            Text("No chores to rotate")
                .font(.title3.bold())
            Text("Add chores with rotation enabled to see the schedule")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }

    private var weekString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = startOfWeek
        let end = Calendar.current.date(byAdding: .day, value: 6, to: start) ?? start
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

    private var startOfWeek: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedWeek)) ?? selectedWeek
    }

    private func changeWeek(_ direction: Int) {
        selectedWeek = Calendar.current.date(byAdding: .weekOfYear, value: direction, to: selectedWeek) ?? selectedWeek
    }
}
