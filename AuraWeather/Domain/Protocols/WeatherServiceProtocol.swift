import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
    func fetchForecast(for city: String) async throws -> [ForecastItem]
}
