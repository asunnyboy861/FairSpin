import SwiftUI
import SwiftData

struct ContentView: View {
    let dataManager: DataManager
    @State private var viewModel: HouseholdViewModel
    @State private var selectedTab = 0
    @State private var screenshotMode = false

    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self._viewModel = State(initialValue: HouseholdViewModel(dataManager: dataManager))
    }

    var body: some View {
        Group {
            if screenshotMode || viewModel.household?.isOnboarded == true {
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
            if ProcessInfo.processInfo.environment["FAIRSPIN_SCREENSHOT"] == "1" {
                setupScreenshotData()
            }
        }
    }

    private func setupScreenshotData() {
        if viewModel.household != nil { return }
        let household = dataManager.createHousehold(name: "Smith Family")
        let mom = dataManager.addMember(name: "Mom", avatarEmoji: "👩", to: household)
        let dad = dataManager.addMember(name: "Dad", avatarEmoji: "👨", to: household)
        let teen = dataManager.addMember(name: "Emma", avatarEmoji: "👧", to: household)
        let kid = dataManager.addMember(name: "Jake", avatarEmoji: "👦", to: household)
        dataManager.addChore(title: "Wash Dishes", category: .kitchen, effortWeight: 3, frequency: .daily, to: household)
        dataManager.addChore(title: "Take Out Trash", category: .kitchen, effortWeight: 1, frequency: .daily, to: household)
        dataManager.addChore(title: "Vacuum Living Room", category: .cleaning, effortWeight: 4, frequency: .weekly, to: household)
        dataManager.addChore(title: "Mow the Lawn", category: .outdoor, effortWeight: 5, frequency: .weekly, to: household)
        dataManager.addChore(title: "Walk the Dog", category: .pets, effortWeight: 2, frequency: .daily, to: household)
        dataManager.addChore(title: "Clean Bathroom", category: .cleaning, effortWeight: 5, frequency: .weekly, to: household)
        household.isOnboarded = true
        try? dataManager.mainContext.save()
        viewModel.household = household
        screenshotMode = true
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
