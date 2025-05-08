🦷 Dental Health Scanner App (SwiftUI)
--------------
This project is a SwiftUI-based iOS application that uses AI to analyze images of teeth for dental health insights. It allows users to capture or upload images, processes them using Google's Generative AI, and provides a detailed dental health report with metrics and care tips.


✨ Features
--------------

* 📸 Camera Integration: Capture teeth images directly using the device's camera.
* 🖼️ Photo Picker: Upload teeth images from the photo gallery.
* 🤖 AI-Powered Analysis: Analyze dental health using Google's Generative AI, assessing:
    1. Cavity Risk
    2. Plaque Level
    3. Tooth Alignment
    4. Tooth Color
    5. Gum Health
    6. Overall Dental Health Score

* 📊 Detailed Results: Display metrics in a visually appealing grid with color-coded indicators.
* 💡 Care Tips: Provide personalized dental care recommendations based on analysis.
* 🔄 Progress Feedback: Show a loading indicator during AI processing.
* 🚨 Error Handling: Display alerts for invalid images (e.g., no teeth detected) or camera unavailability.


🛠 Tech Stack
--------------

* SwiftUI -> Modern UI building
* GoogleGenerativeAI -> AI-powered dental image analysis
* PhotosUI -> Photo gallery access
* UIKit (minor) -> Image handling and camera integration
* Foundation -> General utilities and networking


🚀 Getting Started
--------------

1. Clone the repository:git clone https://github.com/PSSPL-Mobile/Dental-Health-Scanner.git
2. Open the project in Xcode 15 or later.
3. Add the Google Generative AI dependency:
    * Ensure you have a valid API key for Google Generative AI.
    * Add the API key securely, such as in your project’s .plist or a configuration file.
4. Update Info.plist with the required permissions:
    * NSCameraUsageDescription → Camera access for capturing teeth images
    * NSPhotoLibraryUsageDescription → Photo library access for selecting images
5. Build and run the app on a real device
    * Note: Camera functionality is not available on the iOS Simulator.


📖 Usage
--------------

1. Launch the app and view the home screen with instructions.
2. Choose an image source:
    * Tap the Camera button to capture a new photo of teeth.
    * Tap the Gallery button to select an existing photo.
3. Preview the selected or captured image.
4. Tap Proceed to Analysis to start AI processing.
5. View the results, including:
    * Metrics like cavity risk, plaque level, alignment, tooth color, gum health, and overall score.
    * Personalized care tips based on the analysis.
6. If an error occurs (e.g., no teeth detected), an alert will guide you to try again.


🎥 Preview
---------
<p align="left">
  <img src="Video/sampleVideo.gif" width="30%" />
</p>


