import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: HouseholdViewModel
    @State private var showContactSupport = false

    var body: some View {
        NavigationStack {
            Form {
                householdSection
                notificationSection
                rotationSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    private var householdSection: some View {
        Section("Household") {
            if let household = viewModel.household {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(household.name)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Members")
                    Spacer()
                    Text("\(household.members.count)")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Chores")
                    Spacer()
                    Text("\(household.chores.count)")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var notificationSection: some View {
        Section("Notifications") {
            Toggle("Remind before due", isOn: Binding(
                get: { viewModel.household?.notifyBeforeDue ?? true },
                set: { viewModel.household?.notifyBeforeDue = $0 }
            ))

            Toggle("Notify on rotation", isOn: Binding(
                get: { viewModel.household?.notifyOnRotation ?? true },
                set: { viewModel.household?.notifyOnRotation = $0 }
            ))
        }
    }

    private var rotationSection: some View {
        Section("Rotation") {
            Toggle("Fair Mode", isOn: Binding(
                get: { viewModel.household?.fairModeEnabled ?? true },
                set: { viewModel.household?.fairModeEnabled = $0 }
            ))

            Picker("Rotation Day", selection: Binding(
                get: { viewModel.household?.rotationDay ?? 1 },
                set: { viewModel.household?.rotationDay = $0 }
            )) {
                Text("Monday").tag(1)
                Text("Tuesday").tag(2)
                Text("Wednesday").tag(3)
                Text("Thursday").tag(4)
                Text("Friday").tag(5)
                Text("Saturday").tag(6)
                Text("Sunday").tag(7)
            }

            Button("Rotate Now") {
                viewModel.runRotation()
            }
            .foregroundColor(.appPrimary)
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink(destination: ContactSupportView()) {
                Label("Contact Support", systemImage: "envelope")
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/FairSpin/support.html")!) {
                Label("Support Page", systemImage: "questionmark.circle")
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/FairSpin/privacy.html")!) {
                Label("Privacy Policy", systemImage: "hand.raised")
            }

            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
        }
    }
}
