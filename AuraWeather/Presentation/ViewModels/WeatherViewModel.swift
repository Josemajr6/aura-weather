import SwiftUI
import Observation

@Observable
class WeatherViewModel {
    var state: ViewState = .idle // Xcode necesita saber qué es 'ViewState'
    var searchText: String = ""
    var forecast: [ForecastItem] = []
    
    private let service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }
    
    @MainActor
    func searchWeather() async {
        guard !searchText.isEmpty else { return }
        
        state = .loading
        forecast = [] // Limpiamos anteriores
        
        do {
            async let weatherTask = service.fetchWeather(for: searchText)
            async let forecastTask = service.fetchForecast(for: searchText)
            
            let (weather, forecastData) = try await (weatherTask, forecastTask)
            
            self.forecast = forecastData
            self.state = .success(weather)
            
        } catch {
            print("Error: \(error)")
            state = .error("No pudimos encontrar el clima para '\(searchText)'.")
        }
    }
}

// La definición del enum debe estar aquí para evitar fallos
enum ViewState: Equatable {
    case idle
    case loading
    case success(WeatherResponse)
    case error(String)
}
