import SwiftUI

struct ForecastListView: View {
    let forecast: [ForecastItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Título
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(.blue)
                    .font(.title2)
                Text("Próximos 5 Días")
                    .font(.title3.bold())
                    .foregroundStyle(.primary.opacity(0.8))
            }
            .padding(.top, 30)
            .padding(.horizontal, 24)
            
            // Lista
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(forecast) { item in
                        HStack {
                            Text(item.dayName)
                                .font(.system(size: 16, weight: .semibold))
                                .frame(width: 90, alignment: .leading)
                            
                            Spacer()
                            
                            Image(systemName: item.weather.first?.systemIcon ?? "cloud")
                                .symbolRenderingMode(.multicolor)
                                .font(.title3)
                            
                            Spacer()
                            
                            Text(item.main.temperatureString)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.primary)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05)) // Fondo por fila
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
            }
            .scrollContentBackground(.hidden)
        }
    }
}
