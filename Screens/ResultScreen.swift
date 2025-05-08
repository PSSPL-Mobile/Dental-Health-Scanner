

import SwiftUI

struct ResultScreen: View {
    @ObservedObject var viewModel: DentalHealthScannerModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 5) {
                    HStack {
                        Image(icons.logo.rawValue)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                        Text(AppConstants.scanResult)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Text(AppConstants.aiAnalysisReport)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 10) {
                    if let image = viewModel.lastImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 10)
                    } else {
                        Image(systemName: SystemImage.photo.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 10)
                    }

                    Text(viewModel.formattedAnalysisDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Metrics Grid
                if let analysis = viewModel.dentalAnalysis {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 15),
                        GridItem(.flexible(), spacing: 15)
                    ], spacing: 15) {
                        MetricView(title: AppConstants.cravityRisk, value: analysis.cavity_risk.rawValue, icon: SystemImage.checkmark.rawValue, color: colorForRisk(analysis.cavity_risk.rawValue))
                        MetricView(title: AppConstants.plaqueLevel, value: analysis.plaque_level.rawValue, icon: SystemImage.drop.rawValue, color: colorForLevel(analysis.plaque_level.rawValue))
                        MetricView(title: AppConstants.alignment, value: analysis.alignment.rawValue, icon: SystemImage.checkmark.rawValue, color: colorForAlignment(analysis.alignment.rawValue))
                        MetricView(title: AppConstants.teethColor, value: analysis.tooth_color.rawValue, icon: SystemImage.sparkles.rawValue, color: colorForToothColor(analysis.tooth_color.rawValue))
                        MetricView(title: AppConstants.gumHealth, value: analysis.gum_health.rawValue, icon: SystemImage.heart.rawValue, color: colorForGumHealth(analysis.gum_health.rawValue))
                        MetricView(title: AppConstants.overallScore, value: "\(analysis.overall_score)/100", icon: SystemImage.star.rawValue, color: .blue)
                    }
                }

                // Recommended Care Tips
                if let analysis = viewModel.dentalAnalysis {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(AppConstants.recommendedCareTips)
                            .font(.headline)

                        ForEach(analysis.care_tips, id: \.self) { tip in
                            HStack(alignment: .center) {
                                Circle()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(.blue)
                                Text(tip)
                                    .foregroundColor(.black)
                                    .font(.system(size: 16))
                            }
                            .padding(.vertical)
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color.gray.opacity(0.1))
    }
}

struct MetricView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .padding(10)
                .background(color.opacity(0.2))
                .clipShape(Circle())

            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)

            Text(value)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(color)
                .minimumScaleFactor(0.7)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
