import Foundation
import Observation

@Observable
class FavoritesManager {
    var savedCities: [String] = []
    private let key = "favorite_cities"
    
    init() {
        loadFavorites()
    }
    
    // Cargar datos
    private func loadFavorites() {
        if let data = UserDefaults.standard.stringArray(forKey: key) {
            savedCities = data
        }
    }
    
    // Guardar una ciudad (evitando duplicados)
    func addCity(_ city: String) {
        guard !savedCities.contains(where: { $0.caseInsensitiveCompare(city) == .orderedSame }) else { return }
        savedCities.append(city)
        save()
    }
    
    // Eliminar ciudad

    // En FavoritesManager.swift
    func removeCity(at offsets: IndexSet) {
        // Usamos lógica estándar de Arrays, no extensiones de UI
        for index in offsets.sorted(by: >) {
            if savedCities.indices.contains(index) {
                savedCities.remove(at: index)
            }
        }
        save()
    }
    
    func removeCity(_ city: String) {
        savedCities.removeAll { $0 == city }
        save()
    }
    
    // Persistencia
    private func save() {
        UserDefaults.standard.set(savedCities, forKey: key)
    }
    
    func isFavorite(_ city: String) -> Bool {
        savedCities.contains(where: { $0.caseInsensitiveCompare(city) == .orderedSame })
    }
}
