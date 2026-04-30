import SwiftUI

struct ContentView: View {
    let dataManager: DataManager
    @State private var viewModel: HouseholdViewModel
    @State private var selectedTab = 0

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self._viewModel = State(initialValue: HouseholdViewModel(dataManager: dataManager))
    }

    var body: some View {
        Group {
            if viewModel.household?.isOnboarded == true {
                mainContent
            } else {
                OnboardingView(
                    isOnboarded: Binding(
                        get: { viewModel.household?.isOnboarded == true },
                        set: { _ in }
                    ),
                    dataManager: dataManager,
                    onComplete: { household in
                        viewModel.household = household
                    }
                )
            }
        }
        .onAppear {
            viewModel.household = dataManager.fetchHousehold()
        }
    }

    private var mainContent: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ChoreListView(viewModel: viewModel)
                .tabItem {
                    Label("Chores", systemImage: "list.checklist")
                }
                .tag(1)

            RotationCalendarView(viewModel: viewModel)
                .tabItem {
                    Label("Rotation", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(2)

            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .tag(3)

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(4)
        }
    }
}
