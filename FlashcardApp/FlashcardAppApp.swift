import SwiftUI

@main
struct FlashcardAppApp: App {
    var body: some Scene {
        WindowGroup {
            // مؤقتاً للتجربة: بعدين الصفحة اللي قبل تعطي السيناريو
            ReflectionDisplayView(scenario: Scenario.examples[0])
        }
    }
}
