import SwiftUI

@main
struct SoniXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AudioManager.shared)
        }
    }
}
