import Foundation

extension Double {
    // Función para quitar decimales
    func asTemperatureString() -> String {
        return String(format: "%.0f°", self)
    }
    
    // Función para quitar decimales y el símbolo 'º'
    func asIntString() -> String {
        return String(format: "%.0f", self)
    }
}
