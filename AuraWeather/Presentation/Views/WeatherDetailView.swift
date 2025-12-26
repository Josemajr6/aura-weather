import SwiftUI

struct WeatherDetailView: View {
    let weather: WeatherResponse
    var favoritesManager: FavoritesManager
    
    var isFavorite: Bool { favoritesManager.isFavorite(weather.name) }
    
    var backgroundGradient: LinearGradient {
        let condition = weather.weather.first?.main.lowercased() ?? ""
        if condition.contains("clear") { return LinearGradient(colors: [.orange, .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) }
        else if condition.contains("cloud") { return LinearGradient(colors: [.gray, .blue.opacity(0.4)], startPoint: .top, endPoint: .bottom) }
        else { return LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing) }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            backgroundGradient.opacity(0.9)
            
            VStack(spacing: 0) {
                // Cabecera
                HStack {
                    Spacer()
                    Text(weather.name)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Button { toggleFavorite() } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .white.opacity(0.8))
                            .font(.title3)
                    }.buttonStyle(.plain).padding(.leading, 8)
                    Spacer()
                }.padding(.top, 20)
                
                // Clima Central (Ajustado para ser más compacto)
                Spacer()
                Image(systemName: weather.weather.first?.systemIcon ?? "cloud.fill")
                    .symbolRenderingMode(.multicolor).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80) // Icono un poco más pequeño (antes 100)
                    .shadow(radius: 10)
                    .padding(.bottom, 5)
                
                Text(weather.main.temperatureString)
                    .font(.system(size: 70, weight: .medium, design: .rounded)) // Fuente un poco más pequeña (antes 80)
                    .foregroundStyle(.white).shadow(radius: 2)
                
                Text(weather.weather.first?.description.capitalized ?? "")
                    .font(.body).foregroundStyle(.white.opacity(0.9))
                
                Text(weather.main.minMaxString)
                    .font(.caption).foregroundStyle(.white.opacity(0.8))
                Spacer()
                
                // Grid Detalles
                LazyVGrid(columns: columns, spacing: 12) {
                    DetailCard(icon: "thermometer.medium", title: "Sensación", value: weather.main.feelsLikeString)
                    DetailCard(icon: "wind", title: "Viento", value: weather.wind.speedString)
                    DetailCard(icon: "humidity", title: "Humedad", value: "\(weather.main.humidity)%")
                    DetailCard(icon: "eye", title: "Visibilidad", value: "\(weather.visibility/1000) km")
                    DetailCard(icon: "sunrise.fill", title: "Amanecer", value: weather.sys.formattedTime(for: weather.sys.sunrise))
                    DetailCard(icon: "sunset.fill", title: "Atardecer", value: weather.sys.formattedTime(for: weather.sys.sunset))
                }.padding(20)
            }
        }
        .frame(width: 340, height: 500)
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.2), lineWidth: 1))
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
    }
    
    private func toggleFavorite() {
        withAnimation { isFavorite ? favoritesManager.removeCity(weather.name) : favoritesManager.addCity(weather.name) }
    }
}
