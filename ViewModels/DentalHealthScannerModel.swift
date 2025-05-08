import Foundation
import GoogleGenerativeAI
import OSLog
import SwiftUI
import UIKit

// Enums for Dental Analysis Fields
enum CavityRisk: String, Codable {
    case low = "Low Risk"
    case moderate = "Moderate Risk"
    case high = "High Risk"
}

enum PlaqueLevel: String, Codable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
}

enum Alignment: String, Codable {
    case good = "Good"
    case moderate = "Moderate"
    case poor = "Poor"
}

enum GumHealth: String, Codable {
    case healthy = "Healthy"
    case slightlyInflamed = "Slightly Inflamed"
    case inflamed = "Inflamed"
}

enum ToothColor: String, Codable {
    case white = "White"
    case slightlyYellow = "Slightly Yellow"
    case yellow = "Yellow"
}

// Helper functions
 func colorForRisk(_ risk: String) -> Color {
    switch risk.lowercased() {
    case "low risk": return .green
    case "moderate risk": return .orange
    case "high risk": return .red
    default: return .gray
    }
}

 func colorForLevel(_ level: String) -> Color {
    switch level.lowercased() {
    case "low": return .green
    case "moderate": return .orange
    case "high": return .red
    default: return .gray
    }
}

 func colorForAlignment(_ alignment: String) -> Color {
    switch alignment.lowercased() {
    case "good": return .green
    case "moderate": return .orange
    case "poor": return .red
    default: return .gray
    }
}

 func colorForGumHealth(_ health: String) -> Color {
    switch health.lowercased() {
    case "healthy": return .green
    case "slightly inflamed": return .orange
    case "inflamed": return .red
    default: return .gray
    }
}

func colorForToothColor(_ color: String) -> Color {
    switch color.lowercased() {
    case "white": return .green
    case "slightly yellow": return .orange
    case "yellow": return .red
    default: return .gray
    }
}

// Struct to decode the JSON response
struct DentalAnalysis: Codable {
    let cavity_risk: CavityRisk
    let plaque_level: PlaqueLevel
    let alignment: Alignment
    let tooth_color: ToothColor
    let gum_health: GumHealth
    let overall_score: Int
    let care_tips: [String]
}

@MainActor
class DentalHealthScannerModel: ObservableObject {
    private static let largestImageDimension = 768.0
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: AppConstants.category)
    var lastImage: UIImage?
    
    @Published var userInput: String = AppConstants.userInput
    @Published var errorMessage: String?
    @Published var inProgress = false
    @Published var dentalAnalysis: DentalAnalysis?
    @Published var analysisDate: Date?
    
    private var model: GenerativeModel?

    init() {
        model = GenerativeModel(name: AppConstants.model, apiKey: APIKey.default)
    }

    func reason(with image: UIImage) async {
        defer { inProgress = false }
        guard let model else { return }

        do {
            inProgress = true
            errorMessage = nil
            dentalAnalysis = nil

            let prompt = AppConstants.userInput

            var finalImage = image
            lastImage = finalImage

            if !image.size.fits(largestDimension: DentalHealthScannerModel.largestImageDimension) {
                guard let resized = image.preparingThumbnail(
                    of: image.size.aspectFit(largestDimension: DentalHealthScannerModel.largestImageDimension)
                ) else {
                    logger.error("Failed to resize image")
                    return
                }
                finalImage = resized
            }

            let outputStream = model.generateContentStream(prompt, [finalImage])
            var fullText = ""

            for try await chunk in outputStream {
                if let text = chunk.text {
                    fullText += text
                }
            }

            if fullText.contains("NO_TEETH_FOUND") {
                errorMessage = "This image does not appear to show teeth. Please upload a clear image of teeth."
                return
            }
            
            // Use regex to extract valid JSON object
            if let match = fullText.range(of: #"(?s)\{.*\}"#, options: .regularExpression) {
                let json = String(fullText[match])
                if let jsonData = json.data(using: .utf8) {
                    let decoder = JSONDecoder()
                    dentalAnalysis = try decoder.decode(DentalAnalysis.self, from: jsonData)
                    analysisDate = Date()
                } else {
                    errorMessage = "Failed to convert response to data."
                }
            } else {
                errorMessage = "No valid JSON found in response."
            }

        } catch {
            logger.error("Error: \(error.localizedDescription)")
            errorMessage = "An error occurred during analysis."
        }
    }

    func analyzeImage(_ image: UIImage?, completion: @escaping () -> Void) {
        guard let image = image else { return }
        Task {
            await reason(with: image)
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    var formattedAnalysisDate: String {
        guard let date = analysisDate else { return "Processing date unavailable" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Getter for lastImage to make it accessible
    var lastImageValue: UIImage? {
        return lastImage
    }
}

private extension CGSize {
    func fits(largestDimension length: CGFloat) -> Bool {
        return width <= length && height <= length
    }

    func aspectFit(largestDimension length: CGFloat) -> CGSize {
        let aspectRatio = width / height
        if width > height {
            let width = min(self.width, length)
            return CGSize(width: width, height: round(width / aspectRatio))
        } else {
            let height = min(self.height, length)
            return CGSize(width: round(height * aspectRatio), height: height)
        }
    }
}
