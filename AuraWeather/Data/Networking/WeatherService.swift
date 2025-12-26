import Foundation

// 1. Definimos las constantes AQUÍ mismo para que no fallen nunca
struct APIConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let defaultLang = "es"
    static let defaultUnits = "metric"
}

class WeatherService: WeatherServiceProtocol {
    private let session = URLSession.shared
    
    // Recuperamos la API Key del Info.plist de forma segura
    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey") as? String else { return "" }
        return key
    }
    
    // Clima Actual
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let url = buildURL(endpoint: "weather", city: city) else { throw AppError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        try validate(response)
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    // Previsión (Forecast)
    func fetchForecast(for city: String) async throws -> [ForecastItem] {
        guard let url = buildURL(endpoint: "forecast", city: city) else { throw AppError.invalidURL }
        
        let (data, response) = try await session.data(from: url)
        try validate(response)
        
        let decodedResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
        
        // Filtramos para quedarnos con una sola medición por día (aprox a las 12:00)
        // para evitar mostrar 40 items (datos cada 3 horas)
        return decodedResponse.list.filter { $0.dt_txt.contains("12:00:00") }
    }
    
    // Helpers
    private func buildURL(endpoint: String, city: String) -> URL? {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        
        // Usamos las constantes internas
        let urlString = "\(APIConstants.baseURL)\(endpoint)?q=\(encodedCity)&units=\(APIConstants.defaultUnits)&appid=\(apiKey)&lang=\(APIConstants.defaultLang)"
        
        return URL(string: urlString)
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AppError.serverError
        }
    }
}
