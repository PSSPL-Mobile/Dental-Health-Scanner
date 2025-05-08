

struct AppConstants {
    static let dentalHealthScannerTitle = "Dental Health Scanner"
    static let noImageSelectedTitle = "No Image Selected"
    static let camera = "Camera"
    static let gallery = "Gallery"
    static let ok = "OK"
    static let category = "generative-ai"
    static let model = "gemini-1.5-flash-latest"
    static let proceedToAnalysis = "Proceed to Analysis"
    static let noPhotoSelected = "No photo selected"
    static let instruction = "Select a clear image of your teeth for AI analysis."
    static let scanResult = "Scan Results"
    static let aiAnalysisReport = "AI Analysis Report"
    static let cravityRisk = "Cavity Risk"
    static let plaqueLevel = "Plaque Level"
    static let alignment = "Alignment"
    static let teethColor = "Teeth Color"
    static let gumHealth = "Gum Health"
    static let overallScore = "Overall Score"
    static let recommendedCareTips = "Recommended Care Tips:"
    static let cameraNotSupportMsg = "This device does not support camera functionality."
    static let noTeethImageMsg = "This image does not appear to show teeth. Please upload a clear image of teeth."
    static let userInput = """
            You are a dental AI assistant. Analyze the attached photo of a person's teeth and respond only with a valid JSON object that conforms exactly to the following format:

            {
              "cavity_risk": "",
              "plaque_level": "",
              "alignment": "",
              "tooth_color": "",
              "gum_health": "",
              "overall_score": 0,
              "care_tips": []
            }

            The values for each field must be as follows:
            - "cavity_risk": Must be one of "Low Risk", "Moderate Risk", or "High Risk"
            - "plaque_level": Must be one of "Low", "Moderate", or "High"
            - "alignment": Must be one of "Good", "Moderate", or "Poor"
            - "tooth_color": Must be one of "White", "Slightly Yellow", or "Yellow"
            - "gum_health": Must be one of "Healthy", "Slightly Inflamed", or "Inflamed"
            - "overall_score": Must be an integer between 0 and 100
            - "care_tips": Must be a list of 5 short actionable tips for dental care (strings)

            Respond only with "NO_TEETH_FOUND" or valid JSON. Do not add markdown, comments, or any explanation.
            """
}

enum SystemImage: String {
    case camera = "camera.fill"
    case gallery = "photo.on.rectangle.fill"
    case rightArrow = "chevron.right"
    case photo = "photo"
    case checkmark = "checkmark.circle.fill"
    case drop = "drop.fill"
    case sparkles = "sparkles"
    case heart = "heart.circle.fill"
    case star = "star.circle.fill"
//    case speaker = "speaker.wave.2.bubble"
//    case refresh = "refresh"
//    case share = "share"
}

enum icons: String {
    case logo = "teethLogo"
}
