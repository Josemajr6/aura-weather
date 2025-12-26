import SwiftUI
import Observation

struct ContentView: View {
    @State private var viewModel = WeatherViewModel()
    @State private var selectedCategory: String? = "Search"
    @Environment(FavoritesManager.self) var favoritesManager
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedCategory)
        } detail: {
            ZStack {
                backgroundGradient
                
                GeometryReader { proxy in
                    ScrollView {
                        VStack(spacing: 30) {
                            searchBar.padding(.top, 30)
                            
                            // Layout Adaptativo
                            if proxy.size.width > 750 {
                                // MODO ESCRITORIO (Lado a Lado)
                                HStack(alignment: .top, spacing: 30) {
                                    weatherCard
                                    forecastPanel
                                }
                                .padding(.horizontal, 40)
                                .frame(maxWidth: .infinity)
                            } else {
                                // MODO COMPACTO (Vertical)
                                VStack(spacing: 30) {
                                    weatherCard
                                    forecastPanel
                                }
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.bottom, 30)
                        .frame(minHeight: proxy.size.height)
                    }
                }
            }
        }
        .frame(minWidth: 600, minHeight: 500)
        .onChange(of: selectedCategory) { _, newValue in
            if let city = newValue, city != "Search" {
                viewModel.searchText = city
                Task { await viewModel.searchWeather() }
            }
        }
    }
    
    // MARK: - Componentes
    
    var backgroundGradient: some View {
        LinearGradient(colors: [
            Color(nsColor: .windowBackgroundColor),
            Color.blue.opacity(0.08)
        ], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Buscar ciudad...", text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .font(.title3)
                .onSubmit { Task { await viewModel.searchWeather() } }
            if viewModel.state == .loading { ProgressView().controlSize(.small) }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        .frame(maxWidth: 400)
    }
    
    @ViewBuilder
    var weatherCard: some View {
        if case .success(let weather) = viewModel.state {
            WeatherDetailView(weather: weather, favoritesManager: favoritesManager)
        } else if case .idle = viewModel.state {
            ContentUnavailableView("Empieza", systemImage: "magnifyingglass", description: Text("Busca una ciudad arriba."))
                .frame(height: 300)
        }
    }
    
    @ViewBuilder
    var forecastPanel: some View {
        if !viewModel.forecast.isEmpty {
            ForecastListView(forecast: viewModel.forecast)
                // NUEVA ALTURA MÁS CORTA: 500 (Igual que la otra tarjeta)
                .frame(width: 340, height: 500)
                .background(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.3), lineWidth: 1))
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
        }
    }
}
