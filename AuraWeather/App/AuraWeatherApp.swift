import SwiftUI

@main
struct AuraWeatherApp: App {
    // Creamos la instancia única aquí (Source of Truth)
    @State private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inyectamos el manager al árbol de vistas
                .environment(favoritesManager)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
