import SwiftUI

struct SidebarView: View {
    @Binding var selection: String?
    @Environment(FavoritesManager.self) var favoritesManager
    
    var body: some View {
        List(selection: $selection) {
            Section("Navegación") {
                // Etiqueta estática para la búsqueda
                NavigationLink(value: "Search") {
                    Label("Buscar Ciudad", systemImage: "magnifyingglass")
                }
            }
            
            Section("Mis Lugares") {
                if favoritesManager.savedCities.isEmpty {
                    Text("No tienes favoritos")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(favoritesManager.savedCities, id: \.self) { city in
                        NavigationLink(value: city) {
                            Label(city, systemImage: "building.2")
                        }
                    }
                    .onDelete { indexSet in
                        favoritesManager.removeCity(at: indexSet)
                    }
                }
            }
        }
        .listStyle(.sidebar) // Estilo nativo de macOS
        .frame(minWidth: 200)
    }
}
