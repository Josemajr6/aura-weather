import Foundation

struct WeatherResponse: Decodable, Equatable {
    let main: MainWeather
    let weather: [WeatherCondition]
    let name: String
    let dt: TimeInterval
    let wind: Wind      // NUEVO: Datos de viento
    let sys: Sys        // NUEVO: Datos solares (amanecer/atardecer)
    let visibility: Int // NUEVO: Visibilidad en metros
}

struct MainWeather: Decodable, Equatable {
    let temp: Double
    let humidity: Int
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    
    // Usamos la extensión aquí:
    var temperatureString: String {
        return temp.asTemperatureString()
    }
    
    var feelsLikeString: String {
        return feels_like.asTemperatureString()
    }
    
    var minMaxString: String {
        return "Min \(temp_min.asTemperatureString()) / Max \(temp_max.asTemperatureString())"
    }
}
// Nueva estructura para el viento
struct Wind: Decodable, Equatable {
    let speed: Double // Viene en m/s por defecto
    
    // Convertimos m/s a km/h
    var speedString: String {
        let kmh = speed * 3.6
        return String(format: "%.1f km/h", kmh)
    }
}

// Nueva estructura para Amanecer/Atardecer
struct Sys: Decodable, Equatable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
    
    func formattedTime(for timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Formato 24h
        return formatter.string(from: date)
    }
}

struct WeatherCondition: Decodable, Equatable {
    let main: String
    let description: String
    let icon: String
    
    var systemIcon: String {
        switch main.lowercased() {
        case "clouds": return "cloud.fill"
        case "rain": return "cloud.rain.fill"
        case "drizzle": return "cloud.drizzle.fill"
        case "thunderstorm": return "cloud.bolt.rain.fill"
        case "snow": return "cloud.snow.fill"
        case "clear": return "sun.max.fill"
        case "mist", "fog", "haze": return "cloud.fog.fill"
        default: return "cloud.sun.fill"
        }
    }
}



struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable, Identifiable {
    let id = UUID() // Para SwiftUI
    let dt: TimeInterval
    let main: MainWeather
    let weather: [WeatherCondition]
    let dt_txt: String // Fecha en texto para filtrar
    
    // Helper para sacar el día de la semana
    var dayName: String {
        let date = Date(timeIntervalSince1970: dt)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES") // Español
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized
    }
    
    // Helper para la hora
    var hour: String {
        let date = Date(timeIntervalSince1970: dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
