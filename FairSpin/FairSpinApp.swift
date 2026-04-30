import SwiftUI
import SwiftData

@main
struct FairSpinApp: App {
    @State private var dataManager = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView(dataManager: dataManager)
        }
        .modelContainer(dataManager.modelContainer)
    }
}
