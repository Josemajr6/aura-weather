import Foundation

enum AppError: Error {
    case invalidURL
    case serverError
    case decodingError
    case unknown
}
